USE CAREPOINTE;

/*
Author		: Srikanth Vunyala
CreatedDt	: 10/27/2021
Purpose		: This object holds list of data loads and their job details
*/

	DROP TABLE IF EXISTS tbl_JobDetail;

	CREATE TABLE tbl_JobDetail (
		JobId INT NOT NULL,
		JobStreamNm VARCHAR(100) NOT NULL,
		JobNm VARCHAR(100) NOT NULL,
		ContainerNm VARCHAR(100) NOT NULL,
		BusinessDesc VARCHAR(255) NOT NULL,
		PredecessorJobID INT DEFAULT NULL,
		InputFilePath TEXT DEFAULT NULL,
		OutputFilePath TEXT DEFAULT NULL,
		JobSchedule VARCHAR(200) NOT NULL,
		PRIMARY KEY (JobId)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;
