USE CAREPOINTE;

/*
Author		: Srikanth Vunyala
CreatedDt	: 10/27/2021
Purpose		: This object holds the MRN_ID exception generated from claims load
*/

DROP TABLE IF EXISTS tbl_MRN_Exception;

CREATE TABLE `tbl_MRN_Exception` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`JobID` INT NOT NULL,
	`ProcessID` INT NOT NULL,
	`MRN_ID` VARCHAR(250) DEFAULT NULL,
	`Created_Dt` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`Created_By` INT NOT NULL,
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
