USE CAREPOINTE;

DROP PROCEDURE IF EXISTS CAREPOINTE.up_Ins_JobDetailLog;

DELIMITER //

CREATE PROCEDURE CAREPOINTE.up_Ins_JobDetailLog (
IN
	intJobID			int	,
	intProcessID		int	,
	varTaskNm			VARCHAR(100),
	varEventType		VARCHAR(50),
	varEventDesc		TEXT,
	intTaskDuration		int,
	intRowCnt			int,
	varUserID			VARCHAR(50),
	varHostNm			VARCHAR(50)
)

/*
Author		: Srikanth Vunyala
CreatedDt	: 10/27/2021
Purpose		: This object is used to write execution log to tbl_JobDetailLog table from other tools and programming langauges.
*/

BEGIN
	IF (intTaskDuration = '') THEN SET intTaskDuration = 0; END IF;
    IF (intRowCnt = 0) THEN SET intRowCnt = 0; END IF;
    IF (varUserID='') THEN SET varUserID = CURRENT_USER(); END IF;
	IF (varHostNm='') THEN SET varHostNm = @@HOSTNAME; END IF;

	INSERT INTO tbl_JobDetailLog
				(JobID
				,ProcessID
				,TaskNm
				,EventType
				,EventDesc
				,TaskDuration
				,RowCnt
				,UserID
				,HostNm
				,EventDt)
		VALUES (
				intJobID, intProcessID, varTaskNm, varEventType, varEventDesc, intTaskDuration,
				intRowCnt, varUserID, varHostNm, CURRENT_TIMESTAMP);
	 
END; //

DELIMITER ;