/*
*MH*******************************************************************
*MH	
*MH	COPYRIGHT ORTHO CLINICAL DIAGNOSTICS 2001
*MH				ALL RIGHTS RESERVED
*MH
*MH*******************************************************************
*MH	
*MHMN MODULE NAME:		Dry_SCH_WlMsgs.h
*MH	
*MH	PURPOSE:
*MH		This header file contains the definition of the Sample Worklist
*MH	that is transmitted to the Sched task.
*MH		The Sample Worklist message is formatted by PreProc and sent
*MH	to Control.  Control forwards this message to Sched.
*MH	
*MH	ORIGINAL AUTHOR:	Mark D. Reed
*MH	
*MH	ORIGINAL DATE:		
*MH	
*MH	REVISION HISTORY:	at bottom of file
*MH	
*MH*******************************************************************
*/

#ifndef DRY_SCH_WL_MSGS_H
#define DRY_SCH_WL_MSGS_H


#include "SS_Def.h"
#include "CMN_SS_Def.h"
#include "CMN_DatabaseDefines.h"
#include "CMN_SampleProcessing.h"
#include "CMN_ChooseSampCrit.h"
#include "DRY_INV_Def.h"

#include "DRY_SCH_MsgSharedDefs.h"
#include "DRY_SCH_Cmn.h"

