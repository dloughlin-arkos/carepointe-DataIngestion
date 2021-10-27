USE CAREPOINTE;

	DROP TABLE IF EXISTS CAREPOINTE.tbl_JobDetailLog;
    
	CREATE TABLE CAREPOINTE.tbl_JobDetailLog (
		EventID INT NOT NULL AUTO_INCREMENT,
		JobID INT NOT NULL,
		ProcessID INT NOT NULL,
		TaskNm VARCHAR(100) NOT NULL,
		EventType VARCHAR(50) NOT NULL,
		EventDesc TEXT NOT NULL,
		TaskDuration INT NULL,
		RowCnt INT NULL,
		UserID VARCHAR(50) NULL,
		HostNm VARCHAR(50) NULL,
		EventDt DATETIME NOT NULL,
		PRIMARY KEY (EventID)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1;

	CALL up_Ins_JobDetailLog (0, 0, 'FirstLog', 'FirstLog','FirstLog', 0, 0, 'FirstLog', 'FirstLog');