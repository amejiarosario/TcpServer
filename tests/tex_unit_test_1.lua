-----------------------------------------------------------------------------
--  COPYRIGHT ORTHO CLINICAL DIAGNOSTICS 2010
--              ALL RIGHTS RESERVED
-----------------------------------------------------------------------------
-- MODULE NAME: tex_unit_test_1.lua
-- PURPOSE: Lua scripts for performing unit tests on core lua functions.
-- ORIGINAL AUTHOR: Chris Thomas
-- ORIGINAL DATE: 06/22/2010
-- REVISION HISTORY: at bottom of file
-----------------------------------------------------------------------------

local tr = require("test_runner")
local gen = require("generators")
local ut = require("utils")
local sys = require("system")

function do_core_tests()
  tr.test_set("TaskEx-1", "Unit testing of test_runner.lua, generators.lua, utils.lua.", 
        ut.clean_id("$Id: tex_unit_test_1.lua 1114 2011-06-30 19:14:24Z amejia3 $"))
  
  ----------------------------- case 1 ------------------------------------------------
  tr.test_case("TaskEx-1-1", "Test all functions in test_runner.lua.")
  tr.test_step(1, "Test test_info() and test_inspect().")
  tr.test_info("This is some information about the unit test.")
  tr.test_inspect("Verify that the previous info line and this line appear in the report file.")

  tr.test_step(2, "Test all test_check_xxx() functions.")
  tr.test_check(2 + 2 == 4, "***** True statement should not appear in the test report")
  tr.test_check(2 + 2 == 5, "This false statement should appear in the test report")
  
  tr.test_check_e(111, 111, "***** True statement should not appear in the test report")
  tr.test_check_e(111, "111", "This false statement should appear in the test report")
  
  tr.test_check_ne("ABC", "XYZ", "***** True statement should not appear in the test report")
  tr.test_check_ne("123", "123", "This false statement should appear in the test report")
  
  tr.test_check_lt(555, 555.1, "***** True statement should not appear in the test report")
  tr.test_check_lt(432.01, 432.001, "This false statement should appear in the test report")
  
  tr.test_check_lte(555, 555.1, "***** True statement should not appear in the test report")
  tr.test_check_lte(555.1, 555.1, "***** True statement should not appear in the test report")
  tr.test_check_lte(432.01, 432.001, "This false statement should appear in the test report")
  
  tr.test_check_gt(432.01, 432.001, "***** True statement should not appear in the test report")
  tr.test_check_gt(555, 555.1, "This false statement should appear in the test report")
  
  tr.test_check_gte(555.1, 555, "***** True statement should not appear in the test report")
  tr.test_check_gte(555.1, 555.1, "***** True statement should not appear in the test report")
  tr.test_check_gte(432.001, 432.01, "This false statement should appear in the test report")
  
  tr.test_check_close(555.15, 555.16, 0.01, "***** True statement should not appear in the test report")
  tr.test_check_close(432.02, 432.01, 0.009, "This false statement should appear in the test report")

  ----------------------------- case 2 ------------------------------------------------
  tr.test_case("TaskEx-1-2", "Test all functions in utils.lua.")
  
  tr.test_step(1, "Test log(), msec(), timestamp().")
  s = "This is a test log line at " .. sys.msec() .. " milliseconds after test run start."
  sys.dlog(s)
  tr.test_inspect("Verify that the debug log contains: " .. s, true)
    
  tr.test_step(2, "Test strtrim().")
  s = "  I have whitespace    "
  tr.test_check_e(ut.strtrim(s), "I have whitespace")
  
  tr.test_step(3, "Test clean_id().")
  s = "$xxxx foo.bar 567 jfkdsfjsa fjdkjfa$"
  tr.test_check_e(ut.clean_id(s), "foo.bar rev:567")
  
  tr.test_step(4, "Test strjoin().")
  l = { 123, "orange monkey", 765.12, "BlueBlueBlue", "ano", "ther", 222 }
  tr.test_check_e(ut.strjoin("XXX", l), "123XXXorange monkeyXXX765.12XXXBlueBlueBlueXXXanoXXXtherXXX222")
  
  tr.test_step(5, "Test strsplit().")
  l = ut.strsplit(",", "Ut,turpis,adipiscing,luctus,,pharetra,condimentum, ")
  tr.test_check_e(#l, 8, "Number of list entries")
  tr.test_check_e(l[1], "Ut")
  tr.test_check_e(l[2], "turpis")
  tr.test_check_e(l[3], "adipiscing")
  tr.test_check_e(l[4], "luctus")
  tr.test_check_e(l[5], "")
  tr.test_check_e(l[6], "pharetra")
  tr.test_check_e(l[7], "condimentum")
  
  tr.test_step(6, "Test delay_timer().")
  dt = ut.delay_timer(2745).status
  sys.dlog("delay_timer() start.")
  while not dt() do i = 999 end
  sys.dlog("delay_timer() stop.")
  s = "Verify that the debug log indicates delay_timer() start and delay_timer() stop approximately 2.745 seconds apart."
  tr.test_inspect(s, true)
  
  tr.test_step(7, "Test array_from_file() for text data.")
  ta = ut.array_from_file("lib/lua/mixed_data.txt")
  tr.test_check_e(#ta, 276, "Number of text fields")
  tr.test_check_e(ta[1], "TS")
  tr.test_check_e(ta[30], "71")
  tr.test_check_e(ta[193], "CH3")
  tr.test_check_e(ta[239], "4016")
    
  tr.test_step(8, "Test array_from_file() for numerical data.")
  na = ut.array_from_file("lib/lua/numerical_data.txt", true) -- remove blank fields
  tr.test_check_e(#na, 89, "Number of numerical fields")
  tr.test_check_e(tonumber(na[17]), 506)
  tr.test_check_e(tonumber(na[45]), 12.93)
  tr.test_check_e(tonumber(na[69]), 264302719)
  tr.test_check_e(tonumber(na[89]), 1.11)
  
  ----------------------------- case 3 ------------------------------------------------
  tr.test_case("TaskEx-1-3", "Test all functions in generators.lua.")
  
  tr.test_step(1, "Test numb_seq().")
  g = gen.numb_seq(-25, 47, 10).next
  s = ""
  for i = 0, 10 do s = s .. tostring(g()) .. "XXX" end
  tr.test_check_e(s, "-25XXX-15XXX-5XXX5XXX15XXX25XXX35XXX45XXX-25XXX-15XXX-5XXX")
  
  g = gen.numb_seq(13, -7, -2).next
  s = ""
  for i = 0, 10 do s = s .. tostring(g()) .. "XXX" end
  tr.test_check_e(s, "13XXX11XXX9XXX7XXX5XXX3XXX1XXX-1XXX-3XXX-5XXX-7XXX")

  tr.test_step(2, "Test array_seq() with text data.")
  g = gen.array_seq(ta).next
  tr.test_check_e(g(), "TS")
  tr.test_check_e(g(), "ID")
  tr.test_check_e(g(), "NAME")

  tr.test_step(3, "Test array_seq() with numerical data.")
  g = gen.array_seq(na).next
  tr.test_check_close(g(), 20, 0.00000001)
  tr.test_check_close(g(), 13.85, 0.00000001)
  tr.test_check_close(g(), 500, 0.00000001)

  -- The remaining tests use randomization. Seed to a predetermined value and the results should be the same.
  math.randomseed(999)

  tr.test_step(4, "Test array_rand() with numerical data.")
  g = gen.array_rand(na).next
  tr.test_check_close(g(), 508.0, 0.00000001) -- 56.2
  tr.test_check_close(g(), -1.0, 0.00000001) -- 1.0
  tr.test_check_close(g(), 686.0, 0.00000001) -- 75.7

  tr.test_step(5, "Test numb_rand() with integers.")
  g = gen.numb_rand(-5, 15).next
  tr.test_check_e(g(), 3) -- 9
  tr.test_check_e(g(), -3) -- 10
  tr.test_check_e(g(), -5) -- -4
  
  tr.test_step(6, "Test numb_rand() with floats.")
  g = gen.numb_rand(-0.3, 2.298).next
  tr.test_check_close(g(), 1.8873721732231, 0.00000001) -- 0.076137943662831
  tr.test_check_close(g(), 2.1343514511551, 0.00000001) -- 1.6258833582568
  tr.test_check_close(g(), -0.13421069978942, 0.00000001) -- 1.5414426099429
  
  tr.test_step(7, "Test str_rand().")
  g = gen.str_rand(6, 18).next
  tr.test_check_e(g(), "RSNOfgZ EFvw670034cd12") -- mnEF89XYEF5601cd23lmmn56
  tr.test_check_e(g(), "RSbc945nouvrsCD34") -- lmuvDEbcQR67YZefUVstmn
  tr.test_check_e(g(), "cdijWX78mnjk") -- JKSTZ 89GHij
    
  ------------------ test complete -----------------------
  -- Don't forget to finish up the test. If cases or steps are added, this inspection needs to change also.
  tr.test_inspect("Test complete. Verify the report heading indicates correct Test Set, Test Script, and Run Start values.")
  s = "Verify the report summary indicates correct Test Run Finish time and " .. 
      "Cases Run = 3, Cases Failed = 1, Steps Run = 17, Steps Failed = 1, Run Result = Fail."
  tr.test_inspect(s)
  tr.test_end()
end

-----------------------------------------------------------------------------
-- Module initialization.

do_core_tests()

  
-----------------------------------------------------------------------------
--  REVISION HISTORY
--  $LastChangedDate: 2011-06-30 15:14:24 -0400 (Thu, 30 Jun 2011) $
--  $Revision: 1114 $
--  $LastChangedBy: amejia3 $
--  $Id: tex_unit_test_1.lua 1114 2011-06-30 19:14:24Z amejia3 $
-----------------------------------------------------------------------------
