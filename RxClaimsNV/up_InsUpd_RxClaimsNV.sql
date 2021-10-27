USE CAREPOINTE;
DROP PROCEDURE IF EXISTS up_InsUpd_RxClaimsNV;

DELIMITER //
CREATE PROCEDURE up_InsUpd_RxClaimsNV (
	IN
	intJobID			INT,
	intProcessID		INT
)

/*
Author		: Srikanth Vunyala
CreatedDt	: 10/27/2021
Purpose		: This object does upsert of data from staging table to main table for Rx_Claims.
*/

BEGIN
DECLARE dtProcStartTime			DATETIME DEFAULT CURRENT_TIMESTAMP;
DECLARE dtQryStartTime			DATETIME DEFAULT CURRENT_TIMESTAMP;
DECLARE intStatementDuration	INT DEFAULT 0;
DECLARE intProcDuration			INT DEFAULT 0;
DECLARE varHostNm				VARCHAR(50) DEFAULT @@HOSTNAME;
DECLARE varUserNm				VARCHAR(50) DEFAULT CURRENT_USER();
DECLARE intRowCnt				INT DEFAULT 0;
DECLARE varErrorDesc			TEXT;
DECLARE varErrorMessage			TEXT;
DECLARE intErrorSeverity		INT;
DECLARE intErrorState			INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 intErrorState = RETURNED_SQLSTATE, 
		intErrorSeverity = MYSQL_ERRNO, varErrorMessage = MESSAGE_TEXT;
		SET varErrorDesc = CONCAT("ERROR ", intErrorSeverity, " (", intErrorState, "): ", varErrorMessage);
		SET intStatementDuration = TIMESTAMPDIFF(SECOND,dtQryStartTime,CURRENT_TIMESTAMP);	
        
        CALL up_Ins_JobDetailLog (intJobID, intProcessID,  'up_InsUpd_RxClaimsNV', 'Error', varErrorDesc, intStatementDuration, 0, varUserNm, varHostNm);
        CALL up_Ins_JobDetailLog (intJobID, intProcessID,  'up_InsUpd_RxClaimsNV', 'Complete','sp Failed', intStatementDuration, 0, varUserNm, varHostNm);
        
        SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = varErrorDesc;
    END;
    

	SELECT 
		CASE WHEN intProcessID < MAX(ProcessID) THEN MAX(ProcessID)+1 ELSE intProcessID END
	INTO intProcessID 
    FROM tbl_JobDetailLog;

	SELECT CASE WHEN 	
		(SELECT EXISTS (
			SELECT JobID
			FROM tbl_JobDetail 
			WHERE JobID = intJobID)) = 0 THEN 0 ELSE intJobID END
	INTO intJobID;


SET intRowCnt = ROW_COUNT();
SET intStatementDuration = TIMESTAMPDIFF(SECOND,dtQryStartTime,CURRENT_TIMESTAMP);
CALL up_Ins_JobDetailLog (intJobID, intProcessID, 'up_InsUpd_RxClaimsNV', 'Start','sp Initiated', intStatementDuration, 0, varUserNm, varHostNm);
SET dtQryStartTime = CURRENT_TIMESTAMP;

	SELECT * FROM (
	  SELECT CONCAT('DROP TABLE ', GROUP_CONCAT(table_name) , ';')
	  FROM INFORMATION_SCHEMA.TABLES
	  WHERE table_name LIKE 'tbl_rx_claims_backup%'
	) a INTO @mystmt;

	IF LENGTH(@mystmt) > 0 THEN 
		PREPARE mystatement FROM @mystmt;
		EXECUTE mystatement;
	END IF;
	
SET intRowCnt = ROW_COUNT();
SET intStatementDuration = TIMESTAMPDIFF(SECOND,dtQryStartTime,CURRENT_TIMESTAMP);
CALL up_Ins_JobDetailLog (intJobID, intProcessID, 'up_InsUpd_RxClaimsNV', 'Drop', 'Backup of tbl_rx_claims tables dropped', intStatementDuration, intRowCnt, varUserNm, varHostNm);
SET dtQryStartTime = CURRENT_TIMESTAMP;
	SELECT CONCAT('CREATE TABLE tbl_rx_claims_backup', YEAR(CURRENT_TIMESTAMP),MONTH(CURRENT_TIMESTAMP),' ','SELECT * FROM tbl_rx_claims;')
    INTO @bkpstmt;
    
	IF LENGTH(@bkpstmt) > 0 THEN 
		PREPARE mystatement FROM @bkpstmt;
		EXECUTE mystatement;
	END IF;

