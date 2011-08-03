 -----------------------------------------------------------------------------
--  COPYRIGHT ORTHO CLINICAL DIAGNOSTICS 2011
--              ALL RIGHTS RESERVED
-----------------------------------------------------------------------------
-- MODULE NAME:
-- PURPOSE:
-- ORIGINAL AUTHOR: Adrian Mejia (amejia3)
-- ORIGINAL DATE: 08/1/2011
-- REVISION HISTORY: at bottom of file
-----------------------------------------------------------------------------


 -----------------------------
 -- Sched Worlist Assay Lib --
 -----------------------------

 -- 1.- NON_MW_WORKLIST
 SCH_SAMP_WL_MSG = {}

 SCH_SAMP_WL_MSG.eWorklistType			= "NON_MW_WORKLIST"
 SCH_SAMP_WL_MSG.lNumReps 				= 0			-- NumReps (overrided below)

 SCH_SAMP_WL_MSG.sCupPosition 			= 6			-- CupPosition/sCupPosition;	// Identifies sample cup position within tray
 SCH_SAMP_WL_MSG.wSampleNameForDisplay	= ""		-- SampleName/wSampleNameForDisplay[CMN_UTFSTR(CMN_IDENTITY_LEN)];// Text substituted on certain errors
 SCH_SAMP_WL_MSG.wTray 					= "F3"		-- Tray/wTray[CMN_UTFSTR(CMN_TRAY_LEN)];  // Identifies sample tray
 SCH_SAMP_WL_MSG.lSampleProgramID		= 219 		-- Pass through for Intellichecks
 SCH_SAMP_WL_MSG.ResultID				= 293		-- lResultID;		// Pass Thru info: Key into Results DB
 SCH_SAMP_WL_MSG.lCalGroupRunID			= -1		-- CalGroup/lCalGroupRunID;	// Pass Thru info: Key into Cal DB
 SCH_SAMP_WL_MSG.sCalBottleNum			= -1		-- CalBottle/sCalBottleNum;	// Pass Thru info

 SCH_SAMP_WL_MSG.xPrimContainer = {}
 SCH_SAMP_WL_MSG.xPrimContainer.eTubeType	= 0		-- TubeDiam
 SCH_SAMP_WL_MSG.xPrimContainer.eCupTypeCfg = 2		-- CupType

 SCH_SAMP_WL_MSG.lSampPriority 			= 0			-- Sched Priority / lSampPriority : CMN_LONG lSampPriority;
 SCH_SAMP_WL_MSG.ePrimMetPos			= 94		-- SS_POS_TOKEN_VALUES	MetPos/ePrimMetPos; // REFLEX (SAHA_REFLEX) | STAT (SAHA_STAT) | ROUTINE (SAHA_ROUTINE)

 SCH_SAMP_WL_MSG.xAspProfile = {}					-- Total Vol across all dips
 SCH_SAMP_WL_MSG.xAspProfile.eTipType	= 0			-- PrimaryTipType: MICRO_VOL | VITROS
 SCH_SAMP_WL_MSG.xAspProfile.lAspVol	= 8500		-- Vol to initially aspirate
 SCH_SAMP_WL_MSG.lQTipVol				= 3000
 -- non-dry:
 SCH_SAMP_WL_MSG.lNumDils				= 0 		-- Num Wet/Dry Dils
 SCH_SAMP_WL_MSG.lNumUniqueDryDills		= 0			-- Num Unique Dry Dils

 SCH_SAMP_WL_MSG.xUnstartedRepsOnBoard 	= {}
 SCH_SAMP_WL_MSG.xUnstartedRepsOnBoard.lNumMicroTipReps 	= 0		-- Num unstarted wet reps
 SCH_SAMP_WL_MSG.xUnstartedRepsOnBoard.lNumMicroWellReps 	= 0		-- Num unstarted Mwell reps
 SCH_SAMP_WL_MSG.xUnstartedRepsOnBoard.lNumMicroSlideReps 	= 28	-- Num unstarted slide reps

 SCH_SAMP_WL_MSG.eBodyFluid 			= 5 --

 SCH_SAMP_WL_MSG.xSiRep = {}
 SCH_SAMP_WL_MSG.xSiRep.bSiRequired			= 1 	--"SI REQUIRED" : "SI Not Required"
 SCH_SAMP_WL_MSG.bPrimMetMixSampBeforeAsp	= 0 	-- "T" : "F"

 ---[[ REPS

 SCH_SAMP_WL_MSG.axReps = {}
 k=1
 SCH_SAMP_WL_MSG.axReps[k] = dofile('scht_assay_309.lua');
 k=k+1
 SCH_SAMP_WL_MSG.axReps[k] = dofile('scht_assay_345.lua');
 k=k+1
 SCH_SAMP_WL_MSG.axReps[k] = dofile('scht_assay_320.lua');


 -- calculate number of Reps
 SCH_SAMP_WL_MSG.lNumReps 	= table.getn( SCH_SAMP_WL_MSG.axReps )	-- NumReps

 --]] -- REPS

 wl = {}
 wl["NON_MW_WORKLIST"] 		= SCH_SAMP_WL_MSG

 -------------------
 -- 2.- MW_WORKLIST
 -------------------

 wl["MW_WORKLIST"] 			= {}

 -------------------
 -- 3.- Other Type
 -------------------
 wl["other"] 				= {}


 ---[[------------------
 -- Testing lib       --
 -----------------------

 print(SCH_SAMP_WL_MSG.lQTipVol)
 print(SCH_SAMP_WL_MSG.xUnstartedRepsOnBoard.lNumMicroSlideReps)

 print(wl.NON_MW_WORKLIST.lQTipVol)
 print(wl["NON_MW_WORKLIST"].xUnstartedRepsOnBoard.lNumMicroSlideReps)

 local xml 	= require("xml")

 print(xml.table2xml(wl, "wl"))
--]]


return wl

--[[
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
--]]



-----------------------------------------------------------------------------
--  REVISION HISTORY
--  $LastChangedDate: 2011-07-06 12:52:43 -0400 (Wed, 06 Jul 2011) $
--  $Revision: 1132 $
--  $LastChangedBy: amejia3 $
--  $Id: scht_unit_test_4.lua 1132 2011-07-06 16:52:43Z amejia3 $
-----------------------------------------------------------------------------
