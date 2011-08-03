-----------------------------------------------------------------------------
--  COPYRIGHT ORTHO CLINICAL DIAGNOSTICS 2011
--              ALL RIGHTS RESERVED
-----------------------------------------------------------------------------
-- test_runner.lua
-- Lua scripts for performing test run management and report generation.
-----------------------------------------------------------------------------

local ut = require("utils")
local sys = require("system")

-- Create the namespace/module.
local M = {}

-- Current states.  
local curr_case_pass = true
local curr_step_pass = true

-- The tallies.
local cases_run = 0
local cases_failed = 0
local steps_run = 0
local steps_failed = 0

-- Output file handle.
local rf = nil

--[[ TODO improve this using Lua stack. C example:
	@seealso http://www.lua.org/pil/23.1.html

	luaStatus1 = lua_getstack (L, stkpos, &ar);
	if(luaStatus1)
		luaStatus2 = lua_getinfo(L, "nl", &ar); // n=name=func l=currentline=line

	TODO - add xml option similar to http://code.google.com/p/googletest/wiki/AdvancedGuide#Generating_an_XML_Report
       - harmonize with UnitTester.h
--]]
function __FILE__() return debug.getinfo(2,'S').source end
function __LINE__() return debug.getinfo(2, 'l').currentline end
--function __HERE__() return " (".. __FILE__()..":"..__LINE__()..") " end
--macro.define('__FILE__',nil,function(ls) return macro.string(ls.source) end)

-----------------------------------------------------------------------------
-- FUNCTION NAME: write_line
-- PURPOSE:
--   General line output to file and log.
-- PARAMETER LIST:
--   line - The info to write.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
local function write_line(line)
  if rf ~= nil then
    rf:write(line .. "\n")
    rf:flush()
  end
  if #line > 0 then sys.dlog(line, "RI") end
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: write_error
-- PURPOSE:
--   Error line output to file and log.
-- PARAMETER LIST:
--   line - The info to write.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
local function write_error(line)
  if rf ~= nil then
    rf:write("** " .. line .. "\n")
    rf:flush()
  end
  sys.dlog("** " .. line, "RE")
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_check_failed
-- PURPOSE:
--   A step has failed so update all states and counts.
--   If there are too many failures, this function exits the script.
-- PARAMETER LIST:
--   msg1 - Optional message.
--   msg2 - Optional message.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
local function test_check_failed(msg1, msg2)
  -- Don't do this if it's fake.
  if dry_run then return end
  
  -- Update the states and counts.
  if curr_case_pass then
    curr_case_pass = false
    cases_failed = cases_failed + 1
  end
  
  if curr_step_pass then
    curr_step_pass = false
    steps_failed = steps_failed + 1
    -- Check for too many failures.
    if script_context.fail_count > 0 then
      script_context.fail_count = script_context.fail_count - 1
      if script_context.fail_count <= 0 then error("Too many tests failed, stopping run.", 0) end
    end
  end
  
  -- Print failure information.
  if msg1 == nil then msg1 = "Test step failed" end
  if msg2 == nil then msg2 = "" end
  
  write_error(msg1 .. ": " .. msg2)
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_set
-- PURPOSE:
--   Start of a new test set. Also starts the report.
-- PARAMETER LIST:
--   qc_id - Quality center ID.
--   desc - Free text.
--   script - Test script name and rev.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
function M.test_set(qc_id, desc, script)
  -- Reset the vars.
  curr_case_pass = true
  curr_step_pass = true
  cases_run = 0
  cases_failed = 0
  steps_run = 0
  steps_failed = 0

  -- Open the report file.
  rf = io.open (script_context.report_filename, "w+")
  
  if script_context.dry_run then 
    write_line("#**************** Dry Run - Report is not valid *******************")
  end
  
  write_line("#------------------------------------------------------------------")
  write_line("# Unit Tester Report")
  write_line("# Start Time: " .. os.date())
  write_line("#")
  write_line("# -- General information.")
  write_line("# !! Something that should be verified by the test engineer.")
  write_line("# ** Test failure.")
  write_line("#------------------------------------------------------------------")
  write_line("")
  write_line("Test Set " .. qc_id .. ": ", desc)
  write_line("Test Script: " .. script)
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_case
-- PURPOSE:
--   Start a new test case.
-- PARAMETER LIST:
--   qc_id - Quality center ID.
--   desc - Free text.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
function M.test_case(qc_id, desc)
  write_line("")
  write_line("Case " .. qc_id .. ": " .. desc)

  -- Reset the p/f states.
  curr_case_pass = true
  curr_step_pass = true
  
  cases_run = cases_run + 1
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_step
-- PURPOSE:
--   Add a line to the report.
-- PARAMETER LIST:
--   step_number - Step in the case.
--   desc - Free text.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
function M.test_step(step_number, desc)
  write_line("Step " .. step_number .. ": " .. desc)
 
  -- Reset the p/f states.
  curr_step_pass = true

  steps_run = steps_run + 1
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_info
-- PURPOSE:
--   Add a comment line to the report.
-- PARAMETER LIST:
--   info - free text.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
function M.test_info(info)
  write_line("-- " .. info)
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_inspect
-- PURPOSE:
--   Add an inspection line to the report.
-- PARAMETER LIST:
--   info - free text.
--   add_ts - add a timestamp for finding things in the log (optional).
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
function M.test_inspect(info, add_ts)
  if add_ts ~= nil and add_ts == true then
    write_line("!! " .. info .. " (log time: " .. sys.timestamp() .. ")")
  else  
    write_line("!! " .. info)
  end
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_end
-- PURPOSE:
--   Finishes the test and generates the report file.
-- PARAMETER LIST:
--   None.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
function M.test_end()
  if cases_failed == 0 then pf_run = "Pass" else pf_run = "Fail" end
  
  write_line("")
  write_line("#------------------------------------------------------------------")
  write_line("# End Time: " .. os.date())
  write_line("# Cases Run: " .. cases_run)
  write_line("# Cases Failed: " .. cases_failed)
  write_line("# Steps Run: " .. steps_run)
  write_line("# Steps Failed: " .. steps_failed)
  write_line("# Run Result: " .. pf_run)
  write_line("#------------------------------------------------------------------")
  
  -- Close the report file.
  rf:close()
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_check
-- PURPOSE:
--   Tests expression and registers a failure if not true.
-- PARAMETER LIST:
--   expr - Boolean expression.
--   msg - Optional message.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
function M.test_check(expr, msg)
  if expr == false then
    test_check_failed(msg, "Expression is not true")
  end
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_check_e
-- PURPOSE:
--   Tests expression and registers a failure if not equal.
-- PARAMETER LIST:
--   val1 - First value.
--   val2 - Second value.
--   msg - Optional message.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
function M.test_check_e(val1, val2, msg, _FILE_LINE_)
  _FILE_LINE_ = _FILE_LINE_ or ''
  if val1 ~= val2 then
    test_check_failed(msg, _FILE_LINE_ .. tostring(val1) .. " is not equal to " .. tostring(val2))
  end
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_check_ne
-- PURPOSE:
--   Tests expression and registers a failure if equal.
-- PARAMETER LIST:
--   val1 - First value.
--   val2 - Second value.
--   msg - Optional message.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
function M.test_check_ne(val1, val2, msg)
  if val1 == val2 then
    test_check_failed(msg, tostring(val1) .. " is equal to " .. tostring(val2))
  end
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_check_lt
-- PURPOSE:
--   Tests expression and registers a failure if not less than.
-- PARAMETER LIST:
--   val1 - First value.
--   val2 - Second value.
--   msg - Optional message.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
function M.test_check_lt(val1, val2, msg)
  if not(val1 < val2) then
    test_check_failed(msg, tostring(val1) .. " is not less than " .. tostring(val2))
  end
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_check_lte
-- PURPOSE:
--   Tests expression and registers a failure if not less than or equal.
-- PARAMETER LIST:
--   val1 - First value.
--   val2 - Second value.
--   msg - Optional message.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
function M.test_check_lte(val1, val2, msg)
  if not(val1 <= val2) then
    test_check_failed(msg, tostring(val1) .. " is not less than or equal to " .. tostring(val2))
  end
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_check_gt
-- PURPOSE:
--   Tests expression and registers a failure if not greater than.
-- PARAMETER LIST:
--   val1 - First value.
--   val2 - Second value.
--   msg - Optional message.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
function M.test_check_gt(val1, val2, msg)
  if not(val1 > val2) then
    test_check_failed(msg, tostring(val1) .. " is not greater than " .. tostring(val2))
  end
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_check_gte
-- PURPOSE:
--   Tests expression and registers a failure if not greater than or equal.
-- PARAMETER LIST:
--   val1 - First value.
--   val2 - Second value.
--   msg - Optional message.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
function M.test_check_gte(val1, val2, msg)
  if not(val1 >= val2) then
    test_check_failed(msg, tostring(val1) .. " is not greater than or equal to " .. tostring(val2))
  end