SET intRowCnt = ROW_COUNT();
SET intStatementDuration = TIMESTAMPDIFF(SECOND,dtQryStartTime,CURRENT_TIMESTAMP);
CALL up_Ins_JobDetailLog (intJobID, intProcessID, 'up_InsUpd_RxClaimsNV', 'Create', 'Backup created before monthly load', intStatementDuration, intRowCnt, varUserNm, varHostNm);
SET dtQryStartTime = CURRENT_TIMESTAMP;

	UPDATE tbl_rx_claims rx
	INNER JOIN tbl_rx_claims_stg rx1 
		ON rx1.rx_claim_id = rx.rx_claim_id
	SET
		rx.MEMBER_AMISYS_NBR 	= rx1.MEMBER_AMISYS_NBR,
		rx.MEDICARE_ID 			= rx1.MEDICARE_ID,
		rx.MDCR_BNFCRY_ID 		= rx1.MDCR_BNFCRY_ID,
		rx.prescription_nbr 	= rx1.prescription_nbr,
		rx.precriber_npi 		= rx1.precriber_npi,
		rx.prescriber_tin 		= rx1.prescriber_tin,
		rx.prescriber_name 		= rx1.prescriber_name,
		rx.fill_date 			= rx1.fill_date,
		rx.fill_date_yyyy_mm 	= rx1.fill_date_yyyy_mm,
		rx.NATIONAL_DRUG_CODE_NBR = rx1.NATIONAL_DRUG_CODE_NBR,
		rx.GPI_NBR 				= rx1.GPI_NBR,
		rx.Rx_Formulary 		= rx1.Rx_Formulary,
		rx.RX_TierCode 			= rx1.RX_TierCode,
		rx.RX_TierName 			= rx1.RX_TierName,
		rx.RX_TierCodeGeneric 	= rx1.RX_TierCodeGeneric,
		rx.RX_TierCodeBrand 	= rx1.RX_TierCodeBrand,
		rx.RX_TherapeuticClass 	= rx1.RX_TherapeuticClass,
		rx.RX_TherapeuticName 	= rx1.RX_TherapeuticName,
		rx.DRUG_DESC 			= rx1.DRUG_DESC,
		rx.days_supply 			= rx1.days_supply,
		rx.DISPENSED_QUANTITY 	= rx1.DISPENSED_QUANTITY,
		rx.AMT_PAID 			= rx1.AMT_PAID,
		rx.brand_generic 		= rx1.brand_generic,
		rx.INST_NAME 			= rx1.INST_NAME,
		rx.PHRMCY_DSPNSR_TYPE_DESC = rx1.PHRMCY_DSPNSR_TYPE_DESC,
		rx.member_county_name 	= rx1.member_county_name,
		rx.pcp_irs_nbr 			= rx1.pcp_irs_nbr,
		rx.panel_prov 			= rx1.panel_prov,
		rx.ADJDCTN_STATUS_DESC 	= rx1.ADJDCTN_STATUS_DESC,
		rx.PART_B_INDICATOR 	= rx1.PART_B_INDICATOR,
		rx.updated_at 			= CURRENT_TIMESTAMP(),
		rx.updated_by 			= 1065;

