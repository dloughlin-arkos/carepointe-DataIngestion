USE CAREPOINTE;

/*
Author		: Srikanth Vunyala
CreatedDt	: 10/27/2021
Purpose		: This object acts as a staging area to hold source file content during load execution
*/

DROP TABLE IF EXISTS CAREPOINTE.tbl_rx_claims_stg;

CREATE TABLE `tbl_rx_claims_stg` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int DEFAULT '0',
  `RX_CLAIM_ID` bigint DEFAULT NULL,
  `MEMBER_AMISYS_NBR` varchar(11) DEFAULT NULL,
  `MEDICARE_ID` varchar(11) DEFAULT NULL,
  `MDCR_BNFCRY_ID` varchar(11) DEFAULT NULL,
  `prescription_nbr` bigint DEFAULT NULL,
  `precriber_npi` bigint DEFAULT NULL,
  `prescriber_tin` bigint DEFAULT NULL,
  `prescriber_name` tinytext,
  `fill_date` datetime DEFAULT NULL,
  `fill_date_yyyy_mm` bigint DEFAULT NULL,
  `NATIONAL_DRUG_CODE_NBR` bigint DEFAULT NULL,
  `GPI_NBR` varchar(25) DEFAULT NULL,
  `Rx_Formulary` tinyint(1) DEFAULT NULL,
  `RX_TierCode` bigint DEFAULT NULL,
  `RX_TierName` varchar(84) DEFAULT NULL,
  `RX_TierCodeGeneric` tinytext,
  `RX_TierCodeBrand` tinytext,
  `RX_TherapeuticClass` varchar(250) DEFAULT NULL,
  `RX_TherapeuticName` varchar(250) DEFAULT NULL,
  `DRUG_DESC` varchar(25) DEFAULT NULL,
  `days_supply` bigint DEFAULT NULL,
  `DISPENSED_QUANTITY` bigint DEFAULT NULL,
  `AMT_PAID` double DEFAULT NULL,
  `brand_generic` char(1) DEFAULT NULL,
  `INST_NAME` varchar(60) DEFAULT NULL,
  `PHRMCY_DSPNSR_TYPE_DESC` varchar(250) DEFAULT NULL,
  `member_county_name` varchar(8) DEFAULT NULL,
  `pcp_irs_nbr` bigint DEFAULT NULL,
  `panel_prov` varchar(4) DEFAULT NULL,
  `ADJDCTN_STATUS_DESC` varchar(4) DEFAULT NULL,
  `PART_B_INDICATOR` tinyint(1) DEFAULT NULL,
  `Created_at` datetime DEFAULT NULL,
  `created_by` int DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `updated_by` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_patient_id` (`patient_id`),
  KEY `idx_rxclaim_id` (`RX_CLAIM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
