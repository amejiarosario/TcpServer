-----------------------------------------------------------------------------
--  COPYRIGHT ORTHO CLINICAL DIAGNOSTICS 2011
--              ALL RIGHTS RESERVED
-----------------------------------------------------------------------------
-- MODULE NAME: scht_unit_test_4.lua
-- PURPOSE: Lua scripts for performing unit tests on XML Worklist convertion.
-- ORIGINAL AUTHOR: Adrian Mejia (amejia3)
-- ORIGINAL DATE: 06/14/2011
-- REVISION HISTORY: at bottom of file
-----------------------------------------------------------------------------

local sys 	= require("system")
local tr 	= require("test_runner")
local st 	= require("sched_tester") -- has send_sample_wl
local xml 	= require("xml")
local ut 	= require("utils")
local evt 	= require("events")
--local gen 	= require("generators") -- n/a

function do_scht_outbound_tests()
  tr.test_set("SchedTester-4", "Unit testing of Sched in SCHT_StructSerialization.cc",
  	ut.clean_id("$Id: scht_unit_test_4.lua 1132 2011-07-06 16:52:43Z amejia3 $"))

  sys.dlog("**RUNNING $Id: scht_unit_test_4.lua 1132 2011-07-06 16:52:43Z amejia3 $")

  ----------------------------- case 1 ------------------------------------------------
  tr.test_step(1, "Create the table modeling the SCH_SAMP_WL_MSG structure.")
  tr.test_info("Create a table in Lua world and the XML lib is called to translated to XML.")
  tr.test_inspect("Verify that the table was correctly translated to XML")
  
 -- Example of a partial worklist's SCH_SAMP_WL_MSG structure represation in lua table
 SCH_SAMP_WL_MSG = {}
 SCH_SAMP_WL_MSG.eWorklistType 			= "MW_WORKLIST"	-- either NON_MW_WORKLIST or MW_WORKLIST
 SCH_SAMP_WL_MSG.lResultID 				= 78			-- Pass Thru info: Key into Results DB
 SCH_SAMP_WL_MSG.lSampleProgramID 		= 2 			-- Pass through for Intellichecks
 SCH_SAMP_WL_MSG.lCalGroupRunID 		= 828			-- Pass Thru info: Key into Cal DB
 SCH_SAMP_WL_MSG.sCalBottleNum 			= 254			-- Pass Thru info
 SCH_SAMP_WL_MSG.wTray 					= "AT3632"  	-- Identifies sample tray
 -- sCupPosition =254	-- Identifies sample cup position within tray
 SCH_SAMP_WL_MSG.ePrimMetPos 			= "SAHA_ROUTINE"		-- REFLEX (SAHA_REFLEX) | STAT (SAHA_STAT) | ROUTINE (SAHA_ROUTINE)

 SCH_SAMP_WL_MSG.xAspProfile			= {}			-- Total Vol across all dips
 SCH_SAMP_WL_MSG.xAspProfile.eTipType	= "VITROS_TIP"	-- MICRO_VOL | VITROS
 SCH_SAMP_WL_MSG.xAspProfile.lAspVol	= 3500			-- Vol to initially aspirate

 SCH_SAMP_WL_MSG.xUnstartedRepsOnBoard									= {}
 SCH_SAMP_WL_MSG.xUnstartedRepsOnBoard.lNumMicroSlideReps 				= 23
 SCH_SAMP_WL_MSG.xUnstartedRepsOnBoard.lHighestSamplePrioritySlide 		= 67
 SCH_SAMP_WL_MSG.xUnstartedRepsOnBoard.lNumMicroTipReps 				= 932
 SCH_SAMP_WL_MSG.xUnstartedRepsOnBoard.lHighestSamplePriorityMicroTip 	= 2
 SCH_SAMP_WL_MSG.xUnstartedRepsOnBoard.lNumMicroWellReps 				= 0
 SCH_SAMP_WL_MSG.xUnstartedRepsOnBoard.lHighestSamplePriorityMicroWell 	= 54

 actual_xml = xml.table2xml(SCH_SAMP_WL_MSG,"SCH_SAMP_WL_MSG")
 expected_xml = [[<SCH_SAMP_WL_MSG>
  <ePrimMetPos>SAHA_ROUTINE</ePrimMetPos>
  <eWorklistType>MW_WORKLIST</eWorklistType>
  <lCalGroupRunID>828</lCalGroupRunID>
  <lSampleProgramID>2</lSampleProgramID>
  <wTray>AT3632</wTray>
  <sCalBottleNum>254</sCalBottleNum>
  <xAspProfile>
    <eTipType>VITROS_TIP</eTipType>
    <lAspVol>3500</lAspVol>
  </xAspProfile>
  <lResultID>78</lResultID>
  <xUnstartedRepsOnBoard>
    <lNumMicroWellReps>0</lNumMicroWellReps>
    <lNumMicroTipReps>932</lNumMicroTipReps>
    <lHighestSamplePriorityMicroWell>54</lHighestSamplePriorityMicroWell>
    <lHighestSamplePrioritySlide>67</lHighestSamplePrioritySlide>
    <lHighestSamplePriorityMicroTip>2</lHighestSamplePriorityMicroTip>
    <lNumMicroSlideReps>23</lNumMicroSlideReps>
  </xUnstartedRepsOnBoard>
</SCH_SAMP_WL_MSG>]]

 sys.dlog(actual_xml)
 
 tr.test_check_e(actual_xml,expected_xml, "Incorrect XML convertion", " (" .. __FILE__() .. ":" .. __LINE__() .. ") ")
 --tr.test_check_e(actual_xml,expected_xml.."error_injection", "ignore me")
 
 -- write xml file to disk 
 --local file = assert(io.open("xml_output.lua", "w"))
 --file:write(actual_xml)
 --file:close()
 
 ----------------------------- case 2 ------------------------------------------------  
 tr.test_step(2, "Send the generate XML worklist to be converted into SCH_SAMP_WL_MSG structure.")
 tr.test_info("TODO test_info")
 tr.test_inspect("TODO test_inspect")
 
 -- create user event & register ("rep_complete")
 ue1 = evt.reg_user_event("rep_complete", 1)
 
 -- send sample worklist, in the c side represents call SCHT_TaskTester.cc::SCHT_SendSampleWL:129
 st.send_sample_wl(actual_xml) -- test is here.
 
 -- wait for (ue.status())
 status = evt.wait_for(2000, function() return ue1.state() end)
  
 -- ue.data() --> xml
 rep_data = ue1.data()
 sys.dlog (rep_data)
 
 -- turn the xml into table
 dtable = xml.xml2table(rep_data)
 
 -- look at it
 sys.dlog('got the table')
 
----------------------------- case 3 ------------------------------------------------
 --tr.test_step(3, "TBD")
 --tr.test_info("TODO")
 --tr.test_inspect("TODO")
 
----------------------------- case 4 ------------------------------------------------

  ------------------ test complete -----------------------
  -- Don't forget to finish up the test.
  tr.test_end()
end

-----------------------------------------------------------------------------
-- Module initialization.

do_scht_outbound_tests()

-----------------------------------------------------------------------------
--  REVISION HISTORY
--  $LastChangedDate: 2011-07-06 12:52:43 -0400 (Wed, 06 Jul 2011) $
--  $Revision: 1132 $
--  $LastChangedBy: amejia3 $
--  $Id: scht_unit_test_4.lua 1132 2011-07-06 16:52:43Z amejia3 $
-----------------------------------------------------------------------------
