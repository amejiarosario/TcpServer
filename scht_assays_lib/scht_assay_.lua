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

	axReps.nRep = {}
	axReps.nRep.xDryRep = {}
	axReps.nRep.xDryRep.eAssayModelType = --
	axReps.nRep.xDryRep.sSONumber = --
	axReps.nRep.xDryRep.eMetRules = --
	axReps.nRep.xDryRep.lNumSteps = --
	axReps.nRep.xDryRep.lNumSoNumsToFollow = --

	axReps.nRep.xDryRep.xContamInfo = {}
	axReps.nRep.xDryRep.xContamInfo.lNumTestsContam = --
	axReps.nRep.xDryRep.xContamInfo.lNumDecontamTests = --

	axReps.nRep.xDryRep.xContamInfo.axContaminatesFor = {}

	j=1
	axReps.nRep.xDryRep.xContamInfo.axContaminatesFor[j] = {}
	axReps.nRep.xDryRep.xContamInfo.axContaminatesFor[j].sSONumber = --
	axReps.nRep.xDryRep.xContamInfo.axContaminatesFor[j].lMinPmCyclesToContam = --
	axReps.nRep.xDryRep.xContamInfo.axContaminatesFor[j].lNumPmCyclesContam = --
	-- ... j+=1

	k=1
	axReps.nRep.xDryRep.xContamInfo.axDecontaminates[k] = {}
	axReps.nRep.xDryRep.xContamInfo.axDecontaminates[k].sSONumber = --


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