namespace dry
{

// All volumes are defined in 1/100th of micro-liters in a Signed LONG
// CmCycle: 9.5 second cycle based upon the cycle of the CM Rate Ring
// PmCycle: 4.5 second cycle based upon the cycle of the PM Ring
#define SCH_WL_WET_MAX_STEPS_PER_TEST	30
#define	SCH_MAX_NUM_REPS_PER_SAMPLE		CMN_MAX_NUM_REPS_PER_SAMPLE

typedef enum
{
	NON_MW_WORKLIST,
	MW_WORKLIST,
	NUM_WL_TYPES
} SCH_WL_WORKLIST_TYPE;

//////////////////////////
// DRY DEFS
//////////////////////////
#define SCH_WL_DRY_MAX_STEPS_PER_TEST	5

typedef struct
{
	CMN_SHORT				sSONumber;
		// Test or Assay ID that is contaminated as a
		// result of running the current rep before the assays
		// defined in axContam
	CMN_LONG				lMinPmCyclesToContam;
		// Min # cycles that the current rep needs to be in a slot
		// before it can contaminate the assays within alContamIDs
	CMN_LONG				lNumPmCyclesContam;		
		// # Cycles that the pos is contaminated for if it is 
		// not decontaminated first
} SCH_WL_DRY_SO_CONTAM;


typedef struct
{
	CMN_SHORT				sSONumber;
		// Test or Assay IDs that is Decontaminated as a
		// result of running the current rep before the assays
		// defined in axDecontam
} SCH_WL_DRY_SO_DECONTAM;

// Define the contamination and decontamination defs
typedef struct
{
	CMN_LONG				lNumTestsContam;
		// Num of valid entries in alContamIDs
	SCH_WL_DRY_SO_CONTAM	axContaminatesFor[CMN_MAX_CONTAM_TESTS_PER_REP];
		// List of Test or Assay IDs that are contaminated as a
		// result of running the current rep
	CMN_LONG				lNumDecontamTests;
		// Num of valid entries in alDecontamIDs
	SCH_WL_DRY_SO_DECONTAM	axDecontaminates[CMN_MAX_DECONTAM_TESTS_PER_REP];
		// List of Test or Assay IDs that are Decontaminated as a
		// result of running the current rep
} SCH_WL_DRY_REP_CONTAM;


// Define the parameters required for the Dry Reag Step
typedef struct
{
	CMN_REAGENT_LOCATION	xLocation;			// eSupply and lSlot
} SCH_WL_DRY_REAG_STEP;

// Define the parameters required for the Dry Samp Step
typedef struct
{
	SS_POS_TOKEN_VALUES		ePrimSpotPos;		// CM_TIP_LOC | PM_TIP_LOC
	CMN_LONG				lDelayPmCycles;		// Post Metering Delay
	CMN_MET_DISP_PROFILE	xDispProfile;		// Profile for SpotSlide
	CMN_MET_ASP_PROFILE		xRefAspProfile;
	CMN_MET_DISP_PROFILE	xRefDispProfile;
} SCH_WL_DRY_SAMP_STEP;

// Define the parameters required for the Dry Inc Step
typedef struct
{
	CMN_DRY_REP_INS_BLADE_SEL	eInsBladeSelection;	// RM defines ins blade
	CMN_DRY_REP_DUMP_BLADE_SEL	eDumpBladeSelection;// RM defines Dump blade
	CMN_DRY_MAJOR_INC_POS		eMajorIncPos;		// INNER | OUTER | OPTIMIZE
} SCH_WL_DRY_INC_STEP;

// Define the different valid types of Dry Read Steps

// Define the parameters required for the Dry Read Step
// CM Tests: All reads for the different wavelengths will 
// be done in less than 1.6 seconds
// Rate Tests: Each separate read is separated by one CM_Cycle
// Cycles without a read will be represented with a 0 wavelength
// PM Tests: No read data is needed at this time
typedef struct
{
	CMN_READ_TYPE			eReadType;
	CMN_LONG				lNumValidFilters;
	CMN_LONG				alFilterSlots[CMN_DRY_RATE_MAX_PTS_PER_RES];	
} SCH_WL_DRY_READ_STEP;

// Define the parameters required for the Dry Wash Step
typedef struct
{
	CMN_MET_ASP_PROFILE		xAspProfile;
	CMN_MET_DISP_PROFILE	xDispProfile;
//	Post Launch
//	CMN_LONG				lPostMetCmCycles;		
		// # cycles to delay after IR Metering before pushing slide 
		// back into the CM Rate ring
	CMN_DRY_IR_FLUID_TYPE	eFluidType;		// IWF | SWF
	CMN_DRY_IR_WASH_LOC		eWashSpotLoc;	// CENTER | OFF_CENTER
} SCH_WL_DRY_WASH_STEP;

typedef union
{
	SCH_WL_DRY_REAG_STEP	xReagStep;
	SCH_WL_DRY_SAMP_STEP	xSampStep;
	SCH_WL_DRY_INC_STEP		xIncStep;
	SCH_WL_DRY_READ_STEP	xReadStep;
	SCH_WL_DRY_WASH_STEP	xWashStep;
} SCH_WL_DRY_REP_STEP_UNN;

typedef struct
{
	CMN_PROT_STEP_TYPE		eStepType;	// REAG | SAMP | INC | READ | WASH
	SCH_WL_DRY_REP_STEP_UNN	nStep;
} SCH_WL_DRY_REP_STEP;


// Define any Dry Replicate
typedef struct
{
	CMN_ASSAY_MODEL_TYPE	eAssayModelType;// CM | RATE | PM | WET_RATE | WET_END_POINT
	CMN_SHORT				sSONumber;		// Define the cart
	CMN_ASSAY_MET_RULES		eMetRules;		// NOT_FIRST_ABS | NOT_FIRST_RECOMMENDED
	CMN_LONG				lNumSoNumsToFollow;
	CMN_SHORT				asSoNumsToFollow[CMN_MAX_TESTS_FORCED_TO_FOLLOW];
	SCH_WL_DRY_REP_CONTAM	xContamInfo;
	CMN_LONG				lNumSteps;
	SCH_WL_DRY_REP_STEP		axSteps[SCH_WL_DRY_MAX_STEPS_PER_TEST];
} SCH_WL_DRY_REP;

//////////////////////////
// SI REP DEF
//////////////////////////
typedef struct
{
	CMN_BOOL				bSiRequired;
// Sched wil default the values of the following parameters
//	CMN_ASSAY_MODEL_TYPE	eAssayModelType;// CM | RATE | PM | WET_RATE | WET_END_POINT
//	CMN_LONG				lAssayNum;		// map to test within TEST_REC
//	CMN_SHORT				sRepSeqNum;		// map to rep within TEST_REC
} SCH_WL_SI_REP;

typedef union
{
	SCH_WL_DRY_REP			xDryRep;
} SCH_WL_REP_UNN;

// Define any replicate
typedef struct
{
	CMN_ASSAY_MODULE_TYPE	eABFModule;		// WET | DRY | SI
	CMN_LONG				lAssayNum;		// map to test within TEST_REC
	CMN_SHORT				sRepSeqNum;		// map to rep within TEST_REC
	CMN_SHORT				sCalLevel;		// Pass through (serial dilutions)
	CMN_LONG				lDilIndex;		// index axDil to define any
		// needed dil stages for this rep. 
		// SCH_WL_NO_DIL_INDEX: means no dil stage needed
	CMN_LONG				lAliqExpWetCyclesToFail;
		// # Wet Cycles that the sample may remain in AliquotBuffer
		// before all associated results will be failed
	CMN_LONG				lAliqPretreatExpWetCyclesToFail;
		// # Wet Cycles that the sample may remain in AliquotBuffer
		// before all associated results will be failed
	CMN_LONG				lDilExpWetCyclesToFail;
		// # Wet Cycles that the sample may remain in AliquotBuffer
		// before all associated results will be failed
	CMN_SHORT				sMeteringPriority;	// Prot specific
	SCH_WL_REP_UNN			nRep;
} SCH_WL_REP;

// Defines information  about unstarted reps not otherwise known to sched
// Currently used to inform sched about the number of unstarted reps for each
// processing module.  This information is used as input to the load balancing
// algorithm for MicroTip vs. MicroWell scheduling.
// DTR 5209 added highest priority sample to the structure so sched can run higher
// priority samples even if the balancing says not to NOTE: slide info not currently used
typedef struct
{
	CMN_LONG				lNumMicroSlideReps; 
	CMN_LONG				lHighestSamplePrioritySlide;
	CMN_LONG				lNumMicroTipReps;
	CMN_LONG				lHighestSamplePriorityMicroTip;
	CMN_LONG				lNumMicroWellReps;
	CMN_LONG				lHighestSamplePriorityMicroWell;
} SCH_WL_UNSTARTED_REPS_INFO;

//////////////////////////
// SAMPLE WORKLIST DEF
//////////////////////////
typedef struct
{
	SCH_WL_WORKLIST_TYPE		eWorklistType;	// either NON_MW_WORKLIST or MW_WORKLIST
	CMN_LONG					lResultID;		// Pass Thru info: Key into Results DB
	CMN_LONG					lSampleProgramID; // Pass through for Intellichecks
	CMN_LONG					lCalGroupRunID;	// Pass Thru info: Key into Cal DB
	CMN_SHORT					sCalBottleNum;	// Pass Thru info
	CMN_CHAR					wTray[CMN_UTFSTR(CMN_TRAY_LEN)];  // Identifies sample tray
	CMN_SHORT					sCupPosition;	// Identifies sample cup position within tray
	CMN_BODY_FLUID				eBodyFluid;		// Needed by Metering
	CMN_BOOL					bPrimMetMixSampBeforeAsp;	// Premix before asp on some body fluid/QC fluid/assay combinations
	CMN_CHAR					wSampleNameForDisplay[CMN_UTFSTR(CMN_IDENTITY_LEN)];// Text substituted on certain errors
	CMN_SAMP_CONTAINER			xPrimContainer;	// Needed by Met Subsys
	CMN_LONG					lSampPriority;
	SS_POS_TOKEN_VALUES			ePrimMetPos;	// REFLEX | STAT | ROUTINE
	CMN_MET_ASP_PROFILE			xAspProfile;	// Total Vol across all dips
	CMN_ULONG					ulWlGroupId;
	CMN_SHORT					sWlGroupIndex;
	CMN_SHORT					sNumWlInGroup;
	CMN_LONG					lNumUniqueDryDills; // used to unreserve tips when sample asp fails
	CMN_LONG					lNumReps;		// # Reps within axRep
	SCH_WL_REP					axReps[SCH_MAX_NUM_REPS_PER_SAMPLE];
	SCH_WL_SI_REP				xSiRep;
	RET_STAT					SampRetStat;	// If ! PASS Fail all reps immediately
	SCH_WL_UNSTARTED_REPS_INFO	xUnstartedRepsOnBoard;
} SCH_SAMP_WL_MSG;

} // end dry

#endif // DRY_SCH_WL_MSGS_H


/*
*/
/*
*RH**************************************************************
*RH
*RH REVISION HISTORY
*RH $LastChangedDate$
*RH $Revision$
*RH $LastChangedBy$
*RH $Id$
*RH
*RH**************************************************************
*/
