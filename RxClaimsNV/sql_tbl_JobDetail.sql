USE CAREPOINTE;

/*
Author		: Srikanth Vunyala
CreatedDt	: 10/27/2021
Purpose		: This script is used to make changes to tbl_JobDetail table
*/

TRUNCATE TABLE CAREPOINTE.tbl_JobDetail;

INSERT INTO CAREPOINTE.tbl_JobDetail
	(JobId,
	JobStreamNm,
	JobNm,
	ContainerNm,
	BusinessDesc,
	PredecessorJobID,
	InputFilePath,
	OutputFilePath,
	JobSchedule)
VALUES
	(1101, 'Claims', 'RxClaims', 'RxClaimsLoadNV', 'Nevada Rx claims load into carepointe database', NULL, NULL, NULL, 'Monthly 1st Monday @ 0600 HRS ET'),
	(1102, 'Claims', 'RxClaims', 'RxClaimsLoadAZ', 'Arizona Rx claims load into carepointe database', NULL, NULL, NULL, 'Monthly 1st Monday @ 0600 HRS ET'),
	(1201, 'Claims', 'Membership', 'MemberLoadSilverSummit', 'Silver Summit Membership load into carepointe database', NULL, NULL, NULL, 'Monthly 1st Tuesday @ 0600 HRS ET'),
	(1202, 'Claims', 'Membership', 'MemberLoadAllwellPIMA', 'Allwell PIMA Membership load into carepointe database', NULL, NULL, NULL, 'Monthly 1st Tuesday @ 0600 HRS ET');