end

-----------------------------------------------------------------------------
-- FUNCTION NAME: test_check_close
-- PURPOSE:
--   Tests expression and registers a failure if not close to each other.
-- PARAMETER LIST:
--   val1 - First value.
--   val2 - Second value.
--   tol - Within tolerance.
--   msg - Optional message.
-- RETURN VALUES:
--   None.
-----------------------------------------------------------------------------
function M.test_check_close(val1, val2, tol, msg)
  if math.abs(val1 - val2) > tol then
    test_check_failed(msg, tostring(val1) .. " is not close to " .. tostring(val2))
  end
end


-----------------------------------------------------------------------------
-- Module initialization.

sys.dlog("Loading script " .. ut.clean_id("$Id: test_runner.lua 1172 2011-07-25 18:20:45Z cthoma54 $"))

-- Script context.
if script_context == nil then
  -- Create a default.
  script_context = {}
  script_context["fail_count"] = 0
  script_context["dry_run"] = true -- false
  script_context["report_filename"] = "default_report.txt"
end

local fail_cnt = script_context.fail_count
local dry_run = script_context.dry_run


-- Return the module.
return M


-----------------------------------------------------------------------------
--  REVISION HISTORY
--  $LastChangedDate: 2011-07-25 14:20:45 -0400 (Mon, 25 Jul 2011) $
--  $Revision: 1172 $
--  $LastChangedBy: cthoma54 $
--  $Id: test_runner.lua 1172 2011-07-25 18:20:45Z cthoma54 $
-----------------------------------------------------------------------------