SET intRowCnt = ROW_COUNT();
SET intStatementDuration = TIMESTAMPDIFF(SECOND,dtQryStartTime,CURRENT_TIMESTAMP);
CALL up_Ins_JobDetailLog (intJobID, intProcessID, 'up_InsUpd_RxClaimsNV', 'Update', 'Matching RxClaim records updated', intStatementDuration, intRowCnt, varUserNm, varHostNm);
SET dtQryStartTime = CURRENT_TIMESTAMP;

	INSERT INTO tbl_rx_claims (
		RX_CLAIM_ID,
		MEMBER_AMISYS_NBR,
		MEDICARE_ID,
		MDCR_BNFCRY_ID,
		prescription_nbr,
		precriber_npi,
		prescriber_tin,
		prescriber_name,
		fill_date,
		fill_date_yyyy_mm,
		NATIONAL_DRUG_CODE_NBR,
		GPI_NBR,
		Rx_Formulary,
		RX_TierCode,
		RX_TierName,
		RX_TierCodeGeneric,
		RX_TierCodeBrand,
		RX_TherapeuticClass,
		RX_TherapeuticName,
		DRUG_DESC,
		days_supply,
		DISPENSED_QUANTITY,
		AMT_PAID,
		brand_generic,
		INST_NAME,
		PHRMCY_DSPNSR_TYPE_DESC,
		member_county_name,
		pcp_irs_nbr,
		panel_prov,
		ADJDCTN_STATUS_DESC,
		PART_B_INDICATOR,
		Created_at,
		created_by,
		updated_at,
		updated_by
	)
	SELECT 
		RX_CLAIM_ID,
		MEMBER_AMISYS_NBR,
		MEDICARE_ID,
		MDCR_BNFCRY_ID,
		prescription_nbr,
		precriber_npi,
		prescriber_tin,
		prescriber_name,
		fill_date,
		fill_date_yyyy_mm,
		NATIONAL_DRUG_CODE_NBR,
		GPI_NBR,
		Rx_Formulary,
		RX_TierCode,
		RX_TierName,
		RX_TierCodeGeneric,
		RX_TierCodeBrand,
		RX_TherapeuticClass,
		RX_TherapeuticName,
		DRUG_DESC,
		days_supply,
		DISPENSED_QUANTITY,
		AMT_PAID,
		brand_generic,
		INST_NAME,
		PHRMCY_DSPNSR_TYPE_DESC,
		member_county_name,
		pcp_irs_nbr,
		panel_prov,
		ADJDCTN_STATUS_DESC,
		PART_B_INDICATOR,
		CURRENT_TIMESTAMP(),
		1065,
		CURRENT_TIMESTAMP(),
		1065
	FROM tbl_rx_claims_stg rx1
	WHERE NOT EXISTS (SELECT 1 FROM tbl_rx_claims rx WHERE rx.rx_claim_id = rx1.rx_claim_id);


SET intRowCnt = ROW_COUNT();
SET intStatementDuration = TIMESTAMPDIFF(SECOND,dtQryStartTime,CURRENT_TIMESTAMP);
CALL up_Ins_JobDetailLog (intJobID, intProcessID, 'up_InsUpd_RxClaimsNV', 'Insert', 'Created new RxClaim records', intStatementDuration, intRowCnt, varUserNm, varHostNm);
SET dtQryStartTime = CURRENT_TIMESTAMP;

	UPDATE tbl_rx_claims rc 
	INNER JOIN tbl_patient tp ON tp.mrn_id = rc.MEMBER_AMISYS_NBR
	SET rc.patient_id = tp.patient_id;

SET intRowCnt = ROW_COUNT();
SET intStatementDuration = TIMESTAMPDIFF(SECOND,dtQryStartTime,CURRENT_TIMESTAMP);
CALL up_Ins_JobDetailLog (intJobID, intProcessID, 'up_InsUpd_RxClaimsNV', 'Update','MRN ID updated in Patient table', intStatementDuration, intRowCnt, varUserNm, varHostNm);
SET dtQryStartTime = CURRENT_TIMESTAMP;

	INSERT INTO tbl_MRN_Exception (
		JobID,
        ProcessID,
		MRN_ID,
		Created_By)
	SELECT DISTINCT intJobID, intProcessID, C.MEMBER_AMISYS_NBR AS MRN_ID, 1065
	FROM tbl_rx_claims C
	WHERE C.Patient_ID = 0;
    
SET intRowCnt = ROW_COUNT();
SET intStatementDuration = TIMESTAMPDIFF(SECOND,dtQryStartTime,CURRENT_TIMESTAMP);
CALL up_Ins_JobDetailLog (intJobID, intProcessID, 'up_InsUpd_RxClaimsNV', 'Insert','Missing MRN exceptions captured', intStatementDuration, intRowCnt, varUserNm, varHostNm);
SET dtQryStartTime = CURRENT_TIMESTAMP;


SET intStatementDuration = TIMESTAMPDIFF(SECOND,dtQryStartTime,CURRENT_TIMESTAMP);
CALL up_Ins_JobDetailLog (intJobID, intProcessID, 'up_InsUpd_RxClaimsNV', 'Complete','sp Succeeded', intStatementDuration, 0, varUserNm, varHostNm);

END; //

DELIMITER ;