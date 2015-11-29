-- MySQL dump 10.13  Distrib 5.6.22, for osx10.8 (x86_64)
--
-- Host: localhost    Database: quickkyc
-- ------------------------------------------------------
-- Server version	5.6.22

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `form`
--

DROP TABLE IF EXISTS `form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `m_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `details` varchar(250) DEFAULT NULL,
  `updatetime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form`
--

LOCK TABLES `form` WRITE;
/*!40000 ALTER TABLE `form` DISABLE KEYS */;
INSERT INTO `form` VALUES (1,1,'Saving Account','For SB Account Opening','2015-11-28 10:36:02'),(2,2,'Insurance','For Life Insurance Policy','2015-11-28 10:36:02');
/*!40000 ALTER TABLE `form` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_keys`
--

DROP TABLE IF EXISTS `form_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fid` int(11) DEFAULT NULL,
  `qk_id` varchar(100) DEFAULT NULL,
  `option` int(11) DEFAULT '0',
  `minlength` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_keys`
--

LOCK TABLES `form_keys` WRITE;
/*!40000 ALTER TABLE `form_keys` DISABLE KEYS */;
INSERT INTO `form_keys` VALUES (1,1,'QK_PRF_NAME',0,1),(2,1,'QK_PRF_GENDER',0,1),(3,1,'QK_PRF_DOB',0,8),(4,1,'QK_PRF_MARITALSTATUS',0,1),(5,1,'QK_CNT_EMAIL1',0,20),(6,1,'QK_CNT_PHONE_MOBILE_1',0,10),(7,1,'QK_CNT_HOMEADDR',0,10),(8,1,'QK_CNT_HOMEADDR_PIN',0,6),(9,1,'QK_CNT_HOMEADDR_COUNTRY',0,10),(10,1,'QK_ID_PAN',0,10),(11,1,'QK_ID_PASSPORT',0,8),(14,2,'QK_PRF_NAME',0,1),(15,2,'QK_PRF_GENDER',0,1),(16,2,'QK_PRF_DOB',0,8),(17,2,'QK_PRF_MARITALSTATUS',0,1),(18,2,'QK_CNT_EMAIL1',0,20),(19,2,'QK_CNT_PHONE_MOBILE_1',0,10),(20,2,'QK_CNT_HOMEADDR',0,10),(21,2,'QK_CNT_HOMEADDR_PIN',0,6),(22,2,'QK_CNT_HOMEADDR_COUNTRY',0,10),(23,2,'QK_ID_PAN',0,10),(24,2,'QK_ID_PASSPORT',0,8),(25,2,'QK_MED_BLOODGROUP',0,1),(26,2,'QK_MED_FBS',0,1),(27,2,'QK_MED_PPS',0,1),(28,2,'QK_MED_HBAIC',0,1),(29,2,'QK_DOC_PAN',0,0),(30,2,'QK_DOC_PASSPORT',0,0),(31,1,'QK_DOC_PAN',0,0),(32,1,'QK_ID_PASSPORT',0,NULL);
/*!40000 ALTER TABLE `form_keys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `merchant`
--

DROP TABLE IF EXISTS `merchant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `merchant` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `detail` varchar(100) DEFAULT NULL,
  `email` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `contact` varchar(20) DEFAULT NULL,
  `ms_url` varchar(255) DEFAULT NULL,
  `m_key` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `merchant`
--

LOCK TABLES `merchant` WRITE;
/*!40000 ALTER TABLE `merchant` DISABLE KEYS */;
INSERT INTO `merchant` VALUES (1,'ABC Bank','Retail Bank','m@d.com','1234','+91 87 92 114542','http://192.168.137.154/QuickKYC/quickkyc_merchant/','abc123'),(2,'XYZ Life Insurance','Life Insurance','a@z.com','1234','+91 12 34 567890','http://192.168.137.154/QuickKYC/quickkyc_merchant/','xyz123');
/*!40000 ALTER TABLE `merchant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qk_keys`
--

DROP TABLE IF EXISTS `qk_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qk_keys` (
  `id` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `placeholder` varchar(45) DEFAULT NULL,
  `type` varchar(45) NOT NULL,
  `category` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qk_keys`
--

LOCK TABLES `qk_keys` WRITE;
/*!40000 ALTER TABLE `qk_keys` DISABLE KEYS */;
INSERT INTO `qk_keys` VALUES ('QK_CNT_EMAIL1','Email','Enter email address','Email','Contact Information'),('QK_CNT_HOMEADDR','Current Address','Enter your current address','TextArea','Contact Information'),('QK_CNT_HOMEADDR_COUNTRY','Current Address Country','Enter your country','Text','Contact Information'),('QK_CNT_HOMEADDR_PIN','Current Address PIN','Enter pin','Text','Contact Information'),('QK_CNT_PERMADDR','Permanent Address','Enter your permanent address','TextArea','Contact Information'),('QK_CNT_PERMADDR_COUNTRY','Permanent Address Country','Enter your country','Text','Contact Information'),('QK_CNT_PERMADDR_PIN','Permanent Address PIN','Enter pin','Text','Contact Information'),('QK_CNT_PHONE_MOBILE_1','Mobile No.','Enter mobile no.','Phone','Contact Information'),('QK_CNT_PHONE_OFF_2','Phone (Off.)','Enter office phone no.','Phone','Contact Information'),('QK_CNT_PHONE_RES_2','Phone (Res.)','Enter residential phone no.','Phone','Contact Information'),('QK_DOC_AADHAAR','Aadhaar','Upload aadhaar card','DOC','Document'),('QK_DOC_BANKSTATEMENT','Bank Statement','Upload bank statement','DOC','Document'),('QK_DOC_DL','Driving Licence','Upload driving licence','DOC','Document'),('QK_DOC_ELECTRICITYBILL','Electricity Bill','Upload electricity bill','DOC','Document'),('QK_DOC_PAN','PAN Card','Upload pan card','DOC','Document'),('QK_DOC_PASSPORT','Passport','Upload passport','DOC','Document'),('QK_DOC_PHONEBILL','Phone Bill','Upload phone bill','DOC','Document'),('QK_DOC_SALARYSTATEMENT','Salary Statement','Upload salary statement','DOC','Document'),('QK_DOC_VOTERID','Voter','Upload voter id card','DOC','Document'),('QK_FIN_ANNUALSALARY','Annual Salary','Enter annual salary','Amount','Finance Information'),('QK_FIN_FINANCIALASSETS','Financial Assets','Financial assets','Amount','Finance Information'),('QK_FIN_MONTHLYSALARY','Monthly Salary','Your monthly salary','Amount','Finance Information'),('QK_FIN_NETWORTH','Net Worth','Enter your net worth','Amount','Finance Information'),('QK_ID_AADHAAR','Aadhaar ID','Enter aadhaar number','Text','Identity'),('QK_ID_DL','Driving Licence ID','Enter driving licence no.','Text','Identity'),('QK_ID_PAN','PAN Card ID','Enter pan no.','Text','Identity'),('QK_ID_PASSPORT','Passport ID','Enter passport no.','Text','Identity'),('QK_ID_VOTERID','Voter ID','Enter voter id','Text','Identity'),('QK_MED_ALLERGY1','Allergy 1','If any allergy','Text','Medical Information'),('QK_MED_ALLERGY2','Allergy 2','If any allergy','Text','Medical Information'),('QK_MED_ALLERGY3','Allergy 3','If any allergy','Text','Medical Information'),('QK_MED_BLOODGROUP','Blood Group','Your blood group','Enum','Medical Information'),('QK_MED_FBS','FBS','Your FBS','Number','Medical Information'),('QK_MED_HBAIC','HBAIC','Your HBAIC','Number','Medical Information'),('QK_MED_HDL','HDL','Your HDL','Number','Medical Information'),('QK_MED_LDL','LDL','Your LDL','Number','Medical Information'),('QK_MED_PPS','PPS','Your PPS','Number','Medical Information'),('QK_MED_TG','TG','Your TG','Number','Medical Information'),('QK_PRF_DOB','Date of Birth','','Date','Personal Information'),('QK_PRF_EDUCATION','Education','Please tell your education detail','Text','Personal Information'),('QK_PRF_GENDER','Gender','','Enum','Personal Information'),('QK_PRF_MARITALSTATUS','Marital Status','','Enum','Personal Information'),('QK_PRF_NAME','Name','Enter your name','Text','Personal Information'),('QK_PRF_OCCUPATION','Occupation','Enter your occupation','Text','Personal Information'),('QK_PRF_SPOUSEDOB','Spouse Date of Birth','','Date','Personal Information'),('QK_PRF_SPOUSEGENDER','Spouse Gender','','Enum','Personal Information'),('QK_PRF_SPOUSENAME','Spouse Name','Enter your spouse name','Text','Personal Information');
/*!40000 ALTER TABLE `qk_keys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qk_keys_values`
--

DROP TABLE IF EXISTS `qk_keys_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qk_keys_values` (
  `qk_id` varchar(45) NOT NULL,
  `value` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qk_keys_values`
--

LOCK TABLES `qk_keys_values` WRITE;
/*!40000 ALTER TABLE `qk_keys_values` DISABLE KEYS */;
INSERT INTO `qk_keys_values` VALUES ('QK_PRF_GENDER','Male'),('QK_PRF_GENDER','Female'),('QK_PRF_MARITALSTATUS','Single'),('QK_PRF_MARITALSTATUS','Married');
/*!40000 ALTER TABLE `qk_keys_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `validateddocs`
--

DROP TABLE IF EXISTS `validateddocs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `validateddocs` (
  `id` int(11) NOT NULL,
  `mid` varchar(100) NOT NULL,
  `md5` varchar(45) NOT NULL,
  `comment` varchar(200) DEFAULT NULL,
  `expirydate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `validateddocs`
--

LOCK TABLES `validateddocs` WRITE;
/*!40000 ALTER TABLE `validateddocs` DISABLE KEYS */;
/*!40000 ALTER TABLE `validateddocs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'quickkyc'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-11-29 15:55:28
