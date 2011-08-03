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

	axReps = {}

	axReps.eABFModule					= 1
	axReps.lAssayNum					= 309
	axReps.sRepSeqNum					= 0
	axReps.lDilIndex					= -1
	axReps.lAliqExpWetCyclesToFail		= 450
	axReps.lDilExpWetCyclesToFail		= 0
	axReps.sMeteringPriority			= 30000
	axReps.sCalLevel					= -1

	-- switch(axReps->eABFModule)
	-- TODO load

	-- DRY_ASSAY_MODULE_TYPE

	--PrintWorklist: [Sched worklist]: (xDryRep)
	axReps.nRep = {}
	axReps.nRep.xDryRep = {}
	axReps.nRep.xDryRep.eAssayModelType 						= 2 --
	axReps.nRep.xDryRep.sSONumber 								= 42 --
	axReps.nRep.xDryRep.eMetRules 								= 0 --
	axReps.nRep.xDryRep.lNumSteps 								= 2 --
	axReps.nRep.xDryRep.lNumSoNumsToFollow 						= 0 --

	axReps.nRep.xDryRep.xContamInfo = {}
	axReps.nRep.xDryRep.xContamInfo.lNumTestsContam 			= 0 --
	axReps.nRep.xDryRep.xContamInfo.lNumDecontamTests 			= 0 --

	j=1
	axReps.nRep.xDryRep.xContamInfo.axContaminatesFor = {}
	axReps.nRep.xDryRep.xContamInfo.axContaminatesFor[j] = {}
	axReps.nRep.xDryRep.xContamInfo.axContaminatesFor[j].sSONumber 				= nil --
	axReps.nRep.xDryRep.xContamInfo.axContaminatesFor[j].lMinPmCyclesToContam 	= nil --
	axReps.nRep.xDryRep.xContamInfo.axContaminatesFor[j].lNumPmCyclesContam 	= nil --
	-- ... j+=1

	k=1
	axReps.nRep.xDryRep.xContamInfo.axDecontaminates = {}
	axReps.nRep.xDryRep.xContamInfo.axDecontaminates[k] = {}
	axReps.nRep.xDryRep.xContamInfo.axDecontaminates[k].sSONumber 				= nil --
	-- ... k+=1


	-- GenStatusRptSampWlDrySteps

	y=1
	axReps.nRep.xDryRep.axSteps = {}
	axReps.nRep.xDryRep.axSteps[y] = {}
	axReps.nRep.xDryRep.axSteps[y].nStep = {}
	axReps.nRep.xDryRep.axSteps[y].nStep.xReagStep = {}
	axReps.nRep.xDryRep.axSteps[y].nStep.xReagStep.xLocation = {}
	-- WlDrySteps (xReagStep)
	axReps.nRep.xDryRep.axSteps[y].nStep.xReagStep.xLocation.eSupply			= 1
	axReps.nRep.xDryRep.axSteps[y].nStep.xReagStep.xLocation.lSlot				= 39
	axReps.nRep.xDryRep.axSteps[y].nStep.xSampStep = {}
	-- WlDrySteps (xSampStep)
	axReps.nRep.xDryRep.axSteps[y].nStep.xSampStep.ePrimSpotPos					= 18
	axReps.nRep.xDryRep.axSteps[y].nStep.xSampStep.lDelayPmCycles				= 0
	axReps.nRep.xDryRep.axSteps[y].nStep.xSampStep.xDispProfile = {}
	axReps.nRep.xDryRep.axSteps[y].nStep.xSampStep.xDispProfile.lDispVol 		= 1000
	axReps.nRep.xDryRep.axSteps[y].nStep.xSampStep.xRefAspProfile = {}
	axReps.nRep.xDryRep.axSteps[y].nStep.xSampStep.xRefAspProfile.lAspVol 		= 1000
	axReps.nRep.xDryRep.axSteps[y].nStep.xSampStep.xRefDispProfile = {}
	axReps.nRep.xDryRep.axSteps[y].nStep.xSampStep.xRefDispProfile.lDispVol 	= 1000
	axReps.nRep.xDryRep.axSteps[y].nStep.xSampStep.xDispProfile.lNumMixesCycles = 0		-- lNumMixesCycles

	-- SI_ASSAY_MODULE_TYPE
	-- WET_ASSAY_MODULE_TYPE
	-- MW_ASSAY_MODULE_TYPE




	return axReps

-----------------------------------------------------------------------------
--  REVISION HISTORY
--  $LastChangedDate: 2011-07-06 12:52:43 -0400 (Wed, 06 Jul 2011) $
--  $Revision: 1132 $
--  $LastChangedBy: amejia3 $
--  $Id: scht_unit_test_4.lua 1132 2011-07-06 16:52:43Z amejia3 $
-----------------------------------------------------------------------------
