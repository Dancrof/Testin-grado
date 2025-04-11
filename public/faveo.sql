/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.6.20-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: faveo
-- ------------------------------------------------------
-- Server version	10.6.20-MariaDB-ubu2204

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity_log`
--

DROP TABLE IF EXISTS `activity_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `log_name` varchar(255) DEFAULT NULL,
  `description` text NOT NULL,
  `subject_type` varchar(255) DEFAULT NULL,
  `event` varchar(255) DEFAULT NULL,
  `subject_id` bigint(20) unsigned DEFAULT NULL,
  `causer_type` varchar(255) DEFAULT NULL,
  `causer_id` bigint(20) unsigned DEFAULT NULL,
  `properties` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`properties`)),
  `batch_uuid` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subject` (`subject_type`,`subject_id`),
  KEY `causer` (`causer_type`,`causer_id`),
  KEY `activity_log_log_name_index` (`log_name`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log`
--

LOCK TABLES `activity_log` WRITE;
/*!40000 ALTER TABLE `activity_log` DISABLE KEYS */;
INSERT INTO `activity_log` VALUES (1,'Ticket Status','Status <a href=\'https://raffi.helpdesk/faveo/public/admin/status/1/edit\'>Open</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_Status','created',1,NULL,NULL,'{\"attributes\":{\"name\":\"Open\",\"order\":1,\"Default\":\"Yes\",\"visibility for client\":\"Yes\",\"halt sla\":\"No\",\"Comment\":\"No\",\"allow client\":\"Yes\",\"purpose of status\":\"open\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(2,'Ticket Status','Status <a href=\'https://raffi.helpdesk/faveo/public/admin/status/2/edit\'>Resolved</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_Status','created',2,NULL,NULL,'{\"attributes\":{\"name\":\"Resolved\",\"order\":2,\"Default\":\"No\",\"visibility for client\":\"Yes\",\"halt sla\":\"Yes\",\"Comment\":\"No\",\"allow client\":\"Yes\",\"purpose of status\":\"closed\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(3,'Ticket Status','Status <a href=\'https://raffi.helpdesk/faveo/public/admin/status/3/edit\'>Closed</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_Status','created',3,NULL,NULL,'{\"attributes\":{\"name\":\"Closed\",\"order\":3,\"Default\":\"Yes\",\"visibility for client\":\"Yes\",\"halt sla\":\"Yes\",\"Comment\":\"No\",\"allow client\":\"Yes\",\"purpose of status\":\"closed\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(4,'Ticket Status','Status <a href=\'https://raffi.helpdesk/faveo/public/admin/status/4/edit\'>Deleted</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_Status','created',4,NULL,NULL,'{\"attributes\":{\"name\":\"Deleted\",\"order\":4,\"Default\":\"Yes\",\"visibility for client\":\"Yes\",\"halt sla\":\"Yes\",\"Comment\":\"No\",\"allow client\":\"Yes\",\"purpose of status\":\"deleted\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(5,'Ticket Status','Status <a href=\'https://raffi.helpdesk/faveo/public/admin/status/5/edit\'>Request for close</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_Status','created',5,NULL,NULL,'{\"attributes\":{\"name\":\"Request for close\",\"order\":5,\"Default\":\"Yes\",\"visibility for client\":\"Yes\",\"halt sla\":\"Yes\",\"Comment\":\"No\",\"allow client\":\"Yes\",\"purpose of status\":\"approval\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(6,'Ticket Status','Status <a href=\'https://raffi.helpdesk/faveo/public/admin/status/6/edit\'>Spam</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_Status','created',6,NULL,NULL,'{\"attributes\":{\"name\":\"Spam\",\"order\":6,\"Default\":\"Yes\",\"visibility for client\":\"No\",\"halt sla\":\"Yes\",\"Comment\":\"No\",\"allow client\":\"No\",\"purpose of status\":\"spam\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(7,'Ticket Status','Status <a href=\'https://raffi.helpdesk/faveo/public/admin/status/7/edit\'>Unapproved</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_Status','created',7,NULL,NULL,'{\"attributes\":{\"name\":\"Unapproved\",\"order\":7,\"Default\":\"Yes\",\"visibility for client\":\"No\",\"halt sla\":\"Yes\",\"Comment\":\"No\",\"allow client\":\"No\",\"purpose of status\":\"unapproved\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(8,'Ticket Priority','Ticket Priority <a href=\'https://raffi.helpdesk/faveo/public/admin/ticket/priority/1/edit\'>Low</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_Priority','created',1,NULL,NULL,'{\"attributes\":{\"name\":\"Low\",\"Visibility\":\"Public\",\"Priority Description\":\"Low\",\"default\":\"non-default\",\"Priority Color\":\"#00a65a\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(9,'Ticket Priority','Ticket Priority <a href=\'https://raffi.helpdesk/faveo/public/admin/ticket/priority/2/edit\'>Normal</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_Priority','created',2,NULL,NULL,'{\"attributes\":{\"name\":\"Normal\",\"Visibility\":\"Public\",\"Priority Description\":\"Normal\",\"default\":\"Default\",\"Priority Color\":\"#00bfef\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(10,'Ticket Priority','Ticket Priority <a href=\'https://raffi.helpdesk/faveo/public/admin/ticket/priority/3/edit\'>High</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_Priority','created',3,NULL,NULL,'{\"attributes\":{\"name\":\"High\",\"Visibility\":\"Public\",\"Priority Description\":\"High\",\"default\":\"non-default\",\"Priority Color\":\"#f39c11\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(11,'Ticket Priority','Ticket Priority <a href=\'https://raffi.helpdesk/faveo/public/admin/ticket/priority/4/edit\'>Emergency</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_Priority','created',4,NULL,NULL,'{\"attributes\":{\"name\":\"Emergency\",\"Visibility\":\"Public\",\"Priority Description\":\"Emergency\",\"default\":\"non-default\",\"Priority Color\":\"#dd4b38\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(12,'Teams','Team <a href=\'https://raffi.helpdesk/faveo/public/admin/team/1/\'>Level 1 Support</a> has been created','App\\Model\\helpdesk\\Agent\\Teams','created',1,NULL,NULL,'{\"attributes\":{\"name\":\"Level 1 Support\",\"Status\":\"Active\",\"team lead\":null}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(13,'Teams','Team <a href=\'https://raffi.helpdesk/faveo/public/admin/team/2/\'>Level 2 Support</a> has been created','App\\Model\\helpdesk\\Agent\\Teams','created',2,NULL,NULL,'{\"attributes\":{\"name\":\"Level 2 Support\",\"Status\":\"Inactive\",\"team lead\":null}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(14,'Teams','Team <a href=\'https://raffi.helpdesk/faveo/public/admin/team/3/\'>Developer</a> has been created','App\\Model\\helpdesk\\Agent\\Teams','created',3,NULL,NULL,'{\"attributes\":{\"name\":\"Developer\",\"Status\":\"Inactive\",\"team lead\":null}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(15,'Departments','Department <a href=\'https://raffi.helpdesk/faveo/public/admin/department/1/\'>Support</a> has been created','App\\Model\\helpdesk\\Agent\\Department','created',1,NULL,NULL,'{\"attributes\":{\"name\":\"Support\",\"type\":\"Public\",\"outgoing email\":null,\"business hour\":null}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(16,'Departments','Department <a href=\'https://raffi.helpdesk/faveo/public/admin/department/2/\'>Sales</a> has been created','App\\Model\\helpdesk\\Agent\\Department','created',2,NULL,NULL,'{\"attributes\":{\"name\":\"Sales\",\"type\":\"Public\",\"outgoing email\":null,\"business hour\":null}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(17,'Departments','Department <a href=\'https://raffi.helpdesk/faveo/public/admin/department/3/\'>Operation</a> has been created','App\\Model\\helpdesk\\Agent\\Department','created',3,NULL,NULL,'{\"attributes\":{\"name\":\"Operation\",\"type\":\"Public\",\"outgoing email\":null,\"business hour\":null}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(18,'Help Topics','Help Topic <a href=\'https://raffi.helpdesk/faveo/public/admin/helptopic/1/edit\'>Support query</a> has been created','App\\Model\\helpdesk\\Manage\\Help_topic','created',1,NULL,NULL,'{\"attributes\":{\"topic\":\"Support query\",\"Type\":\"Public\",\"Status\":\"Active\",\"Default Department\":\"Support\",\"Linked Department\":\"Support\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(19,'Help Topics','Help Topic <a href=\'https://raffi.helpdesk/faveo/public/admin/helptopic/2/edit\'>Sales query</a> has been created','App\\Model\\helpdesk\\Manage\\Help_topic','created',2,NULL,NULL,'{\"attributes\":{\"topic\":\"Sales query\",\"Type\":\"Public\",\"Status\":\"Inactive\",\"Default Department\":\"Sales\",\"Linked Department\":\"Sales\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(20,'Help Topics','Help Topic <a href=\'https://raffi.helpdesk/faveo/public/admin/helptopic/3/edit\'>Operational query</a> has been created','App\\Model\\helpdesk\\Manage\\Help_topic','created',3,NULL,NULL,'{\"attributes\":{\"topic\":\"Operational query\",\"Type\":\"Public\",\"Status\":\"Inactive\",\"Default Department\":\"Operation\",\"Linked Department\":\"Operation\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(21,'Ticket Settings',' <a href=\'https://raffi.helpdesk/faveo/public/admin/getticket/\'>Ticket Settings</a> has been created','App\\Model\\helpdesk\\Settings\\Ticket','created',1,NULL,NULL,'{\"attributes\":{\"show_org_ticket_form\":0,\"Default status\":\"Open\",\"Agent collision avoidance duration (in minutes)\":\"2\",\"Lock tickets\":\"No\",\"Ticket Number Prefix\":\"HDSK\",\"Show ticket per page\":\"10 Tickets Per Page\",\"Waiting time (in hours)\":0,\"Verify mail source while appending replies\":\"No\",\"Auto assign ticket on first reply\":\"Yes\",\"Include internal notes in thread count\":\"No\",\"Show status update date in inbox\":\"No\",\"Show organization details in inbox\":\"No\",\"Show location in inbox\":\"No\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(22,'Ticket source','Ticket source <a href=\'https://raffi.helpdesk/faveo/public/admin/source/1/edit\'>Web</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_source','created',1,NULL,NULL,'{\"attributes\":{\"name\":\"Web\",\"description\":null,\"display as\":\"Web\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(23,'Ticket source','Ticket source <a href=\'https://raffi.helpdesk/faveo/public/admin/source/2/edit\'>Email</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_source','created',2,NULL,NULL,'{\"attributes\":{\"name\":\"Email\",\"description\":null,\"display as\":\"E-mail\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(24,'Ticket source','Ticket source <a href=\'https://raffi.helpdesk/faveo/public/admin/source/3/edit\'>Agent</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_source','created',3,NULL,NULL,'{\"attributes\":{\"name\":\"Agent\",\"description\":null,\"display as\":\"Agent Panel\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(25,'Ticket source','Ticket source <a href=\'https://raffi.helpdesk/faveo/public/admin/source/4/edit\'>Facebook</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_source','created',4,NULL,NULL,'{\"attributes\":{\"name\":\"Facebook\",\"description\":null,\"display as\":\"Facebook\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(26,'Ticket source','Ticket source <a href=\'https://raffi.helpdesk/faveo/public/admin/source/5/edit\'>Twitter</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_source','created',5,NULL,NULL,'{\"attributes\":{\"name\":\"Twitter\",\"description\":null,\"display as\":\"Twitter\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(27,'Ticket source','Ticket source <a href=\'https://raffi.helpdesk/faveo/public/admin/source/6/edit\'>Call</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_source','created',6,NULL,NULL,'{\"attributes\":{\"name\":\"Call\",\"description\":null,\"display as\":\"Call\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(28,'Ticket source','Ticket source <a href=\'https://raffi.helpdesk/faveo/public/admin/source/7/edit\'>Chat</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_source','created',7,NULL,NULL,'{\"attributes\":{\"name\":\"Chat\",\"description\":null,\"display as\":\"Chat\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(29,'Admin','Admin <a href=\'https://raffi.helpdesk/faveo/public/panel/agent/1\'>demo_admin</a> has been created','App\\User','created',1,NULL,NULL,'{\"attributes\":{\"email\":\"\",\"mobile\":\"\",\"is_delete\":0,\"first name\":\"Demo\",\"last name\":\"Admin\",\"phone number\":null,\"created by\":null,\"user name\":\"demo_admin\",\"Role\":\"Admin\",\"User active status\":\"Active\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(30,'Ticket Types','Ticket type <a href=\'https://raffi.helpdesk/faveo/public/admin/ticket-type/1/edit\'>Question</a> has been created','App\\Model\\helpdesk\\Manage\\Tickettype','created',1,NULL,NULL,'{\"attributes\":{\"name\":\"Question\",\"Visibility\":\"Public\",\"Type Description\":\"Question\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(31,'Ticket Types','Ticket type <a href=\'https://raffi.helpdesk/faveo/public/admin/ticket-type/2/edit\'>Incident</a> has been created','App\\Model\\helpdesk\\Manage\\Tickettype','created',2,NULL,NULL,'{\"attributes\":{\"name\":\"Incident\",\"Visibility\":\"Private\",\"Type Description\":\"Incident\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(32,'Ticket Types','Ticket type <a href=\'https://raffi.helpdesk/faveo/public/admin/ticket-type/3/edit\'>Problem</a> has been created','App\\Model\\helpdesk\\Manage\\Tickettype','created',3,NULL,NULL,'{\"attributes\":{\"name\":\"Problem\",\"Visibility\":\"Private\",\"Type Description\":\"Problem\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(33,'Ticket Types','Ticket type <a href=\'https://raffi.helpdesk/faveo/public/admin/ticket-type/4/edit\'>Feature Request</a> has been created','App\\Model\\helpdesk\\Manage\\Tickettype','created',4,NULL,NULL,'{\"attributes\":{\"name\":\"Feature Request\",\"Visibility\":\"Private\",\"Type Description\":\"Feature Request\"}}',NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(34,'Ticket Status','Status <a href=\'https://raffi.helpdesk/faveo/public/admin/status/8/edit\'>Merged</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_Status','created',8,NULL,NULL,'{\"attributes\":{\"name\":\"Merged\",\"order\":7,\"Default\":\"Yes\",\"visibility for client\":\"No\",\"halt sla\":\"Yes\",\"Comment\":\"No\",\"allow client\":\"No\",\"purpose of status\":\"merged\"}}',NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24'),(35,'Ticket Status','Status Resolved has been deleted','App\\Model\\helpdesk\\Ticket\\Ticket_Status','deleted',2,NULL,NULL,'{\"old\":{\"name\":\"Resolved\",\"order\":2,\"Default\":\"No\",\"visibility for client\":\"Yes\",\"halt sla\":\"Yes\",\"Comment\":\"No\",\"allow client\":\"Yes\",\"purpose of status\":\"closed\"}}',NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24'),(36,'SLA Plans','SLA plan <a href=\'https://raffi.helpdesk/faveo/public/admin/sla/1/edit\'>Default</a> has been created','App\\Model\\helpdesk\\Ticket\\TicketSla','created',1,NULL,NULL,'{\"attributes\":{\"name\":\"Default\",\"Status\":\"Active\",\"category type\":\"ticket\",\"default\":\"Yes\",\"Matcher\":\"\",\"Internal Notes\":\"\"}}',NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24'),(37,'Ticket Filters','Ticket Filters  <strong>Open</strong>  has been created','App\\Model\\helpdesk\\Ticket\\TicketFilter','created',9,NULL,NULL,'{\"attributes\":{\"Name\":\"Open\",\"Icon Class\":\"fas fa-ticket-alt\",\"Icon Color\":\"#00C0EF\",\"Display on Dashboard\":null,\"Display on Navigation Bar\":null}}',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(38,'Ticket Filters','Ticket Filters  <strong>Closed</strong>  has been created','App\\Model\\helpdesk\\Ticket\\TicketFilter','created',10,NULL,NULL,'{\"attributes\":{\"Name\":\"Closed\",\"Icon Class\":\"fas fa-ticket-alt\",\"Icon Color\":\"#00C0EF\",\"Display on Dashboard\":null,\"Display on Navigation Bar\":null}}',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(39,'Categories','Category <a href=\'https://raffi.helpdesk/faveo/public/panel/category/1/edit\'>Uncategorized</a> has been created','App\\Model\\kb\\Category','created',1,NULL,NULL,'{\"attributes\":{\"name\":\"Uncategorized\",\"description\":\"Uncategorized\",\"Status\":\"Active\",\"display order\":0}}',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(40,'Ticket Filters','Ticket Filters  <strong>Open</strong>  has been updated','App\\Model\\helpdesk\\Ticket\\TicketFilter','updated',9,NULL,NULL,'{\"attributes\":{\"Icon Class\":\"fas fa-inbox\",\"Icon Color\":\"#000\"},\"old\":{\"Icon Class\":\"fas fa-ticket-alt\",\"Icon Color\":\"#00C0EF\"}}',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(41,'Ticket source','Ticket source <a href=\'https://raffi.helpdesk/faveo/public/admin/source/10/edit\'>Intercom</a> has been created','App\\Model\\helpdesk\\Ticket\\Ticket_source','created',10,NULL,NULL,'{\"attributes\":{\"name\":\"Intercom\",\"description\":null,\"display as\":\"Intercom\"}}',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(42,'Ticket Filters','Ticket Filters  <strong>Open Tickets</strong>  has been created','App\\Model\\helpdesk\\Ticket\\TicketFilter','created',16,NULL,NULL,'{\"attributes\":{\"Name\":\"Open Tickets\",\"Icon Class\":\"fas fa-inbox\",\"Icon Color\":\"#007bff\",\"Display on Dashboard\":1,\"Display on Navigation Bar\":1}}',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(43,'Ticket Filters','Ticket Filters  <strong>Overdue Tickets</strong>  has been created','App\\Model\\helpdesk\\Ticket\\TicketFilter','created',17,NULL,NULL,'{\"attributes\":{\"Name\":\"Overdue Tickets\",\"Icon Class\":\"far fa-calendar-times\",\"Icon Color\":\"#dd4b39\",\"Display on Dashboard\":1,\"Display on Navigation Bar\":1}}',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(44,'Ticket Filters','Ticket Filters  <strong>Unassigned Tickets </strong>  has been created','App\\Model\\helpdesk\\Ticket\\TicketFilter','created',18,NULL,NULL,'{\"attributes\":{\"Name\":\"Unassigned Tickets \",\"Icon Class\":\"fas fa-user-times\",\"Icon Color\":\"#f39c12\",\"Display on Dashboard\":1,\"Display on Navigation Bar\":1}}',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(45,'Ticket Filters','Ticket Filters  <strong>Unanswered Tickets</strong>  has been created','App\\Model\\helpdesk\\Ticket\\TicketFilter','created',19,NULL,NULL,'{\"attributes\":{\"Name\":\"Unanswered Tickets\",\"Icon Class\":\"fas fa-reply\",\"Icon Color\":\"#00c0ef\",\"Display on Dashboard\":1,\"Display on Navigation Bar\":1}}',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(46,'Ticket Filters','Ticket Filters  <strong>My Tickets</strong>  has been created','App\\Model\\helpdesk\\Ticket\\TicketFilter','created',27,NULL,NULL,'{\"attributes\":{\"Name\":\"My Tickets\",\"Icon Class\":\"fas fa-inbox\",\"Icon Color\":\"#007bff\",\"Display on Dashboard\":1,\"Display on Navigation Bar\":1}}',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(47,'Ticket Filters','Ticket Filters  <strong>My Pending Approvals </strong>  has been created','App\\Model\\helpdesk\\Ticket\\TicketFilter','created',28,NULL,NULL,'{\"attributes\":{\"Name\":\"My Pending Approvals \",\"Icon Class\":\"far fa-clock\",\"Icon Color\":\"#00c0ef\",\"Display on Dashboard\":1,\"Display on Navigation Bar\":1}}',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(48,'Ticket Filters','Ticket Filters  <strong>My Due Today Tickets </strong>  has been created','App\\Model\\helpdesk\\Ticket\\TicketFilter','created',29,NULL,NULL,'{\"attributes\":{\"Name\":\"My Due Today Tickets \",\"Icon Class\":\"far fa-calendar-times\",\"Icon Color\":\"#f39c12\",\"Display on Dashboard\":1,\"Display on Navigation Bar\":0}}',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(49,'Ticket Filters','Ticket Filters  <strong>Unapproved Tickets</strong>  has been created','App\\Model\\helpdesk\\Ticket\\TicketFilter','created',30,NULL,NULL,'{\"attributes\":{\"Name\":\"Unapproved Tickets\",\"Icon Class\":\"fas fa-clock\",\"Icon Color\":\"#00c0ef\",\"Display on Dashboard\":0,\"Display on Navigation Bar\":1}}',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(50,'Ticket Filters','Ticket Filters  <strong>Closed Tickets</strong>  has been created','App\\Model\\helpdesk\\Ticket\\TicketFilter','created',31,NULL,NULL,'{\"attributes\":{\"Name\":\"Closed Tickets\",\"Icon Class\":\"fas fa-minus-circle\",\"Icon Color\":\"#00c0ef\",\"Display on Dashboard\":0,\"Display on Navigation Bar\":1}}',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(51,'Ticket Filters','Ticket Filters  <strong>Spam</strong>  has been created','App\\Model\\helpdesk\\Ticket\\TicketFilter','created',32,NULL,NULL,'{\"attributes\":{\"Name\":\"Spam\",\"Icon Class\":\"fas fa-exclamation-triangle\",\"Icon Color\":\"#00c0ef\",\"Display on Dashboard\":0,\"Display on Navigation Bar\":1}}',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(52,'Ticket Filters','Ticket Filters  <strong>Trash</strong>  has been created','App\\Model\\helpdesk\\Ticket\\TicketFilter','created',33,NULL,NULL,'{\"attributes\":{\"Name\":\"Trash\",\"Icon Class\":\"fas fa-trash\",\"Icon Color\":\"#00c0ef\",\"Display on Dashboard\":0,\"Display on Navigation Bar\":1}}',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `activity_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_sub_modules`
--

DROP TABLE IF EXISTS `admin_sub_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_sub_modules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sub_module_id` bigint(20) unsigned NOT NULL,
  `cache` int(11) NOT NULL DEFAULT 10,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_sub_modules_sub_module_id_foreign` (`sub_module_id`),
  CONSTRAINT `admin_sub_modules_sub_module_id_foreign` FOREIGN KEY (`sub_module_id`) REFERENCES `sub_modules` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_sub_modules`
--

LOCK TABLES `admin_sub_modules` WRITE;
/*!40000 ALTER TABLE `admin_sub_modules` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_sub_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent_type_relations`
--

DROP TABLE IF EXISTS `agent_type_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agent_type_relations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(11) NOT NULL,
  `agent_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_type_relations`
--

LOCK TABLES `agent_type_relations` WRITE;
/*!40000 ALTER TABLE `agent_type_relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `agent_type_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_settings`
--

DROP TABLE IF EXISTS `api_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_settings`
--

LOCK TABLES `api_settings` WRITE;
/*!40000 ALTER TABLE `api_settings` DISABLE KEYS */;
INSERT INTO `api_settings` VALUES (1,'sources','[\"1\",\"3\"]','2025-01-03 04:07:30','2025-01-03 04:07:30');
/*!40000 ALTER TABLE `api_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `approval_level_approvers`
--

DROP TABLE IF EXISTS `approval_level_approvers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `approval_level_approvers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `approval_level_id` int(10) unsigned NOT NULL,
  `approval_level_approver_id` int(10) unsigned NOT NULL,
  `approval_level_approver_type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `approval_level_approvers_approval_level_id_foreign` (`approval_level_id`),
  CONSTRAINT `approval_level_approvers_approval_level_id_foreign` FOREIGN KEY (`approval_level_id`) REFERENCES `approval_levels` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approval_level_approvers`
--

LOCK TABLES `approval_level_approvers` WRITE;
/*!40000 ALTER TABLE `approval_level_approvers` DISABLE KEYS */;
/*!40000 ALTER TABLE `approval_level_approvers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `approval_level_statuses`
--

DROP TABLE IF EXISTS `approval_level_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `approval_level_statuses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `approval_level_id` int(10) unsigned NOT NULL,
  `approval_workflow_ticket_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `match` varchar(10) NOT NULL,
  `order` tinyint(3) unsigned NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `status` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `approval_level_statuses_approval_level_id_foreign` (`approval_level_id`),
  KEY `approval_level_statuses_approval_workflow_ticket_id_foreign` (`approval_workflow_ticket_id`),
  CONSTRAINT `approval_level_statuses_approval_level_id_foreign` FOREIGN KEY (`approval_level_id`) REFERENCES `approval_levels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `approval_level_statuses_approval_workflow_ticket_id_foreign` FOREIGN KEY (`approval_workflow_ticket_id`) REFERENCES `approval_workflow_tickets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approval_level_statuses`
--

LOCK TABLES `approval_level_statuses` WRITE;
/*!40000 ALTER TABLE `approval_level_statuses` DISABLE KEYS */;
/*!40000 ALTER TABLE `approval_level_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `approval_levels`
--

DROP TABLE IF EXISTS `approval_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `approval_levels` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `approval_workflow_id` int(10) unsigned NOT NULL,
  `match` varchar(10) NOT NULL,
  `order` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `approval_levels_approval_workflow_id_foreign` (`approval_workflow_id`),
  CONSTRAINT `approval_levels_approval_workflow_id_foreign` FOREIGN KEY (`approval_workflow_id`) REFERENCES `approval_workflows` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approval_levels`
--

LOCK TABLES `approval_levels` WRITE;
/*!40000 ALTER TABLE `approval_levels` DISABLE KEYS */;
/*!40000 ALTER TABLE `approval_levels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `approval_workflow_tickets`
--

DROP TABLE IF EXISTS `approval_workflow_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `approval_workflow_tickets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `approval_workflow_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `ticket_id` int(10) unsigned NOT NULL,
  `status` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `action_on_approve` int(11) NOT NULL,
  `action_on_deny` int(11) NOT NULL,
  `ticket_status_id` int(10) unsigned DEFAULT NULL,
  `send_auto_reminders` tinyint(1) DEFAULT 0,
  `reminder_interval_type` varchar(255) DEFAULT NULL,
  `reminder_interval` int(11) DEFAULT NULL,
  `next_reminder_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `approval_workflow_tickets_ticket_id_foreign` (`ticket_id`),
  KEY `approval_workflow_tickets_approval_workflow_id_foreign` (`approval_workflow_id`),
  KEY `approval_workflow_tickets_ticket_status_id_foreign` (`ticket_status_id`),
  CONSTRAINT `approval_workflow_tickets_approval_workflow_id_foreign` FOREIGN KEY (`approval_workflow_id`) REFERENCES `approval_workflows` (`id`) ON DELETE CASCADE,
  CONSTRAINT `approval_workflow_tickets_ticket_id_foreign` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `approval_workflow_tickets_ticket_status_id_foreign` FOREIGN KEY (`ticket_status_id`) REFERENCES `ticket_status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approval_workflow_tickets`
--

LOCK TABLES `approval_workflow_tickets` WRITE;
/*!40000 ALTER TABLE `approval_workflow_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `approval_workflow_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `approval_workflows`
--

DROP TABLE IF EXISTS `approval_workflows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `approval_workflows` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `action_on_approve` int(11) NOT NULL,
  `action_on_deny` int(11) NOT NULL,
  `type` varchar(30) NOT NULL,
  `is_visible` tinyint(4) NOT NULL DEFAULT 1,
  `send_auto_reminders` tinyint(1) DEFAULT 0,
  `reminder_interval_type` varchar(255) DEFAULT NULL,
  `reminder_interval` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `approval_workflows_user_id_foreign` (`user_id`),
  CONSTRAINT `approval_workflows_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approval_workflows`
--

LOCK TABLES `approval_workflows` WRITE;
/*!40000 ALTER TABLE `approval_workflows` DISABLE KEYS */;
/*!40000 ALTER TABLE `approval_workflows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `approver_statuses`
--

DROP TABLE IF EXISTS `approver_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `approver_statuses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `approver_id` int(10) unsigned NOT NULL,
  `approver_type` varchar(255) NOT NULL,
  `approval_level_status_id` int(10) unsigned NOT NULL,
  `status` varchar(255) NOT NULL,
  `hash` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `comment` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `approver_statuses_approval_level_status_id_foreign` (`approval_level_status_id`),
  CONSTRAINT `approver_statuses_approval_level_status_id_foreign` FOREIGN KEY (`approval_level_status_id`) REFERENCES `approval_level_statuses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approver_statuses`
--

LOCK TABLES `approver_statuses` WRITE;
/*!40000 ALTER TABLE `approver_statuses` DISABLE KEYS */;
/*!40000 ALTER TABLE `approver_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attachments`
--

DROP TABLE IF EXISTS `attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attachments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `file_size` varchar(255) NOT NULL,
  `file_type` varchar(100) NOT NULL,
  `disposition` varchar(255) NOT NULL,
  `driver` varchar(30) NOT NULL,
  `path` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachable_type` varchar(255) NOT NULL,
  `attachable_id` bigint(20) unsigned NOT NULL,
  `content_id` varchar(255) DEFAULT NULL,
  `permanent_redaction` int(11) NOT NULL DEFAULT 0,
  `temporary_redaction` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `attachments_attachable_type_attachable_id_index` (`attachable_type`,`attachable_id`),
  KEY `attachments_name_index` (`name`),
  KEY `attachments_driver_index` (`driver`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attachments`
--

LOCK TABLES `attachments` WRITE;
/*!40000 ALTER TABLE `attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authentication_log`
--

DROP TABLE IF EXISTS `authentication_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authentication_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `authenticatable_type` varchar(255) NOT NULL,
  `authenticatable_id` bigint(20) unsigned NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `browser` varchar(255) DEFAULT NULL,
  `platform` varchar(255) DEFAULT NULL,
  `device` varchar(255) DEFAULT NULL,
  `login_at` timestamp NULL DEFAULT NULL,
  `session_token` varchar(255) DEFAULT NULL,
  `logout_at` timestamp NULL DEFAULT NULL,
  `location` blob DEFAULT NULL,
  `device_family` varchar(255) DEFAULT NULL,
  `device_identifier` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `authentication_log_authenticatable_type_authenticatable_id_index` (`authenticatable_type`,`authenticatable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authentication_log`
--

LOCK TABLES `authentication_log` WRITE;
/*!40000 ALTER TABLE `authentication_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `authentication_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_paths`
--

DROP TABLE IF EXISTS `backup_paths`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `backup_paths` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `backup_path` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backup_paths`
--

LOCK TABLES `backup_paths` WRITE;
/*!40000 ALTER TABLE `backup_paths` DISABLE KEYS */;
INSERT INTO `backup_paths` VALUES (1,'/var/www/storage','2025-01-03 04:07:24','2025-01-03 04:07:24');
/*!40000 ALTER TABLE `backup_paths` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backups`
--

DROP TABLE IF EXISTS `backups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `backups` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) NOT NULL,
  `db_name` varchar(255) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `db_path` varchar(255) NOT NULL,
  `version` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backups`
--

LOCK TABLES `backups` WRITE;
/*!40000 ALTER TABLE `backups` DISABLE KEYS */;
/*!40000 ALTER TABLE `backups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banlist`
--

DROP TABLE IF EXISTS `banlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `banlist` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ban_status` tinyint(1) NOT NULL,
  `email_address` varchar(255) NOT NULL,
  `internal_notes` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banlist`
--

LOCK TABLES `banlist` WRITE;
/*!40000 ALTER TABLE `banlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `banlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bar_notifications`
--

DROP TABLE IF EXISTS `bar_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bar_notifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bar_notifications`
--

LOCK TABLES `bar_notifications` WRITE;
/*!40000 ALTER TABLE `bar_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `bar_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill_type`
--

DROP TABLE IF EXISTS `bill_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bill_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `price` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_type`
--

LOCK TABLES `bill_type` WRITE;
/*!40000 ALTER TABLE `bill_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `bill_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billing_payment_gateways`
--

DROP TABLE IF EXISTS `billing_payment_gateways`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_payment_gateways` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `gateway_name` varchar(50) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing_payment_gateways`
--

LOCK TABLES `billing_payment_gateways` WRITE;
/*!40000 ALTER TABLE `billing_payment_gateways` DISABLE KEYS */;
/*!40000 ALTER TABLE `billing_payment_gateways` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bills`
--

DROP TABLE IF EXISTS `bills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bills` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `level` varchar(255) NOT NULL,
  `model_id` int(11) NOT NULL,
  `agent` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `hours` varchar(255) NOT NULL,
  `billable` varchar(255) NOT NULL,
  `amount_hourly` varchar(255) DEFAULT NULL,
  `note` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bills`
--

LOCK TABLES `bills` WRITE;
/*!40000 ALTER TABLE `bills` DISABLE KEYS */;
/*!40000 ALTER TABLE `bills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `breaklines`
--

DROP TABLE IF EXISTS `breaklines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breaklines` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `breakline` varchar(1000) NOT NULL,
  `order` int(10) unsigned NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `breaklines`
--

LOCK TABLES `breaklines` WRITE;
/*!40000 ALTER TABLE `breaklines` DISABLE KEYS */;
INSERT INTO `breaklines` VALUES (1,'<blockquote>(?s).*<\\/blockquote>',1,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(2,'(<hr style=\"width:98%;\"><div><b>)?From:.*Sent:.*To:.*',2,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3,'---- On(?:(?!^>*\\s*On\\b|\\bwrote:).).*wrote ----.*',3,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4,'On(?:(?!^>*\\s*On\\b|\\bwrote:).).*wrote:.*',4,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(5,'<br><div><div>(.*?)&lt;<a href=\"mailto:',5,1,'2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `breaklines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_holidays`
--

DROP TABLE IF EXISTS `business_holidays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `business_holidays` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `date` varchar(255) NOT NULL,
  `business_hours_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `business_holidays_business_hours_id_foreign` (`business_hours_id`),
  CONSTRAINT `business_holidays_business_hours_id_foreign` FOREIGN KEY (`business_hours_id`) REFERENCES `business_hours` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_holidays`
--

LOCK TABLES `business_holidays` WRITE;
/*!40000 ALTER TABLE `business_holidays` DISABLE KEYS */;
/*!40000 ALTER TABLE `business_holidays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_hours`
--

DROP TABLE IF EXISTS `business_hours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `business_hours` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `timezone` varchar(255) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_hours`
--

LOCK TABLES `business_hours` WRITE;
/*!40000 ALTER TABLE `business_hours` DISABLE KEYS */;
INSERT INTO `business_hours` VALUES (1,'Default Business-Hours','default',1,'UTC',1,'2025-01-03 04:07:23','2025-01-03 04:07:25');
/*!40000 ALTER TABLE `business_hours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_open_custom_time`
--

DROP TABLE IF EXISTS `business_open_custom_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `business_open_custom_time` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `business_schedule_id` int(10) unsigned NOT NULL,
  `open_time` varchar(255) NOT NULL,
  `close_time` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `business_open_custom_time_business_schedule_id_foreign` (`business_schedule_id`),
  CONSTRAINT `business_open_custom_time_business_schedule_id_foreign` FOREIGN KEY (`business_schedule_id`) REFERENCES `business_schedule` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_open_custom_time`
--

LOCK TABLES `business_open_custom_time` WRITE;
/*!40000 ALTER TABLE `business_open_custom_time` DISABLE KEYS */;
/*!40000 ALTER TABLE `business_open_custom_time` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_schedule`
--

DROP TABLE IF EXISTS `business_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `business_schedule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `business_hours_id` int(10) unsigned NOT NULL,
  `days` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `business_schedule_business_hours_id_foreign` (`business_hours_id`),
  CONSTRAINT `business_schedule_business_hours_id_foreign` FOREIGN KEY (`business_hours_id`) REFERENCES `business_hours` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_schedule`
--

LOCK TABLES `business_schedule` WRITE;
/*!40000 ALTER TABLE `business_schedule` DISABLE KEYS */;
INSERT INTO `business_schedule` VALUES (1,1,'Sunday','Closed','2025-01-03 04:07:23','2025-01-03 04:07:23'),(2,1,'Monday','Open_fixed','2025-01-03 04:07:23','2025-01-03 04:07:23'),(3,1,'Tuesday','Open_fixed','2025-01-03 04:07:23','2025-01-03 04:07:23'),(4,1,'Wednesday','Open_fixed','2025-01-03 04:07:23','2025-01-03 04:07:24'),(5,1,'Thursday','Open_fixed','2025-01-03 04:07:23','2025-01-03 04:07:23'),(6,1,'Friday','Open_fixed','2025-01-03 04:07:23','2025-01-03 04:07:23'),(7,1,'Saturday','Closed','2025-01-03 04:07:23','2025-01-03 04:07:23');
/*!40000 ALTER TABLE `business_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `canned_response`
--

DROP TABLE IF EXISTS `canned_response`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `canned_response` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `canned_response_updated_by_foreign` (`updated_by`),
  CONSTRAINT `canned_response_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `canned_response_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `canned_response`
--

LOCK TABLES `canned_response` WRITE;
/*!40000 ALTER TABLE `canned_response` DISABLE KEYS */;
/*!40000 ALTER TABLE `canned_response` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `commentable_type` varchar(255) NOT NULL,
  `commentable_id` bigint(20) unsigned NOT NULL,
  `comment` text NOT NULL,
  `is_approved` tinyint(1) NOT NULL DEFAULT 0,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `parent_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `comments_commentable_type_commentable_id_index` (`commentable_type`,`commentable_id`),
  KEY `comments_parent_id_foreign` (`parent_id`),
  CONSTRAINT `comments_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_settings`
--

DROP TABLE IF EXISTS `common_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_name` varchar(255) NOT NULL,
  `option_value` varchar(1000) NOT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `optional_field` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_settings`
--

LOCK TABLES `common_settings` WRITE;
/*!40000 ALTER TABLE `common_settings` DISABLE KEYS */;
INSERT INTO `common_settings` VALUES (1,'itil','',0,'',NULL,NULL),(2,'ticket_token_time_duration','1',NULL,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(3,'enable_rtl','',NULL,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(4,'user_set_ticket_status','',1,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(5,'send_otp','',0,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(6,'email_mandatory','',1,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(7,'user_priority','',0,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(8,'dummy_data_installation','',0,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(9,'user_registration','',1,'','2025-01-03 04:07:23','2025-01-03 04:07:24'),(10,'user_show_org_ticket','',1,'','2025-01-03 04:07:23','2025-01-03 04:07:25'),(11,'user_reply_org_ticket','',0,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(12,'allow_users_to_create_ticket','',0,'','2025-01-03 04:07:23','2025-01-03 04:07:31'),(13,'login_restrictions','email',NULL,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(14,'micro_organization_status','',0,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(15,'dashboard-statistics','departments,agents,teams',NULL,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(16,'helptopic_link_with_type','',0,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(17,'batch_tickets','',0,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(18,'redirect_to_timeline','',0,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(19,'allow_external_login','',0,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(20,'allow_users_to_access_system_url','',0,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(21,'redirect_unauthenticated_users_to','',NULL,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(22,'validate_token_api','',NULL,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(23,'validate_api_parameter','token',NULL,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(24,'allow_organization_mngr_approve_tickets','',0,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(25,'allow_organization_dept_mngr_approve_tickets','',0,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(26,'show_gravatar_image','',1,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(27,'time_track','',0,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(28,'registration_mail_templates','multiple',NULL,'','2025-01-03 04:07:23','2025-01-03 04:07:23'),(29,'reports_max_date_range','2',NULL,'','2025-01-03 04:07:24','2025-01-03 04:07:24'),(30,'reports_records_per_file','1000',NULL,'','2025-01-03 04:07:24','2025-01-03 04:07:25'),(31,'cdn_settings','0',NULL,'','2025-01-03 04:07:24','2025-01-03 04:07:24'),(32,'user_show_cc_ticket','',0,'','2025-01-03 04:07:24','2025-01-03 04:07:24'),(33,'v_4_3_0_update','2025-01-03 09:37:25',NULL,'','2025-01-03 04:07:25','2025-01-03 04:07:25'),(34,'v_4_9_0_update','2025-01-03 09:37:28',NULL,'','2025-01-03 04:07:28','2025-01-03 04:07:28'),(35,'network_discovery','',0,'module','2025-01-03 04:07:30','2025-01-03 04:07:30'),(36,'search_import','1',NULL,'years-updated_at','2025-01-03 04:07:30','2025-01-03 04:07:30'),(37,'releases','official',NULL,'','2025-01-03 04:07:31','2025-01-03 04:07:31'),(38,'max_column','15',NULL,'','2025-01-03 04:07:31','2025-01-03 04:07:31'),(39,'sidebar_count','',0,'','2025-01-03 04:07:31','2025-01-03 04:07:31'),(40,'c_f_check','',1,'','2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `common_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conditions`
--

DROP TABLE IF EXISTS `conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `conditions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `job` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `icon` varchar(30) NOT NULL,
  `command` varchar(255) NOT NULL,
  `job_info` varchar(100) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `plugin_job` tinyint(1) NOT NULL DEFAULT 0,
  `plugin_name` varchar(100) DEFAULT NULL,
  `is_background` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conditions`
--

LOCK TABLES `conditions` WRITE;
/*!40000 ALTER TABLE `conditions` DISABLE KEYS */;
INSERT INTO `conditions` VALUES (1,'fetching','everyFiveMinutes','2025-01-03 04:07:23','2025-01-03 04:07:25','fas fa-mail-bulk','ticket:fetch','fetching-info',1,0,NULL,0),(2,'notification','daily','2025-01-03 04:07:23','2025-01-03 04:07:25','fas fa-chart-line','report:send','notification-info',0,0,NULL,0),(3,'work','yearly','2025-01-03 04:07:23','2025-01-03 04:07:30','fa fa-archive','ticket:close','work-info',1,0,NULL,1),(4,'escalation','everyMinute','2025-01-03 04:07:23','2025-01-03 04:07:24','fa fa-hourglass-half','send:escalation','escalation-info',1,0,NULL,0),(5,'recur','daily','2025-01-03 04:07:23','2025-01-03 04:07:25','fas fa-redo','ticket:recur','recur-info',1,0,NULL,0),(6,'check-updates','daily','2025-01-03 04:07:23','2025-01-03 04:07:25','fas fa-sync-alt','faveo:checkupdate','check-updates-info',1,0,NULL,0),(7,'logs','daily','2025-01-03 04:07:24','2025-01-03 04:07:24','glyphicon glyphicon-trash','logs:delete','logs-delete-info',1,0,NULL,0),(8,'attachment-fixer-private','daily','2025-01-03 04:07:25','2025-01-03 04:07:25','fas fa-exclamation-triangle','restructure:private','attachment-fixer-info',1,0,NULL,0),(9,'attachment-fixer-public','daily','2025-01-03 04:07:25','2025-01-03 04:07:25','fas fa-exclamation-triangle','restructure:public','attachment-fixer-info',1,0,NULL,0),(10,'attachment-fixer-disk','daily','2025-01-03 04:07:25','2025-01-03 04:07:25','fas fa-exclamation-triangle','restructure:disk','attachment-fixer-info',1,0,NULL,0),(11,'login-log','daily','2025-01-03 04:07:25','2025-01-03 04:07:25','glyphicon glyphicon-trash','authentication-log:clear','login-log-info',1,0,NULL,0),(12,'Route cache','everyFiveMinutes','2025-01-03 04:07:30','2025-01-03 04:07:30','fa fa-shopping-cart','route_web:cache','caching_web_routes',1,0,NULL,0),(13,'workflow-auto-reminder','daily','2025-01-03 04:07:30','2025-01-03 04:07:30','fa-solid fa-business-time','workflow:reminder','workflow-auto-reminder-info',1,0,NULL,0),(15,'feedback_reminder','everyFiveMinutes','2025-01-03 04:07:30','2025-01-03 04:07:30','fa-solid fa-bell','feedback:reminder','feedback_reminder_tooltip',0,0,NULL,0),(16,'package order expiry','daily','2025-01-03 04:07:30','2025-01-03 04:07:30','fa fa-shopping-cart','order:schedule','package-order-expiry-info',1,0,NULL,0),(17,'report-schedule','everyFiveMinutes','2025-01-03 04:07:30','2025-01-03 04:07:30','fa fa-clock','report:schedule','report-schedule-info',1,0,NULL,0),(18,'system_activity_logs','weekly','2025-01-03 04:07:30','2025-01-03 04:07:30','glyphicon glyphicon-trash','systemactivitylog:clean','delete_system_activity_logs',1,0,NULL,0),(19,'import-search-queries','everyFiveMinutes','2025-01-03 04:07:30','2025-01-03 04:07:30','fa fa-search','import:search_queries','search-queries',0,0,NULL,1),(23,'migrate-fields','everyMinute','2025-01-03 04:07:31','2025-01-03 04:07:31','fa fa-shopping-cart','migrate:fields','migrate-fields-info',1,0,NULL,1);
/*!40000 ALTER TABLE `conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country_code`
--

DROP TABLE IF EXISTS `country_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country_code` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `iso` char(2) NOT NULL,
  `name` varchar(100) NOT NULL,
  `nicename` varchar(100) NOT NULL,
  `iso3` char(3) NOT NULL,
  `numcode` smallint(6) NOT NULL,
  `phonecode` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `example` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=240 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country_code`
--

LOCK TABLES `country_code` WRITE;
/*!40000 ALTER TABLE `country_code` DISABLE KEYS */;
INSERT INTO `country_code` VALUES (1,'AF','AFGHANISTAN','Afghanistan','AFG',4,93,'2025-01-03 04:07:23','2025-01-03 04:07:23','70 123 4567'),(2,'AL','ALBANIA','Albania','ALB',8,355,'2025-01-03 04:07:23','2025-01-03 04:07:23','66 123 4567'),(3,'DZ','ALGERIA','Algeria','DZA',12,213,'2025-01-03 04:07:23','2025-01-03 04:07:23','551 23 45 67'),(4,'AS','AMERICAN SAMOA','American Samoa','ASM',16,1684,'2025-01-03 04:07:23','2025-01-03 04:07:23','684 733-1234'),(5,'AD','ANDORRA','Andorra','AND',20,376,'2025-01-03 04:07:23','2025-01-03 04:07:23','312 345'),(6,'AO','ANGOLA','Angola','AGO',24,244,'2025-01-03 04:07:23','2025-01-03 04:07:23','923 123 456'),(7,'AI','ANGUILLA','Anguilla','AIA',660,1264,'2025-01-03 04:07:23','2025-01-03 04:07:23','264 235-1234'),(8,'AQ','ANTARCTICA','Antarctica','NUL',0,0,'2025-01-03 04:07:23','2025-01-03 04:07:23','0'),(9,'AG','ANTIGUA AND BARBUDA','Antigua and Barbuda','ATG',28,1268,'2025-01-03 04:07:23','2025-01-03 04:07:23','268 464-1234'),(10,'AR','ARGENTINA','Argentina','ARG',32,54,'2025-01-03 04:07:23','2025-01-03 04:07:23','11 15-2345-6789'),(11,'AM','ARMENIA','Armenia','ARM',51,374,'2025-01-03 04:07:23','2025-01-03 04:07:23','77 123456'),(12,'AW','ARUBA','Aruba','ABW',533,297,'2025-01-03 04:07:23','2025-01-03 04:07:23','560 1234'),(13,'AU','AUSTRALIA','Australia','AUS',36,61,'2025-01-03 04:07:23','2025-01-03 04:07:23','412 345 678'),(14,'AT','AUSTRIA','Austria','AUT',40,43,'2025-01-03 04:07:23','2025-01-03 04:07:23','664 123456'),(15,'AZ','AZERBAIJAN','Azerbaijan','AZE',31,994,'2025-01-03 04:07:23','2025-01-03 04:07:23','40 123 45 67'),(16,'BS','BAHAMAS','Bahamas','BHS',44,1242,'2025-01-03 04:07:23','2025-01-03 04:07:23','242 359-1234'),(17,'BH','BAHRAIN','Bahrain','BHR',48,973,'2025-01-03 04:07:23','2025-01-03 04:07:23','3600 1234'),(18,'BD','BANGLADESH','Bangladesh','BGD',50,880,'2025-01-03 04:07:23','2025-01-03 04:07:23','1812-345678'),(19,'BB','BARBADOS','Barbados','BRB',52,1246,'2025-01-03 04:07:23','2025-01-03 04:07:23','246 250-1234'),(20,'BY','BELARUS','Belarus','BLR',112,375,'2025-01-03 04:07:23','2025-01-03 04:07:23','8 029 491-19-11'),(21,'BE','BELGIUM','Belgium','BEL',56,32,'2025-01-03 04:07:23','2025-01-03 04:07:23','470 12 34 56'),(22,'BZ','BELIZE','Belize','BLZ',84,501,'2025-01-03 04:07:23','2025-01-03 04:07:23','622-1234'),(23,'BJ','BENIN','Benin','BEN',204,229,'2025-01-03 04:07:23','2025-01-03 04:07:23','90 01 12 34'),(24,'BM','BERMUDA','Bermuda','BMU',60,1441,'2025-01-03 04:07:23','2025-01-03 04:07:23','441 370-1234'),(25,'BT','BHUTAN','Bhutan','BTN',64,975,'2025-01-03 04:07:23','2025-01-03 04:07:23','17 12 34 56'),(26,'BO','BOLIVIA','Bolivia','BOL',68,591,'2025-01-03 04:07:23','2025-01-03 04:07:23','71234567'),(27,'BA','BOSNIA AND HERZEGOVINA','Bosnia and Herzegovina','BIH',70,387,'2025-01-03 04:07:23','2025-01-03 04:07:23','61 123 456'),(28,'BW','BOTSWANA','Botswana','BWA',72,267,'2025-01-03 04:07:23','2025-01-03 04:07:23','71 123 456'),(29,'BV','BOUVET ISLAND','Bouvet Island','NUL',0,0,'2025-01-03 04:07:23','2025-01-03 04:07:23','0'),(30,'BR','BRAZIL','Brazil','BRA',76,55,'2025-01-03 04:07:23','2025-01-03 04:07:23','11 96123-4567'),(31,'IO','BRITISH INDIAN OCEAN TERRITORY','British Indian Ocean Territory','NUL',0,246,'2025-01-03 04:07:23','2025-01-03 04:07:23','380 1234'),(32,'BN','BRUNEI DARUSSALAM','Brunei Darussalam','BRN',96,673,'2025-01-03 04:07:23','2025-01-03 04:07:23','712 3456'),(33,'BG','BULGARIA','Bulgaria','BGR',100,359,'2025-01-03 04:07:23','2025-01-03 04:07:23','48 123 456'),(34,'BF','BURKINA FASO','Burkina Faso','BFA',854,226,'2025-01-03 04:07:23','2025-01-03 04:07:23','70 12 34 56'),(35,'BI','BURUNDI','Burundi','BDI',108,257,'2025-01-03 04:07:23','2025-01-03 04:07:23','79 56 12 34'),(36,'KH','CAMBODIA','Cambodia','KHM',116,855,'2025-01-03 04:07:23','2025-01-03 04:07:23','91 234 567'),(37,'CM','CAMEROON','Cameroon','CMR',120,237,'2025-01-03 04:07:23','2025-01-03 04:07:23','6 71 23 45 67'),(38,'CA','CANADA','Canada','CAN',124,1,'2025-01-03 04:07:23','2025-01-03 04:07:23','204 234-5678'),(39,'CV','CAPE VERDE','Cape Verde','CPV',132,238,'2025-01-03 04:07:23','2025-01-03 04:07:24','991 12 34'),(40,'KY','CAYMAN ISLANDS','Cayman Islands','CYM',136,1345,'2025-01-03 04:07:23','2025-01-03 04:07:24','345 323-1234'),(41,'CF','CENTRAL AFRICAN REPUBLIC','Central African Republic','CAF',140,236,'2025-01-03 04:07:23','2025-01-03 04:07:24','70 01 23 45'),(42,'TD','CHAD','Chad','TCD',148,235,'2025-01-03 04:07:23','2025-01-03 04:07:24','63 01 23 45'),(43,'CL','CHILE','Chile','CHL',152,56,'2025-01-03 04:07:23','2025-01-03 04:07:24','9 6123 4567'),(44,'CN','CHINA','China','CHN',156,86,'2025-01-03 04:07:23','2025-01-03 04:07:24','131 2345 6789'),(45,'CX','CHRISTMAS ISLAND','Christmas Island','NUL',0,61,'2025-01-03 04:07:23','2025-01-03 04:07:24','412 345 678'),(46,'CC','COCOS (KEELING) ISLANDS','Cocos (Keeling) Islands','NUL',0,672,'2025-01-03 04:07:23','2025-01-03 04:07:24','412 345 678'),(47,'CO','COLOMBIA','Colombia','COL',170,57,'2025-01-03 04:07:23','2025-01-03 04:07:24','321 1234567'),(48,'KM','COMOROS','Comoros','COM',174,269,'2025-01-03 04:07:23','2025-01-03 04:07:24','321 23 45'),(49,'CG','CONGO','Congo','COG',178,242,'2025-01-03 04:07:23','2025-01-03 04:07:24','991 234 567'),(50,'CD','CONGO, THE DEMOCRATIC REPUBLIC OF THE','Congo, the Democratic Republic of the','COD',180,242,'2025-01-03 04:07:23','2025-01-03 04:07:24','6 123 4567'),(51,'CK','COOK ISLANDS','Cook Islands','COK',184,682,'2025-01-03 04:07:23','2025-01-03 04:07:24','71 234'),(52,'CR','COSTA RICA','Costa Rica','CRI',188,506,'2025-01-03 04:07:23','2025-01-03 04:07:24','8312 3456'),(53,'CI','COTE DIVOIRE','Cote DIvoire','CIV',384,225,'2025-01-03 04:07:23','2025-01-03 04:07:24','1 23 45 67'),(54,'HR','CROATIA','Croatia','HRV',191,385,'2025-01-03 04:07:23','2025-01-03 04:07:24','91 234 5678'),(55,'CU','CUBA','Cuba','CUB',192,53,'2025-01-03 04:07:23','2025-01-03 04:07:24','5 1234567'),(56,'CY','CYPRUS','Cyprus','CYP',196,357,'2025-01-03 04:07:23','2025-01-03 04:07:24','96 123456'),(57,'CZ','CZECH REPUBLIC','Czech Republic','CZE',203,420,'2025-01-03 04:07:23','2025-01-03 04:07:24','601 123 456'),(58,'DK','DENMARK','Denmark','DNK',208,45,'2025-01-03 04:07:23','2025-01-03 04:07:24','20 12 34 56'),(59,'DJ','DJIBOUTI','Djibouti','DJI',262,253,'2025-01-03 04:07:23','2025-01-03 04:07:24','77 83 10 01'),(60,'DM','DOMINICA','Dominica','DMA',212,1767,'2025-01-03 04:07:23','2025-01-03 04:07:24','767 225-1234'),(61,'DO','DOMINICAN REPUBLIC','Dominican Republic','DOM',214,1809,'2025-01-03 04:07:23','2025-01-03 04:07:24','809 234-5678'),(62,'EC','ECUADOR','Ecuador','ECU',218,593,'2025-01-03 04:07:23','2025-01-03 04:07:24','99 123 4567'),(63,'EG','EGYPT','Egypt','EGY',818,20,'2025-01-03 04:07:23','2025-01-03 04:07:24','100 123 4567'),(64,'SV','EL SALVADOR','El Salvador','SLV',222,503,'2025-01-03 04:07:23','2025-01-03 04:07:24','7012 3456'),(65,'GQ','EQUATORIAL GUINEA','Equatorial Guinea','GNQ',226,240,'2025-01-03 04:07:23','2025-01-03 04:07:24','222 123 456'),(66,'ER','ERITREA','Eritrea','ERI',232,291,'2025-01-03 04:07:23','2025-01-03 04:07:24','7 123 456'),(67,'EE','ESTONIA','Estonia','EST',233,372,'2025-01-03 04:07:23','2025-01-03 04:07:24','5123 4567'),(68,'ET','ETHIOPIA','Ethiopia','ETH',231,251,'2025-01-03 04:07:23','2025-01-03 04:07:24','91 123 4567'),(69,'FK','FALKLAND ISLANDS (MALVINAS)','Falkland Islands (Malvinas)','FLK',238,500,'2025-01-03 04:07:23','2025-01-03 04:07:24','51234'),(70,'FO','FAROE ISLANDS','Faroe Islands','FRO',234,298,'2025-01-03 04:07:23','2025-01-03 04:07:24','211234'),(71,'FJ','FIJI','Fiji','FJI',242,679,'2025-01-03 04:07:23','2025-01-03 04:07:24','701 2345'),(72,'FI','FINLAND','Finland','FIN',246,358,'2025-01-03 04:07:23','2025-01-03 04:07:24','41 2345678'),(73,'FR','FRANCE','France','FRA',250,33,'2025-01-03 04:07:23','2025-01-03 04:07:24','6 12 34 56 78'),(74,'GF','FRENCH GUIANA','French Guiana','GUF',254,594,'2025-01-03 04:07:23','2025-01-03 04:07:24','694 20 12 34'),(75,'PF','FRENCH POLYNESIA','French Polynesia','PYF',258,689,'2025-01-03 04:07:23','2025-01-03 04:07:24','87 12 34 56'),(76,'TF','FRENCH SOUTHERN TERRITORIES','French Southern Territories','NUL',0,0,'2025-01-03 04:07:23','2025-01-03 04:07:24','0'),(77,'GA','GABON','Gabon','GAB',266,241,'2025-01-03 04:07:23','2025-01-03 04:07:24','6 03 12 34'),(78,'GM','GAMBIA','Gambia','GMB',270,220,'2025-01-03 04:07:23','2025-01-03 04:07:24','301 2345'),(79,'GE','GEORGIA','Georgia','GEO',268,995,'2025-01-03 04:07:23','2025-01-03 04:07:24','555 12 34 56'),(80,'DE','GERMANY','Germany','DEU',276,49,'2025-01-03 04:07:23','2025-01-03 04:07:24','1512 3456789'),(81,'GH','GHANA','Ghana','GHA',288,233,'2025-01-03 04:07:23','2025-01-03 04:07:24','23 123 4567'),(82,'GI','GIBRALTAR','Gibraltar','GIB',292,350,'2025-01-03 04:07:23','2025-01-03 04:07:24','57123456'),(83,'GR','GREECE','Greece','GRC',300,30,'2025-01-03 04:07:23','2025-01-03 04:07:24','691 234 5678'),(84,'GL','GREENLAND','Greenland','GRL',304,299,'2025-01-03 04:07:23','2025-01-03 04:07:24','22 12 34'),(85,'GD','GRENADA','Grenada','GRD',308,1473,'2025-01-03 04:07:23','2025-01-03 04:07:24','473 403-1234'),(86,'GP','GUADELOUPE','Guadeloupe','GLP',312,590,'2025-01-03 04:07:23','2025-01-03 04:07:24','690 30-1234'),(87,'GU','GUAM','Guam','GUM',316,1671,'2025-01-03 04:07:23','2025-01-03 04:07:24','671 300-1234'),(88,'GT','GUATEMALA','Guatemala','GTM',320,502,'2025-01-03 04:07:23','2025-01-03 04:07:24','5123 4567'),(89,'GN','GUINEA','Guinea','GIN',324,224,'2025-01-03 04:07:23','2025-01-03 04:07:24','601 12 34 56'),(90,'GW','GUINEA-BISSAU','Guinea-Bissau','GNB',624,245,'2025-01-03 04:07:23','2025-01-03 04:07:24','955 012 345'),(91,'GY','GUYANA','Guyana','GUY',328,592,'2025-01-03 04:07:23','2025-01-03 04:07:24','609 1234'),(92,'HT','HAITI','Haiti','HTI',332,509,'2025-01-03 04:07:23','2025-01-03 04:07:24','34 10 1234'),(93,'HM','HEARD ISLAND AND MCDONALD ISLANDS','Heard Island and Mcdonald Islands','NUL',0,0,'2025-01-03 04:07:23','2025-01-03 04:07:24','0'),(94,'VA','HOLY SEE (VATICAN CITY STATE)','Holy See (Vatican City State)','VAT',336,39,'2025-01-03 04:07:23','2025-01-03 04:07:24','0'),(95,'HN','HONDURAS','Honduras','HND',340,504,'2025-01-03 04:07:23','2025-01-03 04:07:24','9123-4567'),(96,'HK','HONG KONG','Hong Kong','HKG',344,852,'2025-01-03 04:07:23','2025-01-03 04:07:24','5123 4567'),(97,'HU','HUNGARY','Hungary','HUN',348,36,'2025-01-03 04:07:23','2025-01-03 04:07:24','20 123 4567'),(98,'IS','ICELAND','Iceland','ISL',352,354,'2025-01-03 04:07:23','2025-01-03 04:07:24','611 1234'),(99,'IN','INDIA','India','IND',356,91,'2025-01-03 04:07:23','2025-01-03 04:07:24','99876 54321'),(100,'ID','INDONESIA','Indonesia','IDN',360,62,'2025-01-03 04:07:23','2025-01-03 04:07:24','812-345-678'),(101,'IR','IRAN, ISLAMIC REPUBLIC OF','Iran, Islamic Republic of','IRN',364,98,'2025-01-03 04:07:23','2025-01-03 04:07:24','912 345 6789'),(102,'IQ','IRAQ','Iraq','IRQ',368,964,'2025-01-03 04:07:23','2025-01-03 04:07:24','791 234 5678'),(103,'IE','IRELAND','Ireland','IRL',372,353,'2025-01-03 04:07:23','2025-01-03 04:07:24','85 012 3456'),(104,'IL','ISRAEL','Israel','ISR',376,972,'2025-01-03 04:07:23','2025-01-03 04:07:24','50-123-4567'),(105,'IT','ITALY','Italy','ITA',380,39,'2025-01-03 04:07:23','2025-01-03 04:07:24','312 345 6789'),(106,'JM','JAMAICA','Jamaica','JAM',388,1876,'2025-01-03 04:07:23','2025-01-03 04:07:24','876 210-1234'),(107,'JP','JAPAN','Japan','JPN',392,81,'2025-01-03 04:07:23','2025-01-03 04:07:24','90-1234-5678'),(108,'JO','JORDAN','Jordan','JOR',400,962,'2025-01-03 04:07:23','2025-01-03 04:07:24','7 9012 3456'),(109,'KZ','KAZAKHSTAN','Kazakhstan','KAZ',398,7,'2025-01-03 04:07:23','2025-01-03 04:07:24','8 771 000 9998'),(110,'KE','KENYA','Kenya','KEN',404,254,'2025-01-03 04:07:23','2025-01-03 04:07:24','712 123456'),(111,'KI','KIRIBATI','Kiribati','KIR',296,686,'2025-01-03 04:07:23','2025-01-03 04:07:24','72012345'),(112,'KP','KOREA, DEMOCRATIC PEOPLES REPUBLIC OF','Korea, Democratic Peoples Republic of','PRK',408,850,'2025-01-03 04:07:23','2025-01-03 04:07:24','2-312-3456'),(113,'KR','KOREA, REPUBLIC OF','Korea, Republic of','KOR',410,82,'2025-01-03 04:07:23','2025-01-03 04:07:24','2-312-3456'),(114,'KW','KUWAIT','Kuwait','KWT',414,965,'2025-01-03 04:07:23','2025-01-03 04:07:24','500 12345'),(115,'KG','KYRGYZSTAN','Kyrgyzstan','KGZ',417,996,'2025-01-03 04:07:23','2025-01-03 04:07:24','700 123 456'),(116,'LA','LAO PEOPLES DEMOCRATIC REPUBLIC','Lao Peoples Democratic Republic','LAO',418,856,'2025-01-03 04:07:23','2025-01-03 04:07:24','0'),(117,'LV','LATVIA','Latvia','LVA',428,371,'2025-01-03 04:07:23','2025-01-03 04:07:24','21 234 567'),(118,'LB','LEBANON','Lebanon','LBN',422,961,'2025-01-03 04:07:23','2025-01-03 04:07:24','71 123 456'),(119,'LS','LESOTHO','Lesotho','LSO',426,266,'2025-01-03 04:07:23','2025-01-03 04:07:24','5012 3456'),(120,'LR','LIBERIA','Liberia','LBR',430,231,'2025-01-03 04:07:23','2025-01-03 04:07:24','77 012 3456'),(121,'LY','LIBYAN ARAB JAMAHIRIYA','Libyan Arab Jamahiriya','LBY',434,218,'2025-01-03 04:07:23','2025-01-03 04:07:24','91-2345678'),(122,'LI','LIECHTENSTEIN','Liechtenstein','LIE',438,423,'2025-01-03 04:07:23','2025-01-03 04:07:24','660 234 567'),(123,'LT','LITHUANIA','Lithuania','LTU',440,370,'2025-01-03 04:07:23','2025-01-03 04:07:24','8-612 34567'),(124,'LU','LUXEMBOURG','Luxembourg','LUX',442,352,'2025-01-03 04:07:23','2025-01-03 04:07:24','628 123 456'),(125,'MO','MACAO','Macao','MAC',446,853,'2025-01-03 04:07:23','2025-01-03 04:07:24','6612 3456'),(126,'MK','MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF','Macedonia, the Former Yugoslav Republic of','MKD',807,389,'2025-01-03 04:07:23','2025-01-03 04:07:24','72 345 678'),(127,'MG','MADAGASCAR','Madagascar','MDG',450,261,'2025-01-03 04:07:23','2025-01-03 04:07:24','32 12 345 67'),(128,'MW','MALAWI','Malawi','MWI',454,265,'2025-01-03 04:07:23','2025-01-03 04:07:24','991 23 45 67'),(129,'MY','MALAYSIA','Malaysia','MYS',458,60,'2025-01-03 04:07:23','2025-01-03 04:07:24','12-345 6789'),(130,'MV','MALDIVES','Maldives','MDV',462,960,'2025-01-03 04:07:23','2025-01-03 04:07:24','771-2345'),(131,'ML','MALI','Mali','MLI',466,223,'2025-01-03 04:07:23','2025-01-03 04:07:24','65 01 23 45'),(132,'MT','MALTA','Malta','MLT',470,356,'2025-01-03 04:07:23','2025-01-03 04:07:24','9696 1234'),(133,'MH','MARSHALL ISLANDS','Marshall Islands','MHL',584,692,'2025-01-03 04:07:23','2025-01-03 04:07:24','235-1234'),(134,'MQ','MARTINIQUE','Martinique','MTQ',474,596,'2025-01-03 04:07:23','2025-01-03 04:07:24','696 20 12 34'),(135,'MR','MAURITANIA','Mauritania','MRT',478,222,'2025-01-03 04:07:23','2025-01-03 04:07:24','22 12 34 56'),(136,'MU','MAURITIUS','Mauritius','MUS',480,230,'2025-01-03 04:07:23','2025-01-03 04:07:24','5251 2345'),(137,'YT','MAYOTTE','Mayotte','NUL',0,269,'2025-01-03 04:07:23','2025-01-03 04:07:24','639 12 34 56'),(138,'MX','MEXICO','Mexico','MEX',484,52,'2025-01-03 04:07:23','2025-01-03 04:07:24','44 222 123 4567'),(139,'FM','MICRONESIA, FEDERATED STATES OF','Micronesia, Federated States of','FSM',583,691,'2025-01-03 04:07:23','2025-01-03 04:07:24','350 1234'),(140,'MD','MOLDOVA, REPUBLIC OF','Moldova, Republic of','MDA',498,373,'2025-01-03 04:07:23','2025-01-03 04:07:24','621 12 345'),(141,'MC','MONACO','Monaco','MCO',492,377,'2025-01-03 04:07:23','2025-01-03 04:07:24','6 12 34 56 78'),(142,'MN','MONGOLIA','Mongolia','MNG',496,976,'2025-01-03 04:07:23','2025-01-03 04:07:24','8812 3456'),(143,'MS','MONTSERRAT','Montserrat','MSR',500,1664,'2025-01-03 04:07:23','2025-01-03 04:07:24','664 492-3456'),(144,'MA','MOROCCO','Morocco','MAR',504,212,'2025-01-03 04:07:23','2025-01-03 04:07:24','650-123456'),(145,'MZ','MOZAMBIQUE','Mozambique','MOZ',508,258,'2025-01-03 04:07:23','2025-01-03 04:07:24','82 123 4567'),(146,'MM','MYANMAR','Myanmar','MMR',104,95,'2025-01-03 04:07:23','2025-01-03 04:07:24','9 212 3456'),(147,'NA','NAMIBIA','Namibia','NAM',516,264,'2025-01-03 04:07:23','2025-01-03 04:07:24','81 123 4567'),(148,'NR','NAURU','Nauru','NRU',520,674,'2025-01-03 04:07:23','2025-01-03 04:07:24','555 1234'),(149,'NP','NEPAL','Nepal','NPL',524,977,'2025-01-03 04:07:23','2025-01-03 04:07:24','984-1234567'),(150,'NL','NETHERLANDS','Netherlands','NLD',528,31,'2025-01-03 04:07:23','2025-01-03 04:07:24','6 12345678'),(151,'AN','NETHERLANDS ANTILLES','Netherlands Antilles','ANT',530,599,'2025-01-03 04:07:23','2025-01-03 04:07:24','6 12345678'),(152,'NC','NEW CALEDONIA','New Caledonia','NCL',540,687,'2025-01-03 04:07:23','2025-01-03 04:07:24','75.12.34'),(153,'NZ','NEW ZEALAND','New Zealand','NZL',554,64,'2025-01-03 04:07:23','2025-01-03 04:07:24','21 123 4567'),(154,'NI','NICARAGUA','Nicaragua','NIC',558,505,'2025-01-03 04:07:23','2025-01-03 04:07:24','8123 4567'),(155,'NE','NIGER','Niger','NER',562,227,'2025-01-03 04:07:23','2025-01-03 04:07:24','93 12 34 56'),(156,'NG','NIGERIA','Nigeria','NGA',566,234,'2025-01-03 04:07:23','2025-01-03 04:07:24','802 123 4567'),(157,'NU','NIUE','Niue','NIU',570,683,'2025-01-03 04:07:23','2025-01-03 04:07:24','1234'),(158,'NF','NORFOLK ISLAND','Norfolk Island','NFK',574,672,'2025-01-03 04:07:23','2025-01-03 04:07:24','3 81234'),(159,'MP','NORTHERN MARIANA ISLANDS','Northern Mariana Islands','MNP',580,1670,'2025-01-03 04:07:23','2025-01-03 04:07:24','670 234-5678'),(160,'NO','NORWAY','Norway','NOR',578,47,'2025-01-03 04:07:23','2025-01-03 04:07:24','406 12 345'),(161,'OM','OMAN','Oman','OMN',512,968,'2025-01-03 04:07:23','2025-01-03 04:07:24','9212 3456'),(162,'PK','PAKISTAN','Pakistan','PAK',586,92,'2025-01-03 04:07:23','2025-01-03 04:07:24','301 2345678'),(163,'PW','PALAU','Palau','PLW',585,680,'2025-01-03 04:07:23','2025-01-03 04:07:24','620 1234'),(164,'PS','PALESTINIAN TERRITORY, OCCUPIED','Palestinian Territory, Occupied','NUL',0,970,'2025-01-03 04:07:23','2025-01-03 04:07:24','599 123 456'),(165,'PA','PANAMA','Panama','PAN',591,507,'2025-01-03 04:07:23','2025-01-03 04:07:24','6001-2345'),(166,'PG','PAPUA NEW GUINEA','Papua New Guinea','PNG',598,675,'2025-01-03 04:07:23','2025-01-03 04:07:24','681 2345'),(167,'PY','PARAGUAY','Paraguay','PRY',600,595,'2025-01-03 04:07:23','2025-01-03 04:07:24','961 456789'),(168,'PE','PERU','Peru','PER',604,51,'2025-01-03 04:07:23','2025-01-03 04:07:24','912 345 678'),(169,'PH','PHILIPPINES','Philippines','PHL',608,63,'2025-01-03 04:07:23','2025-01-03 04:07:24','905 123 4567'),(170,'PN','PITCAIRN','Pitcairn','PCN',612,0,'2025-01-03 04:07:23','2025-01-03 04:07:24','0'),(171,'PL','POLAND','Poland','POL',616,48,'2025-01-03 04:07:23','2025-01-03 04:07:24','512 345 678'),(172,'PT','PORTUGAL','Portugal','PRT',620,351,'2025-01-03 04:07:23','2025-01-03 04:07:24','912 345 678'),(173,'PR','PUERTO RICO','Puerto Rico','PRI',630,1787,'2025-01-03 04:07:23','2025-01-03 04:07:24','787 234-5678'),(174,'QA','QATAR','Qatar','QAT',634,974,'2025-01-03 04:07:23','2025-01-03 04:07:24','3312 3456'),(175,'RE','REUNION','Reunion','REU',638,262,'2025-01-03 04:07:23','2025-01-03 04:07:24','692 12 34 56'),(176,'RO','ROMANIA','Romania','ROM',642,40,'2025-01-03 04:07:23','2025-01-03 04:07:24','712 345 678'),(177,'RU','RUSSIAN FEDERATION','Russian Federation','RUS',643,7,'2025-01-03 04:07:23','2025-01-03 04:07:24','8 912 345-67-89'),(178,'RW','RWANDA','Rwanda','RWA',646,250,'2025-01-03 04:07:23','2025-01-03 04:07:24','720 123 456'),(179,'SH','SAINT HELENA','Saint Helena','SHN',654,290,'2025-01-03 04:07:23','2025-01-03 04:07:24','51234'),(180,'KN','SAINT KITTS AND NEVIS','Saint Kitts and Nevis','KNA',659,1869,'2025-01-03 04:07:23','2025-01-03 04:07:24','869 765-2917'),(181,'LC','SAINT LUCIA','Saint Lucia','LCA',662,1758,'2025-01-03 04:07:23','2025-01-03 04:07:24','758 284-5678'),(182,'PM','SAINT PIERRE AND MIQUELON','Saint Pierre and Miquelon','SPM',666,508,'2025-01-03 04:07:23','2025-01-03 04:07:24','55 12 34'),(183,'VC','SAINT VINCENT AND THE GRENADINES','Saint Vincent and the Grenadines','VCT',670,1784,'2025-01-03 04:07:23','2025-01-03 04:07:24','784 430-1234'),(184,'WS','SAMOA','Samoa','WSM',882,684,'2025-01-03 04:07:23','2025-01-03 04:07:24','601234'),(185,'SM','SAN MARINO','San Marino','SMR',674,378,'2025-01-03 04:07:23','2025-01-03 04:07:24','66 66 12 12'),(186,'ST','SAO TOME AND PRINCIPE','Sao Tome and Principe','STP',678,239,'2025-01-03 04:07:23','2025-01-03 04:07:24','981 2345'),(187,'SA','SAUDI ARABIA','Saudi Arabia','SAU',682,966,'2025-01-03 04:07:23','2025-01-03 04:07:24','51 234 5678'),(188,'SN','SENEGAL','Senegal','SEN',686,221,'2025-01-03 04:07:23','2025-01-03 04:07:24','70 123 45 67'),(189,'CS','SERBIA AND MONTENEGRO','Serbia and Montenegro','NUL',0,381,'2025-01-03 04:07:23','2025-01-03 04:07:24','60 1234567'),(190,'SC','SEYCHELLES','Seychelles','SYC',690,248,'2025-01-03 04:07:23','2025-01-03 04:07:24','2 510 123'),(191,'SL','SIERRA LEONE','Sierra Leone','SLE',694,232,'2025-01-03 04:07:23','2025-01-03 04:07:24','25 123456'),(192,'SG','SINGAPORE','Singapore','SGP',702,65,'2025-01-03 04:07:23','2025-01-03 04:07:24','8123 4567'),(193,'SK','SLOVAKIA','Slovakia','SVK',703,421,'2025-01-03 04:07:23','2025-01-03 04:07:24','912 123 456'),(194,'SI','SLOVENIA','Slovenia','SVN',705,386,'2025-01-03 04:07:23','2025-01-03 04:07:24','31 234 567'),(195,'SB','SOLOMON ISLANDS','Solomon Islands','SLB',90,677,'2025-01-03 04:07:23','2025-01-03 04:07:24','74 21234'),(196,'SO','SOMALIA','Somalia','SOM',706,252,'2025-01-03 04:07:23','2025-01-03 04:07:24','7 1123456'),(197,'ZA','SOUTH AFRICA','South Africa','ZAF',710,27,'2025-01-03 04:07:23','2025-01-03 04:07:24','71 123 4567'),(198,'GS','SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS','South Georgia and the South Sandwich Islands','NUL',0,0,'2025-01-03 04:07:23','2025-01-03 04:07:24','0'),(199,'ES','SPAIN','Spain','ESP',724,34,'2025-01-03 04:07:23','2025-01-03 04:07:24','612 34 56 78'),(200,'LK','SRI LANKA','Sri Lanka','LKA',144,94,'2025-01-03 04:07:23','2025-01-03 04:07:24','71 234 5678'),(201,'SD','SUDAN','Sudan','SDN',736,249,'2025-01-03 04:07:23','2025-01-03 04:07:24','91 123 1234'),(202,'SR','SURINAME','Suriname','SUR',740,597,'2025-01-03 04:07:23','2025-01-03 04:07:24','741-2345'),(203,'SJ','SVALBARD AND JAN MAYEN','Svalbard and Jan Mayen','SJM',744,47,'2025-01-03 04:07:23','2025-01-03 04:07:24','412 34 567'),(204,'SZ','SWAZILAND','Swaziland','SWZ',748,268,'2025-01-03 04:07:23','2025-01-03 04:07:24','7612 3456'),(205,'SE','SWEDEN','Sweden','SWE',752,46,'2025-01-03 04:07:23','2025-01-03 04:07:24','70-123 45 67'),(206,'CH','SWITZERLAND','Switzerland','CHE',756,41,'2025-01-03 04:07:23','2025-01-03 04:07:24','78 123 45 67'),(207,'SY','SYRIAN ARAB REPUBLIC','Syrian Arab Republic','SYR',760,963,'2025-01-03 04:07:23','2025-01-03 04:07:24','944 567 890'),(208,'TW','TAIWAN, PROVINCE OF CHINA','Taiwan, Province of China','TWN',158,886,'2025-01-03 04:07:23','2025-01-03 04:07:24','912 345 678'),(209,'TJ','TAJIKISTAN','Tajikistan','TJK',762,992,'2025-01-03 04:07:23','2025-01-03 04:07:24','8 917 12 3456'),(210,'TZ','TANZANIA, UNITED REPUBLIC OF','Tanzania, United Republic of','TZA',834,255,'2025-01-03 04:07:23','2025-01-03 04:07:24','621 234 567'),(211,'TH','THAILAND','Thailand','THA',764,66,'2025-01-03 04:07:23','2025-01-03 04:07:24','81 234 5678'),(212,'TL','TIMOR-LESTE','Timor-Leste','NUL',0,670,'2025-01-03 04:07:23','2025-01-03 04:07:24','7721 2345'),(213,'TG','TOGO','Togo','TGO',768,228,'2025-01-03 04:07:23','2025-01-03 04:07:24','90 11 23 45'),(214,'TK','TOKELAU','Tokelau','TKL',772,690,'2025-01-03 04:07:23','2025-01-03 04:07:24','7290'),(215,'TO','TONGA','Tonga','TON',776,676,'2025-01-03 04:07:23','2025-01-03 04:07:24','771 5123'),(216,'TT','TRINIDAD AND TOBAGO','Trinidad and Tobago','TTO',780,1868,'2025-01-03 04:07:23','2025-01-03 04:07:24','868 291-1234'),(217,'TN','TUNISIA','Tunisia','TUN',788,216,'2025-01-03 04:07:23','2025-01-03 04:07:24','20 123 456'),(218,'TR','TURKEY','Turkey','TUR',792,90,'2025-01-03 04:07:23','2025-01-03 04:07:24','501 234 56 78'),(219,'TM','TURKMENISTAN','Turkmenistan','TKM',795,7370,'2025-01-03 04:07:23','2025-01-03 04:07:24','8 66 123456'),(220,'TC','TURKS AND CAICOS ISLANDS','Turks and Caicos Islands','TCA',796,1649,'2025-01-03 04:07:23','2025-01-03 04:07:24','649 231-1234'),(221,'TV','TUVALU','Tuvalu','TUV',798,688,'2025-01-03 04:07:23','2025-01-03 04:07:24','901234'),(222,'UG','UGANDA','Uganda','UGA',800,256,'2025-01-03 04:07:23','2025-01-03 04:07:24','712 345678'),(223,'UA','UKRAINE','Ukraine','UKR',804,380,'2025-01-03 04:07:23','2025-01-03 04:07:24','39 123 4567'),(224,'AE','UNITED ARAB EMIRATES','United Arab Emirates','ARE',784,971,'2025-01-03 04:07:23','2025-01-03 04:07:24','50 123 4567'),(225,'GB','UNITED KINGDOM','United Kingdom','GBR',826,44,'2025-01-03 04:07:23','2025-01-03 04:07:24','7400 123456'),(226,'US','UNITED STATES','United States','USA',840,1,'2025-01-03 04:07:23','2025-01-03 04:07:24','201 555-0123'),(227,'UM','UNITED STATES MINOR OUTLYING ISLANDS','United States Minor Outlying Islands','NUL',0,1,'2025-01-03 04:07:23','2025-01-03 04:07:24','201 555-0123'),(228,'UY','URUGUAY','Uruguay','URY',858,598,'2025-01-03 04:07:23','2025-01-03 04:07:24','94 231 234'),(229,'UZ','UZBEKISTAN','Uzbekistan','UZB',860,998,'2025-01-03 04:07:23','2025-01-03 04:07:24','8 91 234 56 78'),(230,'VU','VANUATU','Vanuatu','VUT',548,678,'2025-01-03 04:07:23','2025-01-03 04:07:24','591 2345'),(231,'VE','VENEZUELA','Venezuela','VEN',862,58,'2025-01-03 04:07:23','2025-01-03 04:07:24','412-1234567'),(232,'VN','VIET NAM','Viet Nam','VNM',704,84,'2025-01-03 04:07:23','2025-01-03 04:07:24','91 234 56 78'),(233,'VG','VIRGIN ISLANDS, BRITISH','Virgin Islands, British','VGB',92,1284,'2025-01-03 04:07:23','2025-01-03 04:07:24','340 642-1234'),(234,'VI','VIRGIN ISLANDS, U.S.','Virgin Islands, U.s.','VIR',850,1340,'2025-01-03 04:07:23','2025-01-03 04:07:24','340 642-1234'),(235,'WF','WALLIS AND FUTUNA','Wallis and Futuna','WLF',876,681,'2025-01-03 04:07:23','2025-01-03 04:07:24','50 12 34'),(236,'EH','WESTERN SAHARA','Western Sahara','ESH',732,212,'2025-01-03 04:07:23','2025-01-03 04:07:24','650-123456'),(237,'YE','YEMEN','Yemen','YEM',887,967,'2025-01-03 04:07:23','2025-01-03 04:07:24','712 345 678'),(238,'ZM','ZAMBIA','Zambia','ZMB',894,260,'2025-01-03 04:07:23','2025-01-03 04:07:24','95 5123456'),(239,'ZW','ZIMBABWE','Zimbabwe','ZWE',716,263,'2025-01-03 04:07:23','2025-01-03 04:07:24','0');
/*!40000 ALTER TABLE `country_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cron_logs`
--

DROP TABLE IF EXISTS `cron_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cron_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `command` varchar(255) NOT NULL,
  `end_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `description` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `status` varchar(30) DEFAULT NULL,
  `exception_log_id` bigint(20) DEFAULT NULL,
  `duration` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cron_logs_created_at_index` (`created_at`),
  KEY `cron_logs_updated_at_index` (`updated_at`),
  KEY `command` (`command`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cron_logs`
--

LOCK TABLES `cron_logs` WRITE;
/*!40000 ALTER TABLE `cron_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `cron_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_form_value`
--

DROP TABLE IF EXISTS `custom_form_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_form_value` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form_field_id` int(10) unsigned NOT NULL,
  `value` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `custom_id` int(11) NOT NULL,
  `custom_type` varchar(100) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `custom_form_value_custom_id_index` (`custom_id`),
  KEY `custom_form_value_custom_type_index` (`custom_type`),
  KEY `custom_form_value_form_field_id_foreign` (`form_field_id`),
  FULLTEXT KEY `custom_form_value_value_fulltext` (`value`),
  CONSTRAINT `custom_form_value_form_field_id_foreign` FOREIGN KEY (`form_field_id`) REFERENCES `form_fields` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_form_value`
--

LOCK TABLES `custom_form_value` WRITE;
/*!40000 ALTER TABLE `custom_form_value` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_form_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_report_components`
--

DROP TABLE IF EXISTS `daily_report_components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `daily_report_components` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `daily_report_id` bigint(20) unsigned DEFAULT NULL,
  `component_id` varchar(255) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `daily_report_components_daily_report_id_foreign` (`daily_report_id`),
  CONSTRAINT `daily_report_components_daily_report_id_foreign` FOREIGN KEY (`daily_report_id`) REFERENCES `daily_reports` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_report_components`
--

LOCK TABLES `daily_report_components` WRITE;
/*!40000 ALTER TABLE `daily_report_components` DISABLE KEYS */;
/*!40000 ALTER TABLE `daily_report_components` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_reports`
--

DROP TABLE IF EXISTS `daily_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `daily_reports` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_reports`
--

LOCK TABLES `daily_reports` WRITE;
/*!40000 ALTER TABLE `daily_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `daily_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `date_format`
--

DROP TABLE IF EXISTS `date_format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `date_format` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `format` varchar(255) NOT NULL,
  `js_format` varchar(14) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `date_format`
--

LOCK TABLES `date_format` WRITE;
/*!40000 ALTER TABLE `date_format` DISABLE KEYS */;
INSERT INTO `date_format` VALUES (1,'dd/mm/yyyy','',0),(2,'dd-mm-yyyy','',0),(3,'dd.mm.yyyy','',0),(4,'mm/dd/yyyy','',0),(5,'mm:dd:yyyy','',0),(6,'mm-dd-yyyy','',0),(7,'yyyy/mm/dd','',0),(8,'yyyy.mm.dd','',0),(9,'yyyy-mm-dd','',0),(10,'d-m-Y','DD-MM-YYYY',1),(11,'m-d-Y','MM-DD-YYYY',1),(12,'Y-m-d','YYYY-MM-DD',1),(13,'F j, Y','LL',1);
/*!40000 ALTER TABLE `date_format` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `date_time_format`
--

DROP TABLE IF EXISTS `date_time_format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `date_time_format` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `format` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `date_time_format`
--

LOCK TABLES `date_time_format` WRITE;
/*!40000 ALTER TABLE `date_time_format` DISABLE KEYS */;
INSERT INTO `date_time_format` VALUES (1,'F j, Y, g:i a'),(2,'jS F Y'),(3,'H:i'),(4,'d/m/Y H:i'),(5,'d.m.Y H:i'),(6,'d-m-Y H:i'),(7,'m/d/Y H:i'),(8,'m.d.Y H:i'),(9,'m-d-Y H:i'),(10,'Y/m/d H:i'),(11,'Y.m.d H:i'),(12,'Y-m-d H:i');
/*!40000 ALTER TABLE `date_time_format` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `department` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type_id` int(10) unsigned DEFAULT 1,
  `manager` int(10) unsigned DEFAULT NULL,
  `ticket_assignment` varchar(255) NOT NULL,
  `outgoing_email_id` int(10) unsigned DEFAULT NULL,
  `template_set` varchar(255) NOT NULL,
  `auto_ticket_response` varchar(255) NOT NULL,
  `auto_message_response` varchar(255) NOT NULL,
  `auto_response_email` varchar(255) NOT NULL,
  `recipient` varchar(255) NOT NULL,
  `group_access` varchar(255) NOT NULL,
  `department_sign` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `business_hour_id` int(10) unsigned DEFAULT NULL,
  `en_auto_assign` tinyint(1) NOT NULL DEFAULT 0,
  `under_deletion` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `manager_2` (`manager`),
  CONSTRAINT `department_ibfk_2` FOREIGN KEY (`manager`) REFERENCES `users` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'Support',1,NULL,'',NULL,'','','','','','','','2025-01-03 04:07:23','2025-01-03 04:07:23',NULL,0,0),(2,'Sales',1,NULL,'',NULL,'','','','','','','','2025-01-03 04:07:23','2025-01-03 04:07:23',NULL,0,0),(3,'Operation',1,NULL,'',NULL,'','','','','','','','2025-01-03 04:07:23','2025-01-03 04:07:23',NULL,0,0);
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_assign_agents`
--

DROP TABLE IF EXISTS `department_assign_agents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `department_assign_agents` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `department_id` int(11) NOT NULL,
  `agent_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `role` varchar(15) DEFAULT 'member',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_assign_agents`
--

LOCK TABLES `department_assign_agents` WRITE;
/*!40000 ALTER TABLE `department_assign_agents` DISABLE KEYS */;
INSERT INTO `department_assign_agents` VALUES (1,1,1,'2025-01-03 04:07:23','2025-01-03 04:07:23','member');
/*!40000 ALTER TABLE `department_assign_agents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_assign_manager`
--

DROP TABLE IF EXISTS `department_assign_manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `department_assign_manager` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `department_id` int(11) NOT NULL,
  `manager_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_assign_manager`
--

LOCK TABLES `department_assign_manager` WRITE;
/*!40000 ALTER TABLE `department_assign_manager` DISABLE KEYS */;
/*!40000 ALTER TABLE `department_assign_manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_canned_resposne`
--

DROP TABLE IF EXISTS `department_canned_resposne`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `department_canned_resposne` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dept_id` int(10) unsigned NOT NULL,
  `canned_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `department_canned_resposne_dept_id_foreign` (`dept_id`),
  KEY `department_canned_resposne_canned_id_foreign` (`canned_id`),
  CONSTRAINT `department_canned_resposne_canned_id_foreign` FOREIGN KEY (`canned_id`) REFERENCES `canned_response` (`id`),
  CONSTRAINT `department_canned_resposne_dept_id_foreign` FOREIGN KEY (`dept_id`) REFERENCES `department` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_canned_resposne`
--

LOCK TABLES `department_canned_resposne` WRITE;
/*!40000 ALTER TABLE `department_canned_resposne` DISABLE KEYS */;
/*!40000 ALTER TABLE `department_canned_resposne` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_form_group`
--

DROP TABLE IF EXISTS `department_form_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `department_form_group` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `form_group_id` int(10) unsigned NOT NULL,
  `department_id` int(10) unsigned NOT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `department_form_group_form_group_id_foreign` (`form_group_id`),
  KEY `department_form_group_department_id_foreign` (`department_id`),
  CONSTRAINT `department_form_group_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `department_form_group_form_group_id_foreign` FOREIGN KEY (`form_group_id`) REFERENCES `form_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_form_group`
--

LOCK TABLES `department_form_group` WRITE;
/*!40000 ALTER TABLE `department_form_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `department_form_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_oauth`
--

DROP TABLE IF EXISTS `email_oauth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_oauth` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `configuration` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`configuration`)),
  `access_token` text NOT NULL,
  `refresh_token` text NOT NULL,
  `security_token` text NOT NULL,
  `integration_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `email_oauth_integration_id_foreign` (`integration_id`),
  CONSTRAINT `email_oauth_integration_id_foreign` FOREIGN KEY (`integration_id`) REFERENCES `oauth_integrations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_oauth`
--

LOCK TABLES `email_oauth` WRITE;
/*!40000 ALTER TABLE `email_oauth` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_oauth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_threads`
--

DROP TABLE IF EXISTS `email_threads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_threads` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) NOT NULL,
  `thread_id` int(11) NOT NULL,
  `message_id` varchar(255) NOT NULL,
  `uid` int(11) NOT NULL,
  `reference_id` longtext NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `fetching_email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `email_threads_message_id_index` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_threads`
--

LOCK TABLES `email_threads` WRITE;
/*!40000 ALTER TABLE `email_threads` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_threads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emails`
--

DROP TABLE IF EXISTS `emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emails` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email_address` varchar(255) NOT NULL,
  `email_name` varchar(255) NOT NULL,
  `department` int(10) unsigned DEFAULT NULL,
  `priority` int(10) unsigned DEFAULT NULL,
  `help_topic` int(10) unsigned DEFAULT NULL,
  `user_name` varchar(255) NOT NULL,
  `password` text NOT NULL,
  `fetching_host` varchar(255) NOT NULL,
  `fetching_port` varchar(255) NOT NULL,
  `fetching_protocol` varchar(255) NOT NULL,
  `fetching_encryption` varchar(255) DEFAULT NULL,
  `mailbox_protocol` varchar(255) NOT NULL,
  `imap_config` varchar(255) NOT NULL,
  `folder` varchar(255) NOT NULL,
  `sending_host` varchar(255) NOT NULL,
  `sending_port` varchar(255) NOT NULL,
  `sending_protocol` varchar(255) NOT NULL,
  `sending_encryption` varchar(255) DEFAULT NULL,
  `smtp_validate` varchar(255) NOT NULL,
  `smtp_authentication` varchar(255) NOT NULL,
  `internal_notes` varchar(255) NOT NULL,
  `auto_response` tinyint(1) NOT NULL,
  `fetching_status` tinyint(1) NOT NULL,
  `move_to_folder` tinyint(1) NOT NULL,
  `delete_email` tinyint(1) NOT NULL,
  `do_nothing` tinyint(1) NOT NULL,
  `sending_status` tinyint(1) NOT NULL,
  `authentication` tinyint(1) NOT NULL,
  `header_spoofing` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `block_auto_generated` tinyint(1) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `secret` varchar(255) NOT NULL,
  `region` varchar(255) NOT NULL,
  `version` varchar(30) DEFAULT NULL,
  `available_for_fetch` tinyint(1) DEFAULT 1,
  `last_fetched_at` datetime NOT NULL,
  `inline_as_cids` tinyint(1) NOT NULL DEFAULT 0,
  `use_new_imap_package` tinyint(1) NOT NULL DEFAULT 0,
  `is_oauth` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `department` (`department`,`priority`,`help_topic`),
  KEY `department_2` (`department`,`priority`,`help_topic`),
  KEY `priority` (`priority`),
  KEY `help_topic` (`help_topic`),
  KEY `emails_last_fetched_at_index` (`last_fetched_at`),
  CONSTRAINT `emails_ibfk_1` FOREIGN KEY (`department`) REFERENCES `department` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `emails_ibfk_2` FOREIGN KEY (`priority`) REFERENCES `ticket_priority` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `emails_ibfk_3` FOREIGN KEY (`help_topic`) REFERENCES `help_topic` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emails`
--

LOCK TABLES `emails` WRITE;
/*!40000 ALTER TABLE `emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exception_logs`
--

DROP TABLE IF EXISTS `exception_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exception_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `log_category_id` int(10) unsigned NOT NULL,
  `file` varchar(255) NOT NULL,
  `line` int(11) NOT NULL,
  `trace` text NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `exception_logs_created_at_index` (`created_at`),
  KEY `exception_logs_updated_at_index` (`updated_at`),
  KEY `log_category_id` (`log_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exception_logs`
--

LOCK TABLES `exception_logs` WRITE;
/*!40000 ALTER TABLE `exception_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `exception_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `execution_timestamp`
--

DROP TABLE IF EXISTS `execution_timestamp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `execution_timestamp` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `last_execution` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `execution_timestamp`
--

LOCK TABLES `execution_timestamp` WRITE;
/*!40000 ALTER TABLE `execution_timestamp` DISABLE KEYS */;
/*!40000 ALTER TABLE `execution_timestamp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `export_columns`
--

DROP TABLE IF EXISTS `export_columns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `export_columns` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `is_visible` tinyint(1) DEFAULT NULL,
  `is_sortable` tinyint(1) DEFAULT NULL,
  `is_custom` tinyint(1) DEFAULT NULL,
  `is_html` tinyint(1) NOT NULL DEFAULT 0,
  `is_timestamp` tinyint(1) DEFAULT NULL,
  `timestamp_format` varchar(255) DEFAULT NULL,
  `order` bigint(20) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `category_identifier` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `export_columns`
--

LOCK TABLES `export_columns` WRITE;
/*!40000 ALTER TABLE `export_columns` DISABLE KEYS */;
INSERT INTO `export_columns` VALUES (1,'name','name',1,1,0,1,0,NULL,1,'users_export',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30'),(2,'user_name','user_name',0,1,0,1,0,NULL,2,'users_export',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30'),(3,'first_name','first_name',0,1,0,0,0,NULL,3,'users_export',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30'),(4,'last_name','last_name',0,1,0,0,0,NULL,4,'users_export',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30'),(5,'email','email',1,1,0,0,0,NULL,5,'users_export',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30'),(6,'active','active',0,1,0,0,0,NULL,6,'users_export',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30'),(7,'mobile','mobile',0,0,0,0,0,NULL,7,'users_export',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30'),(8,'role','role',1,1,0,0,0,NULL,8,'users_export',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30'),(9,'created_at','created_at',0,1,0,0,1,NULL,9,'users_export',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30'),(10,'location','user_location',0,1,0,0,0,NULL,10,'users_export',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30'),(11,'created_by','created_by',0,1,0,0,0,NULL,11,'users_export',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30'),(12,'deactivated_by','deactivated_by',0,1,0,0,0,NULL,12,'users_export',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30'),(13,'deactivated_at','deactivated_at',0,0,0,0,1,NULL,13,'users_export',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30'),(14,'organizations','organizations',1,0,0,0,0,NULL,14,'users_export',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30'),(15,'labels','labels',0,0,0,1,0,NULL,15,'users_export',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `export_columns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `export_downloads`
--

DROP TABLE IF EXISTS `export_downloads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `export_downloads` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `export_downloads`
--

LOCK TABLES `export_downloads` WRITE;
/*!40000 ALTER TABLE `export_downloads` DISABLE KEYS */;
/*!40000 ALTER TABLE `export_downloads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `extra_orgs`
--

DROP TABLE IF EXISTS `extra_orgs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `extra_orgs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `extra_orgs`
--

LOCK TABLES `extra_orgs` WRITE;
/*!40000 ALTER TABLE `extra_orgs` DISABLE KEYS */;
/*!40000 ALTER TABLE `extra_orgs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_jobs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) DEFAULT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faveo_mails`
--

DROP TABLE IF EXISTS `faveo_mails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `faveo_mails` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email_id` int(11) NOT NULL,
  `drive` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faveo_mails`
--

LOCK TABLES `faveo_mails` WRITE;
/*!40000 ALTER TABLE `faveo_mails` DISABLE KEYS */;
/*!40000 ALTER TABLE `faveo_mails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faveo_queues`
--

DROP TABLE IF EXISTS `faveo_queues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `faveo_queues` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `service_id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faveo_queues`
--

LOCK TABLES `faveo_queues` WRITE;
/*!40000 ALTER TABLE `faveo_queues` DISABLE KEYS */;
/*!40000 ALTER TABLE `faveo_queues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fetched_mails`
--

DROP TABLE IF EXISTS `fetched_mails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fetched_mails` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) DEFAULT NULL,
  `messageId` varchar(255) DEFAULT NULL,
  `content` longblob DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'INITIATED',
  `attempts` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetched_mails`
--

LOCK TABLES `fetched_mails` WRITE;
/*!40000 ALTER TABLE `fetched_mails` DISABLE KEYS */;
/*!40000 ALTER TABLE `fetched_mails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `field_managers`
--

DROP TABLE IF EXISTS `field_managers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `field_managers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `field_managers`
--

LOCK TABLES `field_managers` WRITE;
/*!40000 ALTER TABLE `field_managers` DISABLE KEYS */;
INSERT INTO `field_managers` VALUES (1,'ticket','2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `field_managers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_manager_acl_rules`
--

DROP TABLE IF EXISTS `file_manager_acl_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_manager_acl_rules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `disk` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `access` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `dirname` varchar(255) DEFAULT NULL,
  `basename` varchar(255) DEFAULT NULL,
  `extension` varchar(255) DEFAULT NULL,
  `size` varchar(255) DEFAULT NULL,
  `timestamp` varchar(255) NOT NULL,
  `hidden` tinyint(1) NOT NULL DEFAULT 0,
  `default` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `file_manager_acl_rules_user_id_foreign` (`user_id`),
  CONSTRAINT `file_manager_acl_rules_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_manager_acl_rules`
--

LOCK TABLES `file_manager_acl_rules` WRITE;
/*!40000 ALTER TABLE `file_manager_acl_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_manager_acl_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_manager_acl_rules_departments`
--

DROP TABLE IF EXISTS `file_manager_acl_rules_departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_manager_acl_rules_departments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `rule_id` bigint(20) unsigned DEFAULT NULL,
  `department_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `file_manager_acl_rules_departments_department_id_foreign` (`department_id`),
  KEY `file_manager_acl_rules_departments_rule_id_foreign` (`rule_id`),
  CONSTRAINT `file_manager_acl_rules_departments_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`),
  CONSTRAINT `file_manager_acl_rules_departments_rule_id_foreign` FOREIGN KEY (`rule_id`) REFERENCES `file_manager_acl_rules` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_manager_acl_rules_departments`
--

LOCK TABLES `file_manager_acl_rules_departments` WRITE;
/*!40000 ALTER TABLE `file_manager_acl_rules_departments` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_manager_acl_rules_departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filters`
--

DROP TABLE IF EXISTS `filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `filters` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `filterable_type` varchar(255) NOT NULL,
  `filterable_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `filters`
--

LOCK TABLES `filters` WRITE;
/*!40000 ALTER TABLE `filters` DISABLE KEYS */;
/*!40000 ALTER TABLE `filters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_categories`
--

DROP TABLE IF EXISTS `form_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `type` varchar(25) NOT NULL DEFAULT 'helpdesk',
  `name` varchar(25) NOT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `is_migrated` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `form_categories_parent_id_foreign` (`parent_id`),
  CONSTRAINT `form_categories_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `form_categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_categories`
--

LOCK TABLES `form_categories` WRITE;
/*!40000 ALTER TABLE `form_categories` DISABLE KEYS */;
INSERT INTO `form_categories` VALUES (1,'ticket','2025-01-03 04:07:24','2025-01-03 04:07:25','helpdesk','Ticket',NULL,0),(2,'organisation','2025-01-03 04:07:24','2025-01-03 04:07:25','helpdesk','Organization',NULL,0),(3,'user','2025-01-03 04:07:24','2025-01-03 04:07:25','helpdesk','Requester',NULL,0);
/*!40000 ALTER TABLE `form_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_category_configs`
--

DROP TABLE IF EXISTS `form_category_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_category_configs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned NOT NULL,
  `organization_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `form_category_configs_category_id_foreign` (`category_id`),
  KEY `form_category_configs_organization_id_foreign` (`organization_id`),
  CONSTRAINT `form_category_configs_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `form_categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `form_category_configs_organization_id_foreign` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_category_configs`
--

LOCK TABLES `form_category_configs` WRITE;
/*!40000 ALTER TABLE `form_category_configs` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_category_configs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_category_form_group`
--

DROP TABLE IF EXISTS `form_category_form_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_category_form_group` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `form_group_id` int(10) unsigned NOT NULL,
  `form_category_id` int(10) unsigned NOT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `form_category_form_group_form_group_id_foreign` (`form_group_id`),
  KEY `form_category_form_group_form_category_id_foreign` (`form_category_id`),
  CONSTRAINT `form_category_form_group_form_category_id_foreign` FOREIGN KEY (`form_category_id`) REFERENCES `form_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `form_category_form_group_form_group_id_foreign` FOREIGN KEY (`form_group_id`) REFERENCES `form_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_category_form_group`
--

LOCK TABLES `form_category_form_group` WRITE;
/*!40000 ALTER TABLE `form_category_form_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_category_form_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_field_labels`
--

DROP TABLE IF EXISTS `form_field_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_field_labels` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `language` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `meant_for` varchar(255) DEFAULT NULL,
  `labelable_id` int(10) unsigned DEFAULT NULL,
  `labelable_type` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `description` varchar(1000) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_field_labels`
--

LOCK TABLES `form_field_labels` WRITE;
/*!40000 ALTER TABLE `form_field_labels` DISABLE KEYS */;
INSERT INTO `form_field_labels` VALUES (1,'en','Requester','form_field',1,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(3,'en','CC','form_field',2,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(5,'en','Subject','form_field',3,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(7,'en','Status','form_field',4,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(9,'en','Priority','form_field',5,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(11,'en','Location','form_field',6,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(13,'en','Source','form_field',7,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(15,'en','Help Topic','form_field',8,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(17,'en','Department','form_field',9,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(19,'en','Type','form_field',10,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(21,'en','Assigned','form_field',11,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(23,'en','Description','form_field',12,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(25,'en','Captcha','form_field',13,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(27,'en','Organisation Name','form_field',14,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(29,'en','Phone','form_field',15,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(31,'en','Organisation Domain Name','form_field',16,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:31','Domain names cannot start with special characters such as \'-\', \'/\', or \'@\'. Additionally, prefixes like \'http://\', \'https://\', and \'www\' will not be considered.'),(33,'en','Description','form_field',17,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(35,'en','Address','form_field',18,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(37,'en','Organisation Logo','form_field',19,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(39,'en','Organisation Department','form_field',20,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(41,'en','Captcha','form_field',21,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(43,'en','First Name','form_field',22,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(45,'en','Last Name','form_field',23,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(47,'en','User Name','form_field',24,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(49,'en','Work Phone','form_field',25,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(51,'en','Email','form_field',26,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(53,'en','Mobile Phone','form_field',27,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(55,'en','Address','form_field',28,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(57,'en','Organisation','form_field',29,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(59,'en','Organisation Department','form_field',30,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(61,'en','Captcha','form_field',31,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(63,'en','Select Package','form_field',32,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:24','2025-01-03 04:07:25',''),(65,'en','Team','form_field',33,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:28','2025-01-03 04:07:28',''),(66,'en','Labels','form_field',34,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:30','2025-01-03 04:07:30',''),(67,'en','Labels','form_field',35,'App\\Model\\helpdesk\\Form\\FormField','2025-01-03 04:07:30','2025-01-03 04:07:30','');
/*!40000 ALTER TABLE `form_field_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_field_option_form_group`
--

DROP TABLE IF EXISTS `form_field_option_form_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_field_option_form_group` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `form_group_id` int(10) unsigned NOT NULL,
  `form_field_option_id` int(10) unsigned NOT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `form_field_option_form_group_form_group_id_foreign` (`form_group_id`),
  KEY `form_field_option_form_group_form_field_option_id_foreign` (`form_field_option_id`),
  CONSTRAINT `form_field_option_form_group_form_field_option_id_foreign` FOREIGN KEY (`form_field_option_id`) REFERENCES `form_field_options` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `form_field_option_form_group_form_group_id_foreign` FOREIGN KEY (`form_group_id`) REFERENCES `form_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_field_option_form_group`
--

LOCK TABLES `form_field_option_form_group` WRITE;
/*!40000 ALTER TABLE `form_field_option_form_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_field_option_form_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_field_options`
--

DROP TABLE IF EXISTS `form_field_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_field_options` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form_field_id` int(10) unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_field_options`
--

LOCK TABLES `form_field_options` WRITE;
/*!40000 ALTER TABLE `form_field_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_field_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_fields`
--

DROP TABLE IF EXISTS `form_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
  `category_type` varchar(255) NOT NULL,
  `sort_order` int(10) unsigned DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `required_for_agent` tinyint(1) NOT NULL,
  `required_for_user` tinyint(1) NOT NULL,
  `display_for_agent` tinyint(1) NOT NULL,
  `display_for_user` tinyint(1) NOT NULL,
  `default` tinyint(1) NOT NULL,
  `is_linked` tinyint(1) NOT NULL,
  `media_option` tinyint(1) NOT NULL,
  `api_info` varchar(255) DEFAULT NULL,
  `pattern` varchar(255) DEFAULT NULL,
  `option_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_edit_visible` tinyint(1) NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_locked` tinyint(1) NOT NULL DEFAULT 0,
  `unique` varchar(255) NOT NULL,
  `form_group_id` int(10) unsigned DEFAULT NULL,
  `is_deletable` tinyint(1) NOT NULL DEFAULT 1,
  `is_customizable` tinyint(1) NOT NULL DEFAULT 1,
  `is_observable` tinyint(1) NOT NULL DEFAULT 1,
  `is_filterable` tinyint(1) NOT NULL DEFAULT 1,
  `is_agent_config` tinyint(1) NOT NULL DEFAULT 1,
  `is_user_config` tinyint(1) NOT NULL DEFAULT 1,
  `show_description_under_form_field` tinyint(4) NOT NULL DEFAULT 0,
  `shortcode` text DEFAULT NULL,
  `is_migrated` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `form_fields_form_group_id_foreign` (`form_group_id`),
  CONSTRAINT `form_fields_form_group_id_foreign` FOREIGN KEY (`form_group_id`) REFERENCES `form_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_fields`
--

LOCK TABLES `form_fields` WRITE;
/*!40000 ALTER TABLE `form_fields` DISABLE KEYS */;
INSERT INTO `form_fields` VALUES (1,1,'App\\Model\\helpdesk\\Form\\FormCategory',1,'Requester','api',1,1,1,1,1,0,0,'url:=/api/dependency/users?meta=true;;',NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',1,1,0,'requester',NULL,0,1,0,1,1,1,0,NULL,0),(2,1,'App\\Model\\helpdesk\\Form\\FormCategory',2,'CC','multiselect',0,0,1,0,1,0,0,'url:=/api/dependency/users?meta=true;;',NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',0,1,0,'cc',NULL,0,1,0,1,1,1,0,NULL,0),(3,1,'App\\Model\\helpdesk\\Form\\FormCategory',3,'Subject','text',1,1,1,1,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',1,1,0,'subject',NULL,0,1,1,1,1,1,0,NULL,0),(4,1,'App\\Model\\helpdesk\\Form\\FormCategory',4,'Status','api',0,0,1,0,1,0,0,'url:=/api/dependency/statuses;;',NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',0,1,0,'status_id',NULL,0,1,1,1,1,1,0,NULL,0),(5,1,'App\\Model\\helpdesk\\Form\\FormCategory',5,'Priority','api',1,1,1,1,1,0,0,'url:=/api/dependency/priorities;;',NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',1,1,0,'priority_id',NULL,0,1,1,1,1,1,0,NULL,0),(6,1,'App\\Model\\helpdesk\\Form\\FormCategory',6,'Location','api',0,0,1,0,1,0,0,'url:=/api/dependency/locations;;',NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',1,1,0,'location_id',NULL,0,1,1,1,1,1,0,NULL,0),(7,1,'App\\Model\\helpdesk\\Form\\FormCategory',7,'Source','api',0,0,1,0,1,0,0,'url:=/api/dependency/sources;;',NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',1,1,0,'source_id',NULL,0,1,1,1,1,1,0,NULL,0),(8,1,'App\\Model\\helpdesk\\Form\\FormCategory',8,'Help Topic','api',1,1,1,1,1,0,0,'url:=/api/dependency/help-topics?meta=true;;',NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',1,1,0,'help_topic_id',NULL,0,1,1,1,1,1,0,NULL,0),(9,1,'App\\Model\\helpdesk\\Form\\FormCategory',9,'Department','api',0,0,1,0,1,0,0,'url:=/api/dependency/departments?meta=true;;',NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',1,1,0,'department_id',NULL,0,1,1,1,1,1,0,NULL,0),(10,1,'App\\Model\\helpdesk\\Form\\FormCategory',10,'Type','api',0,0,1,1,1,0,0,'url:=/api/dependency/types;;',NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',1,1,0,'type_id',NULL,0,1,1,1,1,1,0,NULL,0),(11,1,'App\\Model\\helpdesk\\Form\\FormCategory',11,'Assigned','api',0,0,1,0,1,0,0,'url:=/api/dependency/agents?meta=true;;',NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',0,1,0,'assigned_id',NULL,0,1,1,1,1,1,0,NULL,0),(12,1,'App\\Model\\helpdesk\\Form\\FormCategory',12,'Description','htmltextarea',1,1,1,1,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',0,1,0,'description',NULL,0,1,1,1,1,1,0,NULL,0),(14,2,'App\\Model\\helpdesk\\Form\\FormCategory',1,'Organisation Name','text',1,1,1,1,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',1,1,0,'organisation_name',NULL,0,1,1,1,1,1,0,NULL,0),(15,2,'App\\Model\\helpdesk\\Form\\FormCategory',2,'Phone','number',1,0,1,1,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',1,1,0,'phone',NULL,0,1,1,1,1,1,0,NULL,0),(16,2,'App\\Model\\helpdesk\\Form\\FormCategory',3,'Organisation Domain Name','taggable',0,0,1,1,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',1,1,0,'organisation_domain_name',NULL,0,1,1,1,1,1,0,NULL,0),(17,2,'App\\Model\\helpdesk\\Form\\FormCategory',4,'Description','textarea',0,0,1,1,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',1,1,0,'description',NULL,0,1,1,1,1,1,0,NULL,0),(18,2,'App\\Model\\helpdesk\\Form\\FormCategory',5,'Address','textarea',0,0,1,0,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',1,1,0,'address',NULL,0,1,1,1,1,1,0,NULL,0),(19,2,'App\\Model\\helpdesk\\Form\\FormCategory',6,'Organisation Logo','file',0,0,1,1,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',1,1,0,'organisation_logo',NULL,0,1,1,1,1,1,0,NULL,0),(20,2,'App\\Model\\helpdesk\\Form\\FormCategory',7,'Organisation Department','taggable',0,0,1,0,1,0,0,'url:=/api/dependency/organisation-departments;;',NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',1,0,0,'organisation_department',NULL,0,1,1,1,1,1,0,NULL,0),(22,3,'App\\Model\\helpdesk\\Form\\FormCategory',1,'First Name','text',1,1,1,1,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',1,1,0,'first_name',NULL,0,1,1,1,1,1,0,NULL,0),(23,3,'App\\Model\\helpdesk\\Form\\FormCategory',2,'Last Name','text',1,1,1,1,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',1,1,0,'last_name',NULL,0,1,1,1,1,1,0,NULL,0),(24,3,'App\\Model\\helpdesk\\Form\\FormCategory',3,'User Name','text',0,0,1,0,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',1,1,0,'user_name',NULL,0,1,1,1,1,1,0,NULL,0),(25,3,'App\\Model\\helpdesk\\Form\\FormCategory',4,'Work Phone','number',0,0,1,0,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',1,1,0,'phone_number',NULL,0,1,1,1,1,1,0,NULL,0),(26,3,'App\\Model\\helpdesk\\Form\\FormCategory',5,'Email','email',1,1,1,1,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',1,1,0,'email',NULL,0,1,1,1,1,1,0,NULL,0),(27,3,'App\\Model\\helpdesk\\Form\\FormCategory',6,'Mobile Phone','number',0,0,1,0,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',1,1,0,'mobile',NULL,0,1,1,1,1,1,0,NULL,0),(28,3,'App\\Model\\helpdesk\\Form\\FormCategory',7,'Address','textarea',0,0,1,0,1,0,0,NULL,NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',1,1,0,'address',NULL,0,1,1,1,1,1,0,NULL,0),(29,3,'App\\Model\\helpdesk\\Form\\FormCategory',8,'Organisation','multiselect',0,0,1,0,1,0,0,'url:=/api/dependency/organizations;;',NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:25',1,1,0,'organisation',NULL,0,1,1,1,1,1,0,NULL,0),(30,3,'App\\Model\\helpdesk\\Form\\FormCategory',9,'Organisation Department','multiselect',0,0,1,0,1,0,0,'url:=/api/dependency/organisation-departments;;',NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:28',1,0,0,'organisation_department',NULL,0,1,1,1,1,1,0,NULL,0),(32,1,'App\\Model\\helpdesk\\Form\\FormCategory',14,'Billing','api',0,1,1,1,1,0,0,'url:=/ticket/form/dependancy?dependency=user-packages;;',NULL,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',0,0,0,'package_order',NULL,0,0,0,0,1,1,0,NULL,0),(33,1,'App\\Model\\helpdesk\\Form\\FormCategory',9,'Team','api',0,0,0,0,1,0,0,'url:=/api/dependency/teams?meta=true;;',NULL,NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28',1,1,0,'team_id',NULL,0,1,1,1,1,0,0,NULL,0),(34,3,'App\\Model\\helpdesk\\Form\\FormCategory',10,'Labels','multiselect',0,0,0,0,1,0,0,'url:=api/dependency/labels;;',NULL,NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30',1,1,0,'label_ids',NULL,0,1,1,1,1,0,0,NULL,0),(35,2,'App\\Model\\helpdesk\\Form\\FormCategory',6,'Labels','multiselect',0,0,0,0,1,0,0,'url:=api/dependency/labels;;',NULL,NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30',1,1,0,'orglabel_ids',NULL,0,1,1,1,1,0,0,NULL,0);
/*!40000 ALTER TABLE `form_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_groups`
--

DROP TABLE IF EXISTS `form_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `group_type` varchar(25) NOT NULL DEFAULT 'ticket',
  `is_migrated` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_groups`
--

LOCK TABLES `form_groups` WRITE;
/*!40000 ALTER TABLE `form_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forms`
--

DROP TABLE IF EXISTS `forms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form` varchar(255) NOT NULL,
  `json` longtext NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forms`
--

LOCK TABLES `forms` WRITE;
/*!40000 ALTER TABLE `forms` DISABLE KEYS */;
/*!40000 ALTER TABLE `forms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `global_search_filters`
--

DROP TABLE IF EXISTS `global_search_filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `global_search_filters` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `global_search_filters`
--

LOCK TABLES `global_search_filters` WRITE;
/*!40000 ALTER TABLE `global_search_filters` DISABLE KEYS */;
INSERT INTO `global_search_filters` VALUES (1,'ticket_assignee','Ticket Assignee','tickets','2025-01-03 04:07:30','2025-01-03 04:07:30'),(2,'ticket_creator','Ticket Requester','tickets','2025-01-03 04:07:30','2025-01-03 04:07:30'),(3,'ticket_body','Ticket Body','tickets','2025-01-03 04:07:30','2025-01-03 04:07:30'),(4,'ticket_department','Ticket Department','tickets','2025-01-03 04:07:30','2025-01-03 04:07:30'),(5,'ticket_priority','Ticket Priority','tickets','2025-01-03 04:07:30','2025-01-03 04:07:30'),(6,'ticket_status','Ticket Status','tickets','2025-01-03 04:07:30','2025-01-03 04:07:30'),(7,'ticket_custom_values','Ticket Custom Values','tickets','2025-01-03 04:07:30','2025-01-03 04:07:30'),(8,'article_categories','Article Categories','articles','2025-01-03 04:07:30','2025-01-03 04:07:30'),(9,'article_tag','Article Tags','articles','2025-01-03 04:07:30','2025-01-03 04:07:30'),(10,'article_description','Article description','articles','2025-01-03 04:07:30','2025-01-03 04:07:30'),(11,'user_custom_values','Contacts Custom Value','contacts','2025-01-03 04:07:30','2025-01-03 04:07:30');
/*!40000 ALTER TABLE `global_search_filters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `global_search_preferences`
--

DROP TABLE IF EXISTS `global_search_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `global_search_preferences` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `filter_id` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `global_search_preferences`
--

LOCK TABLES `global_search_preferences` WRITE;
/*!40000 ALTER TABLE `global_search_preferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `global_search_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `graphical_reports`
--

DROP TABLE IF EXISTS `graphical_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `graphical_reports` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `report_id` bigint(20) NOT NULL,
  `chart_name` varchar(255) NOT NULL,
  `categorized_by` varchar(255) NOT NULL,
  `selected_chart_type` varchar(30) DEFAULT NULL,
  `is_plugin` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graphical_reports`
--

LOCK TABLES `graphical_reports` WRITE;
/*!40000 ALTER TABLE `graphical_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `graphical_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_assign_department`
--

DROP TABLE IF EXISTS `group_assign_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group_assign_department` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(10) unsigned NOT NULL,
  `department_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  KEY `department_id` (`department_id`),
  CONSTRAINT `group_assign_department_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `group_assign_department_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_assign_department`
--

LOCK TABLES `group_assign_department` WRITE;
/*!40000 ALTER TABLE `group_assign_department` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_assign_department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `halts`
--

DROP TABLE IF EXISTS `halts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `halts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) NOT NULL,
  `halted_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `time_used` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `halted_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `halts`
--

LOCK TABLES `halts` WRITE;
/*!40000 ALTER TABLE `halts` DISABLE KEYS */;
/*!40000 ALTER TABLE `halts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `health_checks`
--

DROP TABLE IF EXISTS `health_checks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `health_checks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `check` varchar(255) NOT NULL,
  `is_os_compatibility` tinyint(4) NOT NULL DEFAULT 1,
  `alert` tinyint(4) NOT NULL DEFAULT 0,
  `api` varchar(255) NOT NULL DEFAULT 'default',
  `health_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `health_checks_health_id_foreign` (`health_id`),
  CONSTRAINT `health_checks_health_id_foreign` FOREIGN KEY (`health_id`) REFERENCES `healths` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_checks`
--

LOCK TABLES `health_checks` WRITE;
/*!40000 ALTER TABLE `health_checks` DISABLE KEYS */;
INSERT INTO `health_checks` VALUES (1,'db_check',1,0,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(2,'cron_check',1,1,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(3,'redis_check',0,1,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(4,'attachment_check',1,1,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(5,'supervisor_check',0,1,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(6,'php_version',1,0,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(7,'plugins_version',1,1,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(8,'cache_check',1,0,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(9,'disk_storage',1,1,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(10,'db_storage',1,0,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(11,'php_upload_size',1,0,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(12,'mysql_config',1,0,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(13,'billing_check',1,0,'billing',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(14,'email_config',1,0,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(15,'horizon_check',0,1,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(16,'horizon_restart',0,0,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(17,'database_optimize',1,0,'default',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(18,'search_driver_status',1,1,'billing',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(19,'re_captcha_check',1,1,'default',1,'2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `health_checks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `health_system_alerts`
--

DROP TABLE IF EXISTS `health_system_alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `health_system_alerts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `check_id` bigint(20) unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  `display` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `health_system_alerts_check_id_foreign` (`check_id`),
  CONSTRAINT `health_system_alerts_check_id_foreign` FOREIGN KEY (`check_id`) REFERENCES `health_checks` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_system_alerts`
--

LOCK TABLES `health_system_alerts` WRITE;
/*!40000 ALTER TABLE `health_system_alerts` DISABLE KEYS */;
INSERT INTO `health_system_alerts` VALUES (1,2,'120',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(2,3,'Critical',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(3,4,'Critical',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(4,5,'Critical',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(5,7,'Critical',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(6,9,'10',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(7,15,'Critical',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(8,18,'Critical',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(9,19,'Critical',1,'2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `health_system_alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `healths`
--

DROP TABLE IF EXISTS `healths`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `healths` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `healths`
--

LOCK TABLES `healths` WRITE;
/*!40000 ALTER TABLE `healths` DISABLE KEYS */;
INSERT INTO `healths` VALUES (1,'health_server_check','','2025-01-03 04:07:30','2025-01-03 04:07:30');
/*!40000 ALTER TABLE `healths` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `help_topic`
--

DROP TABLE IF EXISTS `help_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `help_topic` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `topic` varchar(255) NOT NULL,
  `parent_topic` varchar(255) NOT NULL,
  `custom_form` int(10) unsigned DEFAULT NULL,
  `department` int(10) unsigned DEFAULT NULL,
  `ticket_status` int(10) unsigned DEFAULT NULL,
  `thank_page` varchar(255) NOT NULL,
  `ticket_num_format` varchar(255) NOT NULL,
  `internal_notes` text NOT NULL,
  `status` tinyint(1) NOT NULL,
  `type` tinyint(1) NOT NULL,
  `auto_response` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `linked_departments` varchar(5000) DEFAULT NULL,
  `under_deletion` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `help_topic_ibfk_2` (`department`),
  CONSTRAINT `help_topic_ibfk_2` FOREIGN KEY (`department`) REFERENCES `department` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `help_topic`
--

LOCK TABLES `help_topic` WRITE;
/*!40000 ALTER TABLE `help_topic` DISABLE KEYS */;
INSERT INTO `help_topic` VALUES (1,'Support query','',NULL,1,NULL,'','','',1,1,0,'2025-01-03 04:07:23','2025-01-03 04:07:23',NULL,0),(2,'Sales query','',NULL,2,NULL,'','','',0,1,0,'2025-01-03 04:07:23','2025-01-03 04:07:23',NULL,0),(3,'Operational query','',NULL,3,NULL,'','','',0,1,0,'2025-01-03 04:07:23','2025-01-03 04:07:23',NULL,0);
/*!40000 ALTER TABLE `help_topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `help_topic_form_group`
--

DROP TABLE IF EXISTS `help_topic_form_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `help_topic_form_group` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `form_group_id` int(10) unsigned NOT NULL,
  `help_topic_id` int(10) unsigned NOT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `help_topic_form_group_form_group_id_foreign` (`form_group_id`),
  KEY `help_topic_form_group_help_topic_id_foreign` (`help_topic_id`),
  CONSTRAINT `help_topic_form_group_form_group_id_foreign` FOREIGN KEY (`form_group_id`) REFERENCES `form_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `help_topic_form_group_help_topic_id_foreign` FOREIGN KEY (`help_topic_id`) REFERENCES `help_topic` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `help_topic_form_group`
--

LOCK TABLES `help_topic_form_group` WRITE;
/*!40000 ALTER TABLE `help_topic_form_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `help_topic_form_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `helptopic_assign_type`
--

DROP TABLE IF EXISTS `helptopic_assign_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `helptopic_assign_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `helptopic_id` varchar(255) NOT NULL,
  `type_id` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `helptopic_assign_type`
--

LOCK TABLES `helptopic_assign_type` WRITE;
/*!40000 ALTER TABLE `helptopic_assign_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `helptopic_assign_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_progress`
--

DROP TABLE IF EXISTS `import_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `import_progress` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `is_complete` tinyint(4) NOT NULL DEFAULT 0,
  `total_number_of_records` bigint(20) NOT NULL DEFAULT 0,
  `import_name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `currently_processing_now` int(11) NOT NULL DEFAULT 0,
  `scheduled_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `started_at` timestamp NULL DEFAULT NULL,
  `ended_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_progress`
--

LOCK TABLES `import_progress` WRITE;
/*!40000 ALTER TABLE `import_progress` DISABLE KEYS */;
/*!40000 ALTER TABLE `import_progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_progress_details`
--

DROP TABLE IF EXISTS `import_progress_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `import_progress_details` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `import_progress_id` bigint(20) unsigned NOT NULL,
  `progress_type` varchar(255) NOT NULL,
  `progress_comment` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `import_progress_details_import_progress_id_foreign` (`import_progress_id`),
  CONSTRAINT `import_progress_details_import_progress_id_foreign` FOREIGN KEY (`import_progress_id`) REFERENCES `import_progress` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_progress_details`
--

LOCK TABLES `import_progress_details` WRITE;
/*!40000 ALTER TABLE `import_progress_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `import_progress_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imports`
--

DROP TABLE IF EXISTS `imports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imports` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `path` text NOT NULL,
  `columns` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imports`
--

LOCK TABLES `imports` WRITE;
/*!40000 ALTER TABLE `imports` DISABLE KEYS */;
/*!40000 ALTER TABLE `imports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `in_app_push_notifications`
--

DROP TABLE IF EXISTS `in_app_push_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `in_app_push_notifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subscribed_user_id` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `status` enum('pending','failed','delivered') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `in_app_push_notifications`
--

LOCK TABLES `in_app_push_notifications` WRITE;
/*!40000 ALTER TABLE `in_app_push_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `in_app_push_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inapp_notify`
--

DROP TABLE IF EXISTS `inapp_notify`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inapp_notify` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `user_id` int(10) unsigned DEFAULT NULL,
  `from` int(10) unsigned DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `action_link` text NOT NULL,
  `mobile_scenario_id` varchar(255) DEFAULT NULL,
  `notify_message` text NOT NULL,
  `module` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inapp_notify_user_id_foreign` (`user_id`),
  KEY `inapp_notify_from_foreign` (`from`),
  CONSTRAINT `inapp_notify_from_foreign` FOREIGN KEY (`from`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inapp_notify_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inapp_notify`
--

LOCK TABLES `inapp_notify` WRITE;
/*!40000 ALTER TABLE `inapp_notify` DISABLE KEYS */;
/*!40000 ALTER TABLE `inapp_notify` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned NOT NULL,
  `total_amount` int(11) NOT NULL,
  `tax` int(11) NOT NULL,
  `discount` int(11) NOT NULL,
  `payable_amount` int(11) NOT NULL,
  `amount_paid` int(11) NOT NULL,
  `payment_mode` varchar(100) DEFAULT NULL,
  `due_by` datetime DEFAULT NULL,
  `paid_date` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoices_order_id_foreign` (`order_id`),
  CONSTRAINT `invoices_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longblob NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_reserved_at_index` (`queue`,`reserved_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kb_article`
--

DROP TABLE IF EXISTS `kb_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kb_article` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `summary` text DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  `type` tinyint(1) NOT NULL,
  `publish_time` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `template` varchar(255) NOT NULL,
  `seo_title` varchar(255) NOT NULL,
  `meta_description` varchar(255) NOT NULL,
  `visible_to` varchar(255) NOT NULL DEFAULT 'all_users',
  `author` int(11) NOT NULL,
  `is_comment_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `organization_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kb_article_organization_id_foreign` (`organization_id`),
  FULLTEXT KEY `name_index` (`name`),
  FULLTEXT KEY `description_index` (`description`),
  FULLTEXT KEY `name_description_index` (`name`,`description`),
  FULLTEXT KEY `summary_index` (`summary`),
  FULLTEXT KEY `name_summary_description_index` (`name`,`summary`,`description`),
  CONSTRAINT `kb_article_organization_id_foreign` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_article`
--

LOCK TABLES `kb_article` WRITE;
/*!40000 ALTER TABLE `kb_article` DISABLE KEYS */;
/*!40000 ALTER TABLE `kb_article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kb_article_relationship`
--

DROP TABLE IF EXISTS `kb_article_relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kb_article_relationship` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int(10) unsigned NOT NULL,
  `category_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `article_relationship_article_id_foreign` (`article_id`),
  KEY `article_relationship_category_id_foreign` (`category_id`),
  CONSTRAINT `article_relationship_article_id_foreign` FOREIGN KEY (`article_id`) REFERENCES `kb_article` (`id`),
  CONSTRAINT `article_relationship_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `kb_category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_article_relationship`
--

LOCK TABLES `kb_article_relationship` WRITE;
/*!40000 ALTER TABLE `kb_article_relationship` DISABLE KEYS */;
/*!40000 ALTER TABLE `kb_article_relationship` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kb_article_tag`
--

DROP TABLE IF EXISTS `kb_article_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kb_article_tag` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_article_tag`
--

LOCK TABLES `kb_article_tag` WRITE;
/*!40000 ALTER TABLE `kb_article_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `kb_article_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kb_article_template`
--

DROP TABLE IF EXISTS `kb_article_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kb_article_template` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_article_template`
--

LOCK TABLES `kb_article_template` WRITE;
/*!40000 ALTER TABLE `kb_article_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `kb_article_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kb_category`
--

DROP TABLE IF EXISTS `kb_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kb_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `status` tinyint(1) NOT NULL,
  `parent` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `display_order` int(11) NOT NULL,
  `visible_to` varchar(255) NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `category_level` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `name_index` (`name`),
  FULLTEXT KEY `description_index` (`description`),
  FULLTEXT KEY `name_description_index` (`name`,`description`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_category`
--

LOCK TABLES `kb_category` WRITE;
/*!40000 ALTER TABLE `kb_category` DISABLE KEYS */;
INSERT INTO `kb_category` VALUES (1,'Uncategorized','Uncategorized','Uncategorized',1,0,'2025-01-03 04:07:28','2025-01-03 04:07:28',0,'',1,0);
/*!40000 ALTER TABLE `kb_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kb_comment`
--

DROP TABLE IF EXISTS `kb_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kb_comment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `website` varchar(255) NOT NULL,
  `comment` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `profile_pic` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `comment_article_id_foreign` (`article_id`),
  CONSTRAINT `comment_article_id_foreign` FOREIGN KEY (`article_id`) REFERENCES `kb_article` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_comment`
--

LOCK TABLES `kb_comment` WRITE;
/*!40000 ALTER TABLE `kb_comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `kb_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kb_pages`
--

DROP TABLE IF EXISTS `kb_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kb_pages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `visibility` tinyint(1) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `seo_title` varchar(255) NOT NULL,
  `meta_description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_pages`
--

LOCK TABLES `kb_pages` WRITE;
/*!40000 ALTER TABLE `kb_pages` DISABLE KEYS */;
/*!40000 ALTER TABLE `kb_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kb_settings`
--

DROP TABLE IF EXISTS `kb_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kb_settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pagination` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `status` int(11) NOT NULL,
  `date_format` varchar(255) NOT NULL DEFAULT 'MMMM Do YYYY, h:mm:ss a',
  `is_comment_enabled` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_settings`
--

LOCK TABLES `kb_settings` WRITE;
/*!40000 ALTER TABLE `kb_settings` DISABLE KEYS */;
INSERT INTO `kb_settings` VALUES (1,10,'2025-01-03 04:07:23','2025-01-03 04:07:23',1,'MMMM Do YYYY, h:mm:ss a',0);
/*!40000 ALTER TABLE `kb_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kb_track_popular_articles`
--

DROP TABLE IF EXISTS `kb_track_popular_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kb_track_popular_articles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `visitor_ip_address` varchar(50) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `visits` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_track_popular_articles`
--

LOCK TABLES `kb_track_popular_articles` WRITE;
/*!40000 ALTER TABLE `kb_track_popular_articles` DISABLE KEYS */;
/*!40000 ALTER TABLE `kb_track_popular_articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `labels`
--

DROP TABLE IF EXISTS `labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `labels` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `color` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `order` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `visible_to` varchar(100) DEFAULT 'agents',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `labels`
--

LOCK TABLES `labels` WRITE;
/*!40000 ALTER TABLE `labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `languages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `locale` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `languages`
--

LOCK TABLES `languages` WRITE;
/*!40000 ALTER TABLE `languages` DISABLE KEYS */;
INSERT INTO `languages` VALUES (1,'English','en'),(2,'Italian','it'),(3,'German','de'),(4,'French','fr'),(5,'Brazilian Portuguese','pt_BR'),(6,'Dutch','nl'),(7,'Spanish','es'),(8,'Norwegian','nb_NO'),(9,'Danish','da');
/*!40000 ALTER TABLE `languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `linked_attachments`
--

DROP TABLE IF EXISTS `linked_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `linked_attachments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `attachment_id` int(10) unsigned NOT NULL,
  `category_id` int(11) NOT NULL,
  `category_type` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `linked_attachments_attachment_id_foreign` (`attachment_id`),
  CONSTRAINT `linked_attachments_attachment_id_foreign` FOREIGN KEY (`attachment_id`) REFERENCES `attachments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `linked_attachments`
--

LOCK TABLES `linked_attachments` WRITE;
/*!40000 ALTER TABLE `linked_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `linked_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listener_actions`
--

DROP TABLE IF EXISTS `listener_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listener_actions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `listener_id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `meta` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `custom_action` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listener_actions`
--

LOCK TABLES `listener_actions` WRITE;
/*!40000 ALTER TABLE `listener_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `listener_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listener_events`
--

DROP TABLE IF EXISTS `listener_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listener_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `listener_id` int(11) NOT NULL,
  `event` varchar(255) NOT NULL,
  `condition` varchar(255) NOT NULL,
  `old` varchar(255) DEFAULT NULL,
  `new` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listener_events`
--

LOCK TABLES `listener_events` WRITE;
/*!40000 ALTER TABLE `listener_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `listener_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listener_rules`
--

DROP TABLE IF EXISTS `listener_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listener_rules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `listener_id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `condition` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `custom_rule` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listener_rules`
--

LOCK TABLES `listener_rules` WRITE;
/*!40000 ALTER TABLE `listener_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `listener_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listeners`
--

DROP TABLE IF EXISTS `listeners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listeners` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `performed_by` varchar(255) NOT NULL,
  `order` int(11) NOT NULL,
  `rule_match` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listeners`
--

LOCK TABLES `listeners` WRITE;
/*!40000 ALTER TABLE `listeners` DISABLE KEYS */;
/*!40000 ALTER TABLE `listeners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `phone_country_code` varchar(7) DEFAULT NULL,
  `phone_iso` varchar(4) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `country_id` int(10) unsigned DEFAULT NULL,
  `state_id` bigint(20) unsigned DEFAULT NULL,
  `pin_code` text DEFAULT NULL,
  `city` text DEFAULT NULL,
  `status` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_default` int(11) NOT NULL,
  `under_deletion` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `location_country_id_foreign` (`country_id`),
  KEY `location_state_id_foreign` (`state_id`),
  CONSTRAINT `location_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `country_code` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `location_state_id_foreign` FOREIGN KEY (`state_id`) REFERENCES `states` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES (1,'Bangalore',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2025-01-03 04:07:23','2025-01-03 04:07:23',0,0),(2,'Delhi',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2025-01-03 04:07:23','2025-01-03 04:07:23',0,0),(3,'Kolkata',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2025-01-03 04:07:23','2025-01-03 04:07:23',0,0);
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_categories`
--

DROP TABLE IF EXISTS `log_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_categories`
--

LOCK TABLES `log_categories` WRITE;
/*!40000 ALTER TABLE `log_categories` DISABLE KEYS */;
INSERT INTO `log_categories` VALUES (1,'ticket-create'),(2,'ticket-reply'),(3,'ticket-update'),(4,'ticket-escalate'),(5,'user-create'),(6,'user-update'),(7,'mail-fetch'),(8,'report'),(9,'rating'),(10,'default'),(11,'mail-send'),(12,'user-deactivation'),(13,'Saml-login'),(14,'SD-Integrations'),(15,'report-scheduling'),(16,'webhook'),(17,'search');
/*!40000 ALTER TABLE `log_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_attempt_handler`
--

DROP TABLE IF EXISTS `login_attempt_handler`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login_attempt_handler` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `attempts` int(11) NOT NULL,
  `timings` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_attempt_handler`
--

LOCK TABLES `login_attempt_handler` WRITE;
/*!40000 ALTER TABLE `login_attempt_handler` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_attempt_handler` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_attempts`
--

DROP TABLE IF EXISTS `login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login_attempts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `User` varchar(255) NOT NULL,
  `IP` varchar(255) NOT NULL,
  `Attempts` varchar(255) NOT NULL,
  `LastLogin` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_attempts`
--

LOCK TABLES `login_attempts` WRITE;
/*!40000 ALTER TABLE `login_attempts` DISABLE KEYS */;
INSERT INTO `login_attempts` VALUES (1,'','','','0000-00-00 00:00:00','2025-01-03 04:07:23','2025-01-03 04:07:23');
/*!40000 ALTER TABLE `login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail_logs`
--

DROP TABLE IF EXISTS `mail_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `log_category_id` int(10) unsigned NOT NULL,
  `referee_id` varchar(255) NOT NULL,
  `referee_type` varchar(255) NOT NULL,
  `sender_mail` varchar(255) NOT NULL,
  `reciever_mail` varchar(255) NOT NULL,
  `subject` tinyblob NOT NULL,
  `body` longblob DEFAULT NULL,
  `source` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `status` varchar(30) DEFAULT NULL,
  `collaborators` varchar(255) DEFAULT NULL,
  `exception_log_id` bigint(20) DEFAULT NULL,
  `job_payload` longblob DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mail_logs_created_at_index` (`created_at`),
  KEY `mail_logs_updated_at_index` (`updated_at`),
  KEY `log_category_id` (`log_category_id`),
  KEY `status` (`status`),
  KEY `mail_logs_sender_mail_index` (`sender_mail`),
  KEY `mail_logs_reciever_mail_index` (`reciever_mail`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_logs`
--

LOCK TABLES `mail_logs` WRITE;
/*!40000 ALTER TABLE `mail_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `mail_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail_services`
--

DROP TABLE IF EXISTS `mail_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_services` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `short_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_services`
--

LOCK TABLES `mail_services` WRITE;
/*!40000 ALTER TABLE `mail_services` DISABLE KEYS */;
INSERT INTO `mail_services` VALUES (1,'SMTP','smtp','2025-01-03 04:07:23','2025-01-03 04:07:23'),(2,'Php Mail','mail','2025-01-03 04:07:23','2025-01-03 04:07:23'),(3,'Send Mail','sendmail','2025-01-03 04:07:23','2025-01-03 04:07:23'),(4,'Mailgun','mailgun','2025-01-03 04:07:23','2025-01-03 04:07:23'),(5,'Mandrill','mandrill','2025-01-03 04:07:23','2025-01-03 04:07:23'),(6,'Log file','log','2025-01-03 04:07:23','2025-01-03 04:07:23'),(7,'Mailrelay','mailrelay','2025-01-03 04:07:23','2025-01-03 04:07:23');
/*!40000 ALTER TABLE `mail_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mailbox_protocol`
--

DROP TABLE IF EXISTS `mailbox_protocol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mailbox_protocol` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `value` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mailbox_protocol`
--

LOCK TABLES `mailbox_protocol` WRITE;
/*!40000 ALTER TABLE `mailbox_protocol` DISABLE KEYS */;
INSERT INTO `mailbox_protocol` VALUES (1,'IMAP','/imap'),(2,'IMAP+SSL','/imap/ssl'),(3,'IMAP+TLS','/imap/tls'),(4,'IMAP+SSL/No-validate','/imap/ssl/novalidate-cert');
/*!40000 ALTER TABLE `mailbox_protocol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrate_custom_fields`
--

DROP TABLE IF EXISTS `migrate_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrate_custom_fields` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `form_field_id` int(10) unsigned NOT NULL,
  `new_form_field_id` bigint(20) unsigned NOT NULL,
  `activity_logs_replace` tinyint(4) NOT NULL DEFAULT 0,
  `form_id` varchar(255) DEFAULT NULL,
  `group` varchar(255) DEFAULT NULL,
  `group_id` varchar(255) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `migrate_custom_fields_form_field_id_foreign` (`form_field_id`),
  CONSTRAINT `migrate_custom_fields_form_field_id_foreign` FOREIGN KEY (`form_field_id`) REFERENCES `form_fields` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrate_custom_fields`
--

LOCK TABLES `migrate_custom_fields` WRITE;
/*!40000 ALTER TABLE `migrate_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `migrate_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=615 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2016_02_16_140450_create_banlist_table',1),(2,'2016_02_16_140450_create_canned_response_table',1),(3,'2016_02_16_140450_create_custom_form_fields_table',1),(4,'2016_02_16_140450_create_custom_forms_table',1),(5,'2016_02_16_140450_create_date_format_table',1),(6,'2016_02_16_140450_create_date_time_format_table',1),(7,'2016_02_16_140450_create_department_table',1),(8,'2016_02_16_140450_create_emails_table',1),(9,'2016_02_16_140450_create_group_assign_department_table',1),(10,'2016_02_16_140450_create_groups_table',1),(11,'2016_02_16_140450_create_help_topic_table',1),(12,'2016_02_16_140450_create_kb_article_relationship_table',1),(13,'2016_02_16_140450_create_kb_article_table',1),(14,'2016_02_16_140450_create_kb_category_table',1),(15,'2016_02_16_140450_create_kb_comment_table',1),(16,'2016_02_16_140450_create_kb_pages_table',1),(17,'2016_02_16_140450_create_kb_settings_table',1),(18,'2016_02_16_140450_create_languages_table',1),(19,'2016_02_16_140450_create_log_notification_table',1),(20,'2016_02_16_140450_create_mailbox_protocol_table',1),(21,'2016_02_16_140450_create_organization_table',1),(22,'2016_02_16_140450_create_password_resets_table',1),(23,'2016_02_16_140450_create_plugins_table',1),(24,'2016_02_16_140450_create_settings_auto_response_table',1),(25,'2016_02_16_140450_create_settings_company_table',1),(26,'2016_02_16_140450_create_settings_email_table',1),(27,'2016_02_16_140450_create_settings_ratings_table',1),(28,'2016_02_16_140450_create_settings_system_table',1),(29,'2016_02_16_140450_create_settings_ticket_table',1),(30,'2016_02_16_140450_create_sla_plan_table',1),(31,'2016_02_16_140450_create_team_assign_agent_table',1),(32,'2016_02_16_140450_create_teams_table',1),(33,'2016_02_16_140450_create_template_table',1),(34,'2016_02_16_140450_create_ticket_attachment_table',1),(35,'2016_02_16_140450_create_ticket_collaborator_table',1),(36,'2016_02_16_140450_create_ticket_form_data_table',1),(37,'2016_02_16_140450_create_ticket_priority_table',1),(38,'2016_02_16_140450_create_ticket_source_table',1),(39,'2016_02_16_140450_create_ticket_status_table',1),(40,'2016_02_16_140450_create_ticket_thread_table',1),(41,'2016_02_16_140450_create_tickets_table',1),(42,'2016_02_16_140450_create_time_format_table',1),(43,'2016_02_16_140450_create_timezone_table',1),(44,'2016_02_16_140450_create_user_assign_organization_table',1),(45,'2016_02_16_140450_create_users_table',1),(46,'2016_02_16_140450_create_version_check_table',1),(47,'2016_02_16_140450_create_widgets_table',1),(48,'2016_02_16_140454_add_foreign_keys_to_canned_response_table',1),(49,'2016_02_16_140454_add_foreign_keys_to_department_table',1),(50,'2016_02_16_140454_add_foreign_keys_to_emails_table',1),(51,'2016_02_16_140454_add_foreign_keys_to_group_assign_department_table',1),(52,'2016_02_16_140454_add_foreign_keys_to_help_topic_table',1),(53,'2016_02_16_140454_add_foreign_keys_to_kb_article_relationship_table',1),(54,'2016_02_16_140454_add_foreign_keys_to_kb_comment_table',1),(55,'2016_02_16_140454_add_foreign_keys_to_organization_table',1),(56,'2016_02_16_140454_add_foreign_keys_to_settings_system_table',1),(57,'2016_02_16_140454_add_foreign_keys_to_team_assign_agent_table',1),(58,'2016_02_16_140454_add_foreign_keys_to_teams_table',1),(59,'2016_02_16_140454_add_foreign_keys_to_ticket_attachment_table',1),(60,'2016_02_16_140454_add_foreign_keys_to_ticket_collaborator_table',1),(61,'2016_02_16_140454_add_foreign_keys_to_ticket_form_data_table',1),(62,'2016_02_16_140454_add_foreign_keys_to_ticket_thread_table',1),(63,'2016_02_16_140454_add_foreign_keys_to_tickets_table',1),(64,'2016_02_16_140454_add_foreign_keys_to_user_assign_organization_table',1),(65,'2016_02_16_140454_add_foreign_keys_to_users_table',1),(66,'2016_03_31_061239_create_notifications_table',1),(67,'2016_03_31_061534_create_notification_types_table',1),(68,'2016_03_31_061740_create_user_notification_table',1),(69,'2016_04_18_115852_create_workflow_name_table',1),(70,'2016_04_18_115900_create_workflow_rule_table',1),(71,'2016_04_18_115908_create_workflow_action_table',1),(72,'2016_05_10_102423_create_country_code_table',1),(73,'2016_05_10_102604_create_bar_notifications_table',1),(74,'2016_05_11_105244_create_api_settings_table',1),(75,'2016_05_19_055008_create_workflow_close_table',1),(76,'2016_06_01_000001_create_oauth_auth_codes_table',1),(77,'2016_06_01_000002_create_oauth_access_tokens_table',1),(78,'2016_06_01_000003_create_oauth_refresh_tokens_table',1),(79,'2016_06_01_000004_create_oauth_clients_table',1),(80,'2016_06_01_000005_create_oauth_personal_access_clients_table',1),(81,'2016_06_02_072210_create_common_settings_table',1),(82,'2016_06_02_074913_create_login_attempts_table',1),(83,'2016_06_02_080005_create_ratings_table',1),(84,'2016_06_02_081020_create_rating_ref_table',1),(85,'2016_06_02_090225_create_settings_security_table',1),(86,'2016_06_02_094420_create_template_types_table',1),(87,'2016_06_02_095357_create_ticket_token_table',1),(88,'2016_06_28_141613_version1079table',1),(89,'2016_07_02_051247_create_jobs_table',1),(90,'2016_07_02_051439_create_failed_jobs_table',1),(91,'2016_07_19_071910_create_field_values_table',1),(92,'2016_07_26_084458_create_faveo_mails_table',1),(93,'2016_07_26_090201_create_faveo_queues_table',1),(94,'2016_07_26_094753_create_mail_services_table',1),(95,'2016_07_26_095020_create_queue_services_table',1),(96,'2016_07_29_113012_create_conditions_table',1),(97,'2016_08_08_095744_create_social_media_table',1),(98,'2016_08_12_104410_create_user_additional_infos_table',1),(99,'2016_08_16_104539_alter_ticket_source_table',1),(100,'2016_09_05_140010_create_status_type_table',1),(101,'2016_09_05_140016_alter_status_table',1),(102,'2016_09_07_125906_business_hours_table',1),(103,'2016_09_07_130846_business_schedule_table',1),(104,'2016_09_07_130925_business_schedule_open_custom_time_table',1),(105,'2016_09_07_131000_business_holiday_table',1),(106,'2016_10_07_173423_create_ticket_type_table',1),(107,'2016_10_10_104534_create_labels_table',1),(108,'2016_10_10_113555_create_sla_targets_table',1),(109,'2016_10_10_124120_create_filters_table',1),(110,'2016_10_12_072502_create_tags_table',1),(111,'2016_10_18_085435_create_bills_table',1),(112,'2016_11_07_123810_create_halts_table',1),(113,'2016_12_13_073613_create_department_assign_agents_table',1),(114,'2017_02_02_073016_update_ticket_thread',1),(115,'2017_02_07_104802_update_notification_table',1),(116,'2017_02_09_093019_create_system_portal_table',1),(117,'2017_02_11_072240_create_sla_violated_escalatetable',1),(118,'2017_02_11_074259_create_sla_approach_escalatetable',1),(119,'2017_02_22_075706_update_users_table_22_1_2017',1),(120,'2017_02_23_044150_report_updates',1),(121,'2017_02_25_072334_DepartmentCannedResponse',1),(122,'2017_03_06_074629_notification_update',1),(123,'2017_03_07_073611_alter_tickets_table',1),(124,'2017_03_07_121632_updated_halts',1),(125,'2017_03_10_044621_update_settings_system',1),(126,'2017_03_24_095825_update_job',1),(127,'2017_04_03_063230_update_business_hours',1),(128,'2017_04_03_090919_create_no_assign_escalates_table',1),(129,'2017_04_30_151807_create_update_organization',1),(130,'2017_04_30_192424_create_update_groups',1),(131,'2017_05_05_082718_update_custom_form',1),(132,'2017_05_25_062940_update_ticket_status',1),(133,'2017_06_15_115324_create_email_threads_table',1),(134,'2017_06_16_113453_permision_update',1),(135,'2017_07_04_200732_AlterUserTableForAccountVerification',1),(136,'2017_07_20_115612_create_requireds_table',1),(137,'2017_07_24_102940_update_email_threads',1),(138,'2017_08_01_101844_create_extra_orgs_table',1),(139,'2017_08_07_130239_update_department',1),(140,'2017_08_08_072909_create_agent_type_relations_table',1),(141,'2017_08_12_063307_create_location_table',1),(142,'2017_08_14_054817_add_paid_to_kb_category',1),(143,'2017_08_14_073909_add_location_to_users',1),(144,'2017_08_17_115427_add_apply_sla_helptopic_to_sla_plan',1),(145,'2017_08_18_065645_add_domain_to_organization',1),(146,'2017_08_23_072141_add_apply_sla_orgdepts_to_sla_plan',1),(147,'2017_08_26_090230_create_organization_dept_table',1),(148,'2017_08_28_065405_add_department_to_user_assign_organization',1),(149,'2017_09_02_033151_bill_type_table',1),(150,'2017_09_07_110839_add_nodes_to_departments_table',1),(151,'2017_09_07_110924_add_nodes_to_helptopic_table',1),(152,'2017_09_12_104144_add_descriptin_to_ticket_source',1),(153,'2017_09_13_114806_create_recurs_table',1),(154,'2017_09_13_114826_create_recure_contents_table',1),(155,'2017_09_14_064053_add_location_to_ticket_source',1),(156,'2017_09_14_064205_add_apply_sla_labels_to_sla_plan',1),(157,'2017_09_14_092331_create_kb_article_template_table',1),(158,'2017_09_14_131434_add_template_to_kb_article',1),(159,'2017_09_19_083527_add_sco_to_kb_pages',1),(160,'2017_09_21_063508_alter_social_media_table',1),(161,'2017_09_26_052319_add_linked_departments_in_help_topic',1),(162,'2017_09_29_075059_add_sco_to_kb_article',1),(163,'2017_09_30_100735_add_status_to_kb_settings',1),(164,'2017_10_03_063738_add_serial_key_and_order_number_in_system_setting',1),(165,'2017_10_31_073326_add_is_default_to_location',1),(166,'2017_11_11_081711_create_listeners_table',1),(167,'2017_11_11_081739_create_listener_events_table',1),(168,'2017_11_11_081751_create_listener_rules_table',1),(169,'2017_11_11_081806_create_listener_actions_table',1),(170,'2017_11_23_105805_add_logo_to_organization',1),(171,'2017_12_05_055135_create_team_assign_department_table',1),(172,'2017_12_06_055652_add_order_to_sla_plan',1),(173,'2017_12_06_074424_add_in_app_to_sla_target',1),(174,'2017_12_09_111807_alter_listener_actions',1),(175,'2017_12_09_111905_alter_listener_rules',1),(176,'2017_12_14_093039_add_custom_rule',1),(177,'2017_12_14_093106_add_custom_action',1),(178,'2017_12_29_092541_add_is_default_to_sla_plan',1),(179,'2018_01_02_093934_create_department_assign_manager_table',1),(180,'2018_01_02_172636_create_helptopic_assign_type_table',1),(181,'2018_01_11_072745_rename_kb_article_column',1),(182,'2018_01_11_074226_rename_kb_pages_column',1),(183,'2018_01_15_121625_create_subscribed_users_table',1),(184,'2018_01_15_121833_create_in_app_push_notifications_table',1),(185,'2018_01_26_055048_alter_labels_table',1),(186,'2018_02_16_060521_add_match_rule_column_in_workflow_table',1),(187,'2018_04_06_074050_create_ticket_status_override_table',1),(188,'2018_04_17_083239_add_visible_to_to_kb_article',1),(189,'2018_04_17_185700_alter_user_assign_organization_table',1),(190,'2018_04_24_110724_add_profile_pic_to_kb_comment',1),(191,'2018_04_27_041305_add_datetime_to_kb_settings',1),(192,'2018_04_28_130536_alter_custom_rule_column_make_nullable_in_workflow_rules',1),(193,'2018_04_28_130615_alter_custom_rule_column_make_nullable_in_listener_rules',1),(194,'2018_04_28_130734_alter_custom_rule_column_make_nullable_in_worflow_action',1),(195,'2018_04_28_130820_alter_custom_rule_column_make_nullable_in_listener_action',1),(196,'2018_05_01_051004_add_org_dept_manager_to_organization_dept',1),(197,'2018_05_01_170751_add_service_columns_to_emails',1),(198,'2018_05_28_114843_add_en_auto_assign_column_in_department_table',1),(199,'2018_06_04_071810_alter_emails_table',1),(200,'2018_06_08_070241_add_example_to_country_code',1),(201,'2018_07_01_131928_create_sla_custom_enforcements_fields',1),(202,'2018_07_09_102925_create_reports_table',1),(203,'2018_07_27_070308_create_activity_logs_table',1),(204,'2018_07_30_014930_add_new_inbox_settings_to_settings_ticket',1),(205,'2018_08_16_004121_create_form_categories_table',1),(206,'2018_08_16_115347_create_form_fields_table',1),(207,'2018_08_16_115357_create_form_field_labels_table',1),(208,'2018_08_16_115414_create_form_field_options_table',1),(209,'2018_08_16_124448_create_custom_form_value_table',1),(210,'2018_08_17_095204_alter_status_data_type_common_settings',1),(211,'2018_08_20_083143_add_custom_to_custom_form_value',1),(212,'2018_08_28_054723_create_ticket_rules_table',1),(213,'2018_08_28_054744_create_ticket_actions_table',1),(214,'2018_08_28_054756_create_ticket_workflows_table',1),(215,'2018_08_28_054806_create_ticket_listeners_table',1),(216,'2018_09_03_054808_create_ticket_filters_table',1),(217,'2018_09_03_113219_create_ticket_filter_metas_table',1),(218,'2018_09_03_115529_create_ticket_filter_shareables_table',1),(219,'2018_09_11_114447_add_base_rule_to_ticket_rule',1),(220,'2018_09_20_071459_create_approval_workflows_table',1),(221,'2018_09_20_072143_create_approval_levels_table',1),(222,'2018_09_20_073404_create_approval_level_approvers_table',1),(223,'2018_09_25_045654_add_internal_notes_to_ticket_workflows_table',1),(224,'2018_09_25_050116_add_internal_notes_to_ticket_listeners_table',1),(225,'2018_09_25_055020_add_category_to_ticket_rules_table',1),(226,'2018_09_25_060515_create_ticket_events_table',1),(227,'2018_10_05_064321_create_ticket_action_emails_table',1),(228,'2018_10_09_021450_create_approval_workflow_tickets_table',1),(229,'2018_10_09_021533_create_approval_level_statuses_table',1),(230,'2018_10_09_021548_create_approver_statuses_table',1),(231,'2018_10_09_110747_create_user_types_table',1),(232,'2018_10_10_121039_create_ticket_action_email_user_table',1),(233,'2018_10_16_084837_add_new_columns_to_conditions_table',1),(234,'2018_10_18_005529_add_comment_to_approver_statuses_table',1),(235,'2018_10_19_132628_add_status_columns_to_approval_workflows_table',1),(236,'2018_10_20_080140_create_log_categories_table',1),(237,'2018_10_22_080426_create_cron_logs_table',1),(238,'2018_10_22_080439_create_mail_logs_table',1),(239,'2018_10_22_080454_create_exception_logs_table',1),(240,'2018_10_24_025346_add_status_columns_to_approval_workflow_tickets_table',1),(241,'2018_10_25_113734_alter_tickets_table_add_column_last_estd_duedate',1),(242,'2018_10_31_090326_add_is_edit_visible_to_form_fields_table',1),(243,'2018_10_31_123651_alter_table_reports',1),(244,'2018_11_04_005537_add_category_type_to_form_fields_table',1),(245,'2018_11_15_060602_add_is_active_to_form_fields_table',1),(246,'2018_11_21_115351_add_rating_icon_in_ratings_table',1),(247,'2018_11_26_062439_create_attachments_table',1),(248,'2018_11_26_062543_create_linked_attachments_table',1),(249,'2018_11_27_110014_alter_user_table_phone_number',1),(250,'2018_11_27_122807_add_version_to_plugins_table',1),(251,'2018_12_01_045248_add_is_locked_to_form_fields_table',1),(252,'2018_12_06_073045_alter_id_column_in_workflow_close_table',1),(253,'2018_12_06_084441_add_autoclose_column_in_ticket_status_table',1),(254,'2018_12_07_044150_add_refrence_to_ticket_status_in_workflow_close_table',1),(255,'2018_12_12_061507_add_waiting_time_to_settings_ticket',1),(256,'2019_01_03_025455_alter_mail_logs_body_column',1),(257,'2019_01_09_061632_alter_exception_logs_trace_column',1),(258,'2019_01_11_164353_add_status_to_mail_logs_table',1),(259,'2019_01_11_164622_alter_message_in_exception_logs_table',1),(260,'2019_02_07_120304_create_packages_table',1),(261,'2019_02_09_073630_create_orders_table',1),(262,'2019_02_09_073650_create_user_order_tickets_table',1),(263,'2019_02_11_054748_create_invoices_table',1),(264,'2019_02_11_054800_create_transactions_table',1),(265,'2019_02_11_085033_create_payment_gateways_table',1),(266,'2019_02_15_054920_alter_organization_table_phone_and_address_nullable',1),(267,'2019_02_15_122816_add_location_id_tickets',1),(268,'2019_02_18_122817_alter_user_table_location',1),(269,'2019_02_25_050942_create_table_package_department_link',1),(270,'2019_03_13_090117_add_plugin_name_column_in_template_types',1),(271,'2019_03_14_064450_alter_added_comment_column_to_ticket_status_table',1),(272,'2019_03_19_091103_alter_emails_table_password_column',1),(273,'2019_03_22_053546_add_creator_id_to_tickets_table',1),(274,'2019_03_25_084647_alter_user_types_table_add_column_key',1),(275,'2019_04_01_051423_add_unique_column_to_form_fields_table',1),(276,'2019_04_01_110137_alter_organization_table_internal_notes_column',1),(277,'2019_04_01_133305_add_ticket_status_id_in_approval_workflow_tickets_table',1),(278,'2019_04_11_114608_add_type_user_id_name_and_execution_time_columns_in_recurs_table',1),(279,'2019_05_22_100319_add_value_meta_in_ticket_filter_meta_table',1),(280,'2019_05_29_044747_add_sort_order_to_form_field_options_table',1),(281,'2019_06_05_053332_create_form_groups_table',1),(282,'2019_06_05_053941_add_form_group_id_to_form_fields_table',1),(283,'2019_06_08_054155_create_help_topic_form_group_table',1),(284,'2019_06_08_054208_create_department_form_group_table',1),(285,'2019_06_08_073528_create_form_category_form_group_table',1),(286,'2019_06_08_093008_create_form_field_option_form_group_table',1),(287,'2019_06_12_124848_add_is_deletable_and_is_customizable_column_to_form_fields',1),(288,'2019_06_27_094804_add_is_filterable_column_to_form_fields_table',1),(289,'2019_07_04_084652_alter_kb_article_to_full_text_mode',1),(290,'2019_07_18_120113_remove_gender_column_from_users_table',1),(291,'2019_07_20_080933_update_username_in_users_table',1),(292,'2019_07_29_094015_add_type_column_in_approval_workflows_table',1),(293,'2019_08_06_050305_add_version_column_to_emails_table',1),(294,'2019_08_26_052209_alter_tickets_table_add_response_due_by_column',1),(295,'2019_08_27_064104_create_report_columns_table',1),(296,'2019_09_13_122615_rename_client_input_fild_color_in_system_portal_table',1),(297,'2019_09_13_124545_update_system_portal_table',1),(298,'2019_09_16_100817_alter_users_table_country_code',1),(299,'2019_09_16_121824_alter_ticket_action_emails_table_change_body_column_type',1),(300,'2019_09_30_104727_add_order_and_type_column_to_report_columns_table',1),(301,'2019_10_03_064517_create_backups_table',1),(302,'2019_10_11_055402_create_kb_article_tag_table',1),(303,'2019_10_22_072621_create_user_notification_tokens_table',1),(304,'2019_10_30_113947_create_backup_paths_table',1),(305,'2019_11_21_050957_add_is_manual_duedate_column_to_tickets_table',1),(306,'2019_11_30_034329_add_average_response_time_column_to_tickets_table',1),(307,'2019_12_05_070913_create_ticket_sla_approach_escalate_table',1),(308,'2019_12_05_070935_create_ticket_sla_violated_escalate_table',1),(309,'2019_12_08_235206_create_ticket_slas_table',1),(310,'2019_12_12_055103_add_resolution_due_by_column_to_tickets_table',1),(311,'2019_12_13_092111_add_google2fa_column_to_users',1),(312,'2019_12_19_073025_alter_ticket_thread_table_response_time_column',1),(313,'2019_12_19_073431_alter_tickets_table_resolution_time_column',1),(314,'2020_01_06_065804_create_ticket_sla_metas_table',1),(315,'2020_01_07_065754_add_agent_and_user_config_columns_to_form_fields_table',1),(316,'2020_01_08_030920_add_timestamp_format_to_report_columns_table',1),(317,'2020_01_09_051229_rename_reports_table_to_report_downloads_table',1),(318,'2020_01_09_052730_create_reports_table_new',1),(319,'2020_01_09_060829_add_parent_columns_to_ticket_filters_table',1),(320,'2020_01_13_075456_create_sub_reports_table',1),(321,'2020_01_13_115221_add_sub_report_id_column_to_report_columns_table',1),(322,'2020_01_16_000316_add_report_id_to_report_downloads_table',1),(323,'2020_01_17_081400_alter_tickets_table_to_make_sla_related_columns_nullable',1),(324,'2020_01_18_015838_add_collaborators_to_mail_logs_table',1),(325,'2020_01_19_143402_add_description_column_to_form_field_labels_table',1),(326,'2020_01_28_063634_add_name_column_in_form_categories_table',1),(327,'2020_01_29_021539_create_user_todos_table',1),(328,'2020_02_03_073331_rename_activity_logs_table_to_ticket_activity_logs_table',1),(329,'2020_02_03_074020_alter_ticket_activity_logs_table',1),(330,'2020_02_15_163835_alter_ticket_thread_table',1),(331,'2020_02_21_090110_add_content_id_column_to_ticket_attachment_table',1),(332,'2020_02_24_033238_add_display_on_dashboard_column_to_ticket_filters_table',1),(333,'2020_02_28_065418_alter_ticket_source_table_to_add_default_column',1),(334,'2020_03_02_073028_add_last_login_at_column_in_users_table',1),(335,'2020_03_03_085650_add_status_to_cron_logs_table',1),(336,'2020_03_07_070008_add_exception_log_id_to_mail_logs_table',1),(337,'2020_03_12_112529_add_parent_id_in_tickets_table',1),(338,'2020_03_30_040512_alter_widgets_table_add_type_column',1),(339,'2020_04_02_050957_add_type_column_to_form_groups_table',1),(340,'2020_04_20_113721_add_available_for_fetch_and_last_fetched_at_columns_to_emails_table',1),(341,'2020_04_24_235942_add_indexes_to_tickets_table',1),(342,'2020_04_30_000523_add_icon_columns_to_ticket_filters_table',1),(343,'2020_05_07_095946_create_websockets_statistics_entries_table',1),(344,'2020_05_11_053415_alter_user_table_correct_various_columns_datatype',1),(345,'2020_05_15_025828_optimize_custom_form_value_table',1),(346,'2020_05_20_123349_add_date_time_format_columns_to_settings_system_table',1),(347,'2020_06_18_092739_add_import_identifier_to_users_table',1),(348,'2020_07_01_065026_rename_mobile_otp_verify_column',1),(349,'2020_07_13_125916_add_ticket_number_prefix_column_to_settings_ticket_table',1),(350,'2020_07_16_053351_create_imports_table',1),(351,'2020_08_03_071544_create_third_party_apps_table',1),(352,'2020_08_03_101537_rename_api_enpoint_in_form_fields_table',1),(353,'2020_08_19_053352_alter_labels_table_status_column_type_to_boolean',1),(354,'2020_08_25_053351_alter_ticket_priority_table_status_and_is_default_column_type_to_boolean',1),(355,'2020_08_26_123603_alter_ticket_workflows_table_to_make_internal_note_column_text_from_varchar',1),(356,'2020_09_03_061519_alter_users_table_drop_token_columns',1),(357,'2020_09_08_122217_alter_user_table_add_delete_account_requested_and_processing_account_disabling_column',1),(358,'2020_09_25_121639_create_file_manager_acl_rules_table',1),(359,'2020_09_29_105425_create_file_manager_acl_rules_departments',1),(360,'2020_09_30_073618_create_user_import_maps_table',1),(361,'2020_10_07_103120_alter_file_manager_acl_rules_table_to_add_type',1),(362,'2020_10_08_015815_alter_file_manager_acl_rules_table_to_add_extension_size_timestamp',1),(363,'2020_10_12_080822_alter_team_lead_column_to_team_lead_id_in_teams_table',1),(364,'2020_10_15_103645_create_user_permissions_table',1),(365,'2020_10_15_104236_create_user_permission_table',1),(366,'2020_10_19_065650_alter_settings_ticket_table_to_add_show_user_location_column',1),(367,'2020_10_19_111658_alter_ticket_events_table',1),(368,'2020_10_28_095422_add_iso_column_in_users_table',1),(369,'2020_11_10_104042_alter_common_settings_table',1),(370,'2020_11_10_120418_alter_time_zone_and_time_farmat_column_in_settings_system_table',1),(371,'2020_11_20_122736_create_settings_filesystem_table',1),(372,'2020_11_24_074858_alter_settings_filesystem_table_to_add_public_folder_and_copy_settings',1),(373,'2020_11_26_162237_alter_ticket_activity_logs_table_value_column',1),(374,'2020_12_11_062203_alter_settings_filesystem_table_to_add_files_moved_from_old_private_disk',1),(375,'2020_12_14_075005_alter_file_manager_acl_rules_to_add_visibility_column',1),(376,'2020_12_16_043951_alter_users_table_to_add_profile_pic_driver_column',1),(377,'2020_12_16_053612_alter_organization_table_to_add_logo_driver_column',1),(378,'2020_12_16_062738_alter_settings_company_table_to_add_logo_driver_column',1),(379,'2020_12_16_063009_alter_system_portal_table_to_add_logo_icon_driver_column',1),(380,'2020_12_31_062655_add_is_comment_enabled_to_kb_settings',1),(381,'2020_12_31_064845_add_is_comment_enabled_and_counter_to_kb_article',1),(382,'2020_12_31_080242_add_is_enabled_breadcrumb_to_system_portal',1),(383,'2021_01_12_061154_add_hours_js_format_and_is_active_columns_in_time_format_table',1),(384,'2021_01_12_061333_add_js_format_and_is_active_columns_in_date_format_table',1),(385,'2021_01_21_064230_alter_tickets_table_to_add_parent_ticket_id_column',1),(386,'2021_02_03_113535_create_track_popular_articles',1),(387,'2021_02_18_131043_add_column_to_tags_table',1),(388,'2021_02_23_115146_add_coloumn_to_kb_articles_table',1),(389,'2021_03_01_043028_alter_form_fields_table_to_add_show_description_under_form_field_column',1),(390,'2021_03_05_085630_alter_approval_workflows_table_to_add_is_active_column',1),(391,'2021_03_09_070951_create_state_table',1),(392,'2021_03_09_100500_alter_type_outgoing_email_and_business_hour_and_add_under_deletion_columns_in_department_table',1),(393,'2021_03_09_104134_add_role_column_in_department_assign_agents_table',1),(394,'2021_03_10_062535_add_column_stateid_cityid_pincode_country_id_in_location_table',1),(395,'2021_03_17_043345_alter_filter_table',1),(396,'2021_03_17_070324_alter_ticket_activity_logs_table_add_index_on_ticket_id_column',1),(397,'2021_03_23_094419_add_column_under_deletion_in_ticket_type_table',1),(398,'2021_03_31_084656_add_column_under_deletion_in_ticket_status_table',1),(399,'2021_03_31_115534_add_column_under_deletion_in_ticket_source_table',1),(400,'2021_04_08_100103_alter_visible_to_column_in_labels_table',1),(401,'2021_04_20_000000_create_authentication_log_table',1),(402,'2021_04_27_075417_add_notify_unrecognized_login_to_users',1),(403,'2021_05_26_114047_add_delete_login_logs_older_than_to_settings_security',1),(404,'2021_07_13_183412_drop_unused_template_table',1),(405,'2021_07_19_141750_create_breaklines_table',1),(406,'2021_07_20_090429_alter_form_field_label_to_change_size_of_description_column',1),(407,'2021_07_20_094342_create_notification_channels_table',1),(408,'2021_07_21_104140_alter_template_types_table_add_template_category_column',1),(409,'2021_07_23_120833_add_column_under_deletion_and_change_internal_notes_type_in_help_topic_table',1),(410,'2021_08_03_103550_create_team_department_table',1),(411,'2021_08_03_130124_add_column_under_deletion_in_teams_table',1),(412,'2021_08_04_123425_add_is_2fa_enforced_to_settings_security',1),(413,'2021_08_31_101520_add_admin_sidebar_color_and_agent_sidebar_color_in_system_portal_table',1),(414,'2021_09_13_081924_alter_ratings_table_to_add_extra_columns',1),(415,'2021_09_13_081925_create_rating_feedback_requests_table',1),(416,'2021_09_13_082149_create_rating_additional_questions_table',1),(417,'2021_09_13_100057_create_ratings_morph_table',1),(418,'2021_09_14_083251_add_column_type_in_ticket_filters_table',1),(419,'2021_09_15_045705_create_rating_additional_question_ticket_table',1),(420,'2021_09_27_115338_alter_attachments_table_to_add_morph_relations',1),(421,'2021_09_28_172815_alter_kb_category_table_add_is_default_column',1),(422,'2021_10_07_105818_add_organization_column_to_kb_article_table',1),(423,'2021_10_19_044108_create_versions_table',1),(424,'2021_11_10_044003_rename_priority_id_in_ticket_priority_table',1),(425,'2021_11_10_060020_alter_emails_table_add_inline_as_cids_column',1),(426,'2021_12_09_065542_create_daily_reports_table',1),(427,'2021_12_09_065719_create_daily_report_components_table',1),(428,'2021_12_15_080738_add_autoreminder_columns_to_approval_workflow_table',1),(429,'2021_12_17_052558_alter_ratings_table_to_add_parent_id_column',1),(430,'2021_12_20_101256_add_role_column_in_user_permissions_table',1),(431,'2021_12_22_062150_alter_emails_table_to_add_use_new_imap_package',1),(432,'2021_12_28_105926_alter_rating_feedback_requests_table_to_add_answered_column',1),(433,'2022_01_21_110359_create_comments_table',1),(434,'2022_02_23_074739_add_default_value_to_role_in_user_assign_organization_table',1),(435,'2022_03_03_110140_create_user_backup_codes_table',1),(436,'2022_03_14_104439_add_phone_country_code_and_phone_iso_columns_in_users_table',1),(437,'2022_04_20_063454_add_column_is_private_bucket_enabled_to_settings_filesystem_table',1),(438,'2022_05_06_151305_add_indexing_to_ticket_thread',1),(439,'2022_05_16_111850_create_ticket_department_time_trackings_table',1),(440,'2022_05_26_083931_create_notify_events_table',1),(441,'2022_05_26_084150_create_notify_channels_table',1),(442,'2022_05_26_084340_create_notify_channels_notify_events_table',1),(443,'2022_05_26_084540_create_notify_scenarios_table',1),(444,'2022_05_26_084818_create_notify_persons_table',1),(445,'2022_05_26_085051_create_notify_template_categories_table',1),(446,'2022_05_26_085629_create_notify_shortcodes_table',1),(447,'2022_05_26_085854_create_notify_template_drafts_table',1),(448,'2022_05_26_090013_create_notify_shortcodes_notify_template_drafts_table',1),(449,'2022_05_26_090058_create_notify_scenario_associates_table',1),(450,'2022_05_26_090251_create_notify_template_sets_table',1),(451,'2022_05_26_090422_create_notify_templates_table',1),(452,'2022_05_27_121355_add_category_type_column_to_ticket_workflow_table',1),(453,'2022_05_31_063223_create_notify_base_alerts_settings_table',1),(454,'2022_06_06_044614_create_notify_custom_alert_settings_table',1),(455,'2022_06_15_092650_add_column_ticket_template_id_to_recure_contents_table',1),(456,'2022_06_15_100935_create_ticket_templates_table',1),(457,'2022_06_18_202535_create_export-columns_table',1),(458,'2022_06_20_082223_add_rating_auto_request_field_to_ticket_status_table',1),(459,'2022_06_27_030947_add_category_type_column_to_ticket_listeners_table',1),(460,'2022_06_28_043926_create_inapp_notify_table',1),(461,'2022_06_28_065342_delete_in_app_push_notifications_table',1),(462,'2022_06_28_065416_delete_subscribed_users_table',1),(463,'2022_07_01_074128_add_category_type_to_ticket_slas_table',1),(464,'2022_07_20_074836_add_is_updated_to_settings_system_table',1),(465,'2022_07_23_070907_alter_workflow_close_table_remove_send_mail_column',1),(466,'2022_08_28_103746_alter_users_table_for_adding_deactivation_columns',1),(467,'2022_09_01_101741_add_columns_is_oauth_to_emails',1),(468,'2022_09_05_053312_create_oauth_integrations_table',1),(469,'2022_09_05_091642_create_email_oauth_table',1),(470,'2022_09_15_075605_create_user_assign_labels_table',1),(471,'2022_09_26_061023_create_modules_table',1),(472,'2022_09_26_093116_create_sub_modules_table',1),(473,'2022_09_26_094916_create_user_sub_modules_table',1),(474,'2022_09_29_045906_create_admin_sub_modules',1),(475,'2022_10_03_064616_create_organization_orders_table',1),(476,'2022_10_04_094156_alter_packages_table_add_is_private_column',1),(477,'2022_10_13_000000_add_uuid_to_failed_jobs_table',1),(478,'2022_10_19_050034_create_organisation_assign_labels_table',1),(479,'2022_11_14_075439_add_column_allowed_tickets_period_to_packages_table',1),(480,'2022_11_14_091410_add_column_period_expiry_date_to_orders_table',1),(481,'2022_11_18_070428_add_column_shortcode_to_form_fields_table',1),(482,'2022_11_21_062132_create_ticket_pdf_templates_table',1),(483,'2023_01_09_103819_create_healths_table',1),(484,'2023_01_09_104010_create_health_checks_table',1),(485,'2023_01_17_091537_create_health_system_alerts_table',1),(486,'2023_01_24_103409_create_saml_login_table',1),(487,'2023_01_27_030404_create_activity_log_table',1),(488,'2023_01_27_030405_add_event_column_to_activity_log_table',1),(489,'2023_01_27_030406_add_batch_uuid_column_to_activity_log_table',1),(490,'2023_02_21_062144_create_report_schedule_associates',1),(491,'2023_02_21_062156_create_report_schedule_details',1),(492,'2023_02_22_095644_alter_users_table_to_add_logout_time_coloumn_for_users',1),(493,'2023_02_22_155014_alter_saml_login_table_to_add_logout_time_coloumn',1),(494,'2023_03_16_112242_create_column_module_and_row_id_in_inapp_notify_table',1),(495,'2023_04_03_082334_add_columns_to_reports_table',1),(496,'2023_04_25_071314_create_third_party_applications_table',1),(497,'2023_05_08_075907_create_sessions_table',1),(498,'2023_05_17_082454_alter_packages_table_to_add_month_definition',1),(499,'2023_05_23_095220_create_global_search_filters_table',1),(500,'2023_05_23_095426_create_global_search_preferences_table',1),(501,'2023_06_16_135807_create_export_downloads_table',1),(502,'2023_07_17_103027_add_indexing_to_cron_logs_table',1),(503,'2023_07_17_103037_add_indexing_to_exception_logs_table',1),(504,'2023_07_17_103044_add_indexing_to_mail_logs_table',1),(505,'2023_07_18_113446_change_type_and_length_in_department_table',1),(506,'2023_07_21_074330_add_autoreminder_columns_to_approval_workflow_tickets_table',1),(507,'2023_07_24_055821_add_column_to_third_party_apps_table',1),(508,'2023_07_25_051917_alter_column_type_to_ticket_threads_table',1),(509,'2023_08_02_101134_ticket_mentions',1),(510,'2023_08_03_052557_add_columns_to_attachments_table',1),(511,'2023_08_04_081004_add_channel_id_to_ticket_mentions',1),(512,'2023_08_07_111014_alter_type_to_organization_table',1),(513,'2023_08_12_074357_create_system_activity_log_export_table',1),(514,'2023_08_18_051653_create_cache_table',1),(515,'2023_08_23_074223_create_report_schedule_periods',1),(516,'2023_08_23_075548_create_report_schedule_persons',1),(517,'2023_08_24_100858_add_is_schedule_to_report_downloads',1),(518,'2023_09_04_065522_create_popup_table',1),(519,'2023_09_04_075039_create_popup_users_table',1),(520,'2023_09_05_073954_add_column_default_to_file_manager_acl_rules_table',1),(521,'2023_09_05_075727_create_execution_timestamp_table',1),(522,'2023_09_15_084446_add_column_to_reports_table',1),(523,'2023_09_21_071855_add_columns_to_mail_logs_table',1),(524,'2023_09_22_045316_adding_index_to_mail_logs_table',1),(525,'2023_09_22_045704_adding_index_to_exception_logs_table',1),(526,'2023_09_22_060020_adding_index_to_cron_logs_table',1),(527,'2023_09_27_071027_alter_column_to_settings_company_table',1),(528,'2023_09_27_071100_alter_column_to_system_portal_table',1),(529,'2023_09_27_075005_alter_column_to_users_table',1),(530,'2023_09_28_052247_alter_columns_to_ticket_activity_logs_table',1),(531,'2023_10_09_123750_add_index_to_ticket_thread_table',1),(532,'2023_10_13_082545_add_index_to_ticket_activity_logs_table',1),(533,'2023_10_17_103955_alter_ratings_table_to_add_columns_for_feedback_reminder',1),(534,'2023_10_18_065759_create_ticket_reminders_table',1),(535,'2023_10_19_105927_create_form_category_configs_table',1),(536,'2023_10_26_095639_alter_tickets_table_to_add_category_id_column',1),(537,'2023_10_26_101146_alter_for_category_table_to_add_parent_id_column',1),(538,'2023_11_09_115451_alter_ticket_thread_table_to_change_collation',1),(539,'2023_11_20_063121_alter_tickets_table_to_add_full_text_index',1),(540,'2023_11_21_074647_alter_custom_form_value_change_value_column',1),(541,'2023_11_27_124934_create_websocket_configurations_table',1),(542,'2023_11_28_055521_create_import_progress_table',1),(543,'2023_11_28_055548_create_import_progress_details_table',1),(544,'2023_11_28_113208_add_columns_to_conditions_table',1),(545,'2023_12_05_082509_create_search_drivers_table',1),(546,'2023_12_05_082913_add_provider_column_to_oauth_clients_table',1),(547,'2023_12_14_114845_add_columns_to_settings_ticket_table',1),(548,'2023_12_15_105037_create_ticket_archive_database_setting_table',1),(549,'2023_12_18_094518_create_new_form_categories_table',1),(550,'2023_12_18_113637_create_new_form_sections_table',1),(551,'2023_12_18_113651_create_new_form_fields_table',1),(552,'2023_12_19_114327_create_new_form_field_labels',1),(553,'2024_01_11_112520_alter_attachments_to_add_redaction_columns',1),(554,'2024_01_13_160605_add_updated_by_to_canned_response_table',1),(555,'2024_01_22_062844_add_phone_country_code_and_phone_iso_columns_in_settings_company_table',1),(556,'2024_01_22_062849_add_phone_country_code_and_phone_iso_columns_in_location_table',1),(557,'2024_01_23_095346_create_new_form_field_options_table',1),(558,'2024_01_24_055429_create_new_form_select_options_table',1),(559,'2024_02_05_065017_create_new_custom_form_value_table',1),(560,'2024_02_06_104232_create_fetched_mails_table',1),(561,'2024_02_09_131944_alert_mail_logs_subject_column',1),(562,'2024_02_12_085420_create_field_managers_table',1),(563,'2024_02_14_051343_create_graphical_reports_table',1),(564,'2024_02_14_111003_alter_settings_ticket_to_add_redaction_columns',1),(565,'2024_02_20_071731_alter_settings_security_table_to_add_reset_attempts_column',1),(566,'2024_02_20_085437_alter_password_reset_table_to_add_attempts_related_columns',1),(567,'2024_02_27_083316_create_oauth_faveo_attributes_table',1),(568,'2024_03_01_092327_add_column_form_category_id_to_tickets_table',1),(569,'2024_03_12_034611_create_user_columns_table',1),(570,'2024_03_13_045421_add_columns_to_authentication_log_table',1),(571,'2024_03_15_050938_add_column_to_settings_ticket_table',1),(572,'2024_03_15_052905_create_new_form_category_associations_table',1),(573,'2024_03_22_071514_alter_report_columns_table',1),(574,'2024_03_27_105543_create_triggers_table',1),(575,'2024_04_15_123244_create_job_batches_table',1),(576,'2024_04_16_171055_alter_settings_filesystem_table_to_add_wkhtmltopdf_path_column',1),(577,'2024_04_18_021951_add_index_to_parent_id_column',1),(578,'2024_04_28_173838_alter_report_columns_table_to_add_user_id_column',1),(579,'2024_05_21_033230_alter_report_columns_table_to_add_indexing',1),(580,'2024_05_27_061152_add_soft_deletes_column_to_custom_form_value_table',1),(581,'2024_05_28_071348_add_status_changed_assigned_at_to_tickets_table',1),(582,'2024_06_01_075346_alter_fetched_mail_table_to_change_content_column_type_as_longblob',1),(583,'2024_06_05_092914_add_indexes_to_mail_logs_table',1),(584,'2024_06_12_055130_add_columns_group_to_new_form_fields_table',1),(585,'2024_06_12_055712_add_column_display_on_navigation_bar_and_is_deletable_to_ticket_filters_table',1),(586,'2024_06_14_102248_alter_ticket_pdf_template_table_to_add_logs_column',1),(587,'2024_06_17_051108_add_columns_to_form_categories_table',1),(588,'2024_06_17_051116_add_columns_to_form_groups_table',1),(589,'2024_06_18_060751_add_columns_to_form_fields_table',1),(590,'2024_06_18_060918_create_migrate_custom_fields_table',1),(591,'2024_06_21_051348_create_notify_encrypter_table',1),(592,'2024_06_30_042710_create_webhooks_table',1),(593,'2024_06_30_042917_create_webhook_events_table',1),(594,'2024_06_30_044900_create_webhook_configs_table',1),(595,'2024_06_30_183720_add_column_is_migrated_to_users_table',1),(596,'2024_06_30_183742_add_column_is_migrated_to_organization_table',1),(597,'2024_07_01_120311_create_webhook_logs_table',1),(598,'2024_07_02_152114_add_display_order_column_to_ticket_filters_table',1),(599,'2024_07_04_071120_add_columns_to_settings_system_table',1),(600,'2024_07_05_095831_add_trigger_count_to_tickets_table',1),(601,'2024_08_01_083631_add_client_button_font_color_column_to_system_portal',1),(602,'2024_08_06_095221_alter_reports_table_to_add_display_order_column',1),(603,'2024_08_08_063620_add_columns_is_migrated_to_tickets_table',1),(604,'2024_08_08_101138_create_sd_asset_component_associations_table',1),(605,'2024_08_27_125333_add_columns_to_new_form_fields_table',1),(606,'2024_09_04_075350_create_login_attempt_handler_table',1),(607,'2024_09_11_053825_add_mobile_ext_to_users_table',1),(608,'2024_09_11_063243_add_ext_to_organization_table',1),(609,'2024_09_23_074801_alter_reference_id_column_in_email_threads_table',1),(610,'2024_09_25_093436_alter_domain_column_in_organizations_table',1),(611,'2024_09_30_045139_query_optimizaion_indexing',1),(612,'2024_10_23_055911_change_payload_datatype_to_longblob_in_jobs_table',1),(613,'2024_10_25_071616_alter_column_location_id_for_tickets_table',1),(614,'2024_11_08_160720_alter_authentication_logs_table_to_add_active_column',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modules`
--

DROP TABLE IF EXISTS `modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `key_url` text DEFAULT NULL,
  `panel` varchar(255) NOT NULL,
  `is_enabled` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modules`
--

LOCK TABLES `modules` WRITE;
/*!40000 ALTER TABLE `modules` DISABLE KEYS */;
INSERT INTO `modules` VALUES (1,'dashboard','dashboard-description','api/sub-module/1','helpdesk',0,'2025-01-03 04:07:30','2025-01-03 04:07:30');
/*!40000 ALTER TABLE `modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `new_custom_form_value`
--

DROP TABLE IF EXISTS `new_custom_form_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_custom_form_value` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `form_field_id` bigint(20) unsigned NOT NULL,
  `value` longtext NOT NULL,
  `custom_type` varchar(255) NOT NULL,
  `custom_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `new_custom_form_value_custom_type_custom_id_index` (`custom_type`,`custom_id`),
  KEY `new_custom_form_value_form_field_id_foreign` (`form_field_id`),
  FULLTEXT KEY `new_custom_form_value_value_fulltext` (`value`),
  CONSTRAINT `new_custom_form_value_form_field_id_foreign` FOREIGN KEY (`form_field_id`) REFERENCES `new_form_fields` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_custom_form_value`
--

LOCK TABLES `new_custom_form_value` WRITE;
/*!40000 ALTER TABLE `new_custom_form_value` DISABLE KEYS */;
/*!40000 ALTER TABLE `new_custom_form_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `new_form_categories`
--

DROP TABLE IF EXISTS `new_form_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_form_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(255) NOT NULL,
  `icon_class` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `is_public` tinyint(4) NOT NULL DEFAULT 1,
  `is_delete` tinyint(4) NOT NULL DEFAULT 1,
  `is_clone` tinyint(4) NOT NULL DEFAULT 1,
  `is_default` tinyint(4) NOT NULL DEFAULT 0,
  `is_active` tinyint(4) NOT NULL DEFAULT 0,
  `is_multiple` tinyint(4) NOT NULL DEFAULT 0,
  `is_cloned_form` tinyint(4) NOT NULL DEFAULT 0,
  `is_delete_progress` tinyint(4) NOT NULL DEFAULT 0,
  `is_user_form` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `new_form_categories_type_index` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_form_categories`
--

LOCK TABLES `new_form_categories` WRITE;
/*!40000 ALTER TABLE `new_form_categories` DISABLE KEYS */;
INSERT INTO `new_form_categories` VALUES (1,'ticket','fa-user-tie','Default Ticket Form','helpdesk',1,0,1,1,1,1,0,0,1,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(2,'requester','fa-user','Requester','helpdesk',1,0,1,1,1,0,0,0,0,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(3,'organisation','fa-building','Organisation','helpdesk',1,0,1,1,1,0,0,0,0,'2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `new_form_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `new_form_category_associations`
--

DROP TABLE IF EXISTS `new_form_category_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_form_category_associations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_type` varchar(255) NOT NULL,
  `category_id` bigint(20) unsigned NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `new_form_category_associations_category_type_category_id_index` (`category_type`,`category_id`),
  KEY `new_form_category_associations_model_type_model_id_index` (`model_type`,`model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_form_category_associations`
--

LOCK TABLES `new_form_category_associations` WRITE;
/*!40000 ALTER TABLE `new_form_category_associations` DISABLE KEYS */;
/*!40000 ALTER TABLE `new_form_category_associations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `new_form_field_labels`
--

DROP TABLE IF EXISTS `new_form_field_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_form_field_labels` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `labelable_type` varchar(255) NOT NULL,
  `labelable_id` bigint(20) unsigned NOT NULL,
  `language` varchar(255) NOT NULL DEFAULT 'en',
  `label` text NOT NULL,
  `place_holder` text DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `new_form_field_labels_labelable_type_labelable_id_index` (`labelable_type`,`labelable_id`),
  KEY `new_form_field_labels_language_index` (`language`),
  FULLTEXT KEY `new_form_field_labels_label_fulltext` (`label`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_form_field_labels`
--

LOCK TABLES `new_form_field_labels` WRITE;
/*!40000 ALTER TABLE `new_form_field_labels` DISABLE KEYS */;
INSERT INTO `new_form_field_labels` VALUES (1,'App\\Form\\Models\\FormSection',1,'en','Ticket Properties',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(2,'App\\Form\\Models\\FormField',1,'en','Requester',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(3,'App\\Form\\Models\\FormField',2,'en','CC',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(4,'App\\Form\\Models\\FormField',3,'en','Subject',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(5,'App\\Form\\Models\\FormField',4,'en','Status',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(6,'App\\Form\\Models\\FormField',5,'en','Priority',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(7,'App\\Form\\Models\\FormField',6,'en','Location',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(8,'App\\Form\\Models\\FormField',7,'en','Source',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(9,'App\\Form\\Models\\FormField',8,'en','Help Topic',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(10,'App\\Form\\Models\\FormField',9,'en','Department',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(11,'App\\Form\\Models\\FormField',10,'en','Team',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(12,'App\\Form\\Models\\FormField',11,'en','Type',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(13,'App\\Form\\Models\\FormField',12,'en','Assigned',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(14,'App\\Form\\Models\\FormField',13,'en','Description',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(15,'App\\Form\\Models\\FormField',14,'en','Select Package',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(16,'App\\Form\\Models\\FormSection',2,'en','Requester properties',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(17,'App\\Form\\Models\\FormField',15,'en','First Name',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(18,'App\\Form\\Models\\FormField',16,'en','Last Name',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(19,'App\\Form\\Models\\FormField',17,'en','User Name',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(20,'App\\Form\\Models\\FormField',18,'en','Email',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(21,'App\\Form\\Models\\FormField',19,'en','Mobile',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(22,'App\\Form\\Models\\FormField',20,'en','Address',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(23,'App\\Form\\Models\\FormField',21,'en','Organisation',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(24,'App\\Form\\Models\\FormField',22,'en','Organisation Department',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(25,'App\\Form\\Models\\FormField',23,'en','Labels',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(26,'App\\Form\\Models\\FormSection',3,'en','Organisation properties',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(27,'App\\Form\\Models\\FormField',24,'en','Organisation Name',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(28,'App\\Form\\Models\\FormField',25,'en','Phone',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(29,'App\\Form\\Models\\FormField',26,'en','Organisation Domain Name',NULL,'Put domain name without \"http://\" or \"https://\". Example: \"example.com\"','2025-01-03 04:07:31','2025-01-03 04:07:31'),(30,'App\\Form\\Models\\FormField',27,'en','Description',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(31,'App\\Form\\Models\\FormField',28,'en','Address',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(32,'App\\Form\\Models\\FormField',29,'en','Organisation Logo',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(33,'App\\Form\\Models\\FormField',30,'en','Organisation Department',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(34,'App\\Form\\Models\\FormField',31,'en','Labels',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(35,'App\\Form\\Models\\FormField',32,'en','EXT',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(36,'App\\Form\\Models\\FormField',33,'en','EXT',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `new_form_field_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `new_form_field_options`
--

DROP TABLE IF EXISTS `new_form_field_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_form_field_options` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `form_field_id` bigint(20) unsigned NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `category_identifier` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `new_form_field_options_form_field_id_foreign` (`form_field_id`),
  CONSTRAINT `new_form_field_options_form_field_id_foreign` FOREIGN KEY (`form_field_id`) REFERENCES `new_form_fields` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_form_field_options`
--

LOCK TABLES `new_form_field_options` WRITE;
/*!40000 ALTER TABLE `new_form_field_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `new_form_field_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `new_form_fields`
--

DROP TABLE IF EXISTS `new_form_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_form_fields` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_type` varchar(255) DEFAULT NULL,
  `category_id` bigint(20) unsigned DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `data_type` varchar(255) NOT NULL,
  `api_info` varchar(255) DEFAULT NULL,
  `shortcode` varchar(255) DEFAULT NULL,
  `pattern` varchar(255) DEFAULT NULL,
  `validation_message` longtext DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `column` varchar(255) NOT NULL DEFAULT 'first',
  `is_active` tinyint(4) NOT NULL DEFAULT 1,
  `apply_form` tinyint(4) NOT NULL DEFAULT 0,
  `create_button` tinyint(4) NOT NULL DEFAULT 0,
  `is_edit_visible` tinyint(4) NOT NULL DEFAULT 1,
  `is_observable` tinyint(4) NOT NULL DEFAULT 1,
  `is_agent_config` tinyint(4) NOT NULL DEFAULT 1,
  `is_user_config` tinyint(4) NOT NULL DEFAULT 0,
  `required_for_agent` tinyint(4) NOT NULL DEFAULT 0,
  `required_for_user` tinyint(4) NOT NULL DEFAULT 0,
  `display_for_agent` tinyint(4) NOT NULL DEFAULT 1,
  `display_for_user` tinyint(4) NOT NULL DEFAULT 1,
  `default` tinyint(4) NOT NULL DEFAULT 0,
  `is_configurable` tinyint(4) NOT NULL DEFAULT 1,
  `is_deletable` tinyint(4) NOT NULL DEFAULT 0,
  `is_filterable` tinyint(4) NOT NULL DEFAULT 1,
  `show_description` tinyint(4) NOT NULL DEFAULT 0,
  `media_option` tinyint(4) NOT NULL DEFAULT 0,
  `request_time_information` tinyint(4) NOT NULL DEFAULT 1,
  `field_type` varchar(255) DEFAULT NULL,
  `field_id` bigint(20) unsigned DEFAULT NULL,
  `enable_extension` tinyint(4) NOT NULL DEFAULT 0,
  `concat_field_type` varchar(255) DEFAULT NULL,
  `concat_field_id` bigint(20) unsigned DEFAULT NULL,
  `category_identifier` varchar(255) DEFAULT NULL,
  `form_category_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `group` varchar(255) DEFAULT NULL,
  `display_on_edit` tinyint(4) NOT NULL DEFAULT 0,
  `required_on_edit` tinyint(4) NOT NULL DEFAULT 0,
  `required_for_closure` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `new_form_fields_category_type_category_id_index` (`category_type`,`category_id`),
  KEY `new_form_fields_field_type_field_id_index` (`field_type`,`field_id`),
  KEY `new_form_fields_concat_field_type_concat_field_id_index` (`concat_field_type`,`concat_field_id`),
  KEY `new_form_fields_form_category_id_foreign` (`form_category_id`),
  KEY `new_form_fields_group_index` (`group`),
  KEY `new_form_fields_display_on_edit_index` (`display_on_edit`),
  KEY `new_form_fields_required_on_edit_index` (`required_on_edit`),
  KEY `new_form_fields_required_for_closure_index` (`required_for_closure`),
  CONSTRAINT `new_form_fields_form_category_id_foreign` FOREIGN KEY (`form_category_id`) REFERENCES `new_form_categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_form_fields`
--

LOCK TABLES `new_form_fields` WRITE;
/*!40000 ALTER TABLE `new_form_fields` DISABLE KEYS */;
INSERT INTO `new_form_fields` VALUES (1,'App\\Form\\Models\\FormSection',1,'requester','Requester','api','url:=/api/dependency/users?meta=true;;',NULL,NULL,NULL,1,'first',1,0,0,1,0,1,1,1,1,1,1,1,0,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'ticket',1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(2,'App\\Form\\Models\\FormSection',1,'cc','CC','multiselect','url:=/api/dependency/users?meta=true;;',NULL,NULL,NULL,2,'first',1,0,0,0,0,1,0,0,0,1,0,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'ticket',1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(3,'App\\Form\\Models\\FormSection',1,'subject','Subject','text',NULL,NULL,NULL,NULL,3,'first',1,0,0,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'ticket',1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(4,'App\\Form\\Models\\FormSection',1,'status_id','Status','api','url:=/api/dependency/statuses;;',NULL,NULL,NULL,4,'first',1,0,0,0,1,1,1,0,0,1,0,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'ticket',1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(5,'App\\Form\\Models\\FormSection',1,'priority_id','Priority','api','url:=/api/dependency/priorities;;',NULL,NULL,NULL,5,'first',1,0,0,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'ticket',1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(6,'App\\Form\\Models\\FormSection',1,'location_id','Location','api','url:=/api/dependency/locations;;',NULL,NULL,NULL,6,'first',1,0,0,1,1,1,1,0,0,1,0,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'ticket',1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(7,'App\\Form\\Models\\FormSection',1,'source_id','Source','api','url:=/api/dependency/sources;;',NULL,NULL,NULL,7,'first',1,0,0,1,1,1,1,0,0,1,0,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'ticket',1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(8,'App\\Form\\Models\\FormSection',1,'help_topic_id','Help Topic','api','url:=/api/dependency/help-topics?meta=true;;',NULL,NULL,NULL,8,'first',1,0,0,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'ticket',1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(9,'App\\Form\\Models\\FormSection',1,'department_id','Department','api','url:=/api/dependency/departments?meta=true;;',NULL,NULL,NULL,9,'first',1,0,0,1,1,1,1,0,0,1,0,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'ticket',1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(10,'App\\Form\\Models\\FormSection',1,'team_id','Team','api','url:=/api/dependency/teams?meta=true;;',NULL,NULL,NULL,10,'first',1,0,0,1,1,1,0,0,0,0,0,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'ticket',1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(11,'App\\Form\\Models\\FormSection',1,'type_id','Type','api','url:=/api/dependency/types;;',NULL,NULL,NULL,11,'first',1,0,0,1,1,1,1,0,0,1,1,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'ticket',1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(12,'App\\Form\\Models\\FormSection',1,'assigned_id','Assigned','api','url:=/api/dependency/agents?meta=true;;',NULL,NULL,NULL,12,'first',1,0,0,0,1,1,0,0,0,1,0,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'ticket',1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(13,'App\\Form\\Models\\FormSection',1,'description','Description','htmltextarea',NULL,NULL,NULL,NULL,13,'first',1,0,0,0,1,1,1,1,1,1,1,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'ticket',1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(14,'App\\Form\\Models\\FormSection',1,'package_order','Select Package','api','url:=/ticket/form/dependancy?dependency=user-packages;;',NULL,NULL,NULL,14,'first',0,0,0,0,0,1,1,0,1,1,1,1,1,0,0,0,0,1,NULL,NULL,0,NULL,NULL,'ticket',1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(15,'App\\Form\\Models\\FormSection',2,'first_name','First Name','text',NULL,NULL,NULL,NULL,1,'first',1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'requester',2,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(16,'App\\Form\\Models\\FormSection',2,'last_name','Last Name','text',NULL,NULL,NULL,NULL,2,'first',1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'requester',2,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(17,'App\\Form\\Models\\FormSection',2,'user_name','User Name','text',NULL,NULL,NULL,NULL,3,'first',1,0,0,1,1,1,1,0,0,1,0,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'requester',2,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(18,'App\\Form\\Models\\FormSection',2,'email','Email','email',NULL,NULL,NULL,NULL,4,'first',1,0,0,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'requester',2,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(19,'App\\Form\\Models\\FormSection',2,'mobile','Mobile','mobile',NULL,NULL,NULL,NULL,5,'first',1,0,0,1,1,1,1,0,0,1,0,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'requester',2,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(20,'App\\Form\\Models\\FormSection',2,'address','Address','textarea',NULL,NULL,NULL,NULL,6,'first',1,0,0,1,1,1,1,0,0,1,0,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'requester',2,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(21,'App\\Form\\Models\\FormSection',2,'organisation','Organisation','multiselect','url:=/api/dependency/organizations;;',NULL,NULL,NULL,7,'first',1,0,0,1,1,1,1,0,0,1,0,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'requester',2,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(22,'App\\Form\\Models\\FormSection',2,'organisation_department','Organisation Department','multiselect','url:=/api/dependency/organisation-departments;;',NULL,NULL,NULL,8,'first',0,0,0,1,1,1,1,0,0,1,0,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'requester',2,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(23,'App\\Form\\Models\\FormSection',2,'label_ids','Labels','multiselect','url:=api/dependency/labels;;',NULL,NULL,NULL,9,'first',1,0,0,1,1,1,0,0,0,0,0,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'requester',2,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(24,'App\\Form\\Models\\FormSection',3,'organisation_name','Organisation Name','text',NULL,NULL,NULL,NULL,1,'first',1,0,0,1,1,1,0,1,0,1,1,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'organisation',3,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(25,'App\\Form\\Models\\FormSection',3,'phone','Phone','mobile',NULL,NULL,NULL,NULL,2,'first',1,0,0,1,1,1,0,1,0,1,1,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'organisation',3,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(26,'App\\Form\\Models\\FormSection',3,'organisation_domain_name','Organisation Domain Name','taggable',NULL,NULL,NULL,NULL,3,'first',1,0,0,1,1,1,0,0,0,1,1,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'organisation',3,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(27,'App\\Form\\Models\\FormSection',3,'description','Description','textarea',NULL,NULL,NULL,NULL,4,'first',1,0,0,1,1,1,0,0,0,1,1,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'organisation',3,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(28,'App\\Form\\Models\\FormSection',3,'address','Address','textarea',NULL,NULL,NULL,NULL,5,'first',1,0,0,1,1,1,0,0,0,1,1,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'organisation',3,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(29,'App\\Form\\Models\\FormSection',3,'organisation_logo','Organisation Logo','file',NULL,NULL,NULL,NULL,6,'first',1,0,0,1,1,1,0,0,0,1,1,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'organisation',3,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(30,'App\\Form\\Models\\FormSection',3,'organisation_department','Organisation Department','taggable','url:=/api/dependency/organisation-departments;;',NULL,NULL,NULL,7,'first',0,0,0,1,1,1,0,0,0,1,1,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'organisation',3,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(31,'App\\Form\\Models\\FormSection',3,'orglabel_ids','Labels','multiselect','url:=api/dependency/labels;;',NULL,NULL,NULL,8,'first',1,0,0,1,1,1,0,0,0,1,1,1,1,0,1,0,0,1,NULL,NULL,0,NULL,NULL,'organisation',3,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(32,NULL,NULL,'mobile_ext','EXT','number',NULL,NULL,NULL,NULL,NULL,'first',1,0,0,1,1,1,0,0,0,1,1,1,1,0,1,0,0,1,NULL,NULL,0,'App\\Form\\Models\\FormField',19,'requester',2,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0),(33,NULL,NULL,'ext','EXT','number',NULL,NULL,NULL,NULL,NULL,'first',1,0,0,1,1,1,0,0,0,1,1,1,1,0,1,0,0,1,NULL,NULL,0,'App\\Form\\Models\\FormField',25,'organisation',3,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,0,0,0);
/*!40000 ALTER TABLE `new_form_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `new_form_sections`
--

DROP TABLE IF EXISTS `new_form_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_form_sections` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_type` varchar(255) NOT NULL,
  `category_id` bigint(20) unsigned NOT NULL,
  `key` varchar(255) DEFAULT NULL,
  `title` text DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `data_type` varchar(255) DEFAULT 'section',
  `field_type` varchar(255) DEFAULT NULL,
  `field_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `new_form_sections_category_type_category_id_index` (`category_type`,`category_id`),
  KEY `new_form_sections_field_type_field_id_index` (`field_type`,`field_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_form_sections`
--

LOCK TABLES `new_form_sections` WRITE;
/*!40000 ALTER TABLE `new_form_sections` DISABLE KEYS */;
INSERT INTO `new_form_sections` VALUES (1,'App\\Form\\Models\\FormCategory',1,'ticket_properties','Ticket Properties',1,'section',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(2,'App\\Form\\Models\\FormCategory',2,'requester_properties','Requester properties',1,'section',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(3,'App\\Form\\Models\\FormCategory',3,'organisation_properties','Organisation properties',1,'section',NULL,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `new_form_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `new_form_select_options`
--

DROP TABLE IF EXISTS `new_form_select_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_form_select_options` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_type` varchar(255) NOT NULL,
  `category_id` bigint(20) unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `category_identifier` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `new_form_select_options_category_type_category_id_index` (`category_type`,`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_form_select_options`
--

LOCK TABLES `new_form_select_options` WRITE;
/*!40000 ALTER TABLE `new_form_select_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `new_form_select_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `no_assign_escalate`
--

DROP TABLE IF EXISTS `no_assign_escalate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `no_assign_escalate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sla_plan` int(11) NOT NULL,
  `escalate_time` varchar(255) NOT NULL,
  `escalate_type` varchar(255) NOT NULL,
  `escalate_person` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `no_assign_escalate`
--

LOCK TABLES `no_assign_escalate` WRITE;
/*!40000 ALTER TABLE `no_assign_escalate` DISABLE KEYS */;
/*!40000 ALTER TABLE `no_assign_escalate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_channels`
--

DROP TABLE IF EXISTS `notification_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_channels` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `channel_name` varchar(100) NOT NULL,
  `icon` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `system_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_channels`
--

LOCK TABLES `notification_channels` WRITE;
/*!40000 ALTER TABLE `notification_channels` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `message` varchar(255) NOT NULL,
  `by` varchar(255) NOT NULL,
  `to` varchar(255) NOT NULL,
  `seen` varchar(255) NOT NULL,
  `table` varchar(255) DEFAULT NULL,
  `row_id` int(11) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_base_alerts_settings`
--

DROP TABLE IF EXISTS `notify_base_alerts_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_base_alerts_settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `base_id` int(10) unsigned NOT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notify_base_alerts_settings_base_id_foreign` (`base_id`),
  KEY `notify_base_alerts_settings_channel_id_foreign` (`channel_id`),
  CONSTRAINT `notify_base_alerts_settings_base_id_foreign` FOREIGN KEY (`base_id`) REFERENCES `notify_scenario_associates` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notify_base_alerts_settings_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `notify_channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_base_alerts_settings`
--

LOCK TABLES `notify_base_alerts_settings` WRITE;
/*!40000 ALTER TABLE `notify_base_alerts_settings` DISABLE KEYS */;
INSERT INTO `notify_base_alerts_settings` VALUES (1,2,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(2,2,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3,5,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4,5,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(5,6,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(6,7,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(7,8,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(8,9,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(9,11,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(10,11,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(11,14,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(12,14,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(13,15,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(14,15,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(15,16,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(16,19,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(17,19,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(18,22,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(19,22,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(20,23,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(21,23,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(22,24,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(23,26,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(24,26,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(25,28,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(26,29,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(27,30,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(28,32,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(29,32,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(30,35,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(31,35,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(32,36,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(33,37,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(34,37,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(35,40,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(36,40,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(37,43,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(38,43,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(39,44,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(40,44,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(41,45,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(42,48,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(43,48,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(44,50,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(45,50,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(46,52,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(47,52,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(48,54,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(49,54,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(50,57,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(51,57,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(52,58,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(53,58,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(54,74,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(55,75,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(56,77,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(57,77,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(58,78,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(59,78,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(60,79,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(61,79,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(62,80,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(63,81,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(64,82,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(65,82,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(66,83,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(67,84,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(68,85,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(69,85,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(70,96,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(71,96,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(72,99,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(73,99,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(74,103,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(75,103,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(76,108,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(77,108,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(78,109,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(79,109,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(80,110,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(81,112,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(82,112,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(83,115,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(84,115,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(85,116,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(86,117,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(87,117,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(88,120,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(89,120,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(90,123,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(91,123,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(92,124,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(93,124,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(94,125,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(95,126,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(96,127,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(97,128,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(98,128,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(99,129,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(100,129,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(101,84,2,'2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `notify_base_alerts_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_channels`
--

DROP TABLE IF EXISTS `notify_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_channels` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `channel` varchar(50) NOT NULL,
  `lang_key` varchar(100) NOT NULL,
  `desc_lang_key` varchar(100) NOT NULL,
  `icon` varchar(100) NOT NULL,
  `system_default` tinyint(1) NOT NULL DEFAULT 0,
  `template_types` enum('short','long') NOT NULL DEFAULT 'long',
  `event_listener_class` varchar(255) NOT NULL,
  `plugin_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `notify_channels_channel_unique` (`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_channels`
--

LOCK TABLES `notify_channels` WRITE;
/*!40000 ALTER TABLE `notify_channels` DISABLE KEYS */;
INSERT INTO `notify_channels` VALUES (1,'email','email_lang_key','email_notification_channel_template_description','fas fa-envelope',0,'long','App\\Events\\NotifyToEmail',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(2,'in-app','in-app_lang_key','in_app_desc_key','far fa-bell',0,'short','App\\Events\\NotifyToInApp',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28');
/*!40000 ALTER TABLE `notify_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_channels_notify_events`
--

DROP TABLE IF EXISTS `notify_channels_notify_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_channels_notify_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event_id` int(10) unsigned NOT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notify_channels_notify_events_event_id_foreign` (`event_id`),
  KEY `notify_channels_notify_events_channel_id_foreign` (`channel_id`),
  CONSTRAINT `notify_channels_notify_events_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `notify_channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notify_channels_notify_events_event_id_foreign` FOREIGN KEY (`event_id`) REFERENCES `notify_events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_channels_notify_events`
--

LOCK TABLES `notify_channels_notify_events` WRITE;
/*!40000 ALTER TABLE `notify_channels_notify_events` DISABLE KEYS */;
INSERT INTO `notify_channels_notify_events` VALUES (1,1,1,NULL,NULL),(2,1,2,NULL,NULL),(3,2,1,NULL,NULL),(4,2,2,NULL,NULL),(5,3,1,NULL,NULL),(6,3,2,NULL,NULL),(7,4,1,NULL,NULL),(8,5,1,NULL,NULL),(9,5,2,NULL,NULL),(10,6,1,NULL,NULL),(11,6,2,NULL,NULL),(12,7,1,NULL,NULL),(13,7,2,NULL,NULL),(14,8,1,NULL,NULL),(15,8,2,NULL,NULL),(16,9,1,NULL,NULL),(17,9,2,NULL,NULL),(18,10,1,NULL,NULL),(19,11,1,NULL,NULL),(20,12,1,NULL,NULL),(21,12,2,NULL,NULL),(22,13,1,NULL,NULL),(23,13,2,NULL,NULL),(24,14,1,NULL,NULL),(25,15,1,NULL,NULL),(26,16,1,NULL,NULL),(27,16,2,NULL,NULL),(28,17,1,NULL,NULL),(29,18,1,NULL,NULL),(30,18,2,NULL,NULL),(31,19,1,NULL,NULL),(32,19,2,NULL,NULL),(33,20,1,NULL,NULL),(34,20,2,NULL,NULL),(35,21,1,NULL,NULL),(36,21,2,NULL,NULL),(37,22,1,NULL,NULL),(38,22,2,NULL,NULL),(39,23,1,NULL,NULL),(40,23,2,NULL,NULL),(41,24,1,NULL,NULL),(43,25,1,NULL,NULL),(44,25,2,NULL,NULL),(45,26,1,NULL,NULL),(46,26,2,NULL,NULL);
/*!40000 ALTER TABLE `notify_channels_notify_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_custom_alert_settings`
--

DROP TABLE IF EXISTS `notify_custom_alert_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_custom_alert_settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `base_id` int(10) unsigned NOT NULL,
  `custom_id` int(11) NOT NULL,
  `custom_type` varchar(255) NOT NULL,
  `sub_condition` varchar(255) DEFAULT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notify_custom_alert_settings_base_id_foreign` (`base_id`),
  KEY `notify_custom_alert_settings_channel_id_foreign` (`channel_id`),
  CONSTRAINT `notify_custom_alert_settings_base_id_foreign` FOREIGN KEY (`base_id`) REFERENCES `notify_scenario_associates` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notify_custom_alert_settings_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `notify_channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_custom_alert_settings`
--

LOCK TABLES `notify_custom_alert_settings` WRITE;
/*!40000 ALTER TABLE `notify_custom_alert_settings` DISABLE KEYS */;
INSERT INTO `notify_custom_alert_settings` VALUES (1,64,1,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(2,59,1,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(3,65,1,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(4,64,3,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(5,59,3,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(6,65,3,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(7,64,7,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(8,59,7,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(9,65,7,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(10,64,8,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(11,59,8,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(12,65,8,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(13,66,1,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(14,66,1,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(15,67,1,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(16,67,1,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(17,68,1,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(18,68,1,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(19,69,1,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(20,69,1,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(21,70,1,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(22,70,1,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(23,71,1,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(24,71,1,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(25,72,1,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(26,72,1,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(27,73,1,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(28,73,1,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(29,66,2,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(30,66,2,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(31,67,2,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(32,67,2,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(33,68,2,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(34,68,2,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(35,69,2,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(36,69,2,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(37,70,2,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(38,70,2,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(39,71,2,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(40,71,2,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(41,72,2,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(42,72,2,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(43,73,2,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(44,73,2,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(45,66,3,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(46,66,3,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(47,67,3,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(48,67,3,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(49,68,3,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(50,68,3,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(51,69,3,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(52,69,3,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(53,70,3,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(54,70,3,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(55,71,3,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(56,71,3,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(57,72,3,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(58,72,3,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(59,73,3,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(60,73,3,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(61,66,4,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(62,66,4,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(63,67,4,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(64,67,4,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(65,68,4,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(66,68,4,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(67,69,4,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(68,69,4,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(69,70,4,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(70,70,4,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(71,71,4,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(72,71,4,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(73,72,4,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(74,72,4,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(75,73,4,'',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(76,73,4,'',NULL,2,'2025-01-03 04:07:30','2025-01-03 04:07:30');
/*!40000 ALTER TABLE `notify_custom_alert_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_encrypter`
--

DROP TABLE IF EXISTS `notify_encrypter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_encrypter` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `who` varchar(255) NOT NULL,
  `what` blob NOT NULL,
  `how` blob NOT NULL,
  `why` blob NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_encrypter`
--

LOCK TABLES `notify_encrypter` WRITE;
/*!40000 ALTER TABLE `notify_encrypter` DISABLE KEYS */;
INSERT INTO `notify_encrypter` VALUES (1,'alpha','rRkBVqt3J3nDSw/3BuDSBaex+aJeBhijmMICSoupeaYvokFSPGYN8+SZUBDebVYN','03/A4HXQNlSlhE6keHVD2/UUW/gcHuG37GZbETSxexdXjAwcnkC7qeVv6qM5LfzK14CjmMrClw+HkxEw+xn18m+ZIGn3fPMaZLEbtL+nfcCdcbBdOTUvk/4Fwt2Suk6KdKuzNwSZfjGLHDIHqkeEkQ==','mserzny+SyWYyHZmeCtmBejDHL4Fxo9onwCPuXoU9Cm7aT2DhL81k8JaJNeQ0o94W1YO4nIY+nUn+l3nbDVRpKA2VMfilsjUGjGxxYFBCUKITpo4aSMMtDWMLf21luNr','2025-01-03 04:07:31','2025-01-03 04:07:31'),(2,'beta','yogbntjRcvcBGC0/H+KzJ9xmGsmsh65SCGL4ibFD+fE3CE2GXEjaHAXb7CSbzlRCe0fsbr1Q0Fkyr9I89bXXH0fd+Cn7+cVs7qZkMI46m9vN1FxZ/cgKlLgvbgos6lfB9ou5RVSJooHf2y0uOOlo7vP4ZpMnObzTflyXveuCV5z12ebceVeDYii716eUFPrETgu4CRp97ENu46GWGenRwqE/ldZWm0/zosi+HDa2zUimvT9EAz6MHr5+zNrKUYdSXQsOEN3LyV5P1+4ODK5IVwC4TSBP6+DYkhltibMqmJoekyVh/WK4lhSlZeMsxGiL8B7HcIHgubW45uEWwfPlt09jTpoUlMN7sHSC4nZHHYtfScgDjRo4xTHwQgkT8f8jtJGhKdmZszAWNGXmnHwAY1z1TSz+RdledoRuP0F7sC13ijNEmZbpspcfcLdCIgQ9ob1Y+rHD2iylmIH4U46FJaphyzqOCj+R4f5v4wqGlLUoHZZ1QWOuSOcfXWr5mMjGwxzPGkrnEEgOpqxZApdOXkp9quFvDV1TumMWSV9I/d6ikxk7Ux6EYo414jAthfxp4xsuYt9lycN+OSDp0VhdeOgCMTXDQ6/zgZOj46P78V9cOmjS3sXHxVwQgj/kwGiqaKfjP8vjcseAD4vR48JGEGEN92/ZXz+cWAULByjz0VMz+OESItSUJ8Mt8GyiaO5anqyBgIMFdeQlfhWFWaoF7sm0DD5BbHGN1tcw42SR9P0x3utsjVbhZhxt+5WfUoOotLNLY4ilO9aStV4tb6SNSpVJFgVlrDuYyutQp5wKkyDbTax0690UPDmz1HRWsHIDT90nnYOPJY+sF7sP1gpmZcH/aLRpm8X2nVlU1Wl3cAx1bH3mUYL9PW/CPl08ORv6sFUzuePR6lD6Js7RPZXoonePwAQ0+q5GdarHhjqckgua+I33SXshZcFJzwz7Jefx41q6sLwJd31XLYDOJ66BOjbkt+PA/Kzme0XEzp0E4jFdjRlREm2u5QJ4JG7977Rmt3y914djmQRsbcYFB5eQvz+AdFJpw5U10moc/E5zFAljSmT83VDDbI6Vj8mk+x1Cv1Ctp6wpZcVoXvbWrW2J3UJed2rYIQDX/m4dqbjbCl6qNlsaHNHusFCXMpRmgtigvNeuvaLZrk8qxN1ATmQPO9A+9/K/muawmfGlDQ9qn1hY67vMwHuyrgEY85iyGz0lnDhITki7uwMVk45IeS+DkwdgNibaXDRyUhlRHV5/gmu11lVXfqIt7mI9PIgNoxinHBsVJmHp2jPiOS8wajY0u0walzxGSJWLTVKwofN1m0fnGz9lM2+J2saH/hOpZr09qflpuCFVfzZr9kMganhDkGF5G7idSo7/4PgHQ08tK5PSJpjxG7HIRKGpaYZlMBpfSzOouPu/rzG9H5T0yCTlNvqDs2m2szN9G8JZpzcdOuleca/DE7tdo2JF/9XBtsTgSNwynVM2OrJWf5AuBiU22a7bk5w5b5VkJT96byqp28e5zpN5HnK0DJOhrvrhefyRMTqIAluJRp7Ce8hKxm2W+/MNLTVyIrWrYE5CreAZQ2qY0M6cJJ8pIeh5Jg6Q19iqU74QaAH062f8QZBmESe9w07K0oZJeYtOI74cjCknZlrjtmqaohEIfIEcNdwNJ0HK9yh/rJKJhQ9ZsvI7/BLKxQZbv5iBxGpgqCIVMv/H31kgvDIbm3AGaRyWCKjZQaUg413nn1Z9QhpOEBCneesurQ6i5/o5LvtLMwjbyz0RSsMVbWMdkIRx7gB3sgYe27NqjgQp5/kisMeP2s8GEUcETdfMvlgjTgAB1Jl7U2GcCkNkmmNIp1kn8Wdii0rAcRFI525K6/3VaZuTIKQBCSeNp4AA69YmYDJZUG9xNeNf3qtNaJnbFq53w/CwUpNM40ym62hftlwRRc9KowS9bg2Pa0dXpUZQcbhbX1j5M6ejVxslpEge7Jq1tOnHr2CBDUSjVxYZARLlSF7mVsPqUouFGfTypsqK/FHZNZABOM9YVp8K/wrOBsSdWQuFQDujfcTl0B0rfxbCXcehwISCOkt2S8fm7awBauydPui36jCWmg/QFLAA1RcLE1ipn2AHrp3pqhspnneqRpwdYvJuFYYPyVRvP9H1BqddhPpV7Oyd0hn9L1s1DmR5UBARfbcuNEj8TFQzPS0YeQP9hrRvEHZ/JciNNoUXR4RGqjDhITDrrOtFCgtLtUCJqsvf0GIYvuYs0aWn1+RHvqqF3k35hp1vl3iXhRFPHtRDm78ZJpM9SpBqitWi7BSw8esINmk2KMoQ6dw+bKFLie0XHiXXpRzhbHIT2yTKsbmvLK6R8nYRc8hgfpCSXjCAutPozRSgD265k9c3PJi88XvakPVU81aQDA0wbDwLrXcwXF0od0vTwp2HnNrj4FbsTxGQ7neqwPcBMwpdiscyxz32fT0OABK12FXmyHMjjI0clfu4tzIgSsGEHdFtLB92LvTUBJtEgIpFdJTx8aRopHqDLVogLArqo3BNvGIOR8vza00ZA7hTa1ykulvdMCIMYBNcYIi1YKFMfbFGp+8wm2FXnCUN+OJL3SlOogKsSHQB/24MDQ33qc+n8KPBoHbp7A8JSryhJSTFiY0s0prNFGeqDh1pHRRnrWvRSIE+J9lKSL/UIEsPaaSYSnvHjn73Avg9L+x/CyLfZNcq0Gilb1Etuq7/lCnruuh5vge/cB93qgkPaJFsrhvSVT637lG5p36B5qEX57RLJfIAD1yMIR7HuwGfpeMNdQ9GY/kZpewTKAil2ZcPbmDu/eZpPzL62nxwkOsU9YS4Oeg5VkQkHuj454VyqagFxQGLdwfBHAG2Gs7Jt4pvcTyAQQcFP6VALvpwGByamWuopkWZ559g6NzpRYRLi+9NfdaAC47A1vw3lFiXhfKQOQLjdmG1oiJYAZsHkTIEsHJjf7HHYgFaJSKZWqd0Smw9gqHZktzqZVSDRy5Fh68KWdX/U5IlYPqfq1ILT4HMuItayOtqPdI62tQLrgMyZyf71pDk5xuFHlhmAjGpCJGdwPo=','03/A4HXQNlSlhE6keHVD2/UUW/gcHuG37GZbETSxexdXjAwcnkC7qeVv6qM5LfzK14CjmMrClw+HkxEw+xn18m+ZIGn3fPMaZLEbtL+nfcCdcbBdOTUvk/4Fwt2Suk6KdKuzNwSZfjGLHDIHqkeEkQ==','7+ukj4fc9fWOApvg4t+2dUGKmAvOZoiQAcCEOm9IZDmdLWUX4kfcLEH54w0o3OOUOMcCznLFdcepGV/pF0gTp25y5GSPzwjMENgyC1+oFAY=','2025-01-03 04:07:31','2025-01-03 04:07:31'),(3,'gamma','BoPhgz0zazDHodNSsjl1qKkVcaeDAYaPE2rIVQhtvFU2QYGlXplgJjnNJ8jB2GQKoe5NWAzNSNLK/mFp++bkcX/6jybEDkNaKKPV4AuOjGh8ol/T7S1qXWpY6dWgvz2zkm1ZKuY13lb5lM+ZYOiP8A==','kXAigkwrxXKbPgE4OB2PG2yrv6KviY2AC8MKncQBHLr8876iO1Ttk8J5p0CjT/ndysaTVNhuAGhyOC2mueLYJXKlJg0nemlKndza9eN4Ujw9NofkhaKPJYX9eEhdm1un','BwIFmQ5sNtdUSZ6gSFRyFrSZXLmTq4rcOsxCsIYfL1FEcWG1AZhjzpvWaFe9sYN3C1x+oIYILjAcXaiv+EmUH5Hm1qEkuH6IUiHkGitcdbY=','2025-01-03 04:07:31','2025-01-03 04:07:31'),(4,'delta','wSEHeAdV/rCCJqPS354mSH/ICXvJm92FWcoIi9zGq08irwm/B+cALrr9FbUIZoBsoKIEaCQg7J8q5ow4noSgqUCUzl2o87blk1nFMTr9RVk=','4d1xOUpxNofLxh9LCuRqT6dpe1gu+acSm8BwUpCyZQvrxLbWL0oyDV7fEA1MpVno1fwlJ9CuDfGMpp9LmIo7VA==','/O/vsLaqfXsAWnm2jL7I+jFis9744Hr3B60hO/Xq1+ltCRZKDEEuTVd16M9GPRTk','2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `notify_encrypter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_events`
--

DROP TABLE IF EXISTS `notify_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event` varchar(50) NOT NULL,
  `lang_key` varchar(100) NOT NULL,
  `desc_lang_key` varchar(150) NOT NULL,
  `module` varchar(50) NOT NULL,
  `class_name` varchar(255) NOT NULL,
  `plugin_name` varchar(255) DEFAULT NULL,
  `restricted_channels` varchar(255) DEFAULT NULL,
  `has_custom_settings` tinyint(1) NOT NULL DEFAULT 0,
  `is_editing_allowed` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `notify_events_event_unique` (`event`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_events`
--

LOCK TABLES `notify_events` WRITE;
/*!40000 ALTER TABLE `notify_events` DISABLE KEYS */;
INSERT INTO `notify_events` VALUES (1,'ticket_created','ticket_created_lang_key','ticket_created_desc_key','tickets','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,NULL,0,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(2,'ticket_reply','ticket_reply_lang_key','ticket_reply_desc_key','tickets','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,NULL,0,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3,'new_user_registration_alert','new_user_registration_alert_lang_key','new_user_registration_alert_desc_key','users','App\\Notify\\Controllers\\NotifyResolver\\UserResolverController',NULL,NULL,0,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4,'new_user_registration_confirmation','new_user_registration_confirmation_lang_key','new_user_registration_confirmation_desc_key','users','App\\Notify\\Controllers\\NotifyResolver\\UserResolverController',NULL,'email',0,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(5,'ticket_assignment','ticket_assignment_lang_key','ticket_assignment_desc_key','tickets','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,NULL,0,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(6,'ticket_rating_submitted','ticket_rating_submitted_lang_key','ticket_rating_submitted_desc_key','ratings','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,NULL,0,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(7,'internal_change','internal_change_lang_key','internal_change_desc_key','tickets','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,NULL,0,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(8,'ticket_status_changed','ticket_status_changed_lang_key','ticket_status_changed_desc_key','tickets','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,NULL,1,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(9,'sla_alerts','sla_alerts_lang_key','sla_alerts_desc_key','sla','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,NULL,1,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(10,'email_verify','email_verify_lang_key','email_verify_desc_key','users','App\\Notify\\Controllers\\NotifyResolver\\UserResolverController',NULL,'email',0,0,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(11,'password_reset','password_reset_lang_key','password_reset_desc_key','users','App\\Notify\\Controllers\\NotifyResolver\\UserResolverController',NULL,'email',0,0,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(12,'login_alerts','login_alerts_lang_key','login_alerts_desc_key','users','App\\Notify\\Controllers\\NotifyResolver\\UserResolverController',NULL,NULL,0,0,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(13,'backup_alerts','backup_alerts_lang_key','backup_alerts_desc_key','users','App\\Notify\\Controllers\\NotifyResolver\\UserResolverController',NULL,NULL,0,0,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(14,'rating_feedback_requests','rating_feedback_requests_lang_key','rating_feedback_requests_desc_key','ratings','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,'email',0,0,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(15,'check_ticket_alert','check_ticket_alert_lang_key','check_ticket_alert_desc_key','tickets','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,'email',0,0,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(16,'report_export','report_export_lang_key','report_export_desc_key','reports','App\\Notify\\Controllers\\NotifyResolver\\UserResolverController',NULL,NULL,0,0,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(17,'ticket_forwarding','ticket_forwarding_lang_key','ticket_forwarding_desc_key','tickets','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,'email',0,0,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(18,'ticket_approval','ticket_approval_lang_key','ticket_approval_desc_key','tickets','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,NULL,0,0,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(19,'custom_alerts','custom_alerts_lang_key','custom_alerts_desc_key','users','App\\Notify\\Controllers\\NotifyResolver\\UserResolverController',NULL,NULL,0,0,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(20,'ticket_pdf_template_generate','ticket_pdf_template_generate_lang_key','ticket_pdf_template_generate_desc_key','tickets','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,NULL,0,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(21,'ticket_fork','ticket_fork_lang_key','ticket_fork_desc_key','tickets','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,NULL,0,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(22,'fork_ticket_assignment','fork_ticket_assignment_lang_key','fork_ticket_assignment_desc_key','tickets','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,NULL,0,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(23,'ticket_merge','ticket_merge_lang_key','ticket_merge_desc_key','tickets','App\\Notify\\Controllers\\NotifyResolver\\TicketUserResolverController',NULL,NULL,0,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(24,'job_dispatch_alert','job_dispatch_alert_lang_key','job_dispatch_alert_desc_key','jobs','App\\Health\\Controllers\\Alerts\\JobUserResolverController',NULL,NULL,0,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(25,'user_export','user_export_lang_key','user_export_desc_key','users','App\\Notify\\Controllers\\NotifyResolver\\UserResolverController',NULL,NULL,0,0,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(26,'report_schedule_export','report_schedule_export_lang_key','report_schedule_export_desc_key','reports','App\\Notify\\Controllers\\NotifyResolver\\UserResolverController',NULL,NULL,0,0,'2025-01-03 04:07:30','2025-01-03 04:07:30');
/*!40000 ALTER TABLE `notify_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_persons`
--

DROP TABLE IF EXISTS `notify_persons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_persons` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `person` varchar(100) NOT NULL,
  `lang_key` varchar(100) NOT NULL,
  `desc_lang_key` varchar(100) NOT NULL,
  `plugin_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `notify_persons_person_unique` (`person`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_persons`
--

LOCK TABLES `notify_persons` WRITE;
/*!40000 ALTER TABLE `notify_persons` DISABLE KEYS */;
INSERT INTO `notify_persons` VALUES (1,'admins','admins_lang_key','admins_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(2,'department_managers','department_managers_lang_key','department_managers_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3,'department_members','department_members_lang_key','department_members_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4,'team_members','team_members_lang_key','team_members_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(5,'team_leads','team_leads_lang_key','team_leads_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(6,'requester','requester_lang_key','requester_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(7,'organization_managers','organization_managers_lang_key','organization_managers_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(8,'assigned_agent','assigned_agent_lang_key','assigned_agent_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(9,'agents','agents_lang_key','agents_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(10,'managers_all_departments','managers_all_departments_lang_key','managers_all_departments_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(11,'leads_all_teams','leads_all_teams_lang_key','leads_all_teams_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(12,'custom','custom_lang_key','custom_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(13,'collaborators','collaborators_lang_key','collaborators_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(14,'mentioned_agents','mentioned_agents_lang_key','mentioned_agents_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(15,'mentioned_departments','mentioned_departments_lang_key','mentioned_departments_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(16,'mentioned_teams','mentioned_teams_lang_key','mentioned_teams_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(17,'requester_collaborators','requester_collaborators_lang_key','requester_collaborators_desc_key',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `notify_persons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_scenario_associates`
--

DROP TABLE IF EXISTS `notify_scenario_associates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_scenario_associates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `person_id` int(10) unsigned NOT NULL,
  `scenario_id` int(10) unsigned NOT NULL,
  `template_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notify_scenario_associates_person_id_foreign` (`person_id`),
  KEY `notify_scenario_associates_scenario_id_foreign` (`scenario_id`),
  KEY `notify_scenario_associates_template_id_foreign` (`template_id`),
  CONSTRAINT `notify_scenario_associates_person_id_foreign` FOREIGN KEY (`person_id`) REFERENCES `notify_persons` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notify_scenario_associates_scenario_id_foreign` FOREIGN KEY (`scenario_id`) REFERENCES `notify_scenarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notify_scenario_associates_template_id_foreign` FOREIGN KEY (`template_id`) REFERENCES `notify_template_drafts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_scenario_associates`
--

LOCK TABLES `notify_scenario_associates` WRITE;
/*!40000 ALTER TABLE `notify_scenario_associates` DISABLE KEYS */;
INSERT INTO `notify_scenario_associates` VALUES (1,1,1,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(2,2,1,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3,3,1,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4,4,1,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(5,5,1,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(6,6,2,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(7,7,2,3,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(8,6,3,4,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(9,7,3,5,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(10,1,4,6,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(11,2,4,6,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(12,3,4,6,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(13,4,4,6,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(14,5,4,6,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(15,8,4,7,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(16,17,4,8,'2025-01-03 04:07:28','2025-01-03 04:07:31'),(17,7,4,9,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(18,1,5,10,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(19,2,5,10,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(20,3,5,10,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(21,4,5,10,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(22,5,5,10,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(23,8,5,11,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(24,17,5,12,'2025-01-03 04:07:28','2025-01-03 04:07:31'),(25,7,5,13,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(26,1,6,14,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(27,9,6,14,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(28,10,6,14,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(29,11,6,14,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(30,6,7,15,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(31,1,8,16,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(32,2,8,16,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(33,3,8,16,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(34,4,8,16,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(35,5,8,16,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(36,6,8,17,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(37,8,8,18,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(38,7,8,19,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(39,1,9,20,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(40,2,9,20,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(41,3,9,20,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(42,4,9,20,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(43,5,9,20,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(44,8,9,20,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(45,6,9,21,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(46,7,9,22,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(47,1,10,23,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(48,2,10,23,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(49,3,10,23,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(50,8,10,23,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(51,4,10,23,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(52,5,10,23,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(53,1,11,24,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(54,2,11,24,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(55,3,11,24,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(56,4,11,24,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(57,5,11,24,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(58,8,11,25,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(59,1,12,26,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(60,2,12,26,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(61,3,12,26,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(62,4,12,26,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(63,5,12,26,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(64,6,12,27,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(65,8,12,28,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(66,12,13,29,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(67,8,13,30,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(68,12,14,31,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(69,8,14,32,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(70,12,15,33,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(71,8,15,34,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(72,12,16,35,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(73,8,16,36,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(74,6,17,37,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(75,6,18,38,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(76,6,19,39,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(77,6,20,40,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(78,6,21,41,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(79,12,22,42,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(80,6,23,43,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(81,6,24,44,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(82,12,25,45,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(83,12,26,46,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(84,12,27,47,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(85,12,28,48,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(92,1,29,50,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(93,6,29,50,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(94,8,29,50,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(95,7,29,50,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(96,2,29,50,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(97,3,29,50,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(98,4,29,50,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(99,5,29,50,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(100,14,11,51,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(101,15,11,52,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(102,16,11,53,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(103,1,30,54,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(104,2,30,54,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(105,3,30,54,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(106,4,30,54,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(107,5,30,54,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(108,8,30,54,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(109,7,30,55,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(110,6,30,56,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(111,1,31,57,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(112,2,31,57,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(113,3,31,57,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(114,4,31,57,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(115,5,31,57,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(116,6,31,58,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(117,8,31,59,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(118,7,31,60,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(119,1,32,61,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(120,2,32,61,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(121,3,32,61,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(122,4,32,61,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(123,5,32,61,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(124,8,32,61,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(125,7,32,62,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(126,17,32,63,'2025-01-03 04:07:30','2025-01-03 04:07:31'),(127,1,33,64,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(128,12,34,65,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(129,12,35,66,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(130,14,4,67,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(131,15,4,68,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(132,16,4,69,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(133,13,2,70,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(134,13,3,71,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(135,13,8,72,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(136,13,9,73,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(137,13,31,74,'2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `notify_scenario_associates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_scenarios`
--

DROP TABLE IF EXISTS `notify_scenarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_scenarios` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `scenario` varchar(50) NOT NULL,
  `lang_key` varchar(100) NOT NULL,
  `desc_lang_key` varchar(150) NOT NULL,
  `event_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `notify_scenarios_scenario_unique` (`scenario`),
  KEY `notify_scenarios_event_id_foreign` (`event_id`),
  CONSTRAINT `notify_scenarios_event_id_foreign` FOREIGN KEY (`event_id`) REFERENCES `notify_events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_scenarios`
--

LOCK TABLES `notify_scenarios` WRITE;
/*!40000 ALTER TABLE `notify_scenarios` DISABLE KEYS */;
INSERT INTO `notify_scenarios` VALUES (1,'ticket_created_alert','ticket_created_alert_lang_key','ticket_created_alert_desc_key',1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(2,'ticket_created_by_agents','ticket_created_by_agents_lang_key','ticket_created_by_agents_desc_key',1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3,'ticket_created_by_clients','ticket_created_by_clients_lang_key','ticket_created_by_clients_desc_key',1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4,'ticket_reply_by_agent','ticket_reply_by_agent_lang_key','ticket_reply_by_agent_desc_key',2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(5,'ticket_reply_by_client','ticket_reply_by_client_lang_key','ticket_reply_by_client_desc_key',2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(6,'new_user_registration_alert','new_user_registration_alert_lang_key','new_user_registration_alert_desc_key',3,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(7,'new_user_registration_confirmation','new_user_registration_confirmation_lang_key','new_user_registration_confirmation_desc_key',4,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(8,'ticket_assignment_agents','ticket_assignment_agents_lang_key','ticket_assignment_agents_desc_key',5,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(9,'ticket_assignment_team','ticket_assignment_team_lang_key','ticket_assignment_team_desc_key',5,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(10,'ticket_rating_submitted','ticket_rating_submitted_lang_key','ticket_rating_submitted_desc_key',6,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(11,'internal_change','internal_change_lang_key','internal_change_desc_key',7,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(12,'ticket_status_changed','ticket_status_changed_lang_key','ticket_status_changed_desc_key',8,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(13,'response_due_approach','response_due_approach_lang_key','response_due_approach_desc_key',9,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(14,'response_due_violate','response_due_violate_lang_key','response_due_violate_desc_key',9,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(15,'resolve_due_approach','resolve_due_approach_lang_key','resolve_due_approach_desc_key',9,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(16,'resolve_due_violate','resolve_due_violate_lang_key','resolve_due_violate_desc_key',9,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(17,'email_verify','email_verify_lang_key','email_verify_desc_key',10,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(18,'password_reset_requested','password_reset_requested_lang_key','password_reset_requested_desc_key',11,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(19,'password_resetted','password_resetted_lang_key','password_resetted_desc_key',11,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(20,'invalid_login_alert','invalid_login_alert_lang_key','invalid_login_alert_desc_key',12,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(21,'new_device_login_alert','new_device_login_alert_lang_key','new_device_login_alert_desc_key',12,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(22,'backup_alerts','backup_alerts_lang_key','backup_alerts_desc_key',13,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(23,'rating_feedback_requests','rating_feedback_requests_lang_key','rating_feedback_requests_desc_key',14,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(24,'check_ticket_alert','check_ticket_alert_lang_key','check_ticket_alert_desc_key',15,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(25,'report_export','report_export_lang_key','report_export_desc_key',16,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(26,'ticket_forwarding','ticket_forwarding_lang_key','ticket_forwarding_desc_key',17,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(27,'ticket_approval','ticket_approval_lang_key','ticket_approval_desc_key',18,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(28,'custom_alerts','custom_alerts_lang_key','custom_alerts_desc_key',19,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(29,'ticket_pdf_generate_alert','ticket_pdf_generate_alert_lang_key','ticket_pdf_generate_alert_desc_key',20,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(30,'ticket_fork_alert','ticket_fork_alert_lang_key','ticket_fork_alert_desc_key',21,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(31,'fork_ticket_assignment_agents','fork_ticket_assignment_agents_lang_key','fork_ticket_assignment_agents_desc_key',22,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(32,'ticket_merge_alert','ticket_merge_alert_lang_key','ticket_merge_alert_desc_key',23,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(33,'job_dispatch_alert','job_dispatch_alert_lang_key','job_dispatch_alert_desc_key',24,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(34,'user_export','user_export_lang_key','user_export_desc_key',25,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(35,'report_schedule_export','report_schedule_export_lang_key','report_schedule_export_desc_key',26,'2025-01-03 04:07:30','2025-01-03 04:07:30');
/*!40000 ALTER TABLE `notify_scenarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_shortcode_notify_template_draft`
--

DROP TABLE IF EXISTS `notify_shortcode_notify_template_draft`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_shortcode_notify_template_draft` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `template_id` int(10) unsigned NOT NULL,
  `shortcode_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notify_shortcode_notify_template_draft_template_id_foreign` (`template_id`),
  KEY `notify_shortcode_notify_template_draft_shortcode_id_foreign` (`shortcode_id`),
  CONSTRAINT `notify_shortcode_notify_template_draft_shortcode_id_foreign` FOREIGN KEY (`shortcode_id`) REFERENCES `notify_shortcodes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notify_shortcode_notify_template_draft_template_id_foreign` FOREIGN KEY (`template_id`) REFERENCES `notify_template_drafts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1641 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_shortcode_notify_template_draft`
--

LOCK TABLES `notify_shortcode_notify_template_draft` WRITE;
/*!40000 ALTER TABLE `notify_shortcode_notify_template_draft` DISABLE KEYS */;
INSERT INTO `notify_shortcode_notify_template_draft` VALUES (1,1,7,NULL,NULL),(2,1,8,NULL,NULL),(3,1,9,NULL,NULL),(4,1,10,NULL,NULL),(5,1,11,NULL,NULL),(6,1,12,NULL,NULL),(7,1,13,NULL,NULL),(8,1,14,NULL,NULL),(9,1,15,NULL,NULL),(10,1,16,NULL,NULL),(11,1,17,NULL,NULL),(12,1,18,NULL,NULL),(13,1,19,NULL,NULL),(14,1,20,NULL,NULL),(15,1,6,NULL,NULL),(16,1,21,NULL,NULL),(17,1,22,NULL,NULL),(18,1,23,NULL,NULL),(19,1,24,NULL,NULL),(20,1,25,NULL,NULL),(21,1,26,NULL,NULL),(22,1,27,NULL,NULL),(23,1,28,NULL,NULL),(24,1,29,NULL,NULL),(25,2,7,NULL,NULL),(26,2,8,NULL,NULL),(27,2,9,NULL,NULL),(28,2,10,NULL,NULL),(29,2,11,NULL,NULL),(30,2,12,NULL,NULL),(31,2,13,NULL,NULL),(32,2,14,NULL,NULL),(33,2,15,NULL,NULL),(34,2,16,NULL,NULL),(35,2,17,NULL,NULL),(36,2,18,NULL,NULL),(37,2,19,NULL,NULL),(38,2,20,NULL,NULL),(39,2,6,NULL,NULL),(40,2,21,NULL,NULL),(41,2,22,NULL,NULL),(42,2,23,NULL,NULL),(43,2,24,NULL,NULL),(44,2,25,NULL,NULL),(45,2,26,NULL,NULL),(46,2,27,NULL,NULL),(47,2,28,NULL,NULL),(48,2,29,NULL,NULL),(49,2,30,NULL,NULL),(50,2,31,NULL,NULL),(51,2,32,NULL,NULL),(52,2,33,NULL,NULL),(53,3,7,NULL,NULL),(54,3,8,NULL,NULL),(55,3,9,NULL,NULL),(56,3,10,NULL,NULL),(57,3,11,NULL,NULL),(58,3,12,NULL,NULL),(59,3,13,NULL,NULL),(60,3,14,NULL,NULL),(61,3,15,NULL,NULL),(62,3,16,NULL,NULL),(63,3,17,NULL,NULL),(64,3,18,NULL,NULL),(65,3,19,NULL,NULL),(66,3,20,NULL,NULL),(67,3,6,NULL,NULL),(68,3,21,NULL,NULL),(69,3,22,NULL,NULL),(70,3,23,NULL,NULL),(71,3,24,NULL,NULL),(72,3,25,NULL,NULL),(73,3,26,NULL,NULL),(74,3,27,NULL,NULL),(75,3,28,NULL,NULL),(76,3,29,NULL,NULL),(77,3,30,NULL,NULL),(78,3,31,NULL,NULL),(79,3,32,NULL,NULL),(80,3,33,NULL,NULL),(81,4,7,NULL,NULL),(82,4,8,NULL,NULL),(83,4,9,NULL,NULL),(84,4,10,NULL,NULL),(85,4,11,NULL,NULL),(86,4,12,NULL,NULL),(87,4,13,NULL,NULL),(88,4,14,NULL,NULL),(89,4,15,NULL,NULL),(90,4,16,NULL,NULL),(91,4,17,NULL,NULL),(92,4,18,NULL,NULL),(93,4,19,NULL,NULL),(94,4,20,NULL,NULL),(95,4,6,NULL,NULL),(96,4,21,NULL,NULL),(97,4,22,NULL,NULL),(98,4,23,NULL,NULL),(99,4,24,NULL,NULL),(100,4,25,NULL,NULL),(101,4,26,NULL,NULL),(102,4,27,NULL,NULL),(103,4,28,NULL,NULL),(104,4,29,NULL,NULL),(105,5,7,NULL,NULL),(106,5,8,NULL,NULL),(107,5,9,NULL,NULL),(108,5,10,NULL,NULL),(109,5,11,NULL,NULL),(110,5,12,NULL,NULL),(111,5,13,NULL,NULL),(112,5,14,NULL,NULL),(113,5,15,NULL,NULL),(114,5,16,NULL,NULL),(115,5,17,NULL,NULL),(116,5,18,NULL,NULL),(117,5,19,NULL,NULL),(118,5,20,NULL,NULL),(119,5,6,NULL,NULL),(120,5,21,NULL,NULL),(121,5,22,NULL,NULL),(122,5,23,NULL,NULL),(123,5,24,NULL,NULL),(124,5,25,NULL,NULL),(125,5,26,NULL,NULL),(126,5,27,NULL,NULL),(127,5,28,NULL,NULL),(128,5,29,NULL,NULL),(129,6,7,NULL,NULL),(130,6,8,NULL,NULL),(131,6,9,NULL,NULL),(132,6,10,NULL,NULL),(133,6,11,NULL,NULL),(134,6,12,NULL,NULL),(135,6,13,NULL,NULL),(136,6,14,NULL,NULL),(137,6,15,NULL,NULL),(138,6,16,NULL,NULL),(139,6,17,NULL,NULL),(140,6,18,NULL,NULL),(141,6,19,NULL,NULL),(142,6,20,NULL,NULL),(143,6,6,NULL,NULL),(144,6,21,NULL,NULL),(145,6,22,NULL,NULL),(146,6,23,NULL,NULL),(147,6,24,NULL,NULL),(148,6,25,NULL,NULL),(149,6,26,NULL,NULL),(150,6,27,NULL,NULL),(151,6,28,NULL,NULL),(152,6,29,NULL,NULL),(153,6,30,NULL,NULL),(154,6,31,NULL,NULL),(155,6,32,NULL,NULL),(156,6,33,NULL,NULL),(157,7,7,NULL,NULL),(158,7,8,NULL,NULL),(159,7,9,NULL,NULL),(160,7,10,NULL,NULL),(161,7,11,NULL,NULL),(162,7,12,NULL,NULL),(163,7,13,NULL,NULL),(164,7,14,NULL,NULL),(165,7,15,NULL,NULL),(166,7,16,NULL,NULL),(167,7,17,NULL,NULL),(168,7,18,NULL,NULL),(169,7,19,NULL,NULL),(170,7,20,NULL,NULL),(171,7,6,NULL,NULL),(172,7,21,NULL,NULL),(173,7,22,NULL,NULL),(174,7,23,NULL,NULL),(175,7,24,NULL,NULL),(176,7,25,NULL,NULL),(177,7,26,NULL,NULL),(178,7,27,NULL,NULL),(179,7,28,NULL,NULL),(180,7,29,NULL,NULL),(181,7,30,NULL,NULL),(182,7,31,NULL,NULL),(183,7,32,NULL,NULL),(184,7,33,NULL,NULL),(185,8,7,NULL,NULL),(186,8,8,NULL,NULL),(187,8,9,NULL,NULL),(188,8,10,NULL,NULL),(189,8,11,NULL,NULL),(190,8,12,NULL,NULL),(191,8,13,NULL,NULL),(192,8,14,NULL,NULL),(193,8,15,NULL,NULL),(194,8,16,NULL,NULL),(195,8,17,NULL,NULL),(196,8,18,NULL,NULL),(197,8,19,NULL,NULL),(198,8,20,NULL,NULL),(199,8,6,NULL,NULL),(200,8,21,NULL,NULL),(201,8,22,NULL,NULL),(202,8,23,NULL,NULL),(203,8,24,NULL,NULL),(204,8,25,NULL,NULL),(205,8,26,NULL,NULL),(206,8,27,NULL,NULL),(207,8,28,NULL,NULL),(208,8,29,NULL,NULL),(209,8,30,NULL,NULL),(210,8,31,NULL,NULL),(211,8,32,NULL,NULL),(212,8,33,NULL,NULL),(213,9,7,NULL,NULL),(214,9,8,NULL,NULL),(215,9,9,NULL,NULL),(216,9,10,NULL,NULL),(217,9,11,NULL,NULL),(218,9,12,NULL,NULL),(219,9,13,NULL,NULL),(220,9,14,NULL,NULL),(221,9,15,NULL,NULL),(222,9,16,NULL,NULL),(223,9,17,NULL,NULL),(224,9,18,NULL,NULL),(225,9,19,NULL,NULL),(226,9,20,NULL,NULL),(227,9,6,NULL,NULL),(228,9,21,NULL,NULL),(229,9,22,NULL,NULL),(230,9,23,NULL,NULL),(231,9,24,NULL,NULL),(232,9,25,NULL,NULL),(233,9,26,NULL,NULL),(234,9,27,NULL,NULL),(235,9,28,NULL,NULL),(236,9,29,NULL,NULL),(237,9,30,NULL,NULL),(238,9,31,NULL,NULL),(239,9,32,NULL,NULL),(240,9,33,NULL,NULL),(241,10,7,NULL,NULL),(242,10,8,NULL,NULL),(243,10,9,NULL,NULL),(244,10,10,NULL,NULL),(245,10,11,NULL,NULL),(246,10,12,NULL,NULL),(247,10,13,NULL,NULL),(248,10,14,NULL,NULL),(249,10,15,NULL,NULL),(250,10,16,NULL,NULL),(251,10,17,NULL,NULL),(252,10,18,NULL,NULL),(253,10,19,NULL,NULL),(254,10,20,NULL,NULL),(255,10,6,NULL,NULL),(256,10,21,NULL,NULL),(257,10,22,NULL,NULL),(258,10,23,NULL,NULL),(259,10,24,NULL,NULL),(260,10,25,NULL,NULL),(261,10,26,NULL,NULL),(262,10,27,NULL,NULL),(263,10,28,NULL,NULL),(264,10,29,NULL,NULL),(265,10,30,NULL,NULL),(266,10,31,NULL,NULL),(267,10,32,NULL,NULL),(268,10,33,NULL,NULL),(269,11,7,NULL,NULL),(270,11,8,NULL,NULL),(271,11,9,NULL,NULL),(272,11,10,NULL,NULL),(273,11,11,NULL,NULL),(274,11,12,NULL,NULL),(275,11,13,NULL,NULL),(276,11,14,NULL,NULL),(277,11,15,NULL,NULL),(278,11,16,NULL,NULL),(279,11,17,NULL,NULL),(280,11,18,NULL,NULL),(281,11,19,NULL,NULL),(282,11,20,NULL,NULL),(283,11,6,NULL,NULL),(284,11,21,NULL,NULL),(285,11,22,NULL,NULL),(286,11,23,NULL,NULL),(287,11,24,NULL,NULL),(288,11,25,NULL,NULL),(289,11,26,NULL,NULL),(290,11,27,NULL,NULL),(291,11,28,NULL,NULL),(292,11,29,NULL,NULL),(293,11,30,NULL,NULL),(294,11,31,NULL,NULL),(295,11,32,NULL,NULL),(296,11,33,NULL,NULL),(297,12,7,NULL,NULL),(298,12,8,NULL,NULL),(299,12,9,NULL,NULL),(300,12,10,NULL,NULL),(301,12,11,NULL,NULL),(302,12,12,NULL,NULL),(303,12,13,NULL,NULL),(304,12,14,NULL,NULL),(305,12,15,NULL,NULL),(306,12,16,NULL,NULL),(307,12,17,NULL,NULL),(308,12,18,NULL,NULL),(309,12,19,NULL,NULL),(310,12,20,NULL,NULL),(311,12,6,NULL,NULL),(312,12,21,NULL,NULL),(313,12,22,NULL,NULL),(314,12,23,NULL,NULL),(315,12,24,NULL,NULL),(316,12,25,NULL,NULL),(317,12,26,NULL,NULL),(318,12,27,NULL,NULL),(319,12,28,NULL,NULL),(320,12,29,NULL,NULL),(321,12,30,NULL,NULL),(322,12,31,NULL,NULL),(323,12,32,NULL,NULL),(324,12,33,NULL,NULL),(325,13,7,NULL,NULL),(326,13,8,NULL,NULL),(327,13,9,NULL,NULL),(328,13,10,NULL,NULL),(329,13,11,NULL,NULL),(330,13,12,NULL,NULL),(331,13,13,NULL,NULL),(332,13,14,NULL,NULL),(333,13,15,NULL,NULL),(334,13,16,NULL,NULL),(335,13,17,NULL,NULL),(336,13,18,NULL,NULL),(337,13,19,NULL,NULL),(338,13,20,NULL,NULL),(339,13,6,NULL,NULL),(340,13,21,NULL,NULL),(341,13,22,NULL,NULL),(342,13,23,NULL,NULL),(343,13,24,NULL,NULL),(344,13,25,NULL,NULL),(345,13,26,NULL,NULL),(346,13,27,NULL,NULL),(347,13,28,NULL,NULL),(348,13,29,NULL,NULL),(349,13,30,NULL,NULL),(350,13,31,NULL,NULL),(351,13,32,NULL,NULL),(352,13,33,NULL,NULL),(353,14,34,NULL,NULL),(354,14,35,NULL,NULL),(355,14,36,NULL,NULL),(356,15,34,NULL,NULL),(357,15,35,NULL,NULL),(358,15,37,NULL,NULL),(359,16,7,NULL,NULL),(360,16,8,NULL,NULL),(361,16,9,NULL,NULL),(362,16,10,NULL,NULL),(363,16,11,NULL,NULL),(364,16,12,NULL,NULL),(365,16,13,NULL,NULL),(366,16,14,NULL,NULL),(367,16,15,NULL,NULL),(368,16,16,NULL,NULL),(369,16,17,NULL,NULL),(370,16,18,NULL,NULL),(371,16,19,NULL,NULL),(372,16,20,NULL,NULL),(373,16,6,NULL,NULL),(374,16,21,NULL,NULL),(375,16,22,NULL,NULL),(376,16,23,NULL,NULL),(377,16,24,NULL,NULL),(378,16,25,NULL,NULL),(379,16,26,NULL,NULL),(380,16,27,NULL,NULL),(381,16,28,NULL,NULL),(382,16,29,NULL,NULL),(383,16,30,NULL,NULL),(384,16,31,NULL,NULL),(385,16,32,NULL,NULL),(386,16,33,NULL,NULL),(387,17,7,NULL,NULL),(388,17,8,NULL,NULL),(389,17,9,NULL,NULL),(390,17,10,NULL,NULL),(391,17,11,NULL,NULL),(392,17,12,NULL,NULL),(393,17,13,NULL,NULL),(394,17,14,NULL,NULL),(395,17,15,NULL,NULL),(396,17,16,NULL,NULL),(397,17,17,NULL,NULL),(398,17,18,NULL,NULL),(399,17,19,NULL,NULL),(400,17,20,NULL,NULL),(401,17,6,NULL,NULL),(402,17,21,NULL,NULL),(403,17,22,NULL,NULL),(404,17,23,NULL,NULL),(405,17,24,NULL,NULL),(406,17,25,NULL,NULL),(407,17,26,NULL,NULL),(408,17,27,NULL,NULL),(409,17,28,NULL,NULL),(410,17,29,NULL,NULL),(411,17,30,NULL,NULL),(412,17,31,NULL,NULL),(413,17,32,NULL,NULL),(414,17,33,NULL,NULL),(415,18,7,NULL,NULL),(416,18,8,NULL,NULL),(417,18,9,NULL,NULL),(418,18,10,NULL,NULL),(419,18,11,NULL,NULL),(420,18,12,NULL,NULL),(421,18,13,NULL,NULL),(422,18,14,NULL,NULL),(423,18,15,NULL,NULL),(424,18,16,NULL,NULL),(425,18,17,NULL,NULL),(426,18,18,NULL,NULL),(427,18,19,NULL,NULL),(428,18,20,NULL,NULL),(429,18,6,NULL,NULL),(430,18,21,NULL,NULL),(431,18,22,NULL,NULL),(432,18,23,NULL,NULL),(433,18,24,NULL,NULL),(434,18,25,NULL,NULL),(435,18,26,NULL,NULL),(436,18,27,NULL,NULL),(437,18,28,NULL,NULL),(438,18,29,NULL,NULL),(439,18,30,NULL,NULL),(440,18,31,NULL,NULL),(441,18,32,NULL,NULL),(442,18,33,NULL,NULL),(443,19,7,NULL,NULL),(444,19,8,NULL,NULL),(445,19,9,NULL,NULL),(446,19,10,NULL,NULL),(447,19,11,NULL,NULL),(448,19,12,NULL,NULL),(449,19,13,NULL,NULL),(450,19,14,NULL,NULL),(451,19,15,NULL,NULL),(452,19,16,NULL,NULL),(453,19,17,NULL,NULL),(454,19,18,NULL,NULL),(455,19,19,NULL,NULL),(456,19,20,NULL,NULL),(457,19,6,NULL,NULL),(458,19,21,NULL,NULL),(459,19,22,NULL,NULL),(460,19,23,NULL,NULL),(461,19,24,NULL,NULL),(462,19,25,NULL,NULL),(463,19,26,NULL,NULL),(464,19,27,NULL,NULL),(465,19,28,NULL,NULL),(466,19,29,NULL,NULL),(467,19,30,NULL,NULL),(468,19,31,NULL,NULL),(469,19,32,NULL,NULL),(470,19,33,NULL,NULL),(471,20,7,NULL,NULL),(472,20,8,NULL,NULL),(473,20,9,NULL,NULL),(474,20,10,NULL,NULL),(475,20,11,NULL,NULL),(476,20,12,NULL,NULL),(477,20,13,NULL,NULL),(478,20,14,NULL,NULL),(479,20,15,NULL,NULL),(480,20,16,NULL,NULL),(481,20,17,NULL,NULL),(482,20,18,NULL,NULL),(483,20,19,NULL,NULL),(484,20,20,NULL,NULL),(485,20,6,NULL,NULL),(486,20,21,NULL,NULL),(487,20,22,NULL,NULL),(488,20,23,NULL,NULL),(489,20,24,NULL,NULL),(490,20,25,NULL,NULL),(491,20,26,NULL,NULL),(492,20,27,NULL,NULL),(493,20,28,NULL,NULL),(494,20,29,NULL,NULL),(495,20,30,NULL,NULL),(496,20,31,NULL,NULL),(497,20,32,NULL,NULL),(498,20,33,NULL,NULL),(499,21,7,NULL,NULL),(500,21,8,NULL,NULL),(501,21,9,NULL,NULL),(502,21,10,NULL,NULL),(503,21,11,NULL,NULL),(504,21,12,NULL,NULL),(505,21,13,NULL,NULL),(506,21,14,NULL,NULL),(507,21,15,NULL,NULL),(508,21,16,NULL,NULL),(509,21,17,NULL,NULL),(510,21,18,NULL,NULL),(511,21,19,NULL,NULL),(512,21,20,NULL,NULL),(513,21,6,NULL,NULL),(514,21,21,NULL,NULL),(515,21,22,NULL,NULL),(516,21,23,NULL,NULL),(517,21,24,NULL,NULL),(518,21,25,NULL,NULL),(519,21,26,NULL,NULL),(520,21,27,NULL,NULL),(521,21,28,NULL,NULL),(522,21,29,NULL,NULL),(523,21,30,NULL,NULL),(524,21,31,NULL,NULL),(525,21,32,NULL,NULL),(526,21,33,NULL,NULL),(527,22,7,NULL,NULL),(528,22,8,NULL,NULL),(529,22,9,NULL,NULL),(530,22,10,NULL,NULL),(531,22,11,NULL,NULL),(532,22,12,NULL,NULL),(533,22,13,NULL,NULL),(534,22,14,NULL,NULL),(535,22,15,NULL,NULL),(536,22,16,NULL,NULL),(537,22,17,NULL,NULL),(538,22,18,NULL,NULL),(539,22,19,NULL,NULL),(540,22,20,NULL,NULL),(541,22,6,NULL,NULL),(542,22,21,NULL,NULL),(543,22,22,NULL,NULL),(544,22,23,NULL,NULL),(545,22,24,NULL,NULL),(546,22,25,NULL,NULL),(547,22,26,NULL,NULL),(548,22,27,NULL,NULL),(549,22,28,NULL,NULL),(550,22,29,NULL,NULL),(551,22,30,NULL,NULL),(552,22,31,NULL,NULL),(553,22,32,NULL,NULL),(554,22,33,NULL,NULL),(555,23,7,NULL,NULL),(556,23,8,NULL,NULL),(557,23,9,NULL,NULL),(558,23,10,NULL,NULL),(559,23,11,NULL,NULL),(560,23,12,NULL,NULL),(561,23,13,NULL,NULL),(562,23,14,NULL,NULL),(563,23,15,NULL,NULL),(564,23,16,NULL,NULL),(565,23,17,NULL,NULL),(566,23,18,NULL,NULL),(567,23,19,NULL,NULL),(568,23,20,NULL,NULL),(569,23,6,NULL,NULL),(570,23,21,NULL,NULL),(571,23,22,NULL,NULL),(572,23,23,NULL,NULL),(573,23,24,NULL,NULL),(574,23,25,NULL,NULL),(575,23,26,NULL,NULL),(576,23,27,NULL,NULL),(577,23,28,NULL,NULL),(578,23,29,NULL,NULL),(579,23,38,NULL,NULL),(580,23,30,NULL,NULL),(581,23,31,NULL,NULL),(582,23,32,NULL,NULL),(583,23,33,NULL,NULL),(584,24,7,NULL,NULL),(585,24,8,NULL,NULL),(586,24,9,NULL,NULL),(587,24,10,NULL,NULL),(588,24,11,NULL,NULL),(589,24,12,NULL,NULL),(590,24,13,NULL,NULL),(591,24,14,NULL,NULL),(592,24,15,NULL,NULL),(593,24,16,NULL,NULL),(594,24,17,NULL,NULL),(595,24,18,NULL,NULL),(596,24,19,NULL,NULL),(597,24,20,NULL,NULL),(598,24,6,NULL,NULL),(599,24,21,NULL,NULL),(600,24,22,NULL,NULL),(601,24,23,NULL,NULL),(602,24,24,NULL,NULL),(603,24,25,NULL,NULL),(604,24,26,NULL,NULL),(605,24,27,NULL,NULL),(606,24,28,NULL,NULL),(607,24,29,NULL,NULL),(608,24,30,NULL,NULL),(609,24,31,NULL,NULL),(610,24,32,NULL,NULL),(611,24,33,NULL,NULL),(612,25,7,NULL,NULL),(613,25,8,NULL,NULL),(614,25,9,NULL,NULL),(615,25,10,NULL,NULL),(616,25,11,NULL,NULL),(617,25,12,NULL,NULL),(618,25,13,NULL,NULL),(619,25,14,NULL,NULL),(620,25,15,NULL,NULL),(621,25,16,NULL,NULL),(622,25,17,NULL,NULL),(623,25,18,NULL,NULL),(624,25,19,NULL,NULL),(625,25,20,NULL,NULL),(626,25,6,NULL,NULL),(627,25,21,NULL,NULL),(628,25,22,NULL,NULL),(629,25,23,NULL,NULL),(630,25,24,NULL,NULL),(631,25,25,NULL,NULL),(632,25,26,NULL,NULL),(633,25,27,NULL,NULL),(634,25,28,NULL,NULL),(635,25,29,NULL,NULL),(636,25,30,NULL,NULL),(637,25,31,NULL,NULL),(638,25,32,NULL,NULL),(639,25,33,NULL,NULL),(640,26,7,NULL,NULL),(641,26,8,NULL,NULL),(642,26,9,NULL,NULL),(643,26,10,NULL,NULL),(644,26,11,NULL,NULL),(645,26,12,NULL,NULL),(646,26,13,NULL,NULL),(647,26,14,NULL,NULL),(648,26,15,NULL,NULL),(649,26,16,NULL,NULL),(650,26,17,NULL,NULL),(651,26,18,NULL,NULL),(652,26,19,NULL,NULL),(653,26,20,NULL,NULL),(654,26,6,NULL,NULL),(655,26,21,NULL,NULL),(656,26,22,NULL,NULL),(657,26,23,NULL,NULL),(658,26,24,NULL,NULL),(659,26,25,NULL,NULL),(660,26,26,NULL,NULL),(661,26,27,NULL,NULL),(662,26,28,NULL,NULL),(663,26,29,NULL,NULL),(664,26,30,NULL,NULL),(665,26,31,NULL,NULL),(666,26,32,NULL,NULL),(667,26,33,NULL,NULL),(668,27,7,NULL,NULL),(669,27,8,NULL,NULL),(670,27,9,NULL,NULL),(671,27,10,NULL,NULL),(672,27,11,NULL,NULL),(673,27,12,NULL,NULL),(674,27,13,NULL,NULL),(675,27,14,NULL,NULL),(676,27,15,NULL,NULL),(677,27,16,NULL,NULL),(678,27,17,NULL,NULL),(679,27,18,NULL,NULL),(680,27,19,NULL,NULL),(681,27,20,NULL,NULL),(682,27,6,NULL,NULL),(683,27,21,NULL,NULL),(684,27,22,NULL,NULL),(685,27,23,NULL,NULL),(686,27,24,NULL,NULL),(687,27,25,NULL,NULL),(688,27,26,NULL,NULL),(689,27,27,NULL,NULL),(690,27,28,NULL,NULL),(691,27,29,NULL,NULL),(692,27,30,NULL,NULL),(693,27,31,NULL,NULL),(694,27,32,NULL,NULL),(695,27,33,NULL,NULL),(696,28,7,NULL,NULL),(697,28,8,NULL,NULL),(698,28,9,NULL,NULL),(699,28,10,NULL,NULL),(700,28,11,NULL,NULL),(701,28,12,NULL,NULL),(702,28,13,NULL,NULL),(703,28,14,NULL,NULL),(704,28,15,NULL,NULL),(705,28,16,NULL,NULL),(706,28,17,NULL,NULL),(707,28,18,NULL,NULL),(708,28,19,NULL,NULL),(709,28,20,NULL,NULL),(710,28,6,NULL,NULL),(711,28,21,NULL,NULL),(712,28,22,NULL,NULL),(713,28,23,NULL,NULL),(714,28,24,NULL,NULL),(715,28,25,NULL,NULL),(716,28,26,NULL,NULL),(717,28,27,NULL,NULL),(718,28,28,NULL,NULL),(719,28,29,NULL,NULL),(720,28,30,NULL,NULL),(721,28,31,NULL,NULL),(722,28,32,NULL,NULL),(723,28,33,NULL,NULL),(724,29,7,NULL,NULL),(725,29,8,NULL,NULL),(726,29,9,NULL,NULL),(727,29,10,NULL,NULL),(728,29,11,NULL,NULL),(729,29,12,NULL,NULL),(730,29,13,NULL,NULL),(731,29,14,NULL,NULL),(732,29,15,NULL,NULL),(733,29,16,NULL,NULL),(734,29,17,NULL,NULL),(735,29,18,NULL,NULL),(736,29,19,NULL,NULL),(737,29,20,NULL,NULL),(738,29,6,NULL,NULL),(739,29,21,NULL,NULL),(740,29,22,NULL,NULL),(741,29,23,NULL,NULL),(742,29,24,NULL,NULL),(743,29,25,NULL,NULL),(744,29,26,NULL,NULL),(745,29,27,NULL,NULL),(746,29,28,NULL,NULL),(747,29,29,NULL,NULL),(748,30,7,NULL,NULL),(749,30,8,NULL,NULL),(750,30,9,NULL,NULL),(751,30,10,NULL,NULL),(752,30,11,NULL,NULL),(753,30,12,NULL,NULL),(754,30,13,NULL,NULL),(755,30,14,NULL,NULL),(756,30,15,NULL,NULL),(757,30,16,NULL,NULL),(758,30,17,NULL,NULL),(759,30,18,NULL,NULL),(760,30,19,NULL,NULL),(761,30,20,NULL,NULL),(762,30,6,NULL,NULL),(763,30,21,NULL,NULL),(764,30,22,NULL,NULL),(765,30,23,NULL,NULL),(766,30,24,NULL,NULL),(767,30,25,NULL,NULL),(768,30,26,NULL,NULL),(769,30,27,NULL,NULL),(770,30,28,NULL,NULL),(771,30,29,NULL,NULL),(772,31,7,NULL,NULL),(773,31,8,NULL,NULL),(774,31,9,NULL,NULL),(775,31,10,NULL,NULL),(776,31,11,NULL,NULL),(777,31,12,NULL,NULL),(778,31,13,NULL,NULL),(779,31,14,NULL,NULL),(780,31,15,NULL,NULL),(781,31,16,NULL,NULL),(782,31,17,NULL,NULL),(783,31,18,NULL,NULL),(784,31,19,NULL,NULL),(785,31,20,NULL,NULL),(786,31,6,NULL,NULL),(787,31,21,NULL,NULL),(788,31,22,NULL,NULL),(789,31,23,NULL,NULL),(790,31,24,NULL,NULL),(791,31,25,NULL,NULL),(792,31,26,NULL,NULL),(793,31,27,NULL,NULL),(794,31,28,NULL,NULL),(795,31,29,NULL,NULL),(796,32,7,NULL,NULL),(797,32,8,NULL,NULL),(798,32,9,NULL,NULL),(799,32,10,NULL,NULL),(800,32,11,NULL,NULL),(801,32,12,NULL,NULL),(802,32,13,NULL,NULL),(803,32,14,NULL,NULL),(804,32,15,NULL,NULL),(805,32,16,NULL,NULL),(806,32,17,NULL,NULL),(807,32,18,NULL,NULL),(808,32,19,NULL,NULL),(809,32,20,NULL,NULL),(810,32,6,NULL,NULL),(811,32,21,NULL,NULL),(812,32,22,NULL,NULL),(813,32,23,NULL,NULL),(814,32,24,NULL,NULL),(815,32,25,NULL,NULL),(816,32,26,NULL,NULL),(817,32,27,NULL,NULL),(818,32,28,NULL,NULL),(819,32,29,NULL,NULL),(820,33,7,NULL,NULL),(821,33,8,NULL,NULL),(822,33,9,NULL,NULL),(823,33,10,NULL,NULL),(824,33,11,NULL,NULL),(825,33,12,NULL,NULL),(826,33,13,NULL,NULL),(827,33,14,NULL,NULL),(828,33,15,NULL,NULL),(829,33,16,NULL,NULL),(830,33,17,NULL,NULL),(831,33,18,NULL,NULL),(832,33,19,NULL,NULL),(833,33,20,NULL,NULL),(834,33,6,NULL,NULL),(835,33,21,NULL,NULL),(836,33,22,NULL,NULL),(837,33,23,NULL,NULL),(838,33,24,NULL,NULL),(839,33,25,NULL,NULL),(840,33,26,NULL,NULL),(841,33,27,NULL,NULL),(842,33,28,NULL,NULL),(843,33,29,NULL,NULL),(844,34,7,NULL,NULL),(845,34,8,NULL,NULL),(846,34,9,NULL,NULL),(847,34,10,NULL,NULL),(848,34,11,NULL,NULL),(849,34,12,NULL,NULL),(850,34,13,NULL,NULL),(851,34,14,NULL,NULL),(852,34,15,NULL,NULL),(853,34,16,NULL,NULL),(854,34,17,NULL,NULL),(855,34,18,NULL,NULL),(856,34,19,NULL,NULL),(857,34,20,NULL,NULL),(858,34,6,NULL,NULL),(859,34,21,NULL,NULL),(860,34,22,NULL,NULL),(861,34,23,NULL,NULL),(862,34,24,NULL,NULL),(863,34,25,NULL,NULL),(864,34,26,NULL,NULL),(865,34,27,NULL,NULL),(866,34,28,NULL,NULL),(867,34,29,NULL,NULL),(868,35,7,NULL,NULL),(869,35,8,NULL,NULL),(870,35,9,NULL,NULL),(871,35,10,NULL,NULL),(872,35,11,NULL,NULL),(873,35,12,NULL,NULL),(874,35,13,NULL,NULL),(875,35,14,NULL,NULL),(876,35,15,NULL,NULL),(877,35,16,NULL,NULL),(878,35,17,NULL,NULL),(879,35,18,NULL,NULL),(880,35,19,NULL,NULL),(881,35,20,NULL,NULL),(882,35,6,NULL,NULL),(883,35,21,NULL,NULL),(884,35,22,NULL,NULL),(885,35,23,NULL,NULL),(886,35,24,NULL,NULL),(887,35,25,NULL,NULL),(888,35,26,NULL,NULL),(889,35,27,NULL,NULL),(890,35,28,NULL,NULL),(891,35,29,NULL,NULL),(892,36,7,NULL,NULL),(893,36,8,NULL,NULL),(894,36,9,NULL,NULL),(895,36,10,NULL,NULL),(896,36,11,NULL,NULL),(897,36,12,NULL,NULL),(898,36,13,NULL,NULL),(899,36,14,NULL,NULL),(900,36,15,NULL,NULL),(901,36,16,NULL,NULL),(902,36,17,NULL,NULL),(903,36,18,NULL,NULL),(904,36,19,NULL,NULL),(905,36,20,NULL,NULL),(906,36,6,NULL,NULL),(907,36,21,NULL,NULL),(908,36,22,NULL,NULL),(909,36,23,NULL,NULL),(910,36,24,NULL,NULL),(911,36,25,NULL,NULL),(912,36,26,NULL,NULL),(913,36,27,NULL,NULL),(914,36,28,NULL,NULL),(915,36,29,NULL,NULL),(916,37,34,NULL,NULL),(917,37,35,NULL,NULL),(918,37,39,NULL,NULL),(919,38,40,NULL,NULL),(920,39,37,NULL,NULL),(921,40,41,NULL,NULL),(922,40,42,NULL,NULL),(923,40,43,NULL,NULL),(924,40,44,NULL,NULL),(925,40,45,NULL,NULL),(926,40,46,NULL,NULL),(927,40,47,NULL,NULL),(928,40,48,NULL,NULL),(929,41,41,NULL,NULL),(930,41,42,NULL,NULL),(931,41,43,NULL,NULL),(932,41,44,NULL,NULL),(933,41,45,NULL,NULL),(934,41,46,NULL,NULL),(935,41,47,NULL,NULL),(936,41,48,NULL,NULL),(937,42,49,NULL,NULL),(938,43,7,NULL,NULL),(939,43,8,NULL,NULL),(940,43,9,NULL,NULL),(941,43,10,NULL,NULL),(942,43,11,NULL,NULL),(943,43,12,NULL,NULL),(944,43,13,NULL,NULL),(945,43,14,NULL,NULL),(946,43,15,NULL,NULL),(947,43,16,NULL,NULL),(948,43,17,NULL,NULL),(949,43,18,NULL,NULL),(950,43,19,NULL,NULL),(951,43,20,NULL,NULL),(952,43,6,NULL,NULL),(953,43,21,NULL,NULL),(954,43,22,NULL,NULL),(955,43,23,NULL,NULL),(956,43,24,NULL,NULL),(957,43,25,NULL,NULL),(958,43,26,NULL,NULL),(959,43,27,NULL,NULL),(960,43,28,NULL,NULL),(961,43,29,NULL,NULL),(962,43,50,NULL,NULL),(963,44,7,NULL,NULL),(964,44,8,NULL,NULL),(965,44,9,NULL,NULL),(966,44,10,NULL,NULL),(967,44,11,NULL,NULL),(968,44,12,NULL,NULL),(969,44,13,NULL,NULL),(970,44,14,NULL,NULL),(971,44,15,NULL,NULL),(972,44,16,NULL,NULL),(973,44,17,NULL,NULL),(974,44,18,NULL,NULL),(975,44,19,NULL,NULL),(976,44,20,NULL,NULL),(977,44,6,NULL,NULL),(978,44,21,NULL,NULL),(979,44,22,NULL,NULL),(980,44,23,NULL,NULL),(981,44,24,NULL,NULL),(982,44,25,NULL,NULL),(983,44,26,NULL,NULL),(984,44,27,NULL,NULL),(985,44,28,NULL,NULL),(986,44,29,NULL,NULL),(987,45,51,NULL,NULL),(988,45,52,NULL,NULL),(989,45,53,NULL,NULL),(990,46,7,NULL,NULL),(991,46,8,NULL,NULL),(992,46,9,NULL,NULL),(993,46,10,NULL,NULL),(994,46,11,NULL,NULL),(995,46,12,NULL,NULL),(996,46,13,NULL,NULL),(997,46,14,NULL,NULL),(998,46,15,NULL,NULL),(999,46,16,NULL,NULL),(1000,46,17,NULL,NULL),(1001,46,18,NULL,NULL),(1002,46,19,NULL,NULL),(1003,46,20,NULL,NULL),(1004,46,6,NULL,NULL),(1005,46,21,NULL,NULL),(1006,46,22,NULL,NULL),(1007,46,23,NULL,NULL),(1008,46,24,NULL,NULL),(1009,46,25,NULL,NULL),(1010,46,26,NULL,NULL),(1011,46,27,NULL,NULL),(1012,46,28,NULL,NULL),(1013,46,29,NULL,NULL),(1014,46,54,NULL,NULL),(1015,46,30,NULL,NULL),(1016,46,31,NULL,NULL),(1017,46,32,NULL,NULL),(1018,46,33,NULL,NULL),(1019,47,7,NULL,NULL),(1020,47,8,NULL,NULL),(1021,47,9,NULL,NULL),(1022,47,10,NULL,NULL),(1023,47,11,NULL,NULL),(1024,47,12,NULL,NULL),(1025,47,13,NULL,NULL),(1026,47,14,NULL,NULL),(1027,47,15,NULL,NULL),(1028,47,16,NULL,NULL),(1029,47,17,NULL,NULL),(1030,47,18,NULL,NULL),(1031,47,19,NULL,NULL),(1032,47,20,NULL,NULL),(1033,47,6,NULL,NULL),(1034,47,21,NULL,NULL),(1035,47,22,NULL,NULL),(1036,47,23,NULL,NULL),(1037,47,24,NULL,NULL),(1038,47,25,NULL,NULL),(1039,47,26,NULL,NULL),(1040,47,27,NULL,NULL),(1041,47,28,NULL,NULL),(1042,47,29,NULL,NULL),(1043,47,55,NULL,NULL),(1044,47,30,NULL,NULL),(1045,47,31,NULL,NULL),(1046,47,32,NULL,NULL),(1047,47,33,NULL,NULL),(1048,48,20,NULL,NULL),(1049,48,56,NULL,NULL),(1050,1,1,NULL,NULL),(1051,6,1,NULL,NULL),(1052,10,1,NULL,NULL),(1053,16,1,NULL,NULL),(1054,20,1,NULL,NULL),(1055,49,7,NULL,NULL),(1056,49,8,NULL,NULL),(1057,49,9,NULL,NULL),(1058,49,10,NULL,NULL),(1059,49,11,NULL,NULL),(1060,49,12,NULL,NULL),(1061,49,13,NULL,NULL),(1062,49,14,NULL,NULL),(1063,49,15,NULL,NULL),(1064,49,16,NULL,NULL),(1065,49,17,NULL,NULL),(1066,49,18,NULL,NULL),(1067,49,19,NULL,NULL),(1068,49,20,NULL,NULL),(1069,49,6,NULL,NULL),(1070,49,21,NULL,NULL),(1071,49,22,NULL,NULL),(1072,49,23,NULL,NULL),(1073,49,24,NULL,NULL),(1074,49,25,NULL,NULL),(1075,49,26,NULL,NULL),(1076,49,27,NULL,NULL),(1077,49,28,NULL,NULL),(1078,49,29,NULL,NULL),(1079,49,30,NULL,NULL),(1080,49,31,NULL,NULL),(1081,49,32,NULL,NULL),(1082,49,33,NULL,NULL),(1104,51,7,NULL,NULL),(1105,51,8,NULL,NULL),(1106,51,9,NULL,NULL),(1107,51,10,NULL,NULL),(1108,51,11,NULL,NULL),(1109,51,12,NULL,NULL),(1110,51,13,NULL,NULL),(1111,51,14,NULL,NULL),(1112,51,15,NULL,NULL),(1113,51,16,NULL,NULL),(1114,51,17,NULL,NULL),(1115,51,18,NULL,NULL),(1116,51,19,NULL,NULL),(1117,51,20,NULL,NULL),(1118,51,6,NULL,NULL),(1119,51,22,NULL,NULL),(1120,51,23,NULL,NULL),(1121,51,24,NULL,NULL),(1122,51,25,NULL,NULL),(1123,51,26,NULL,NULL),(1124,51,27,NULL,NULL),(1125,51,28,NULL,NULL),(1126,51,29,NULL,NULL),(1127,51,30,NULL,NULL),(1128,51,31,NULL,NULL),(1129,51,32,NULL,NULL),(1130,51,33,NULL,NULL),(1131,52,7,NULL,NULL),(1132,52,8,NULL,NULL),(1133,52,9,NULL,NULL),(1134,52,10,NULL,NULL),(1135,52,11,NULL,NULL),(1136,52,12,NULL,NULL),(1137,52,13,NULL,NULL),(1138,52,14,NULL,NULL),(1139,52,15,NULL,NULL),(1140,52,16,NULL,NULL),(1141,52,17,NULL,NULL),(1142,52,18,NULL,NULL),(1143,52,19,NULL,NULL),(1144,52,20,NULL,NULL),(1145,52,6,NULL,NULL),(1146,52,22,NULL,NULL),(1147,52,23,NULL,NULL),(1148,52,24,NULL,NULL),(1149,52,25,NULL,NULL),(1150,52,26,NULL,NULL),(1151,52,27,NULL,NULL),(1152,52,28,NULL,NULL),(1153,52,29,NULL,NULL),(1154,52,30,NULL,NULL),(1155,52,31,NULL,NULL),(1156,52,32,NULL,NULL),(1157,52,33,NULL,NULL),(1158,53,7,NULL,NULL),(1159,53,8,NULL,NULL),(1160,53,9,NULL,NULL),(1161,53,10,NULL,NULL),(1162,53,11,NULL,NULL),(1163,53,12,NULL,NULL),(1164,53,13,NULL,NULL),(1165,53,14,NULL,NULL),(1166,53,15,NULL,NULL),(1167,53,16,NULL,NULL),(1168,53,17,NULL,NULL),(1169,53,18,NULL,NULL),(1170,53,19,NULL,NULL),(1171,53,20,NULL,NULL),(1172,53,6,NULL,NULL),(1173,53,22,NULL,NULL),(1174,53,23,NULL,NULL),(1175,53,24,NULL,NULL),(1176,53,25,NULL,NULL),(1177,53,26,NULL,NULL),(1178,53,27,NULL,NULL),(1179,53,28,NULL,NULL),(1180,53,29,NULL,NULL),(1181,53,30,NULL,NULL),(1182,53,31,NULL,NULL),(1183,53,32,NULL,NULL),(1184,53,33,NULL,NULL),(1185,54,7,NULL,NULL),(1186,54,8,NULL,NULL),(1187,54,9,NULL,NULL),(1188,54,11,NULL,NULL),(1189,54,20,NULL,NULL),(1190,54,28,NULL,NULL),(1191,54,58,NULL,NULL),(1192,54,10,NULL,NULL),(1193,54,12,NULL,NULL),(1194,54,13,NULL,NULL),(1195,54,14,NULL,NULL),(1196,54,15,NULL,NULL),(1197,54,16,NULL,NULL),(1198,54,17,NULL,NULL),(1199,54,18,NULL,NULL),(1200,54,19,NULL,NULL),(1201,54,6,NULL,NULL),(1202,54,22,NULL,NULL),(1203,54,23,NULL,NULL),(1204,54,24,NULL,NULL),(1205,54,25,NULL,NULL),(1206,54,26,NULL,NULL),(1207,54,27,NULL,NULL),(1208,54,29,NULL,NULL),(1209,54,30,NULL,NULL),(1210,54,31,NULL,NULL),(1211,54,32,NULL,NULL),(1212,54,33,NULL,NULL),(1213,55,7,NULL,NULL),(1214,55,8,NULL,NULL),(1215,55,9,NULL,NULL),(1216,55,11,NULL,NULL),(1217,55,20,NULL,NULL),(1218,55,28,NULL,NULL),(1219,55,58,NULL,NULL),(1220,55,10,NULL,NULL),(1221,55,12,NULL,NULL),(1222,55,13,NULL,NULL),(1223,55,14,NULL,NULL),(1224,55,15,NULL,NULL),(1225,55,16,NULL,NULL),(1226,55,17,NULL,NULL),(1227,55,18,NULL,NULL),(1228,55,19,NULL,NULL),(1229,55,6,NULL,NULL),(1230,55,22,NULL,NULL),(1231,55,23,NULL,NULL),(1232,55,24,NULL,NULL),(1233,55,25,NULL,NULL),(1234,55,26,NULL,NULL),(1235,55,27,NULL,NULL),(1236,55,29,NULL,NULL),(1237,55,30,NULL,NULL),(1238,55,31,NULL,NULL),(1239,55,32,NULL,NULL),(1240,55,33,NULL,NULL),(1241,56,7,NULL,NULL),(1242,56,8,NULL,NULL),(1243,56,9,NULL,NULL),(1244,56,11,NULL,NULL),(1245,56,20,NULL,NULL),(1246,56,28,NULL,NULL),(1247,56,58,NULL,NULL),(1248,56,10,NULL,NULL),(1249,56,12,NULL,NULL),(1250,56,13,NULL,NULL),(1251,56,14,NULL,NULL),(1252,56,15,NULL,NULL),(1253,56,16,NULL,NULL),(1254,56,17,NULL,NULL),(1255,56,18,NULL,NULL),(1256,56,19,NULL,NULL),(1257,56,6,NULL,NULL),(1258,56,22,NULL,NULL),(1259,56,23,NULL,NULL),(1260,56,24,NULL,NULL),(1261,56,25,NULL,NULL),(1262,56,26,NULL,NULL),(1263,56,27,NULL,NULL),(1264,56,29,NULL,NULL),(1265,56,30,NULL,NULL),(1266,56,31,NULL,NULL),(1267,56,32,NULL,NULL),(1268,56,33,NULL,NULL),(1269,57,7,NULL,NULL),(1270,57,8,NULL,NULL),(1271,57,9,NULL,NULL),(1272,57,11,NULL,NULL),(1273,57,20,NULL,NULL),(1274,57,28,NULL,NULL),(1275,57,58,NULL,NULL),(1276,57,10,NULL,NULL),(1277,57,12,NULL,NULL),(1278,57,13,NULL,NULL),(1279,57,14,NULL,NULL),(1280,57,15,NULL,NULL),(1281,57,16,NULL,NULL),(1282,57,17,NULL,NULL),(1283,57,18,NULL,NULL),(1284,57,19,NULL,NULL),(1285,57,6,NULL,NULL),(1286,57,22,NULL,NULL),(1287,57,23,NULL,NULL),(1288,57,24,NULL,NULL),(1289,57,25,NULL,NULL),(1290,57,26,NULL,NULL),(1291,57,27,NULL,NULL),(1292,57,29,NULL,NULL),(1293,57,30,NULL,NULL),(1294,57,31,NULL,NULL),(1295,57,32,NULL,NULL),(1296,57,33,NULL,NULL),(1297,58,7,NULL,NULL),(1298,58,8,NULL,NULL),(1299,58,9,NULL,NULL),(1300,58,11,NULL,NULL),(1301,58,20,NULL,NULL),(1302,58,28,NULL,NULL),(1303,58,58,NULL,NULL),(1304,58,10,NULL,NULL),(1305,58,12,NULL,NULL),(1306,58,13,NULL,NULL),(1307,58,14,NULL,NULL),(1308,58,15,NULL,NULL),(1309,58,16,NULL,NULL),(1310,58,17,NULL,NULL),(1311,58,18,NULL,NULL),(1312,58,19,NULL,NULL),(1313,58,6,NULL,NULL),(1314,58,22,NULL,NULL),(1315,58,23,NULL,NULL),(1316,58,24,NULL,NULL),(1317,58,25,NULL,NULL),(1318,58,26,NULL,NULL),(1319,58,27,NULL,NULL),(1320,58,29,NULL,NULL),(1321,58,30,NULL,NULL),(1322,58,31,NULL,NULL),(1323,58,32,NULL,NULL),(1324,58,33,NULL,NULL),(1325,59,7,NULL,NULL),(1326,59,8,NULL,NULL),(1327,59,9,NULL,NULL),(1328,59,11,NULL,NULL),(1329,59,20,NULL,NULL),(1330,59,28,NULL,NULL),(1331,59,58,NULL,NULL),(1332,59,10,NULL,NULL),(1333,59,12,NULL,NULL),(1334,59,13,NULL,NULL),(1335,59,14,NULL,NULL),(1336,59,15,NULL,NULL),(1337,59,16,NULL,NULL),(1338,59,17,NULL,NULL),(1339,59,18,NULL,NULL),(1340,59,19,NULL,NULL),(1341,59,6,NULL,NULL),(1342,59,22,NULL,NULL),(1343,59,23,NULL,NULL),(1344,59,24,NULL,NULL),(1345,59,25,NULL,NULL),(1346,59,26,NULL,NULL),(1347,59,27,NULL,NULL),(1348,59,29,NULL,NULL),(1349,59,30,NULL,NULL),(1350,59,31,NULL,NULL),(1351,59,32,NULL,NULL),(1352,59,33,NULL,NULL),(1353,60,7,NULL,NULL),(1354,60,8,NULL,NULL),(1355,60,9,NULL,NULL),(1356,60,11,NULL,NULL),(1357,60,20,NULL,NULL),(1358,60,28,NULL,NULL),(1359,60,58,NULL,NULL),(1360,60,10,NULL,NULL),(1361,60,12,NULL,NULL),(1362,60,13,NULL,NULL),(1363,60,14,NULL,NULL),(1364,60,15,NULL,NULL),(1365,60,16,NULL,NULL),(1366,60,17,NULL,NULL),(1367,60,18,NULL,NULL),(1368,60,19,NULL,NULL),(1369,60,6,NULL,NULL),(1370,60,22,NULL,NULL),(1371,60,23,NULL,NULL),(1372,60,24,NULL,NULL),(1373,60,25,NULL,NULL),(1374,60,26,NULL,NULL),(1375,60,27,NULL,NULL),(1376,60,29,NULL,NULL),(1377,60,30,NULL,NULL),(1378,60,31,NULL,NULL),(1379,60,32,NULL,NULL),(1380,60,33,NULL,NULL),(1381,61,7,NULL,NULL),(1382,61,8,NULL,NULL),(1383,61,9,NULL,NULL),(1384,61,11,NULL,NULL),(1385,61,20,NULL,NULL),(1386,61,28,NULL,NULL),(1387,61,59,NULL,NULL),(1388,62,7,NULL,NULL),(1389,62,8,NULL,NULL),(1390,62,9,NULL,NULL),(1391,62,11,NULL,NULL),(1392,62,20,NULL,NULL),(1393,62,28,NULL,NULL),(1394,62,59,NULL,NULL),(1395,63,7,NULL,NULL),(1396,63,8,NULL,NULL),(1397,63,9,NULL,NULL),(1398,63,11,NULL,NULL),(1399,63,20,NULL,NULL),(1400,63,28,NULL,NULL),(1401,63,59,NULL,NULL),(1402,64,1,NULL,NULL),(1403,64,60,NULL,NULL),(1404,64,61,NULL,NULL),(1405,64,62,NULL,NULL),(1406,64,63,NULL,NULL),(1407,64,64,NULL,NULL),(1408,64,65,NULL,NULL),(1409,64,66,NULL,NULL),(1410,64,3,NULL,NULL),(1411,65,67,NULL,NULL),(1412,66,1,NULL,NULL),(1413,66,56,NULL,NULL),(1414,66,68,NULL,NULL),(1415,66,51,NULL,NULL),(1416,66,52,NULL,NULL),(1417,66,53,NULL,NULL),(1418,67,7,NULL,NULL),(1419,67,8,NULL,NULL),(1420,67,9,NULL,NULL),(1421,67,10,NULL,NULL),(1422,67,11,NULL,NULL),(1423,67,12,NULL,NULL),(1424,67,13,NULL,NULL),(1425,67,14,NULL,NULL),(1426,67,15,NULL,NULL),(1427,67,16,NULL,NULL),(1428,67,17,NULL,NULL),(1429,67,18,NULL,NULL),(1430,67,19,NULL,NULL),(1431,67,20,NULL,NULL),(1432,67,6,NULL,NULL),(1433,67,22,NULL,NULL),(1434,67,23,NULL,NULL),(1435,67,24,NULL,NULL),(1436,67,25,NULL,NULL),(1437,67,26,NULL,NULL),(1438,67,27,NULL,NULL),(1439,67,28,NULL,NULL),(1440,67,29,NULL,NULL),(1441,67,30,NULL,NULL),(1442,67,31,NULL,NULL),(1443,67,32,NULL,NULL),(1444,67,33,NULL,NULL),(1445,68,7,NULL,NULL),(1446,68,8,NULL,NULL),(1447,68,9,NULL,NULL),(1448,68,10,NULL,NULL),(1449,68,11,NULL,NULL),(1450,68,12,NULL,NULL),(1451,68,13,NULL,NULL),(1452,68,14,NULL,NULL),(1453,68,15,NULL,NULL),(1454,68,16,NULL,NULL),(1455,68,17,NULL,NULL),(1456,68,18,NULL,NULL),(1457,68,19,NULL,NULL),(1458,68,20,NULL,NULL),(1459,68,6,NULL,NULL),(1460,68,22,NULL,NULL),(1461,68,23,NULL,NULL),(1462,68,24,NULL,NULL),(1463,68,25,NULL,NULL),(1464,68,26,NULL,NULL),(1465,68,27,NULL,NULL),(1466,68,28,NULL,NULL),(1467,68,29,NULL,NULL),(1468,68,30,NULL,NULL),(1469,68,31,NULL,NULL),(1470,68,32,NULL,NULL),(1471,68,33,NULL,NULL),(1472,69,7,NULL,NULL),(1473,69,8,NULL,NULL),(1474,69,9,NULL,NULL),(1475,69,10,NULL,NULL),(1476,69,11,NULL,NULL),(1477,69,12,NULL,NULL),(1478,69,13,NULL,NULL),(1479,69,14,NULL,NULL),(1480,69,15,NULL,NULL),(1481,69,16,NULL,NULL),(1482,69,17,NULL,NULL),(1483,69,18,NULL,NULL),(1484,69,19,NULL,NULL),(1485,69,20,NULL,NULL),(1486,69,6,NULL,NULL),(1487,69,22,NULL,NULL),(1488,69,23,NULL,NULL),(1489,69,24,NULL,NULL),(1490,69,25,NULL,NULL),(1491,69,26,NULL,NULL),(1492,69,27,NULL,NULL),(1493,69,28,NULL,NULL),(1494,69,29,NULL,NULL),(1495,69,30,NULL,NULL),(1496,69,31,NULL,NULL),(1497,69,32,NULL,NULL),(1498,69,33,NULL,NULL),(1499,50,69,NULL,NULL),(1500,50,70,NULL,NULL),(1501,70,7,NULL,NULL),(1502,70,8,NULL,NULL),(1503,70,9,NULL,NULL),(1504,70,10,NULL,NULL),(1505,70,11,NULL,NULL),(1506,70,12,NULL,NULL),(1507,70,13,NULL,NULL),(1508,70,14,NULL,NULL),(1509,70,15,NULL,NULL),(1510,70,16,NULL,NULL),(1511,70,17,NULL,NULL),(1512,70,18,NULL,NULL),(1513,70,19,NULL,NULL),(1514,70,20,NULL,NULL),(1515,70,6,NULL,NULL),(1516,70,21,NULL,NULL),(1517,70,22,NULL,NULL),(1518,70,23,NULL,NULL),(1519,70,24,NULL,NULL),(1520,70,25,NULL,NULL),(1521,70,26,NULL,NULL),(1522,70,27,NULL,NULL),(1523,70,28,NULL,NULL),(1524,70,29,NULL,NULL),(1525,70,30,NULL,NULL),(1526,70,31,NULL,NULL),(1527,70,32,NULL,NULL),(1528,70,33,NULL,NULL),(1529,71,7,NULL,NULL),(1530,71,8,NULL,NULL),(1531,71,9,NULL,NULL),(1532,71,10,NULL,NULL),(1533,71,11,NULL,NULL),(1534,71,12,NULL,NULL),(1535,71,13,NULL,NULL),(1536,71,14,NULL,NULL),(1537,71,15,NULL,NULL),(1538,71,16,NULL,NULL),(1539,71,17,NULL,NULL),(1540,71,18,NULL,NULL),(1541,71,19,NULL,NULL),(1542,71,20,NULL,NULL),(1543,71,6,NULL,NULL),(1544,71,21,NULL,NULL),(1545,71,22,NULL,NULL),(1546,71,23,NULL,NULL),(1547,71,24,NULL,NULL),(1548,71,25,NULL,NULL),(1549,71,26,NULL,NULL),(1550,71,27,NULL,NULL),(1551,71,28,NULL,NULL),(1552,71,29,NULL,NULL),(1553,71,30,NULL,NULL),(1554,71,31,NULL,NULL),(1555,71,32,NULL,NULL),(1556,71,33,NULL,NULL),(1557,72,7,NULL,NULL),(1558,72,8,NULL,NULL),(1559,72,9,NULL,NULL),(1560,72,10,NULL,NULL),(1561,72,11,NULL,NULL),(1562,72,12,NULL,NULL),(1563,72,13,NULL,NULL),(1564,72,14,NULL,NULL),(1565,72,15,NULL,NULL),(1566,72,16,NULL,NULL),(1567,72,17,NULL,NULL),(1568,72,18,NULL,NULL),(1569,72,19,NULL,NULL),(1570,72,20,NULL,NULL),(1571,72,6,NULL,NULL),(1572,72,21,NULL,NULL),(1573,72,22,NULL,NULL),(1574,72,23,NULL,NULL),(1575,72,24,NULL,NULL),(1576,72,25,NULL,NULL),(1577,72,26,NULL,NULL),(1578,72,27,NULL,NULL),(1579,72,28,NULL,NULL),(1580,72,29,NULL,NULL),(1581,72,30,NULL,NULL),(1582,72,31,NULL,NULL),(1583,72,32,NULL,NULL),(1584,72,33,NULL,NULL),(1585,73,7,NULL,NULL),(1586,73,8,NULL,NULL),(1587,73,9,NULL,NULL),(1588,73,10,NULL,NULL),(1589,73,11,NULL,NULL),(1590,73,12,NULL,NULL),(1591,73,13,NULL,NULL),(1592,73,14,NULL,NULL),(1593,73,15,NULL,NULL),(1594,73,16,NULL,NULL),(1595,73,17,NULL,NULL),(1596,73,18,NULL,NULL),(1597,73,19,NULL,NULL),(1598,73,20,NULL,NULL),(1599,73,6,NULL,NULL),(1600,73,21,NULL,NULL),(1601,73,22,NULL,NULL),(1602,73,23,NULL,NULL),(1603,73,24,NULL,NULL),(1604,73,25,NULL,NULL),(1605,73,26,NULL,NULL),(1606,73,27,NULL,NULL),(1607,73,28,NULL,NULL),(1608,73,29,NULL,NULL),(1609,73,30,NULL,NULL),(1610,73,31,NULL,NULL),(1611,73,32,NULL,NULL),(1612,73,33,NULL,NULL),(1613,74,7,NULL,NULL),(1614,74,8,NULL,NULL),(1615,74,9,NULL,NULL),(1616,74,10,NULL,NULL),(1617,74,11,NULL,NULL),(1618,74,12,NULL,NULL),(1619,74,13,NULL,NULL),(1620,74,14,NULL,NULL),(1621,74,15,NULL,NULL),(1622,74,16,NULL,NULL),(1623,74,17,NULL,NULL),(1624,74,18,NULL,NULL),(1625,74,19,NULL,NULL),(1626,74,20,NULL,NULL),(1627,74,6,NULL,NULL),(1628,74,21,NULL,NULL),(1629,74,22,NULL,NULL),(1630,74,23,NULL,NULL),(1631,74,24,NULL,NULL),(1632,74,25,NULL,NULL),(1633,74,26,NULL,NULL),(1634,74,27,NULL,NULL),(1635,74,28,NULL,NULL),(1636,74,29,NULL,NULL),(1637,74,30,NULL,NULL),(1638,74,31,NULL,NULL),(1639,74,32,NULL,NULL),(1640,74,33,NULL,NULL);
/*!40000 ALTER TABLE `notify_shortcode_notify_template_draft` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_shortcodes`
--

DROP TABLE IF EXISTS `notify_shortcodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_shortcodes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `key_name` varchar(50) NOT NULL,
  `shortcode` varchar(100) NOT NULL,
  `desc_lang_key` varchar(255) NOT NULL,
  `plugin_name` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `notify_shortcodes_key_name_unique` (`key_name`),
  UNIQUE KEY `notify_shortcodes_shortcode_unique` (`shortcode`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_shortcodes`
--

LOCK TABLES `notify_shortcodes` WRITE;
/*!40000 ALTER TABLE `notify_shortcodes` DISABLE KEYS */;
INSERT INTO `notify_shortcodes` VALUES (1,'receiver_name','{!! $receiver_name !!}','receiver_name_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(2,'system_link','{!! $system_link !!}','system_link_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3,'system_name','{!! $system_name !!}','system_name_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4,'company_name','{!! $company_name !!}','company_name_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(5,'company_link','{!! $company_link !!}','company_link_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(6,'activity_by','{!! $activity_by !!}','activity_by_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(7,'ticket_link','{!! $ticket_link !!}','ticket_link_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(8,'ticket_number','{!! $ticket_number !!}','ticket_number_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(9,'ticket_subject','{!! $ticket_subject !!}','ticket_subject_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(10,'ticket_due_date','{!! $ticket_due_date !!}','ticket_due_date_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(11,'ticket_created_at','{!! $ticket_created_at !!}','ticket_created_at_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(12,'department_signature','{!! $department_signature !!}','department_signature_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(13,'agent_name','{!! $agent_name !!}','agent_name_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(14,'agent_email','{!! $agent_email !!}','agent_email_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(15,'agent_contact','{!! $agent_contact !!}','agent_contact_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(16,'agent_sign','{!! $agent_sign !!}','agent_sign_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(17,'client_name','{!! $client_name !!}','client_name_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(18,'client_email','{!! $client_email !!}','client_email_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(19,'client_contact','{!! $client_contact !!}','client_contact_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(20,'message_content','{!! $message_content !!}','message_content_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(21,'ticket_link_for_clients','{!! $ticket_link_for_clients !!}','ticket_link_for_clients_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(22,'ticket_priority','{!! $ticket_priority !!}','ticket_priority_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(23,'ticket_department','{!! $ticket_department !!}','ticket_department_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(24,'ticket_sla','{!! $ticket_sla !!}','ticket_sla_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(25,'ticket_source','{!! $ticket_source !!}','ticket_source_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(26,'ticket_helptopic','{!! $ticket_helptopic !!}','ticket_helptopic_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(27,'assigned_team_name','{!! $assigned_team_name !!}','assigned_team_name_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(28,'ticket_title','{!! $ticket_title !!}','ticket_title_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(29,'ticket_status','{!! $ticket_status !!}','ticket_status_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(30,'actor_name','{!! $actor_name !!}','actor_name_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(31,'actor_email','{!! $actor_email !!}','actor_email_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(32,'actor_contact','{!! $actor_contact !!}','actor_contact_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(33,'actor_sign','{!! $actor_sign !!}','actor_sign_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(34,'new_user_name','{!! $new_user_name !!}','new_user_name_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(35,'new_user_email','{!! $new_user_email !!}','new_user_email_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(36,'user_profile_link','{!! $user_profile_link !!}','user_profile_link_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(37,'user_password','{!! $user_password !!}','user_password_desc_key',NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(38,'rating_value','{!! $rating_value !!}','rating_value_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(39,'account_activation_link','{!! $account_activation_link !!}','account_activation_link_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(40,'password_reset_link','{!! $password_reset_link !!}','password_reset_link_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(41,'login_name','{!! $login_name !!}','login_name_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(42,'login_appName','{!! $login_appName !!}','login_appName_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(43,'login_accountEmail','{!! $login_accountEmail !!}','login_accountEmail_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(44,'login_time','{!! $login_time !!}','login_time_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(45,'login_ipAddress','{!! $login_ipAddress !!}','login_ipAddress_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(46,'login_browser','{!! $login_browser !!}','login_browser_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(47,'login_platform','{!! $login_platform !!}','login_platform_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(48,'login_device','{!! $login_device !!}','login_device_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(49,'version','{!! $version !!}','version_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(50,'ratings_icon_with_link','{!! $ratings_icon_with_link !!}','ratings_icon_with_link_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(51,'report_type','{!! $report_type !!}','report_type_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(52,'report_link','{!! $report_link !!}','report_link_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(53,'report_expiry','{!! $report_expiry !!}','report_expiry_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(54,'ticket_conversation','{!! $ticket_conversation !!}','ticket_conversation_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(55,'approval_link','{!! $approval_link !!}','approval_link_desc_key',NULL,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(56,'subject','{!! $subject !!}','subject_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(57,'portal_logo','{!! $portal_logo !!}','portal_logo_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(58,'parent_ticket','{!! $parent_ticket !!}','parent_ticket_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(59,'child_ticket','{!! $child_ticket !!}','child_ticket_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(60,'job_name','{!! $job_name !!}','job_name_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(61,'job_details','{!! $job_details !!}','job_details_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(62,'connection_name','{!! $connection_name !!}','connection_name_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(63,'exception_message','{!! $exception_message !!}','exception_message_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(64,'exception_line','{!! $exception_line !!}','exception_line_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(65,'exception_file','{!! $exception_file !!}','exception_file_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(66,'exception_trace','{!! $exception_trace !!}','exception_trace_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(67,'export_link','{!! $export_link !!}','export_link_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(68,'description','{!! $description !!}','description_desc_key',NULL,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(69,'ticket_activity_log','{!! $ticket_activity_log !!}','ticket_activity_log_desc_key',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(70,'ticket_approval_activity_log','{!! $ticket_approval_activity_log !!}','ticket_approval_activity_log_desc_key',NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `notify_shortcodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_template_categories`
--

DROP TABLE IF EXISTS `notify_template_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_template_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(50) NOT NULL,
  `lang_key` varchar(100) NOT NULL,
  `desc_lang_key` varchar(150) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `notify_template_categories_category_unique` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_template_categories`
--

LOCK TABLES `notify_template_categories` WRITE;
/*!40000 ALTER TABLE `notify_template_categories` DISABLE KEYS */;
INSERT INTO `notify_template_categories` VALUES (1,'agent_templates','agent_templates_lang_key','agent_templates_desc_key','2025-01-03 04:07:28','2025-01-03 04:07:28'),(2,'client_templates','client_templates_lang_key','client_templates_desc_key','2025-01-03 04:07:28','2025-01-03 04:07:28'),(3,'org_mngr_templates','org_mngr_templates_lang_key','org_mngr_templates_desc_key','2025-01-03 04:07:28','2025-01-03 04:07:28'),(4,'assigned_agent_templates','assigned_agent_templates_lang_key','assigned_agent_templates_desc_key','2025-01-03 04:07:28','2025-01-03 04:07:28'),(5,'common_templates','common_templates_lang_key','common_templates_desc_key','2025-01-03 04:07:28','2025-01-03 04:07:28');
/*!40000 ALTER TABLE `notify_template_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_template_drafts`
--

DROP TABLE IF EXISTS `notify_template_drafts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_template_drafts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `template` varchar(150) NOT NULL,
  `desc_lang_key` varchar(150) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `long_message` text NOT NULL,
  `short_message` text NOT NULL,
  `category_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `notify_template_drafts_template_unique` (`template`),
  KEY `notify_template_drafts_category_id_foreign` (`category_id`),
  CONSTRAINT `notify_template_drafts_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `notify_template_categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_template_drafts`
--

LOCK TABLES `notify_template_drafts` WRITE;
/*!40000 ALTER TABLE `notify_template_drafts` DISABLE KEYS */;
INSERT INTO `notify_template_drafts` VALUES (1,'new_ticket_alert_template','new_ticket_alert_template_desc_key','#{!! $ticket_number !!} | New ticket has been created','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />New ticket with ID: {!! $ticket_number !!} has been created in our helpdesk.<br /><br /><strong>Client Details</strong><br /><strong>Name:</strong> {!! $client_name !!}<br /><strong>E-mail:</strong> {!! $client_email !!}<br /><br /><strong>Message</strong><br />{!! $message_content !!}</p>Kind regards,<br />{!! $system_name !!}</p></div></div>','#{!! $ticket_number !!} : New ticket has been created in the system',1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(2,'ticket_created_by_agent_ack_template','ticket_created_by_agent_ack_template_desc_key','#{!! $ticket_number !!} | Your Request has been received','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Thank you for contacting us. This is to confirm that our agent has logged your request in our support system. When replying, please make sure that the ticket ID is kept in the subject so that we can track your replies.<br /><br /><strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />You can check the status of or update this ticket online at: <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_link !!}</a></p>{!! $department_signature !!}</div></div>','#{!! $ticket_number !!} : Our agent has created your ticket',2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3,'ticket_created_by_agent_ack_org_template','ticket_created_by_agent_ack_org_template_desc_key','#{!! $ticket_number !!} | A ticket has been requested','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/>Our agent has created a new ticket for a request of your organization&#39;s member.</p><p><strong>Ticket ID:</strong>&nbsp; {!! $ticket_number !!}<br/><br/><strong>Member&#39;s Details:</strong><br/><strong>Name:</strong>&nbsp; {!! $client_name !!}<br/><strong>E-mail:</strong> {!! $client_email !!}<br/><br/><strong>Message:</strong><br/>{!! $message_content !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : Our agent has created your organization ticket',3,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4,'ticket_created_by_client_ack_template','ticket_created_by_client_ack_template_desc_key','#{!! $ticket_number !!} | Your Request has been received','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Thank you for contacting us. This is an automated response confirming the receipt of your ticket. Our team will get back to you as soon as possible. When replying, please make sure that the ticket ID is kept in the subject so that we can track your replies.<br /><br /><strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><br />You can check the status of or update this ticket online at: <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_link !!}</a></p>{!! $department_signature !!}</div></div>','#{!! $ticket_number !!} : Your ticket has been created.',2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(5,'ticket_created_by_client_ack_org_template','ticket_created_by_client_ack_org_template_desc_key','#{!! $ticket_number !!} | A ticket has been requested','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/>A member of your organization has created a new ticket in our helpdesk system.</p><p><strong>Ticket ID:</strong>&nbsp; {!! $ticket_number !!}<br/><br/><strong>Member&#39;s Details</strong><br/><strong>Name:</strong>&nbsp; {!! $client_name !!}<br/><strong>E-mail:</strong> {!! $client_email !!}<br/><br/><strong>Message</strong><br/>{!! $message_content !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : Your organization ticket has been created',3,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(6,'template_ticket_reply_to_agents_by_agent_template','template_ticket_reply_to_agents_by_agent_template_desc_key','#{!! $ticket_number !!} | New agent reply on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />An agent has replied to a ticket with ID: {!! $ticket_number !!}.<br /><br /><strong>Reply content:</strong><br />{!! $message_content !!}<br /><br /><strong>Ticket link:</strong> <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a><br /><br /></p>{!! $agent_signature !!}</div></div>','#{!! $ticket_number !!} : An agent has replied on the ticket',1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(7,'template_ticket_reply_to_assigned_agents_by_agent_template','template_ticket_reply_to_assigned_agents_by_agent_template_desc_key','#{!! $ticket_number !!} | New agent reply on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p> Hello {!! $receiver_name !!},<br /><br />A reply has been made to a ticket assigned to you with ID: {!! $ticket_number !!} by {!! $activity_by !!} in our helpdesk system.<br /><br /><strong>Reply content</strong><br />{!! $message_content !!}<br /><br /><strong>Ticket link</strong><br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a><br /><br /></p>{!! $agent_signature !!}</div></div>','#{!! $ticket_number !!} : An agent has replied on your assigned ticket',4,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(8,'template_ticket_reply_to_client_by_agent_template','template_ticket_reply_to_client_by_agent_template_desc_key','#{!! $ticket_number !!} | New reply on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\">{!! $message_content !!}<br /><br /><strong>Ticket Details</strong><br/><strong>Ticket ID:</strong> {!! $ticket_number !!}<br />{!! $agent_signature !!}</div></div>','#{!! $ticket_number !!} : New reply on your ticket',2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(9,'template_ticket_reply_to_org_mngr_by_agent_template','template_ticket_reply_to_org_mngr_by_agent_template_desc_key','#{!! $ticket_number !!} | New reply on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\">{!! $message_content !!}<br /><br /><strong>Ticket Details</strong><br/><strong>Ticket ID:</strong> {!! $ticket_number !!}<br />{!! $agent_signature !!}</div></div>','#{!! $ticket_number !!} : New reply on your ticket organization ticket',3,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(10,'template_ticket_reply_to_agents_by_client_template','template_ticket_reply_to_agents_by_client_template_desc_key','#{!! $ticket_number !!} | New response on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Client has made a new reply on their ticket in our helpdesk system.<br /><br /><strong>Ticket ID:</strong>  {!! $ticket_number !!}<br /><br /><strong>Reply Message:</strong><br />{!! $message_content !!}<br /><br />Please follow the link below to check and reply on ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : new response on the ticket.',1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(11,'template_ticket_reply_to_assigned_agents_by_client_template','template_ticket_reply_to_assigned_agents_by_client_template_desc_key','#{!! $ticket_number !!} | New response on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Client has made a new reply on their ticket which is assigned to you.<br /><br /><strong>Ticket ID:</strong>  {!! $ticket_number !!}<br /><br /><strong>Reply Message</strong><br />{!! $message_content !!}<br /><br />Please follow the link below to check and reply on ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : new response on your assigned ticket.',4,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(12,'template_ticket_reply_to_client_by_client_template','template_ticket_reply_to_client_by_client_template_desc_key','#{!! $ticket_number !!} | New reply on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />{!! $activity_by !!} has made a new reply on the ticket with Id <strong>{!! $ticket_number !!}</strong><br /><br /><strong>Reply Message</strong><br />{!! $message_content !!}<br /><br />Please follow the link below to check and reply on ticket.<br /><a href=\"{!! $ticket_link_for_clients !!}\" target=\"_blank\">{!! $ticket_link_for_clients !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : new response on your ticket',2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(13,'template_ticket_reply_to_org_mngr_by_client_template','template_ticket_reply_to_org_mngr_by_client_template_desc_key','#{!! $ticket_number !!} | New reply on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />A new reply has been made on your organization member\'s ticket in our system.<br /><br /><strong>Ticket ID:</strong>  {!! $ticket_number !!}<br /><br /><strong>Reply Message</strong><br />{!! $message_content !!}<br /><br />Please follow the link below to check and reply on ticket.<br /><a href=\"{!! $ticket_link_for_clients !!}\" target=\"_blank\">{!! $ticket_link_for_clients !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : new response on your organisation ticket.',3,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(14,'new_user_template','new_user_template_desc_key','New user has been registered','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/>A new user has been registered in our helpdesk system.<br/><br/><strong>User Details</strong><br/><strong>Name: </strong>{!! $new_user_name !!}<br/><strong>Email</strong><strong>:</strong> {!! $new_user_email !!}<br/><br/>You can check or update the user\'s complete profile by clicking the link below<br/>{!! $user_profile_link !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>','A new user has been registered',1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(15,'registration_notification_template','registration_notification_template_desc_key','Registration Confirmation','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This email is confirmation that you are now registered on <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a>.<br /><br /><strong>Registered Email:</strong> {!! $new_user_email !!}<br /><strong>Password:</strong> {!! $user_password !!}<br /><br />You can visit the helpdesk to browse articles and contact us at any time: <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>','You account has been registered successfully',5,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(16,'ticket_agent_assignment_agents_template','ticket_agent_assignment_agents_template_desc_key','#{!! $ticket_number !!} | Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /><strong>Ticket No:</strong> {!! $ticket_number !!}<br />Has been assigned to {!! $agent_name !!} by {!! $activity_by !!}<br/><br/>Follow the link below to check and reply on the ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : has been assigned to {!! $agent_name !!}',1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(17,'ticket_agent_assignment_client_template','ticket_agent_assignment_client_template_desc_key','#{!! $ticket_number !!} | Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your ticket with ID: {!! $ticket_number !!} has been assigned to one of our agents. They will contact you soon.</p>Kind regards,<br />{!! $system_name !!}</div></div>','Your ticket #{!! $ticket_number !!} has been assigned to the concerned agent',2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(18,'ticket_agent_assignment_assigned_template','ticket_agent_assignment_assigned_template_desc_key','#{!! $ticket_number !!} | Assigned to you','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /><strong>Ticket No:</strong> {!! $ticket_number !!}<br />Has been assigned to you by {!! $activity_by !!}<br/><br/>Follow the link below to check and reply on the ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : has been assigned to you',4,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(19,'ticket_agent_assignment_organization_managers_template','ticket_agent_assignment_organization_managers_template_desc_key','#{!! $ticket_number !!} | Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your organization member\'s ticket with ID: {!! $ticket_number !!} has been assigned to one of our agents. They will contact them soon.</p>Kind regards,<br />{!! $system_name !!}</div></div>','Your organisation ticket #{!! $ticket_number !!} has been assigned to the concerned agent',3,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(20,'ticket_team_assignment_agents_template','ticket_team_assignment_agents_template_desc_key','#{!! $ticket_number !!} | Assigned to a team','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /><strong>Ticket No:</strong> {!! $ticket_number !!}<br /><br />Has been assigned to your team <b>{!! $assigned_team_name !!}</b> by {!! $activity_by !!}<br /><br />Follow the link below to check and reply on the ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : has been assigned to {!! $assigned_team_name !!}',1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(21,'ticket_team_assignment_clients_template','ticket_team_assignment_clients_template_desc_key','#{!! $ticket_number !!} | Assigned to a team','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your ticket with ID: {!! $ticket_number !!} has been assigned to our {!! $assigned_team_name !!} team. They will contact you soon.</p>Kind regards,<br />{!! $system_name !!}</div></div>','Your ticket #{!! $ticket_number !!} has been assigned to the concerned team',2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(22,'ticket_team_assignment_organization_managers_template','ticket_team_assignment_organization_managers_template_desc_key','#{!! $ticket_number !!} | Assigned to a team','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your organization member\'s ticket with ID: {!! $ticket_number !!} has been assigned to our {!! $assigned_team_name !!} team. They will contact them soon.</p>Kind regards,<br />{!! $system_name !!}</div></div>','Your organization ticket #{!! $ticket_number !!} has been assigned to the concerned team',3,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(23,'rating_confirmation_template','rating_confirmation_template_desc_key','Rating Submitted','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Overall rating has been submitted for a ticket {!! $ticket_link !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : client rated their experience on the ticket',1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(24,'internal_change_alert_agents_template','internal_change_alert_agents_template_desc_key','#{!! $ticket_number !!} | New updates on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This message is regarding a ticket with the ticket ID {!! $ticket_number !!}.<br />{!! $message_content !!}<br />By {!! $activity_by !!}</p>Kind regards,<br />{!! $system_name !!}<br /></div></div>','#{!! $ticket_number !!} : new activity update on the ticket',1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(25,'internal_change_alert_assigned_agent_template','internal_change_alert_assigned_agent_template_desc_key','#{!! $ticket_number !!} | New updates on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This message is regarding a ticket assigned to you with the ticket ID {!! $ticket_number !!}.<br />{!! $message_content !!}<br />By {!! $activity_by !!}</p>Kind regards,<br />{!! $system_name !!}<br /></div></div>','#{!! $ticket_number !!} : new activity update on your ticket.',4,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(26,'ticket_status_changed_alert_template','ticket_status_changed_alert_template_desc_key','#{!! $ticket_number !!} | Status has been set to {!! $ticket_status !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This email is regarding ticket {!! $ticket_number !!}.<br /><br />Status has been set to {!! $ticket_status !!} by {!! $actor_name !!}.</p>Kind regards,<br />{!! $system_name !!}</div></div>','{!! $ticket_number !!} : Status has been set to {!! $ticket_status !!}',1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(27,'ticket_status_changed_alert_client_template','ticket_status_changed_alert_client_template_desc_key','#{!! $ticket_number !!} | Status updated','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\">Hello {!! $receiver_name !!},<br /><br />This email is regarding your ticket with ID: {!! $ticket_number !!}.<br />Status has been set to {!! $ticket_status !!}.<br />If you are not satisfied please respond to the ticket here <a href=\"{!! $ticket_link_for_clients !!}\">{!! $ticket_link_for_clients !!}</a><br /><br />Kind regards,<br />{!! $system_name !!}</div></div>','Status of your ticket has been set to {!! $ticket_status !!}',2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(28,'ticket_status_changed_alert_assigned_template','ticket_status_changed_alert_assigned_template_desc_key','#{!! $ticket_number !!} | Status updated','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This email is regarding ticket {!! $ticket_number !!} which is assigned to you.<br /><br />Status has been set to {!! $ticket_status !!} by {!! $actor_name !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>','{!! $ticket_number !!} : Status has been set to {!! $ticket_status !!}',4,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(29,'response_due_approach_agents_template','response_due_approach_agents_template_desc_key','#{!! $ticket_number !!} | Response Time SLA Approaching','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p> Hello {!! $receiver_name !!},<br /><br />There has been no response for a ticket. The first response should happen on or before {!! $ticket_due_date !!}.<br/><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!} </a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : Response is due on the ticket. Awaiting response on before {!! $ticket_due_date !!}',1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(30,'response_due_approach_assigned_agent_template','response_due_approach_assigned_agent_template_desc_key','#{!! $ticket_number !!} | Response Time SLA Approaching','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />There has been no response for a ticket assigned to you. The first response should happen on or before {!! $ticket_due_date !!}.<br /><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!} </a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : Response is due your ticket. Awaiting response on or before {!! $ticket_due_date !!}',4,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(31,'response_due_violate_agents_template','response_due_violate_agents_template_desc_key','#{!! $ticket_number !!} | Response Time SLA Violate','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />There has been no response for a ticket. The first response was due by {!! $ticket_due_date !!}.<br /><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!} </a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : Response SLA has been violated, expected response was due on or before {!! $ticket_due_date !!}',1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(32,'response_due_violate_assigned_agent_template','response_due_violate_assigned_agent_template_desc_key','#{!! $ticket_number !!} | Response Time SLA Violate','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />There has been no response for a ticket assigned to you. The first response was due by {!! $ticket_due_date !!}.<br /><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!} </a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : Response SLA for your ticket has been violated, expected response was due on or before {!! $ticket_due_date !!}',4,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(33,'resolve_due_approach_agents_template','resolve_due_approach_agents_template_desc_key','#{!! $ticket_number !!} | Resolution Time SLA Approaching','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Ticket has not been resolved within the SLA time period. The ticket has to be resolved on or before {!! $ticket_due_date !!}.<br /><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : Resolution is due on the ticket. Awaiting resolution on before {!! $ticket_due_date !!}',1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(34,'resolve_due_approach_assigned_agent_template','resolve_due_approach_assigned_agent_template_desc_key','#{!! $ticket_number !!} | Resolution Time SLA Approaching','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p> Hello {!! $receiver_name !!},<br /><br />The ticket assigned to you has not yet been resolved. The ticket has to be resolved on or before {!! $ticket_due_date !!}.<br /><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!} </a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : Resolution is due your ticket. Awaiting resolution on or before {!! $ticket_due_date !!}',4,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(35,'resolve_due_violate_agents_template','resolve_due_violate_agents_template_desc_key','#{!! $ticket_number !!} | Resolve Time SLA Violate','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p> Hello {!! $receiver_name !!},<br /><br />Ticket has not been resolved within the SLA time period. The ticket was due by {!! $ticket_due_date !!}.<br /><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!} </a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : Resolution SLA has been violated, expected resolution was due on or before {!! $ticket_due_date !!}',1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(36,'resolve_due_violate_assigned_agent_template','resolve_due_violate_assigned_agent_template_desc_key','#{!! $ticket_number !!} | Resolve Time SLA Violate','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Ticket which is assigned to you has not been resolved within the SLA time period. The ticket was due by {!! $ticket_due_date !!}.<br /><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!} </a></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : Resolution SLA for your ticket has been violated, expected resolution was due on or before {!! $ticket_due_date !!}',4,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(37,'email_verify_alert_template','email_verify_alert_template_desc_key','Verify your email address','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/>This is a verification mail for your email registered with us.<br/><br/><strong>Registered Email:</strong> {!! $new_user_email !!}<br/><br/>Please click on the below link to verify your email address so you can use the system.<br/><a href=\"{!! $account_activation_link !!}\" target=\"_blank\">{!! $account_activation_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>','Email verification required.',5,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(38,'reset_password_template','reset_password_template_desc_key','Reset your Password','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />You asked to reset your password. To do so, please click this link:<br /><a href=\"{!! $password_reset_link !!}\" target=\"_blank\">{!! $password_reset_link !!}</a><br /><br />This will let you change your password to something new. If you did not ask for this, do not worry, we will keep your password safe.</p>Kind regards,<br />{!! $system_name !!}</div></div>','Reset password using this link',5,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(39,'reset_new_password_template','reset_new_password_template_desc_key','Password changed','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your password is successfully changed. Your new password is: {!! $user_password !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>','You account password has been updated',5,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(40,'invalid_login_alert_template','invalid_login_alert_template_desc_key','Failed login attempt','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/> We want to alert you that someone tried to login into your {!! $login_appName !!} account with wrong credentials.<br/><br/><b>Account:</b> {!! $login_accountEmail !!}<br/><b>Time:</b> {!! $login_time !!}<br/><b>IP Address:</b> {!! $login_ipAddress !!}<br/><b>Browser:</b> {!! $login_browser !!}<br/><b>Platform/OS:</b> {!! $login_platform !!}<br/><b>Device:</b> {!! $login_device !!}<br/><br/> If this was you, you can ignore this alert. If you suspect any suspicious activity on your account, please change your password.<br/><br/></p>Kind regards,<br />{!! $system_name !!}</div></div>','Invalid login attempt detected.',5,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(41,'new_device_login_alert_template','new_device_login_alert_template_desc_key','Login alert','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/> We have noticed an unusual login into your {!! $login_appName !!} account from a device or IP you do not usually use.<br/><br/><b>Account:</b> {!! $login_accountEmail !!}<br/><b>Time:</b> {!! $login_time !!}<br/><b>IP Address:</b> {!! $login_ipAddress !!}<br/><b>Browser:</b> {!! $login_browser !!}<br/><b>Platform/OS:</b> {!! $login_platform !!}<br/><b>Device:</b> {!! $login_device !!}<br/><br/> If this was you, you can ignore this alert. If you suspect any suspicious activity on your account, please change your password.<br/><br/></p>Kind regards,<br />{!! $system_name !!}</div></div>','New device login detected',5,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(42,'backup_completed_template','backup_completed_template_desc_key','Your system backup has been completed successfully','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p> Hello {!! $receiver_name !!}, <br/> <br/> Your system backup for {!! $version !!} has been completed successfully.</p>Kind regards,<br />{!! $system_name !!}</div></div>','Backup process for {!! $version !!} has been completed.',1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(43,'rating_template','rating_template_desc_key','#{!! $ticket_number !!} | Rate your experience','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},</p><p>We hope you are happy with our support for the <strong>Ticket ID:</strong>&nbsp;{!! $ticket_number !!}</p><p>Please provide us with your valuable feedback for our service by clicking on a rating of your choice.</p><p>{!! $ratings_icon_with_link !!}</p><p>Kind regards,<br/>{!! $system_name !!}</p></div></div>','Submit your rating for the ticket',5,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(44,'check_ticket_template','check_ticket_template_desc_key','Check your Ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Click the link below to view your requested ticket<br /><a href=\"{!! $ticket_link_for_clients !!}\" target=\"_blank\">{!! $ticket_link_for_clients !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>','Check your ticket',2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(45,'report_export_template','report_export_template_desc_key','Exported report available for download','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />{!! $report_type !!} is successfully generated and ready for download.<br /><br /><strong>Download link:</strong> <a href=\"{!! $report_link !!}\" target=\"_blank\">{!! $report_link !!}</a><br /><br /><i>Please note this link will be expired in {!! $report_expiry !!}.</i></p>Kind regards,<br />{!! $system_name !!}</div></div>','Your exported <b>{!! $report_type !!}</b> is now available for download',1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(46,'ticket_forwarding_template','ticket_forwarding_template_desc_key','FW: {!! $ticket_title !!} [#{!! $ticket_number !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p> Hello,<br /><br />Following ticket has been forwarded to you by {!! $activity_by !!}<br /><br />{!! $ticket_conversation !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>','Check forwarded ticket',5,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(47,'ticket_approval_template','ticket_approval_template_desc_key','Ticket Approval Link','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Ticket {!! $ticket_number !!} has been waiting for your approval.<br /><br />Please <a href=\"{!! $approval_link !!}\" target=\"_blank\">click here</a> to review the ticket.</p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : Your approval has been requested',5,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(48,'custom_alerts_notify_template','custom_alerts_notify_template_desc_key','{!! $subject !!}','{!! $message_content !!}','{!! $message_content !!}',5,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(49,'ticket_created_by_agent_ack_cc_template','ticket_created_by_agent_ack_cc_template_desc_key','#{!! $ticket_number !!} | A new ticket has been created by an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This is to confirm that our agent has logged a request in our support system. When replying, please make sure that the ticket ID is kept in the subject so that we can track your replies.<br /><br /><strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />You can check the status of or update this ticket online at: <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_link !!}</a></p>{!! $department_signature !!}</div></div>','#{!! $ticket_number !!} : Our agent has created a ticket',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(50,'ticket_pdf_generate_alert_template','ticket_pdf_generate_alert_template_desc_key','Ticket pdf','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Please download pdf attachment for this {!! $ticket_number !!} has been generated in our helpdesk.<br /><br /> </p>Kind regards,<br />{!! $system_name !!}</p></div></div>','#{!! $ticket_number !!} : Ticket pdf has been received in the email',5,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(51,'mentioned_agents','mentioned_agents_desc_key','You were mentioned','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />You were mentioned in a ticket with <strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />{!! $system_link !!}</a></div></div>','Mentioned you in a ticket with Ticket Number: (#{!! $ticket_number !!})',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(52,'mentioned_departments','mentioned_departments_desc_key','Your department is mentioned','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />You were mentioned in a ticket with <strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />{!! $system_link !!}</a></div></div>','Mentioned your Department in a ticket with Ticket Number: (#{!! $ticket_number !!})',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(53,'mentioned_teams','mentioned_teams_desc_key','You team is mentioned','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your team was mentioned in a ticket with <strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />{!! $system_link !!}</a></div></div>','Mentioned your Team in a ticket with Ticket Number: (#{!! $ticket_number !!})',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(54,'ticket_fork_alert_template','ticket_fork_alert_template_desc_key','Ticket has forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Ticket has forked from {!! $parent_ticket !!} to {!! $ticket_number !!}<br /><br /><strong>Client Details</strong><br /><strong>Name:</strong> {!! $client_name !!}<br /><strong>E-mail:</strong> {!! $client_email !!}<br /><br /><strong>Message</strong><br />{!! $message_content !!}</p>Kind regards,<br />{!! $system_name !!}</p></div></div>','Ticket has forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!}',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(55,'ticket_fork_alert_org_mmgr_template','ticket_fork_alert_org_mmgr_template_desc_key','Ticket has forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/>Our agent has forked ticket from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} for a request of your organization&#39;s member.</p><p><strong>New Ticket ID:</strong>&nbsp; {!! $ticket_number !!}<br/><br/><strong>Parent Ticket ID:</strong>&nbsp; {!! $parent_ticket !!}<br/><br/>Member&#39;s Details:<br/><strong>Name:</strong>&nbsp; {!! $client_name !!}<br/><strong>E-mail:</strong> {!! $client_email !!}<br/><br/><strong>Message:</strong><br/>{!! $message_content !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $ticket_number !!} : Our agent has forked your organization ticket from #{!! $parent_ticket !!}  to #{!! $ticket_number !!}',3,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(56,'ticket_fork_alert_client_template','ticket_fork_alert_client_template_desc_key','Your Ticket #{!! $parent_ticket !!} has forked to #{!! $ticket_number !!}.','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your Ticket #{!! $parent_ticket !!} has forked to #{!! $ticket_number !!}.<br /><br /><strong>New Ticket ID:</strong> {!! $ticket_number !!} <br /><br /><strong>Parent Ticket ID:</strong> {!! $parent_ticket !!} <br /><br />You can check the status of or update this ticket online at: <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_link !!}</a></p>{!! $department_signature !!}</div></div>','Your Ticket #{!! $parent_ticket !!} has forked to #{!! $ticket_number !!}.',2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(57,'fork_ticket_agent_assignment_agents_template','fork_ticket_agent_assignment_agents_template_desc_key','Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} | Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /><strong>Ticket forked from {!! $parent_ticket !!} to {!! $ticket_number !!}<br />Has been assigned to {!! $agent_name !!} by {!! $activity_by !!}<br/><br/>Follow the link below to check and reply on the ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>','Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} : has been assigned to {!! $agent_name !!}',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(58,'fork_ticket_agent_assignment_client_template','fork_ticket_agent_assignment_client_template_desc_key','Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!}| Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your ticket forked from {!! $parent_ticket !!} to {!! $ticket_number !!} has been assigned to one of our agents. They will contact you soon.</p>Kind regards,<br />{!! $system_name !!}</div></div>','Your ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} has been assigned to the concerned agent',2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(59,'fork_ticket_agent_assignment_assigned_template','fork_ticket_agent_assignment_assigned_template_desc_key','Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} | Assigned to you','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /><strong>Ticket No:</strong> Ticket forked from {!! $parent_ticket !!} to {!! $ticket_number !!}<br />Has been assigned to you by {!! $activity_by !!}<br/><br/>Follow the link below to check and reply on the ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>','Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} : has been assigned to you',4,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(60,'fork_ticket_agent_assignment_organization_managers_template','fork_ticket_agent_assignment_organization_managers_template_desc_key','Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} | Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your organization member\'s ticket forked from {!! $parent_ticket !!} to {!! $ticket_number !!} has been assigned to one of our agents. They will contact them soon.</p>Kind regards,<br />{!! $system_name !!}</div></div>','Your organisation ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} has been assigned to the concerned agent',3,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(61,'ticket_merge_alert_template','ticket_merge_alert_template_desc_key','Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}<br /><br /><strong>Ticket Details</strong><br /><br />Please follow the link below to check ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a><br /></p>Kind regards,<br />{!! $system_name !!}</p></div></div>','Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(62,'ticket_merge_alert_org_mmgr_template','ticket_merge_alert_org_mmgr_template_desc_key','Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/>#{!! $ticket_number !!} : Our agent has merged your organization ticket #{!! $child_ticket !!} with #{!! $ticket_number !!} on a request of your organization&#39;s member.</p><p>Member&#39;s Details:<br/><strong>Name:</strong>&nbsp; {!! $client_name !!}<br/><strong>E-mail:</strong> {!! $client_email !!}<br/></p>Kind regards,<br />{!! $system_name !!}</div></div>','#{!! $child_ticket !!} : Our agent has merged your organization ticket with #{!! $ticket_number !!}.',3,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(63,'ticket_merge_alert_client_template','ticket_merge_alert_client_template_desc_key','Your Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}.','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}.<br /><br />You can check this ticket online at: <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards<br />{!! $department_signature !!}</p></div></div>','Your Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}.',2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(64,'job_dispatch_alert_template','job_dispatch_alert_template_desc_key','Job failed','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /> <strong>Job name: </strong>{!! $job_name !!} <br /><br /> <strong>Connection name: </strong>{!! $connection_name !!} <br /><br />  <strong>Exception message:</strong> <br>{!! $exception_message !!} <br /><br /> <strong>Exception File: </strong>{!! $exception_file !!} &nbsp; <strong>Exception Line: </strong> {!! $exception_line !!} <br /><br /> <strong>Exception trace: </strong> <br /><br>{!! $exception_trace !!} </p>Kind regards,<br />{!! $system_name !!}</p></div></div>','Job name : {!! $job_name !!} <br /><br /> Exception message : {!! $exception_message !!}',5,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(65,'user_export_template','user_export_template_desc_key','Exported users are now available for download','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />User exported successfully and can be downloaded now.<br /><br /><strong>Download link:</strong> <a href=\"{!! $export_link !!}\" target=\"_blank\">{!! $export_link !!}</a><br /><br /></p>Kind regards,<br />{!! $system_name !!}</div></div>','User exported successfully, Download Now ',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(66,'report_schedule_export_template','report_schedule_export_template_desc_key','{!! $subject !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />{!! $description !!} <br /><br /><strong>Download link:</strong> <a href=\"{!! $report_link !!}\" target=\"_blank\">{!! $report_link !!}</a><br /><br /><i>Please note this link will be expired in {!! $report_expiry !!}.</i></p>Kind regards,<br />{!! $system_name !!}</div></div>','Your {!! $subject !!} scheduled report is now available for download',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(67,'mentioned_agents_reply','mentioned_agents_reply_desc_key','You were mentioned in a ticket reply','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />You were mentioned in a ticket reply with <strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />{!! $system_link !!}</a></div></div>','Mentioned you in a ticket reply with Ticket Number: (#{!! $ticket_number !!})',1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(68,'mentioned_departments_agent_reply','mentioned_departments_agent_reply_desc_key','Your department is mentioned in a ticket reply','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your department was mentioned in a ticket reply with <strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />{!! $system_link !!}</a></div></div>','Mentioned your Department in a ticket reply with Ticket Number: (#{!! $ticket_number !!})',1,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(69,'mentioned_teams_agent_reply','mentioned_teams_agent_reply_desc_key','Your team is mentioned in a ticket reply','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your team was mentioned in a ticket reply with <strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />{!! $system_link !!}</a></div></div>','Mentioned your Team in a ticket reply with Ticket Number: (#{!! $ticket_number !!})',1,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(70,'ticket_created_by_agent_acknowledge_cc_template','ticket_created_by_agent_acknowledge_cc_template_desc_key','#{!! $ticket_number !!} | You’ve been added as collaborator on a new ticket created by an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This is to confirm that our agent has logged a request in our support system. When replying, please make sure that the ticket ID is kept in the subject so that we can track your replies.<br /><br/><strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Requester:</strong> {!! $client_name !!} <br /><strong>Message Details:</strong> {!! $message_content !!} <br /><br />You have been added as collaborator on this ticket, You can check the status of or update this ticket online at: <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_link !!}</a></p>{!! $department_signature !!}</div></div>','#{!! $ticket_number !!} : Our agent has created a ticket',5,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(71,'ticket_created_by_client_acknowledge_cc_template','ticket_created_by_client_acknowledge_cc_template_desc_key','#{!! $ticket_number !!} | You’ve been added as collaborator on a new ticket created by {!! $client_name !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This is to confirm that {!! $client_name !!} has logged a request in our support system. When replying, please make sure that the ticket ID is kept in the subject so that we can track your replies.<br /><br/><strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Message Details:</strong> {!! $message_content !!} <br /><br />You have been added as collaborator on this ticket, You can check the status of or update this ticket online at: <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_link !!}</a></p></div></div>','#{!! $ticket_number !!} : Our agent has created a ticket',5,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(72,'ticket_agent_assignment_collaborator_template','ticket_agent_assignment_collaborator_template_desc_key','#{!! $ticket_number !!} | Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /><strong>Requester:</strong> {!! $client_name !!} <br />This is to inform you that the ticket with ID <strong>{!! $ticket_number !!}</strong> has been assigned to one of our agents. The agent will contact the requester shortly to address the issue.<br/><br/>Kind regards,<br />{!! $system_name !!}</p></div></div>','#{!! $ticket_number !!} : has been assigned to an agent',5,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(73,'ticket_team_assignment_collaborator_template','ticket_team_assignment_collaborator_template_desc_key','#{!! $ticket_number !!} | Assigned to a team','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /><strong>Requester:</strong> {!! $client_name !!} <br />This is to inform you that the ticket with ID <strong>{!! $ticket_number !!}</strong> has been assigned to our {!! $assigned_team_name !!} team. The requester will be contacted by the assigned team shortly.<br/><br/>Kind regards,<br />{!! $system_name !!}</p></div></div>','#{!! $ticket_number !!} : has been assigned to a team',5,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(74,'fork_ticket_agent_assignment_collaborator','fork_ticket_agent_assignment_collaborator_desc_key','Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} | Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This is to inform you that the ticket forked from <strong>{!! $parent_ticket !!}</strong> to <strong>{!! $ticket_number !!}</strong> has been assigned to one of our agent. The agent will contact the requester shortly to address the issue.<br/><br/>If you wish to check the ticket or follow the progress, you can do so using the link below:<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a><br /><br />Kind regards,<br />{!! $system_name !!}</p></div></div>','Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} : has been assigned to agent',5,'2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `notify_template_drafts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_template_sets`
--

DROP TABLE IF EXISTS `notify_template_sets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_template_sets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `template_language` varchar(10) NOT NULL,
  `channel_id` int(10) unsigned NOT NULL,
  `department_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notify_template_sets_channel_id_foreign` (`channel_id`),
  KEY `notify_template_sets_department_id_foreign` (`department_id`),
  CONSTRAINT `notify_template_sets_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `notify_channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notify_template_sets_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_template_sets`
--

LOCK TABLES `notify_template_sets` WRITE;
/*!40000 ALTER TABLE `notify_template_sets` DISABLE KEYS */;
INSERT INTO `notify_template_sets` VALUES (1,'email (default)',1,1,'en',1,NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(2,'in-app (default)',1,1,'en',2,NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28');
/*!40000 ALTER TABLE `notify_template_sets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_templates`
--

DROP TABLE IF EXISTS `notify_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_templates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `template_id` int(10) unsigned NOT NULL,
  `set_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notify_templates_template_id_foreign` (`template_id`),
  KEY `notify_templates_set_id_foreign` (`set_id`),
  CONSTRAINT `notify_templates_set_id_foreign` FOREIGN KEY (`set_id`) REFERENCES `notify_template_sets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notify_templates_template_id_foreign` FOREIGN KEY (`template_id`) REFERENCES `notify_template_drafts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_templates`
--

LOCK TABLES `notify_templates` WRITE;
/*!40000 ALTER TABLE `notify_templates` DISABLE KEYS */;
INSERT INTO `notify_templates` VALUES (1,'#{!! $ticket_number !!} | New ticket has been created','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />New ticket with ID: {!! $ticket_number !!} has been created in our helpdesk.<br /><br /><strong>Client Details</strong><br /><strong>Name:</strong> {!! $client_name !!}<br /><strong>E-mail:</strong> {!! $client_email !!}<br /><br /><strong>Message</strong><br />{!! $message_content !!}</p>Kind regards,<br />{!! $system_name !!}</p></div></div>',1,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(2,'#{!! $ticket_number !!} | Your Request has been received','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Thank you for contacting us. This is to confirm that our agent has logged your request in our support system. When replying, please make sure that the ticket ID is kept in the subject so that we can track your replies.<br /><br /><strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />You can check the status of or update this ticket online at: <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_link !!}</a></p>{!! $department_signature !!}</div></div>',2,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3,'#{!! $ticket_number !!} | A ticket has been requested','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/>Our agent has created a new ticket for a request of your organization&#39;s member.</p><p><strong>Ticket ID:</strong>&nbsp; {!! $ticket_number !!}<br/><br/><strong>Member&#39;s Details:</strong><br/><strong>Name:</strong>&nbsp; {!! $client_name !!}<br/><strong>E-mail:</strong> {!! $client_email !!}<br/><br/><strong>Message:</strong><br/>{!! $message_content !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>',3,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4,'#{!! $ticket_number !!} | Your Request has been received','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Thank you for contacting us. This is an automated response confirming the receipt of your ticket. Our team will get back to you as soon as possible. When replying, please make sure that the ticket ID is kept in the subject so that we can track your replies.<br /><br /><strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><br />You can check the status of or update this ticket online at: <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_link !!}</a></p>{!! $department_signature !!}</div></div>',4,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(5,'#{!! $ticket_number !!} | A ticket has been requested','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/>A member of your organization has created a new ticket in our helpdesk system.</p><p><strong>Ticket ID:</strong>&nbsp; {!! $ticket_number !!}<br/><br/><strong>Member&#39;s Details</strong><br/><strong>Name:</strong>&nbsp; {!! $client_name !!}<br/><strong>E-mail:</strong> {!! $client_email !!}<br/><br/><strong>Message</strong><br/>{!! $message_content !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>',5,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(6,'#{!! $ticket_number !!} | New ticket has been created','#{!! $ticket_number !!} : New ticket has been created in the system',1,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(7,'#{!! $ticket_number !!} | Your Request has been received','#{!! $ticket_number !!} : Our agent has created your ticket',2,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(8,'#{!! $ticket_number !!} | A ticket has been requested','#{!! $ticket_number !!} : Our agent has created your organization ticket',3,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(9,'#{!! $ticket_number !!} | Your Request has been received','#{!! $ticket_number !!} : Your ticket has been created.',4,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(10,'#{!! $ticket_number !!} | A ticket has been requested','#{!! $ticket_number !!} : Your organization ticket has been created',5,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(11,'#{!! $ticket_number !!} | New agent reply on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />An agent has replied to a ticket with ID: {!! $ticket_number !!}.<br /><br /><strong>Reply content:</strong><br />{!! $message_content !!}<br /><br /><strong>Ticket link:</strong> <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a><br /><br /></p>{!! $agent_signature !!}</div></div>',6,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(12,'#{!! $ticket_number !!} | New agent reply on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p> Hello {!! $receiver_name !!},<br /><br />A reply has been made to a ticket assigned to you with ID: {!! $ticket_number !!} by {!! $activity_by !!} in our helpdesk system.<br /><br /><strong>Reply content</strong><br />{!! $message_content !!}<br /><br /><strong>Ticket link</strong><br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a><br /><br /></p>{!! $agent_signature !!}</div></div>',7,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(13,'#{!! $ticket_number !!} | New reply on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\">{!! $message_content !!}<br /><br /><strong>Ticket Details</strong><br/><strong>Ticket ID:</strong> {!! $ticket_number !!}<br />{!! $agent_signature !!}</div></div>',8,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(14,'#{!! $ticket_number !!} | New reply on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\">{!! $message_content !!}<br /><br /><strong>Ticket Details</strong><br/><strong>Ticket ID:</strong> {!! $ticket_number !!}<br />{!! $agent_signature !!}</div></div>',9,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(15,'#{!! $ticket_number !!} | New response on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Client has made a new reply on their ticket in our helpdesk system.<br /><br /><strong>Ticket ID:</strong>  {!! $ticket_number !!}<br /><br /><strong>Reply Message:</strong><br />{!! $message_content !!}<br /><br />Please follow the link below to check and reply on ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>',10,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(16,'#{!! $ticket_number !!} | New response on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Client has made a new reply on their ticket which is assigned to you.<br /><br /><strong>Ticket ID:</strong>  {!! $ticket_number !!}<br /><br /><strong>Reply Message</strong><br />{!! $message_content !!}<br /><br />Please follow the link below to check and reply on ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>',11,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(17,'#{!! $ticket_number !!} | New reply on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />{!! $activity_by !!} has made a new reply on the ticket with Id <strong>{!! $ticket_number !!}</strong><br /><br /><strong>Reply Message</strong><br />{!! $message_content !!}<br /><br />Please follow the link below to check and reply on ticket.<br /><a href=\"{!! $ticket_link_for_clients !!}\" target=\"_blank\">{!! $ticket_link_for_clients !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>',12,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(18,'#{!! $ticket_number !!} | New reply on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />A new reply has been made on your organization member\'s ticket in our system.<br /><br /><strong>Ticket ID:</strong>  {!! $ticket_number !!}<br /><br /><strong>Reply Message</strong><br />{!! $message_content !!}<br /><br />Please follow the link below to check and reply on ticket.<br /><a href=\"{!! $ticket_link_for_clients !!}\" target=\"_blank\">{!! $ticket_link_for_clients !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>',13,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(19,'#{!! $ticket_number !!} | New agent reply on the ticket','#{!! $ticket_number !!} : An agent has replied on the ticket',6,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(20,'#{!! $ticket_number !!} | New agent reply on the ticket','#{!! $ticket_number !!} : An agent has replied on your assigned ticket',7,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(21,'#{!! $ticket_number !!} | New reply on the ticket','#{!! $ticket_number !!} : New reply on your ticket',8,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(22,'#{!! $ticket_number !!} | New reply on the ticket','#{!! $ticket_number !!} : New reply on your ticket organization ticket',9,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(23,'#{!! $ticket_number !!} | New response on the ticket','#{!! $ticket_number !!} : new response on the ticket.',10,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(24,'#{!! $ticket_number !!} | New response on the ticket','#{!! $ticket_number !!} : new response on your assigned ticket.',11,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(25,'#{!! $ticket_number !!} | New reply on the ticket','#{!! $ticket_number !!} : new response on your ticket',12,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(26,'#{!! $ticket_number !!} | New reply on the ticket','#{!! $ticket_number !!} : new response on your organisation ticket.',13,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(27,'New user has been registered','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/>A new user has been registered in our helpdesk system.<br/><br/><strong>User Details</strong><br/><strong>Name: </strong>{!! $new_user_name !!}<br/><strong>Email</strong><strong>:</strong> {!! $new_user_email !!}<br/><br/>You can check or update the user\'s complete profile by clicking the link below<br/>{!! $user_profile_link !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>',14,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(28,'New user has been registered','A new user has been registered',14,2,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(29,'Registration Confirmation','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This email is confirmation that you are now registered on <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a>.<br /><br /><strong>Registered Email:</strong> {!! $new_user_email !!}<br /><strong>Password:</strong> {!! $user_password !!}<br /><br />You can visit the helpdesk to browse articles and contact us at any time: <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>',15,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(30,'#{!! $ticket_number !!} | Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /><strong>Ticket No:</strong> {!! $ticket_number !!}<br />Has been assigned to {!! $agent_name !!} by {!! $activity_by !!}<br/><br/>Follow the link below to check and reply on the ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>',16,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(31,'#{!! $ticket_number !!} | Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your ticket with ID: {!! $ticket_number !!} has been assigned to one of our agents. They will contact you soon.</p>Kind regards,<br />{!! $system_name !!}</div></div>',17,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(32,'#{!! $ticket_number !!} | Assigned to you','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /><strong>Ticket No:</strong> {!! $ticket_number !!}<br />Has been assigned to you by {!! $activity_by !!}<br/><br/>Follow the link below to check and reply on the ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>',18,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(33,'#{!! $ticket_number !!} | Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your organization member\'s ticket with ID: {!! $ticket_number !!} has been assigned to one of our agents. They will contact them soon.</p>Kind regards,<br />{!! $system_name !!}</div></div>',19,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(34,'#{!! $ticket_number !!} | Assigned to a team','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /><strong>Ticket No:</strong> {!! $ticket_number !!}<br /><br />Has been assigned to your team <b>{!! $assigned_team_name !!}</b> by {!! $activity_by !!}<br /><br />Follow the link below to check and reply on the ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>',20,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(35,'#{!! $ticket_number !!} | Assigned to a team','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your ticket with ID: {!! $ticket_number !!} has been assigned to our {!! $assigned_team_name !!} team. They will contact you soon.</p>Kind regards,<br />{!! $system_name !!}</div></div>',21,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(36,'#{!! $ticket_number !!} | Assigned to a team','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your organization member\'s ticket with ID: {!! $ticket_number !!} has been assigned to our {!! $assigned_team_name !!} team. They will contact them soon.</p>Kind regards,<br />{!! $system_name !!}</div></div>',22,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(37,'#{!! $ticket_number !!} | Assigned to an agent','#{!! $ticket_number !!} : has been assigned to {!! $agent_name !!}',16,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(38,'#{!! $ticket_number !!} | Assigned to an agent','Your ticket #{!! $ticket_number !!} has been assigned to the concerned agent',17,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(39,'#{!! $ticket_number !!} | Assigned to you','#{!! $ticket_number !!} : has been assigned to you',18,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(40,'#{!! $ticket_number !!} | Assigned to an agent','Your organisation ticket #{!! $ticket_number !!} has been assigned to the concerned agent',19,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(41,'#{!! $ticket_number !!} | Assigned to a team','#{!! $ticket_number !!} : has been assigned to {!! $assigned_team_name !!}',20,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(42,'#{!! $ticket_number !!} | Assigned to a team','Your ticket #{!! $ticket_number !!} has been assigned to the concerned team',21,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(43,'#{!! $ticket_number !!} | Assigned to a team','Your organization ticket #{!! $ticket_number !!} has been assigned to the concerned team',22,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(44,'Rating Submitted','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Overall rating has been submitted for a ticket {!! $ticket_link !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>',23,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(45,'Rating Submitted','#{!! $ticket_number !!} : client rated their experience on the ticket',23,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(46,'#{!! $ticket_number !!} | New updates on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This message is regarding a ticket with the ticket ID {!! $ticket_number !!}.<br />{!! $message_content !!}<br />By {!! $activity_by !!}</p>Kind regards,<br />{!! $system_name !!}<br /></div></div>',24,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(47,'#{!! $ticket_number !!} | New updates on the ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This message is regarding a ticket assigned to you with the ticket ID {!! $ticket_number !!}.<br />{!! $message_content !!}<br />By {!! $activity_by !!}</p>Kind regards,<br />{!! $system_name !!}<br /></div></div>',25,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(48,'#{!! $ticket_number !!} | New updates on the ticket','#{!! $ticket_number !!} : new activity update on the ticket',24,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(49,'#{!! $ticket_number !!} | New updates on the ticket','#{!! $ticket_number !!} : new activity update on your ticket.',25,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(50,'#{!! $ticket_number !!} | Status has been set to {!! $ticket_status !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This email is regarding ticket {!! $ticket_number !!}.<br /><br />Status has been set to {!! $ticket_status !!} by {!! $actor_name !!}.</p>Kind regards,<br />{!! $system_name !!}</div></div>',26,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(51,'#{!! $ticket_number !!} | Status updated','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\">Hello {!! $receiver_name !!},<br /><br />This email is regarding your ticket with ID: {!! $ticket_number !!}.<br />Status has been set to {!! $ticket_status !!}.<br />If you are not satisfied please respond to the ticket here <a href=\"{!! $ticket_link_for_clients !!}\">{!! $ticket_link_for_clients !!}</a><br /><br />Kind regards,<br />{!! $system_name !!}</div></div>',27,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(52,'#{!! $ticket_number !!} | Status updated','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This email is regarding ticket {!! $ticket_number !!} which is assigned to you.<br /><br />Status has been set to {!! $ticket_status !!} by {!! $actor_name !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>',28,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(53,'#{!! $ticket_number !!} | Status has been set to {!! $ticket_status !!}','{!! $ticket_number !!} : Status has been set to {!! $ticket_status !!}',26,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(54,'#{!! $ticket_number !!} | Status updated','Status of your ticket has been set to {!! $ticket_status !!}',27,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(55,'#{!! $ticket_number !!} | Status updated','{!! $ticket_number !!} : Status has been set to {!! $ticket_status !!}',28,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(56,'#{!! $ticket_number !!} | Response Time SLA Approaching','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p> Hello {!! $receiver_name !!},<br /><br />There has been no response for a ticket. The first response should happen on or before {!! $ticket_due_date !!}.<br/><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!} </a></p>Kind regards,<br />{!! $system_name !!}</div></div>',29,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(57,'#{!! $ticket_number !!} | Response Time SLA Approaching','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />There has been no response for a ticket assigned to you. The first response should happen on or before {!! $ticket_due_date !!}.<br /><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!} </a></p>Kind regards,<br />{!! $system_name !!}</div></div>',30,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(58,'#{!! $ticket_number !!} | Response Time SLA Violate','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />There has been no response for a ticket. The first response was due by {!! $ticket_due_date !!}.<br /><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!} </a></p>Kind regards,<br />{!! $system_name !!}</div></div>',31,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(59,'#{!! $ticket_number !!} | Response Time SLA Violate','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />There has been no response for a ticket assigned to you. The first response was due by {!! $ticket_due_date !!}.<br /><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!} </a></p>Kind regards,<br />{!! $system_name !!}</div></div>',32,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(60,'#{!! $ticket_number !!} | Resolution Time SLA Approaching','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Ticket has not been resolved within the SLA time period. The ticket has to be resolved on or before {!! $ticket_due_date !!}.<br /><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>',33,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(61,'#{!! $ticket_number !!} | Resolution Time SLA Approaching','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p> Hello {!! $receiver_name !!},<br /><br />The ticket assigned to you has not yet been resolved. The ticket has to be resolved on or before {!! $ticket_due_date !!}.<br /><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!} </a></p>Kind regards,<br />{!! $system_name !!}</div></div>',34,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(62,'#{!! $ticket_number !!} | Resolve Time SLA Violate','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p> Hello {!! $receiver_name !!},<br /><br />Ticket has not been resolved within the SLA time period. The ticket was due by {!! $ticket_due_date !!}.<br /><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!} </a></p>Kind regards,<br />{!! $system_name !!}</div></div>',35,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(63,'#{!! $ticket_number !!} | Resolve Time SLA Violate','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Ticket which is assigned to you has not been resolved within the SLA time period. The ticket was due by {!! $ticket_due_date !!}.<br /><br /><strong>Ticket Details:</strong><br /><br /><strong>Subject:</strong> {!! $ticket_subject !!}<br /><strong>Number:</strong> {!! $ticket_number !!}<br /><strong>Requester:</strong> {!! $client_name !!}<br /><br />This is an automatic escalation email from <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_name !!}</a><br /><br />Respond to ticket here <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!} </a></p>Kind regards,<br />{!! $system_name !!}</div></div>',36,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(64,'#{!! $ticket_number !!} | Response Time SLA Approaching','#{!! $ticket_number !!} : Response is due on the ticket. Awaiting response on before {!! $ticket_due_date !!}',29,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(65,'#{!! $ticket_number !!} | Response Time SLA Approaching','#{!! $ticket_number !!} : Response is due your ticket. Awaiting response on or before {!! $ticket_due_date !!}',30,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(66,'#{!! $ticket_number !!} | Response Time SLA Violate','#{!! $ticket_number !!} : Response SLA has been violated, expected response was due on or before {!! $ticket_due_date !!}',31,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(67,'#{!! $ticket_number !!} | Response Time SLA Violate','#{!! $ticket_number !!} : Response SLA for your ticket has been violated, expected response was due on or before {!! $ticket_due_date !!}',32,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(68,'#{!! $ticket_number !!} | Resolution Time SLA Approaching','#{!! $ticket_number !!} : Resolution is due on the ticket. Awaiting resolution on before {!! $ticket_due_date !!}',33,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(69,'#{!! $ticket_number !!} | Resolution Time SLA Approaching','#{!! $ticket_number !!} : Resolution is due your ticket. Awaiting resolution on or before {!! $ticket_due_date !!}',34,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(70,'#{!! $ticket_number !!} | Resolve Time SLA Violate','#{!! $ticket_number !!} : Resolution SLA has been violated, expected resolution was due on or before {!! $ticket_due_date !!}',35,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(71,'#{!! $ticket_number !!} | Resolve Time SLA Violate','#{!! $ticket_number !!} : Resolution SLA for your ticket has been violated, expected resolution was due on or before {!! $ticket_due_date !!}',36,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(72,'Verify your email address','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/>This is a verification mail for your email registered with us.<br/><br/><strong>Registered Email:</strong> {!! $new_user_email !!}<br/><br/>Please click on the below link to verify your email address so you can use the system.<br/><a href=\"{!! $account_activation_link !!}\" target=\"_blank\">{!! $account_activation_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>',37,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(73,'Reset your Password','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />You asked to reset your password. To do so, please click this link:<br /><a href=\"{!! $password_reset_link !!}\" target=\"_blank\">{!! $password_reset_link !!}</a><br /><br />This will let you change your password to something new. If you did not ask for this, do not worry, we will keep your password safe.</p>Kind regards,<br />{!! $system_name !!}</div></div>',38,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(74,'Password changed','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your password is successfully changed. Your new password is: {!! $user_password !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>',39,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(75,'Failed login attempt','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/> We want to alert you that someone tried to login into your {!! $login_appName !!} account with wrong credentials.<br/><br/><b>Account:</b> {!! $login_accountEmail !!}<br/><b>Time:</b> {!! $login_time !!}<br/><b>IP Address:</b> {!! $login_ipAddress !!}<br/><b>Browser:</b> {!! $login_browser !!}<br/><b>Platform/OS:</b> {!! $login_platform !!}<br/><b>Device:</b> {!! $login_device !!}<br/><br/> If this was you, you can ignore this alert. If you suspect any suspicious activity on your account, please change your password.<br/><br/></p>Kind regards,<br />{!! $system_name !!}</div></div>',40,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(76,'Login alert','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/> We have noticed an unusual login into your {!! $login_appName !!} account from a device or IP you do not usually use.<br/><br/><b>Account:</b> {!! $login_accountEmail !!}<br/><b>Time:</b> {!! $login_time !!}<br/><b>IP Address:</b> {!! $login_ipAddress !!}<br/><b>Browser:</b> {!! $login_browser !!}<br/><b>Platform/OS:</b> {!! $login_platform !!}<br/><b>Device:</b> {!! $login_device !!}<br/><br/> If this was you, you can ignore this alert. If you suspect any suspicious activity on your account, please change your password.<br/><br/></p>Kind regards,<br />{!! $system_name !!}</div></div>',41,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(77,'Failed login attempt','Invalid login attempt detected.',40,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(78,'Login alert','New device login detected',41,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(79,'Your system backup has been completed successfully','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p> Hello {!! $receiver_name !!}, <br/> <br/> Your system backup for {!! $version !!} has been completed successfully.</p>Kind regards,<br />{!! $system_name !!}</div></div>',42,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(80,'Your system backup has been completed successfully','Backup process for {!! $version !!} has been completed.',42,2,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(81,'#{!! $ticket_number !!} | Rate your experience','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},</p><p>We hope you are happy with our support for the <strong>Ticket ID:</strong>&nbsp;{!! $ticket_number !!}</p><p>Please provide us with your valuable feedback for our service by clicking on a rating of your choice.</p><p>{!! $ratings_icon_with_link !!}</p><p>Kind regards,<br/>{!! $system_name !!}</p></div></div>',43,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(82,'Check your Ticket','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Click the link below to view your requested ticket<br /><a href=\"{!! $ticket_link_for_clients !!}\" target=\"_blank\">{!! $ticket_link_for_clients !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>',44,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(83,'Exported report available for download','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />{!! $report_type !!} is successfully generated and ready for download.<br /><br /><strong>Download link:</strong> <a href=\"{!! $report_link !!}\" target=\"_blank\">{!! $report_link !!}</a><br /><br /><i>Please note this link will be expired in {!! $report_expiry !!}.</i></p>Kind regards,<br />{!! $system_name !!}</div></div>',45,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(84,'Exported report available for download','Your exported <b>{!! $report_type !!}</b> is now available for download',45,2,'2025-01-03 04:07:29','2025-01-03 04:07:31'),(85,'FW: {!! $ticket_title !!} [#{!! $ticket_number !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p> Hello,<br /><br />Following ticket has been forwarded to you by {!! $activity_by !!}<br /><br />{!! $ticket_conversation !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>',46,1,'2025-01-03 04:07:29','2025-01-03 04:07:29'),(86,'Ticket Approval Link','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Ticket {!! $ticket_number !!} has been waiting for your approval.<br /><br />Please <a href=\"{!! $approval_link !!}\" target=\"_blank\">click here</a> to review the ticket.</p>Kind regards,<br />{!! $system_name !!}</div></div>',47,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(87,'Ticket Approval Link','#{!! $ticket_number !!} : Your approval has been requested',47,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(88,'{!! $subject !!}','{!! $message_content !!}',48,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(89,'{!! $subject !!}','{!! $message_content !!}',48,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(90,'#{!! $ticket_number !!} | A new ticket has been created by an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This is to confirm that our agent has logged a request in our support system. When replying, please make sure that the ticket ID is kept in the subject so that we can track your replies.<br /><br /><strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />You can check the status of or update this ticket online at: <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_link !!}</a></p>{!! $department_signature !!}</div></div>',49,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(91,'#{!! $ticket_number !!} | A new ticket has been created by an agent','#{!! $ticket_number !!} : Our agent has created a ticket',49,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(92,'Ticket pdf','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Please download pdf attachment for this {!! $ticket_number !!} has been generated in our helpdesk.<br /><br /> </p>Kind regards,<br />{!! $system_name !!}</p></div></div>',50,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(93,'Ticket pdf','#{!! $ticket_number !!} : Ticket pdf has been received in the email',50,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(94,'You were mentioned','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />You were mentioned in a ticket with <strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />{!! $system_link !!}</a></div></div>',51,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(95,'Your department is mentioned','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />You were mentioned in a ticket with <strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />{!! $system_link !!}</a></div></div>',52,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(96,'You team is mentioned','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your team was mentioned in a ticket with <strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />{!! $system_link !!}</a></div></div>',53,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(97,'You were mentioned','Mentioned you in a ticket with Ticket Number: (#{!! $ticket_number !!})',51,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(98,'Your department is mentioned','Mentioned your Department in a ticket with Ticket Number: (#{!! $ticket_number !!})',52,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(99,'You team is mentioned','Mentioned your Team in a ticket with Ticket Number: (#{!! $ticket_number !!})',53,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(100,'Ticket has forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Ticket has forked from {!! $parent_ticket !!} to {!! $ticket_number !!}<br /><br /><strong>Client Details</strong><br /><strong>Name:</strong> {!! $client_name !!}<br /><strong>E-mail:</strong> {!! $client_email !!}<br /><br /><strong>Message</strong><br />{!! $message_content !!}</p>Kind regards,<br />{!! $system_name !!}</p></div></div>',54,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(101,'Ticket has forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/>Our agent has forked ticket from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} for a request of your organization&#39;s member.</p><p><strong>New Ticket ID:</strong>&nbsp; {!! $ticket_number !!}<br/><br/><strong>Parent Ticket ID:</strong>&nbsp; {!! $parent_ticket !!}<br/><br/>Member&#39;s Details:<br/><strong>Name:</strong>&nbsp; {!! $client_name !!}<br/><strong>E-mail:</strong> {!! $client_email !!}<br/><br/><strong>Message:</strong><br/>{!! $message_content !!}</p>Kind regards,<br />{!! $system_name !!}</div></div>',55,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(102,'Your Ticket #{!! $parent_ticket !!} has forked to #{!! $ticket_number !!}.','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your Ticket #{!! $parent_ticket !!} has forked to #{!! $ticket_number !!}.<br /><br /><strong>New Ticket ID:</strong> {!! $ticket_number !!} <br /><br /><strong>Parent Ticket ID:</strong> {!! $parent_ticket !!} <br /><br />You can check the status of or update this ticket online at: <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_link !!}</a></p>{!! $department_signature !!}</div></div>',56,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(103,'Ticket has forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!}','Ticket has forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!}',54,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(104,'Ticket has forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!}','#{!! $ticket_number !!} : Our agent has forked your organization ticket from #{!! $parent_ticket !!}  to #{!! $ticket_number !!}',55,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(105,'Your Ticket #{!! $parent_ticket !!} has forked to #{!! $ticket_number !!}.','Your Ticket #{!! $parent_ticket !!} has forked to #{!! $ticket_number !!}.',56,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(106,'Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} | Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /><strong>Ticket forked from {!! $parent_ticket !!} to {!! $ticket_number !!}<br />Has been assigned to {!! $agent_name !!} by {!! $activity_by !!}<br/><br/>Follow the link below to check and reply on the ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>',57,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(107,'Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!}| Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your ticket forked from {!! $parent_ticket !!} to {!! $ticket_number !!} has been assigned to one of our agents. They will contact you soon.</p>Kind regards,<br />{!! $system_name !!}</div></div>',58,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(108,'Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} | Assigned to you','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /><strong>Ticket No:</strong> Ticket forked from {!! $parent_ticket !!} to {!! $ticket_number !!}<br />Has been assigned to you by {!! $activity_by !!}<br/><br/>Follow the link below to check and reply on the ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards,<br />{!! $system_name !!}</div></div>',59,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(109,'Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} | Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your organization member\'s ticket forked from {!! $parent_ticket !!} to {!! $ticket_number !!} has been assigned to one of our agents. They will contact them soon.</p>Kind regards,<br />{!! $system_name !!}</div></div>',60,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(110,'Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} | Assigned to an agent','Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} : has been assigned to {!! $agent_name !!}',57,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(111,'Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!}| Assigned to an agent','Your ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} has been assigned to the concerned agent',58,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(112,'Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} | Assigned to you','Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} : has been assigned to you',59,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(113,'Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} | Assigned to an agent','Your organisation ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} has been assigned to the concerned agent',60,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(114,'Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}<br /><br /><strong>Ticket Details</strong><br /><br />Please follow the link below to check ticket.<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a><br /></p>Kind regards,<br />{!! $system_name !!}</p></div></div>',61,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(115,'Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br/><br/>#{!! $ticket_number !!} : Our agent has merged your organization ticket #{!! $child_ticket !!} with #{!! $ticket_number !!} on a request of your organization&#39;s member.</p><p>Member&#39;s Details:<br/><strong>Name:</strong>&nbsp; {!! $client_name !!}<br/><strong>E-mail:</strong> {!! $client_email !!}<br/></p>Kind regards,<br />{!! $system_name !!}</div></div>',62,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(116,'Your Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}.','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}.<br /><br />You can check this ticket online at: <a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a></p>Kind regards<br />{!! $department_signature !!}</p></div></div>',63,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(117,'Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}','Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}',61,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(118,'Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}','#{!! $child_ticket !!} : Our agent has merged your organization ticket with #{!! $ticket_number !!}.',62,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(119,'Your Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}.','Your Ticket #{!! $child_ticket !!} has merged with #{!! $ticket_number !!}.',63,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(120,'Job failed','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /> <strong>Job name: </strong>{!! $job_name !!} <br /><br /> <strong>Connection name: </strong>{!! $connection_name !!} <br /><br />  <strong>Exception message:</strong> <br>{!! $exception_message !!} <br /><br /> <strong>Exception File: </strong>{!! $exception_file !!} &nbsp; <strong>Exception Line: </strong> {!! $exception_line !!} <br /><br /> <strong>Exception trace: </strong> <br /><br>{!! $exception_trace !!} </p>Kind regards,<br />{!! $system_name !!}</p></div></div>',64,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(122,'Exported users are now available for download','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />User exported successfully and can be downloaded now.<br /><br /><strong>Download link:</strong> <a href=\"{!! $export_link !!}\" target=\"_blank\">{!! $export_link !!}</a><br /><br /></p>Kind regards,<br />{!! $system_name !!}</div></div>',65,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(123,'Exported users are now available for download','User exported successfully, Download Now ',65,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(124,'{!! $subject !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />{!! $description !!} <br /><br /><strong>Download link:</strong> <a href=\"{!! $report_link !!}\" target=\"_blank\">{!! $report_link !!}</a><br /><br /><i>Please note this link will be expired in {!! $report_expiry !!}.</i></p>Kind regards,<br />{!! $system_name !!}</div></div>',66,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(125,'{!! $subject !!}','Your {!! $subject !!} scheduled report is now available for download',66,2,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(126,'You were mentioned in a ticket reply','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />You were mentioned in a ticket reply with <strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />{!! $system_link !!}</a></div></div>',67,1,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(127,'Your department is mentioned in a ticket reply','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your department was mentioned in a ticket reply with <strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />{!! $system_link !!}</a></div></div>',68,1,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(128,'Your team is mentioned in a ticket reply','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />Your team was mentioned in a ticket reply with <strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Request message:</strong> {!! $message_content !!} <br /><br />{!! $system_link !!}</a></div></div>',69,1,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(129,'You were mentioned in a ticket reply','Mentioned you in a ticket reply with Ticket Number: (#{!! $ticket_number !!})',67,2,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(130,'Your department is mentioned in a ticket reply','Mentioned your Department in a ticket reply with Ticket Number: (#{!! $ticket_number !!})',68,2,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(131,'Your team is mentioned in a ticket reply','Mentioned your Team in a ticket reply with Ticket Number: (#{!! $ticket_number !!})',69,2,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(132,'#{!! $ticket_number !!} | You’ve been added as collaborator on a new ticket created by an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This is to confirm that our agent has logged a request in our support system. When replying, please make sure that the ticket ID is kept in the subject so that we can track your replies.<br /><br/><strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Requester:</strong> {!! $client_name !!} <br /><strong>Message Details:</strong> {!! $message_content !!} <br /><br />You have been added as collaborator on this ticket, You can check the status of or update this ticket online at: <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_link !!}</a></p>{!! $department_signature !!}</div></div>',70,1,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(133,'#{!! $ticket_number !!} | You’ve been added as collaborator on a new ticket created by {!! $client_name !!}','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This is to confirm that {!! $client_name !!} has logged a request in our support system. When replying, please make sure that the ticket ID is kept in the subject so that we can track your replies.<br /><br/><strong>Ticket ID:</strong> {!! $ticket_number !!} <br /><strong>Message Details:</strong> {!! $message_content !!} <br /><br />You have been added as collaborator on this ticket, You can check the status of or update this ticket online at: <a href=\"{!! $system_link !!}\" target=\"_blank\">{!! $system_link !!}</a></p></div></div>',71,1,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(134,'#{!! $ticket_number !!} | You’ve been added as collaborator on a new ticket created by an agent','#{!! $ticket_number !!} : Our agent has created a ticket',70,2,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(135,'#{!! $ticket_number !!} | You’ve been added as collaborator on a new ticket created by {!! $client_name !!}','#{!! $ticket_number !!} : Our agent has created a ticket',71,2,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(136,'#{!! $ticket_number !!} | Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /><strong>Requester:</strong> {!! $client_name !!} <br />This is to inform you that the ticket with ID <strong>{!! $ticket_number !!}</strong> has been assigned to one of our agents. The agent will contact the requester shortly to address the issue.<br/><br/>Kind regards,<br />{!! $system_name !!}</p></div></div>',72,1,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(137,'#{!! $ticket_number !!} | Assigned to a team','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br /><strong>Requester:</strong> {!! $client_name !!} <br />This is to inform you that the ticket with ID <strong>{!! $ticket_number !!}</strong> has been assigned to our {!! $assigned_team_name !!} team. The requester will be contacted by the assigned team shortly.<br/><br/>Kind regards,<br />{!! $system_name !!}</p></div></div>',73,1,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(138,'#{!! $ticket_number !!} | Assigned to an agent','#{!! $ticket_number !!} : has been assigned to an agent',72,2,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(139,'#{!! $ticket_number !!} | Assigned to a team','#{!! $ticket_number !!} : has been assigned to a team',73,2,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(140,'Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} | Assigned to an agent','<div style=\"width: 100%!important; margin: 0; padding: 0;\"><div style=\"padding: 15px; line-height: 18px; font-family: Lucida Grande,Verdana,Arial,sans-serif; font-size: 12px; color: #444444;\"><p>Hello {!! $receiver_name !!},<br /><br />This is to inform you that the ticket forked from <strong>{!! $parent_ticket !!}</strong> to <strong>{!! $ticket_number !!}</strong> has been assigned to one of our agent. The agent will contact the requester shortly to address the issue.<br/><br/>If you wish to check the ticket or follow the progress, you can do so using the link below:<br /><a href=\"{!! $ticket_link !!}\" target=\"_blank\">{!! $ticket_link !!}</a><br /><br />Kind regards,<br />{!! $system_name !!}</p></div></div>',74,1,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(141,'Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} | Assigned to an agent','Ticket forked from #{!! $parent_ticket !!}  to #{!! $ticket_number !!} : has been assigned to agent',74,2,'2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `notify_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth_access_tokens`
--

DROP TABLE IF EXISTS `oauth_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauth_access_tokens` (
  `id` varchar(100) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `client_id` int(10) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `scopes` text DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_access_tokens_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth_access_tokens`
--

LOCK TABLES `oauth_access_tokens` WRITE;
/*!40000 ALTER TABLE `oauth_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth_auth_codes`
--

DROP TABLE IF EXISTS `oauth_auth_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauth_auth_codes` (
  `id` varchar(100) NOT NULL,
  `user_id` int(11) NOT NULL,
  `client_id` int(10) unsigned NOT NULL,
  `scopes` text DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth_auth_codes`
--

LOCK TABLES `oauth_auth_codes` WRITE;
/*!40000 ALTER TABLE `oauth_auth_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth_auth_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth_clients`
--

DROP TABLE IF EXISTS `oauth_clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauth_clients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `secret` varchar(100) NOT NULL,
  `redirect` text NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_clients_user_id_index` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth_clients`
--

LOCK TABLES `oauth_clients` WRITE;
/*!40000 ALTER TABLE `oauth_clients` DISABLE KEYS */;
INSERT INTO `oauth_clients` VALUES (1,NULL,'Faveo Helpdesk Personal Access Client','xNXPD7U0hzsrrluq7dhqhid7e7hmQ7LF75VmnsYF','http://localhost',1,0,0,'2025-01-03 04:07:24','2025-01-03 04:07:24',NULL),(2,NULL,'Faveo Helpdesk Password Grant Client','iKHj1ad2G06wW2AlzbFAiNBd1y2i1g9k7msrHhi7','http://localhost',0,1,0,'2025-01-03 04:07:24','2025-01-03 04:07:24','users');
/*!40000 ALTER TABLE `oauth_clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth_faveo_attributes`
--

DROP TABLE IF EXISTS `oauth_faveo_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauth_faveo_attributes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `homepage_url` varchar(255) NOT NULL,
  `profile_pic` longtext DEFAULT NULL,
  `path` longtext DEFAULT NULL,
  `description` blob DEFAULT NULL,
  `client_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth_faveo_attributes`
--

LOCK TABLES `oauth_faveo_attributes` WRITE;
/*!40000 ALTER TABLE `oauth_faveo_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth_faveo_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth_integrations`
--

DROP TABLE IF EXISTS `oauth_integrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauth_integrations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `provider` varchar(255) NOT NULL,
  `client_id` text NOT NULL,
  `client_secret` text NOT NULL,
  `redirect_uri` text NOT NULL,
  `is_active` tinyint(4) NOT NULL DEFAULT 0,
  `authorize_url` text NOT NULL,
  `token_url` text NOT NULL,
  `scope` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth_integrations`
--

LOCK TABLES `oauth_integrations` WRITE;
/*!40000 ALTER TABLE `oauth_integrations` DISABLE KEYS */;
INSERT INTO `oauth_integrations` VALUES (1,'office365','Office 365','','','https://raffi.helpdesk/faveo/public/email/oauth/office365',0,'https://login.microsoftonline.com/common/oauth2/v2.0/authorize','https://login.microsoftonline.com/common/oauth2/v2.0/token','offline_access https://outlook.office.com/IMAP.AccessAsUser.All https://outlook.office.com/SMTP.Send https://outlook.office.com/User.Read https://outlook.office365.com/EWS.AccessAsUser.All','2025-01-03 04:07:28','2025-01-03 04:07:28');
/*!40000 ALTER TABLE `oauth_integrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth_personal_access_clients`
--

DROP TABLE IF EXISTS `oauth_personal_access_clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauth_personal_access_clients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_personal_access_clients_client_id_index` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth_personal_access_clients`
--

LOCK TABLES `oauth_personal_access_clients` WRITE;
/*!40000 ALTER TABLE `oauth_personal_access_clients` DISABLE KEYS */;
INSERT INTO `oauth_personal_access_clients` VALUES (1,1,'2025-01-03 04:07:24','2025-01-03 04:07:24');
/*!40000 ALTER TABLE `oauth_personal_access_clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth_refresh_tokens`
--

DROP TABLE IF EXISTS `oauth_refresh_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauth_refresh_tokens` (
  `id` varchar(100) NOT NULL,
  `access_token_id` varchar(100) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth_refresh_tokens`
--

LOCK TABLES `oauth_refresh_tokens` WRITE;
/*!40000 ALTER TABLE `oauth_refresh_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth_refresh_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `package_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `credit_type` varchar(255) NOT NULL,
  `credit` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `expiry_date` datetime DEFAULT NULL,
  `period_expiry_date` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `orders_package_id_foreign` (`package_id`),
  KEY `orders_user_id_foreign` (`user_id`),
  CONSTRAINT `orders_package_id_foreign` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`),
  CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organization`
--

DROP TABLE IF EXISTS `organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `website` varchar(255) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `head` int(10) unsigned DEFAULT NULL,
  `internal_notes` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `client_Code` varchar(255) NOT NULL,
  `phone1` varchar(255) NOT NULL,
  `line_of_business` varchar(255) NOT NULL,
  `relation_type` varchar(255) NOT NULL,
  `branch` varchar(255) NOT NULL,
  `fax` varchar(255) NOT NULL,
  `domain` longtext NOT NULL,
  `logo` longtext DEFAULT NULL,
  `logo_driver` varchar(255) DEFAULT NULL,
  `is_migrated` tinyint(4) NOT NULL DEFAULT 0,
  `ext` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `head` (`head`),
  KEY `organization_is_migrated_index` (`is_migrated`),
  CONSTRAINT `organization_ibfk_1` FOREIGN KEY (`head`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organization`
--

LOCK TABLES `organization` WRITE;
/*!40000 ALTER TABLE `organization` DISABLE KEYS */;
/*!40000 ALTER TABLE `organization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organization_assign_labels`
--

DROP TABLE IF EXISTS `organization_assign_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_assign_labels` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) NOT NULL,
  `label_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organization_assign_labels`
--

LOCK TABLES `organization_assign_labels` WRITE;
/*!40000 ALTER TABLE `organization_assign_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `organization_assign_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organization_dept`
--

DROP TABLE IF EXISTS `organization_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_dept` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `org_deptname` varchar(255) NOT NULL,
  `business_hours_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `org_dept_manager` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organization_dept`
--

LOCK TABLES `organization_dept` WRITE;
/*!40000 ALTER TABLE `organization_dept` DISABLE KEYS */;
/*!40000 ALTER TABLE `organization_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organization_orders`
--

DROP TABLE IF EXISTS `organization_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) NOT NULL,
  `organization_id` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organization_orders`
--

LOCK TABLES `organization_orders` WRITE;
/*!40000 ALTER TABLE `organization_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `organization_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `package_department_link`
--

DROP TABLE IF EXISTS `package_department_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `package_department_link` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `package_id` int(10) unsigned NOT NULL,
  `department_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `package_department_link_package_id_foreign` (`package_id`),
  KEY `package_department_link_department_id_foreign` (`department_id`),
  CONSTRAINT `package_department_link_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`) ON DELETE CASCADE,
  CONSTRAINT `package_department_link_package_id_foreign` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `package_department_link`
--

LOCK TABLES `package_department_link` WRITE;
/*!40000 ALTER TABLE `package_department_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `package_department_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packages`
--

DROP TABLE IF EXISTS `packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `price` varchar(255) NOT NULL,
  `validity` varchar(255) DEFAULT NULL,
  `allowed_tickets` int(11) NOT NULL,
  `display_order` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `package_pic` varchar(255) DEFAULT NULL,
  `kb_link` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_private` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_tickets_period` varchar(255) NOT NULL DEFAULT 'all',
  `month_definition` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packages`
--

LOCK TABLES `packages` WRITE;
/*!40000 ALTER TABLE `packages` DISABLE KEYS */;
/*!40000 ALTER TABLE `packages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `attempts` int(11) NOT NULL DEFAULT 1,
  `attempts_expiry` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`),
  KEY `password_resets_token_index` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permision`
--

DROP TABLE IF EXISTS `permision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permision` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permision` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permision`
--

LOCK TABLES `permision` WRITE;
/*!40000 ALTER TABLE `permision` DISABLE KEYS */;
/*!40000 ALTER TABLE `permision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugins`
--

DROP TABLE IF EXISTS `plugins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plugins` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `version` varchar(30) NOT NULL DEFAULT '0.0.0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugins`
--

LOCK TABLES `plugins` WRITE;
/*!40000 ALTER TABLE `plugins` DISABLE KEYS */;
INSERT INTO `plugins` VALUES (1,'','',1,'2025-01-03 04:07:25','2025-01-03 04:07:25','0.0.0');
/*!40000 ALTER TABLE `plugins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `popup`
--

DROP TABLE IF EXISTS `popup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `popup` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pop_name` varchar(255) NOT NULL,
  `description` blob DEFAULT NULL,
  `use` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `popup`
--

LOCK TABLES `popup` WRITE;
/*!40000 ALTER TABLE `popup` DISABLE KEYS */;
INSERT INTO `popup` VALUES (1,'renew','eyJpdiI6IjFZNEs1TldnYTZTVlNyS1M1a0h2SUE9PSIsInZhbHVlIjoiaGZrYmdrRXdnL0l1ZEFyZ3FJbm0xR3ViMElOSVFVZ2hta3NsSmJ4UU9ydGRmT2djWkpOYzlMajQxdldSd3pqV2hxdytYRmY5UDZDb29ZcXQ1dXlLdGFFQTRrMDBiU2JieWk2OVZxK0Zac0tBQ1kwNmRVb3pKZUdkYkZwQXJBd3hpNkt6RTRIeUttWWI3WldOUkJiOFRJL2VzbHdEdlZJTUljRmhxK1pyazJsMTYrMlEyZ1ZvZUZ3OHhRYml4Ui9JbE5uNkpGMjRPKzVxOEJDRDlCcXAzUT09IiwibWFjIjoiMWQ5MWZjNGEzN2FlODg5N2M1OGU0NzYyNDQ3MWMzZGI2YmZhYmQzNzFlYWZmM2JkYWIzNmNhYThiNWNkMmVmOCIsInRhZyI6IiJ9',0,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(2,'update','eyJpdiI6IlUySWFGSEZOTE1HV3RidTJqblNaU0E9PSIsInZhbHVlIjoiNzFacWNJZ3VLUm04RFpydzkwL2djZnZqWDFhaENzaUtYYm1BTmVCWmtlRmgyb3IySU9RbHFoOVFTNWFqblBScExtWHFhRVRCZytxMG53T1lnbjgreTJoYldYQmJqY3I3bGo5eGkvMGx6b0txK2c3Rk54ZWl6czRWUnhYT2ZiWHBpZWo4V1NkbWJsblZvdTBmWnIyT2ZyT01QcS9MRlhybVA0WFUvN2lTWkF3MDB2QXorNjV0dyt4blAzYWZmZi84bzdGU201Q3piUVVMc1RaT0pRb29rZz09IiwibWFjIjoiZmJjNDA5OTY1MzBhY2Q3ZDZiMzFhOWEwMmY1NzQ1ZmE1MDkyZmJhNjIzN2JjMDhiMjc2NzNmYWE5MWY0YTM1ZiIsInRhZyI6IiJ9',0,'2025-01-03 04:07:30','2025-01-03 04:07:30');
/*!40000 ALTER TABLE `popup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `popup_users`
--

DROP TABLE IF EXISTS `popup_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `popup_users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pop_id` bigint(20) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `days` int(10) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `popup_users_pop_id_foreign` (`pop_id`),
  KEY `popup_users_user_id_foreign` (`user_id`),
  CONSTRAINT `popup_users_pop_id_foreign` FOREIGN KEY (`pop_id`) REFERENCES `popup` (`id`) ON DELETE CASCADE,
  CONSTRAINT `popup_users_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `popup_users`
--

LOCK TABLES `popup_users` WRITE;
/*!40000 ALTER TABLE `popup_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `popup_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `queue_services`
--

DROP TABLE IF EXISTS `queue_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `queue_services` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `short_name` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `queue_services`
--

LOCK TABLES `queue_services` WRITE;
/*!40000 ALTER TABLE `queue_services` DISABLE KEYS */;
INSERT INTO `queue_services` VALUES (1,'Sync','sync',1,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(2,'Database','database',0,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(3,'Beanstalkd','beanstalkd',0,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(4,'SQS','sqs',0,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(5,'Iron','iron',0,'2025-01-03 04:07:23','2025-01-03 04:07:23'),(6,'Redis','redis',0,'2025-01-03 04:07:23','2025-01-03 04:07:23');
/*!40000 ALTER TABLE `queue_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating_additional_question_ticket`
--

DROP TABLE IF EXISTS `rating_additional_question_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_additional_question_ticket` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(10) unsigned NOT NULL,
  `rating_additional_question_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `raqt_rating_additional_question_id` (`rating_additional_question_id`),
  KEY `raqt_ticket_id` (`ticket_id`),
  CONSTRAINT `raqt_rating_additional_question_id` FOREIGN KEY (`rating_additional_question_id`) REFERENCES `rating_additional_questions` (`id`),
  CONSTRAINT `raqt_ticket_id` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating_additional_question_ticket`
--

LOCK TABLES `rating_additional_question_ticket` WRITE;
/*!40000 ALTER TABLE `rating_additional_question_ticket` DISABLE KEYS */;
/*!40000 ALTER TABLE `rating_additional_question_ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating_additional_questions`
--

DROP TABLE IF EXISTS `rating_additional_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_additional_questions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `question` varchar(255) NOT NULL,
  `rating_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rating_additional_questions_rating_id_foreign` (`rating_id`),
  CONSTRAINT `rating_additional_questions_rating_id_foreign` FOREIGN KEY (`rating_id`) REFERENCES `ratings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating_additional_questions`
--

LOCK TABLES `rating_additional_questions` WRITE;
/*!40000 ALTER TABLE `rating_additional_questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `rating_additional_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating_feedback_requests`
--

DROP TABLE IF EXISTS `rating_feedback_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_feedback_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `requested_type` varchar(255) NOT NULL,
  `requested_id` bigint(20) unsigned NOT NULL,
  `rating_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_answered` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `rating_feedback_requests_requested_type_requested_id_index` (`requested_type`,`requested_id`),
  KEY `rating_feedback_requests_rating_id_foreign` (`rating_id`),
  KEY `rating_feedback_requests_is_answered_index` (`is_answered`),
  CONSTRAINT `rating_feedback_requests_rating_id_foreign` FOREIGN KEY (`rating_id`) REFERENCES `ratings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating_feedback_requests`
--

LOCK TABLES `rating_feedback_requests` WRITE;
/*!40000 ALTER TABLE `rating_feedback_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `rating_feedback_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating_ref`
--

DROP TABLE IF EXISTS `rating_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_ref` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rating_id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `thread_id` int(11) NOT NULL,
  `rating_value` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating_ref`
--

LOCK TABLES `rating_ref` WRITE;
/*!40000 ALTER TABLE `rating_ref` DISABLE KEYS */;
/*!40000 ALTER TABLE `rating_ref` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ratings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL,
  `allow_modification` int(11) NOT NULL,
  `rating_scale` int(11) NOT NULL,
  `rating_area` varchar(255) NOT NULL,
  `restrict` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `rating_icon` varchar(255) DEFAULT 'star',
  `thank_you_message` text NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `show_additional_comment_box` tinyint(1) NOT NULL DEFAULT 0,
  `has_additional_question` tinyint(1) NOT NULL DEFAULT 0,
  `parent_rating_id` int(10) unsigned DEFAULT NULL,
  `auto_reminder` int(11) NOT NULL DEFAULT 0,
  `reminder_time_interval` int(11) DEFAULT NULL,
  `total_number_of_reminders` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ratings_parent_rating_id_foreign` (`parent_rating_id`),
  CONSTRAINT `ratings_parent_rating_id_foreign` FOREIGN KEY (`parent_rating_id`) REFERENCES `ratings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratings`
--

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;
INSERT INTO `ratings` VALUES (1,'OverAll Satisfaction',1,1,5,'Helpdesk Area','','2025-01-03 04:07:23','2025-01-03 04:07:28','star','Thank you for your valuable feedback.',1,0,0,NULL,0,NULL,NULL),(2,'Reply Rating',2,1,5,'Comment Area','','2025-01-03 04:07:23','2025-01-03 04:07:28','star','Thank you for your valuable feedback.',0,0,0,NULL,0,NULL,NULL);
/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratings_morph`
--

DROP TABLE IF EXISTS `ratings_morph`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ratings_morph` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `rating` int(11) NOT NULL,
  `rateable_type` varchar(255) NOT NULL,
  `rateable_id` bigint(20) unsigned NOT NULL,
  `impact` varchar(255) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `rating_id` int(10) unsigned NOT NULL,
  `from_mail` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ratings_morph_rateable_type_rateable_id_index` (`rateable_type`,`rateable_id`),
  KEY `ratings_morph_rateable_id_index` (`rateable_id`),
  KEY `ratings_morph_rateable_type_index` (`rateable_type`),
  KEY `ratings_morph_user_id_foreign` (`user_id`),
  KEY `ratings_morph_rating_id_foreign` (`rating_id`),
  CONSTRAINT `ratings_morph_rating_id_foreign` FOREIGN KEY (`rating_id`) REFERENCES `ratings` (`id`),
  CONSTRAINT `ratings_morph_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratings_morph`
--

LOCK TABLES `ratings_morph` WRITE;
/*!40000 ALTER TABLE `ratings_morph` DISABLE KEYS */;
/*!40000 ALTER TABLE `ratings_morph` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recure_contents`
--

DROP TABLE IF EXISTS `recure_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recure_contents` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `recur_id` int(11) NOT NULL,
  `option` varchar(255) NOT NULL,
  `value` longtext NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `ticket_template_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recure_contents`
--

LOCK TABLES `recure_contents` WRITE;
/*!40000 ALTER TABLE `recure_contents` DISABLE KEYS */;
/*!40000 ALTER TABLE `recure_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recurs`
--

DROP TABLE IF EXISTS `recurs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recurs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `interval` varchar(255) NOT NULL,
  `delivery_on` varchar(255) NOT NULL,
  `start_date` timestamp NULL DEFAULT NULL,
  `end_date` timestamp NULL DEFAULT NULL,
  `last_execution` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'admin_panel',
  `user_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `execution_time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `recurs_user_id_foreign` (`user_id`),
  CONSTRAINT `recurs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recurs`
--

LOCK TABLES `recurs` WRITE;
/*!40000 ALTER TABLE `recurs` DISABLE KEYS */;
/*!40000 ALTER TABLE `recurs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_columns`
--

DROP TABLE IF EXISTS `report_columns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_columns` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `is_visible` tinyint(1) NOT NULL DEFAULT 0,
  `is_sortable` tinyint(1) NOT NULL DEFAULT 0,
  `is_timestamp` tinyint(1) NOT NULL DEFAULT 0,
  `timestamp_format` varchar(255) DEFAULT NULL,
  `is_html` tinyint(1) NOT NULL DEFAULT 0,
  `is_custom` tinyint(1) NOT NULL DEFAULT 0,
  `equation` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT 0,
  `type` varchar(150) NOT NULL,
  `sub_report_id` int(11) DEFAULT NULL,
  `category_modifier` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `report_columns_key_sub_report_id_index` (`key`,`sub_report_id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_columns`
--

LOCK TABLES `report_columns` WRITE;
/*!40000 ALTER TABLE `report_columns` DISABLE KEYS */;
INSERT INTO `report_columns` VALUES (1,'ticket_number','ticket_number',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',1,'management_report',4,NULL),(2,'subject','subject',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',2,'management_report',4,NULL),(3,'statuses.name','status',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',3,'management_report',4,NULL),(4,'department.name','department',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',4,'management_report',4,NULL),(5,'helptopic.name','helptopic',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',5,'management_report',4,NULL),(6,'types.name','type',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',6,'management_report',4,NULL),(7,'priority.name','priority',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',7,'management_report',4,NULL),(8,'user.name','owner',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',8,'management_report',4,NULL),(9,'organizations','organizations',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',9,'management_report',4,NULL),(10,'assigned.name','assigned_agent',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',10,'management_report',4,NULL),(11,'sources.name','source',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',11,'management_report',4,NULL),(12,'assigned_team.name','assigned_team',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',12,'management_report',4,NULL),(13,'creator.name','creator',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',13,'management_report',4,NULL),(14,'location.name','location',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',14,'management_report',4,NULL),(15,'time_tracked','time_tracked',1,0,0,NULL,0,0,'','2025-01-03 04:07:24','2025-01-03 04:07:24',15,'management_report',4,NULL),(16,'overdue','is_overdue',0,0,0,NULL,0,0,'','2025-01-03 04:07:24','2025-01-03 04:07:31',16,'management_report',4,NULL),(17,'is_response_sla','has_response_sla_met',0,1,0,NULL,0,0,'','2025-01-03 04:07:24','2025-01-03 04:07:31',17,'management_report',4,NULL),(18,'is_resolution_sla','has_resolution_sla_met',0,1,0,NULL,0,0,'','2025-01-03 04:07:24','2025-01-03 04:07:31',18,'management_report',4,NULL),(19,'labels','labels',0,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:31',19,'management_report',4,NULL),(20,'tags','tags',0,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:31',20,'management_report',4,NULL),(21,'resolution_time','resolved_in',0,1,0,NULL,0,0,'','2025-01-03 04:07:24','2025-01-03 04:07:31',21,'management_report',4,NULL),(22,'first_response_time','first_replied_at',0,1,1,NULL,0,0,'','2025-01-03 04:07:24','2025-01-03 04:07:31',22,'management_report',4,NULL),(23,'created_at','created_at',0,1,1,NULL,0,0,'','2025-01-03 04:07:24','2025-01-03 04:07:31',23,'management_report',4,NULL),(24,'updated_at','updated_at',0,1,1,NULL,0,0,'','2025-01-03 04:07:24','2025-01-03 04:07:31',24,'management_report',4,NULL),(25,'closed_at','closed_at',0,1,1,NULL,0,0,'','2025-01-03 04:07:24','2025-01-03 04:07:31',25,'management_report',4,NULL),(26,'description','description',0,0,0,NULL,0,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',26,'management_report',4,NULL),(27,'name','name',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',1,'agent_performance_report',5,NULL),(28,'assigned_tickets','assigned_tickets',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',2,'agent_performance_report',5,NULL),(29,'reopened_tickets','reopened_tickets',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',3,'agent_performance_report',5,NULL),(30,'resolved_tickets','resolved_tickets',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',4,'agent_performance_report',5,NULL),(31,'tickets_with_response_sla_met','tickets_with_response_sla_met',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',5,'agent_performance_report',5,NULL),(32,'tickets_with_resolution_sla_met','tickets_with_resolution_sla_met',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',6,'agent_performance_report',5,NULL),(33,'avg_resolution_time','avg_resolution_time',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',7,'agent_performance_report',5,NULL),(34,'avg_response_time','avg_response_time',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',8,'agent_performance_report',5,NULL),(35,'responses','responses',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',9,'agent_performance_report',5,NULL),(36,'name','name',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',1,'department_performance_report',6,NULL),(37,'assigned_tickets','assigned_tickets',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',2,'department_performance_report',6,NULL),(38,'reopened_tickets','reopened_tickets',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',3,'department_performance_report',6,NULL),(39,'resolved_tickets','resolved_tickets',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',4,'department_performance_report',6,NULL),(40,'tickets_with_response_sla_met','tickets_with_response_sla_met',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',5,'department_performance_report',6,NULL),(41,'tickets_with_resolution_sla_met','tickets_with_resolution_sla_met',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',6,'department_performance_report',6,NULL),(42,'avg_resolution_time','avg_resolution_time',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',7,'department_performance_report',6,NULL),(43,'avg_response_time','avg_response_time',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',8,'department_performance_report',6,NULL),(44,'responses','responses',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',9,'department_performance_report',6,NULL),(45,'name','name',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',1,'team_performance_report',7,NULL),(46,'assigned_tickets','assigned_tickets',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',2,'team_performance_report',7,NULL),(47,'reopened_tickets','reopened_tickets',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',3,'team_performance_report',7,NULL),(48,'resolved_tickets','resolved_tickets',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',4,'team_performance_report',7,NULL),(49,'tickets_with_response_sla_met','tickets_with_response_sla_met',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',5,'team_performance_report',7,NULL),(50,'tickets_with_resolution_sla_met','tickets_with_resolution_sla_met',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',6,'team_performance_report',7,NULL),(51,'avg_resolution_time','avg_resolution_time',1,1,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',7,'team_performance_report',7,NULL),(52,'avg_response_time','avg_response_time',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',8,'team_performance_report',7,NULL),(53,'responses','responses',1,0,0,NULL,1,0,'','2025-01-03 04:07:24','2025-01-03 04:07:25',9,'team_performance_report',7,NULL),(54,'ticket_number','ticket_number',1,1,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:28',1,'turn-around-time-report',12,NULL),(55,'turn_around_time_department','turn_around_time_department',1,1,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:28',2,'turn-around-time-report',12,NULL),(56,'subject','subject',1,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:31',3,'turn-around-time-report',12,NULL),(57,'statuses.name','status',1,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:31',4,'turn-around-time-report',12,NULL),(58,'department.name','department',1,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:31',5,'turn-around-time-report',12,NULL),(59,'helptopic.name','helptopic',1,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:31',6,'turn-around-time-report',12,NULL),(60,'types.name','type',1,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:31',7,'turn-around-time-report',12,NULL),(61,'priority.name','priority',1,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:31',8,'turn-around-time-report',12,NULL),(62,'user.name','owner',1,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:31',9,'turn-around-time-report',12,NULL),(63,'organizations','organizations',1,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:31',10,'turn-around-time-report',12,NULL),(64,'assigned.name','assigned_agent',1,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:31',11,'turn-around-time-report',12,NULL),(65,'sources.name','source',1,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:31',12,'turn-around-time-report',12,NULL),(66,'assigned_team.name','assigned_team',1,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:31',13,'turn-around-time-report',12,NULL),(67,'creator.name','creator',1,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:31',14,'turn-around-time-report',12,NULL),(68,'location.name','location',1,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:31',15,'turn-around-time-report',12,NULL),(69,'time_tracked','time_tracked',0,0,0,NULL,0,0,'','2025-01-03 04:07:28','2025-01-03 04:07:28',16,'turn-around-time-report',12,NULL),(70,'overdue','is_overdue',0,0,0,NULL,0,0,'','2025-01-03 04:07:28','2025-01-03 04:07:28',17,'turn-around-time-report',12,NULL),(71,'is_response_sla','has_response_sla_met',0,1,0,NULL,0,0,'','2025-01-03 04:07:28','2025-01-03 04:07:28',18,'turn-around-time-report',12,NULL),(72,'is_resolution_sla','has_resolution_sla_met',0,1,0,NULL,0,0,'','2025-01-03 04:07:28','2025-01-03 04:07:28',19,'turn-around-time-report',12,NULL),(73,'labels','labels',0,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:28',20,'turn-around-time-report',12,NULL),(74,'tags','tags',0,0,0,NULL,1,0,'','2025-01-03 04:07:28','2025-01-03 04:07:28',21,'turn-around-time-report',12,NULL),(75,'resolution_time','resolved_in',0,1,0,NULL,0,0,'','2025-01-03 04:07:28','2025-01-03 04:07:28',22,'turn-around-time-report',12,NULL),(76,'first_response_time','first_replied_at',0,1,1,NULL,0,0,'','2025-01-03 04:07:28','2025-01-03 04:07:28',23,'turn-around-time-report',12,NULL),(77,'created_at','created_at',0,1,1,NULL,0,0,'','2025-01-03 04:07:28','2025-01-03 04:07:28',24,'turn-around-time-report',12,NULL),(78,'updated_at','updated_at',0,1,1,NULL,0,0,'','2025-01-03 04:07:28','2025-01-03 04:07:28',25,'turn-around-time-report',12,NULL),(79,'closed_at','closed_at',0,1,1,NULL,0,0,'','2025-01-03 04:07:28','2025-01-03 04:07:28',26,'turn-around-time-report',12,NULL),(80,'description','description',0,0,0,NULL,0,0,'','2025-01-03 04:07:28','2025-01-03 04:07:28',27,'turn-around-time-report',12,NULL),(81,'subject','subject',1,1,0,NULL,0,0,'','2025-01-03 04:07:30','2025-01-03 04:07:30',1,'schedule-report',13,NULL),(82,'type','type',1,0,0,NULL,0,0,'','2025-01-03 04:07:30','2025-01-03 04:07:30',2,'schedule-report',13,NULL),(83,'status','status',1,1,0,NULL,0,0,'','2025-01-03 04:07:30','2025-01-03 04:07:30',3,'schedule-report',13,NULL),(84,'interval','interval',0,1,0,NULL,0,0,'','2025-01-03 04:07:30','2025-01-03 04:07:30',4,'schedule-report',13,NULL),(85,'periods','periods',0,0,0,NULL,1,0,'','2025-01-03 04:07:30','2025-01-03 04:07:30',5,'schedule-report',13,NULL),(86,'execute_at','execute_at',0,0,0,NULL,0,0,'','2025-01-03 04:07:30','2025-01-03 04:07:30',6,'schedule-report',13,NULL),(87,'persons','notify',0,1,0,NULL,1,0,'','2025-01-03 04:07:30','2025-01-03 04:07:30',7,'schedule-report',13,NULL),(88,'extension','extension',0,1,0,NULL,0,0,'','2025-01-03 04:07:30','2025-01-03 04:07:30',8,'schedule-report',13,NULL),(89,'created_at','created_at',0,1,1,NULL,0,0,'','2025-01-03 04:07:30','2025-01-03 04:07:30',9,'schedule-report',13,NULL),(90,'updated_at','updated_at',0,1,1,NULL,0,0,'','2025-01-03 04:07:30','2025-01-03 04:07:30',10,'schedule-report',13,NULL),(91,'name','name',1,1,0,NULL,1,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',1,'user-report',14,NULL),(92,'user_name','user_name',0,1,0,NULL,1,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',2,'user-report',14,NULL),(93,'first_name','first_name',0,1,0,NULL,0,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',3,'user-report',14,NULL),(94,'last_name','last_name',0,1,0,NULL,0,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',4,'user-report',14,NULL),(95,'email','email',1,1,0,NULL,0,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',5,'user-report',14,NULL),(96,'active','active',0,1,0,NULL,0,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',6,'user-report',14,NULL),(97,'mobile','mobile',0,0,0,NULL,0,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',8,'user-report',14,NULL),(98,'role','role',1,1,0,NULL,0,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',9,'user-report',14,NULL),(99,'created_at','created_at',0,1,1,NULL,0,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',10,'user-report',14,NULL),(100,'location','user_location',0,1,0,NULL,0,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',11,'user-report',14,NULL),(101,'created_by','created_by',0,1,0,NULL,0,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',12,'user-report',14,NULL),(102,'deactivated_by','deactivated_by',0,1,0,NULL,0,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',13,'user-report',14,NULL),(103,'deactivated_at','deactivated_at',0,0,1,NULL,0,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',14,'user-report',14,NULL),(104,'organizations','organizations',1,0,0,NULL,0,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',15,'user-report',14,NULL),(105,'labels','labels',0,0,0,NULL,1,0,'','2025-01-03 04:07:31','2025-01-03 04:07:31',16,'user-report',14,NULL);
/*!40000 ALTER TABLE `report_columns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_downloads`
--

DROP TABLE IF EXISTS `report_downloads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_downloads` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `file` varchar(255) NOT NULL,
  `report_id` bigint(20) NOT NULL,
  `ext` char(5) NOT NULL,
  `type` varchar(100) NOT NULL,
  `hash` varchar(100) NOT NULL,
  `expired_at` datetime NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `is_completed` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `schedule_content_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reports_hash_unique` (`hash`),
  KEY `reports_user_id_foreign` (`user_id`),
  KEY `report_downloads_schedule_content_id_foreign` (`schedule_content_id`),
  CONSTRAINT `report_downloads_schedule_content_id_foreign` FOREIGN KEY (`schedule_content_id`) REFERENCES `report_schedule_contents` (`id`),
  CONSTRAINT `reports_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_downloads`
--

LOCK TABLES `report_downloads` WRITE;
/*!40000 ALTER TABLE `report_downloads` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_downloads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_schedule_contents`
--

DROP TABLE IF EXISTS `report_schedule_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_schedule_contents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `report_schedule_id` bigint(20) unsigned NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `subject` varchar(255) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `execution_time` time NOT NULL,
  `extension` varchar(255) NOT NULL,
  `available_for_schedule` tinyint(4) NOT NULL DEFAULT 1,
  `last_scheduled_at` timestamp NULL DEFAULT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `report_schedule_contents_report_schedule_id_foreign` (`report_schedule_id`),
  CONSTRAINT `report_schedule_contents_report_schedule_id_foreign` FOREIGN KEY (`report_schedule_id`) REFERENCES `report_schedules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_schedule_contents`
--

LOCK TABLES `report_schedule_contents` WRITE;
/*!40000 ALTER TABLE `report_schedule_contents` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_schedule_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_schedule_periods`
--

DROP TABLE IF EXISTS `report_schedule_periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_schedule_periods` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `schedule_content_id` bigint(20) unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  `executed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `report_schedule_periods_schedule_content_id_foreign` (`schedule_content_id`),
  CONSTRAINT `report_schedule_periods_schedule_content_id_foreign` FOREIGN KEY (`schedule_content_id`) REFERENCES `report_schedule_contents` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_schedule_periods`
--

LOCK TABLES `report_schedule_periods` WRITE;
/*!40000 ALTER TABLE `report_schedule_periods` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_schedule_periods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_schedule_persons`
--

DROP TABLE IF EXISTS `report_schedule_persons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_schedule_persons` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `schedule_content_id` bigint(20) unsigned NOT NULL,
  `user_type` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `report_schedule_persons_schedule_content_id_foreign` (`schedule_content_id`),
  KEY `report_schedule_persons_user_type_user_id_index` (`user_type`,`user_id`),
  CONSTRAINT `report_schedule_persons_schedule_content_id_foreign` FOREIGN KEY (`schedule_content_id`) REFERENCES `report_schedule_contents` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_schedule_persons`
--

LOCK TABLES `report_schedule_persons` WRITE;
/*!40000 ALTER TABLE `report_schedule_persons` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_schedule_persons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_schedules`
--

DROP TABLE IF EXISTS `report_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_schedules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `report_type` varchar(255) NOT NULL,
  `report_id` bigint(20) unsigned NOT NULL,
  `user_type` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `report_schedules_report_type_report_id_index` (`report_type`,`report_id`),
  KEY `report_schedules_user_type_user_id_index` (`user_type`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_schedules`
--

LOCK TABLES `report_schedules` WRITE;
/*!40000 ALTER TABLE `report_schedules` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `description` text NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL,
  `type` varchar(255) NOT NULL,
  `icon_class` varchar(50) NOT NULL,
  `category` varchar(30) NOT NULL,
  `view_url` varchar(255) DEFAULT NULL,
  `export_url` varchar(255) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_plugin` tinyint(4) NOT NULL DEFAULT 0,
  `is_private` tinyint(4) NOT NULL DEFAULT 0,
  `display_order` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
INSERT INTO `reports` VALUES (1,'helpdesk-in-depth','helpdesk-in-depth-description',NULL,0,'helpdesk-in-depth','fa fa-support fa-stack-1x','helpdesk-analysis','reports/helpdesk-in-depth/1','api/agent/report-export/1',1,'2025-01-03 04:07:24','2025-01-03 04:07:24',0,0,NULL),(2,'ticket-volume-trends','ticket-volume-trends-description',NULL,0,'ticket-volume-trends','fa fa-calendar fa-stack-1x','helpdesk-analysis','reports/ticket-volume-trends/2','api/agent/report-export/2',1,'2025-01-03 04:07:24','2025-01-03 04:07:24',0,0,NULL),(3,'management-report','management-report-description',NULL,0,'management-report','fa fa-user-secret fa-stack-1x','helpdesk-analysis','reports/management-report/3','api/agent/report-export/3',1,'2025-01-03 04:07:24','2025-01-03 04:07:31',0,0,NULL),(4,'agent-performance','agent-performance-description',NULL,0,'agent-performance','fa fa-user fa-stack-1x','productivity','reports/agent-performance/4','api/agent/report-export/4',1,'2025-01-03 04:07:24','2025-01-03 04:07:25',0,0,NULL),(5,'department-performance','department-performance-description',NULL,0,'department-performance','fa fa-building fa-stack-1x','productivity','reports/department-performance/5','api/agent/report-export/5',1,'2025-01-03 04:07:24','2025-01-03 04:07:25',0,0,NULL),(6,'team-performance','team-performance-description',NULL,0,'team-performance','fa fa-users fa-stack-1x','productivity','reports/team-performance/6','api/agent/report-export/6',1,'2025-01-03 04:07:24','2025-01-03 04:07:25',0,0,NULL),(7,'performance-distribution','performance-distribution-description',NULL,0,'performance-distribution','fa fa-cubes fa-stack-1x','productivity','reports/performance-distribution/7','api/agent/report-export/7',1,'2025-01-03 04:07:24','2025-01-03 04:07:24',0,0,NULL),(8,'top-customer-analysis','top-customer-analysis-description',NULL,0,'top-customer-analysis','fa fa-bank fa-stack-1x','customer-happiness','reports/top-customer-analysis/8','api/agent/report-export/8',1,'2025-01-03 04:07:24','2025-01-03 04:07:24',0,0,NULL),(9,'rating-in-depth','rating-in-depth-description',NULL,0,'rating-in-depth','fa fa-support fa-stack-1x','customer-happiness','reports/Feedback Rating Analysis/9','api/agent/report-export/9',1,'2025-01-03 04:07:28','2025-01-03 04:07:28',0,0,NULL),(10,'turn-around-time-report','turn-around-time-report-description',NULL,0,'turn-around-time','fa fa-clock fa-stack-1x','helpdesk-analysis','reports/turn-around-time/10','api/agent/report-export/10',1,'2025-01-03 04:07:28','2025-01-03 04:07:31',0,0,NULL),(11,'schedule-report','schedule-report-report-description',NULL,0,'schedule-report','fa fa-clock fa-stack-1x','schedule-datatable',NULL,NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30',0,1,NULL),(12,'user-report','user-report-description',NULL,0,'user-report','fa fa-clock fa-stack-1x','user-datatable',NULL,NULL,1,'2025-01-03 04:07:31','2025-01-03 04:07:31',0,0,NULL);
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `required_fields`
--

DROP TABLE IF EXISTS `required_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `required_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `is_agent_required` int(11) NOT NULL,
  `is_client_required` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `required_fields`
--

LOCK TABLES `required_fields` WRITE;
/*!40000 ALTER TABLE `required_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `required_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requireds`
--

DROP TABLE IF EXISTS `requireds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requireds` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form` varchar(255) DEFAULT NULL,
  `field` varchar(255) DEFAULT NULL,
  `agent` varchar(255) DEFAULT NULL,
  `client` varchar(255) DEFAULT NULL,
  `parent` int(11) DEFAULT NULL,
  `option` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requireds`
--

LOCK TABLES `requireds` WRITE;
/*!40000 ALTER TABLE `requireds` DISABLE KEYS */;
/*!40000 ALTER TABLE `requireds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `saml_login`
--

DROP TABLE IF EXISTS `saml_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `saml_login` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `provider` varchar(255) NOT NULL,
  `entity_id` varchar(255) NOT NULL,
  `sso_url` varchar(255) NOT NULL,
  `slo_url` varchar(255) NOT NULL,
  `certificate` longtext NOT NULL,
  `status` int(11) NOT NULL,
  `SP_entity_id` varchar(255) NOT NULL,
  `SP_ACS_url` varchar(255) NOT NULL,
  `login_url` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `logout_time` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `saml_login`
--

LOCK TABLES `saml_login` WRITE;
/*!40000 ALTER TABLE `saml_login` DISABLE KEYS */;
/*!40000 ALTER TABLE `saml_login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `search_drivers`
--

DROP TABLE IF EXISTS `search_drivers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `search_drivers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`value`)),
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `search_drivers`
--

LOCK TABLES `search_drivers` WRITE;
/*!40000 ALTER TABLE `search_drivers` DISABLE KEYS */;
INSERT INTO `search_drivers` VALUES (1,'database',NULL,1,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(2,'meilisearch','{\"host\":\"http:\\/\\/localhost:7700\",\"key\":\"master-key\"}',0,'2025-01-03 04:07:30','2025-01-03 04:07:30'),(3,'algolia','{\"id\":\"\",\"secret\":\"\"}',0,'2025-01-03 04:07:30','2025-01-03 04:07:30');
/*!40000 ALTER TABLE `search_drivers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings_auto_response`
--

DROP TABLE IF EXISTS `settings_auto_response`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings_auto_response` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `new_ticket` tinyint(1) NOT NULL,
  `agent_new_ticket` tinyint(1) NOT NULL,
  `submitter` tinyint(1) NOT NULL,
  `participants` tinyint(1) NOT NULL,
  `overlimit` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings_auto_response`
--

LOCK TABLES `settings_auto_response` WRITE;
/*!40000 ALTER TABLE `settings_auto_response` DISABLE KEYS */;
/*!40000 ALTER TABLE `settings_auto_response` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings_company`
--

DROP TABLE IF EXISTS `settings_company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings_company` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `company_name` varchar(255) NOT NULL,
  `website` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `phone_country_code` varchar(7) DEFAULT NULL,
  `phone_iso` varchar(4) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `landing_page` varchar(255) NOT NULL,
  `offline_page` varchar(255) NOT NULL,
  `thank_page` varchar(255) NOT NULL,
  `logo` longtext DEFAULT NULL,
  `use_logo` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `logo_driver` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings_company`
--

LOCK TABLES `settings_company` WRITE;
/*!40000 ALTER TABLE `settings_company` DISABLE KEYS */;
INSERT INTO `settings_company` VALUES (1,'','','',NULL,NULL,'','','','',NULL,'','2025-01-03 04:07:23','2025-01-03 04:07:23',NULL);
/*!40000 ALTER TABLE `settings_company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings_email`
--

DROP TABLE IF EXISTS `settings_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings_email` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `template` varchar(255) NOT NULL,
  `sys_email` varchar(255) DEFAULT NULL,
  `alert_email` varchar(255) NOT NULL,
  `admin_email` varchar(255) NOT NULL,
  `mta` varchar(255) NOT NULL,
  `email_fetching` tinyint(1) NOT NULL,
  `notification_cron` tinyint(1) NOT NULL,
  `strip` tinyint(1) NOT NULL,
  `separator` tinyint(1) NOT NULL,
  `all_emails` tinyint(1) NOT NULL,
  `email_collaborator` tinyint(1) NOT NULL,
  `attachment` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings_email`
--

LOCK TABLES `settings_email` WRITE;
/*!40000 ALTER TABLE `settings_email` DISABLE KEYS */;
INSERT INTO `settings_email` VALUES (1,'default',NULL,'','','',1,0,0,0,1,1,1,'2025-01-03 04:07:23','2025-01-03 04:07:23');
/*!40000 ALTER TABLE `settings_email` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings_filesystem`
--

DROP TABLE IF EXISTS `settings_filesystem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings_filesystem` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `disk` varchar(255) NOT NULL,
  `allowed_files` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `show_public_folder_with_default_disk` tinyint(4) NOT NULL DEFAULT 0,
  `paste_on_disk_change` tinyint(4) NOT NULL DEFAULT 0,
  `paste_type` varchar(255) DEFAULT NULL,
  `files_moved_from_old_private_disk` tinyint(4) NOT NULL DEFAULT 0,
  `is_private_bucket_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `wkhtmltopdf_path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings_filesystem`
--

LOCK TABLES `settings_filesystem` WRITE;
/*!40000 ALTER TABLE `settings_filesystem` DISABLE KEYS */;
INSERT INTO `settings_filesystem` VALUES (1,'system','png,gif,jpg,jpeg,zip,rar,doc,docx,xls,xlsx,ppt,pptx,pdf,csv,txt','2025-01-03 04:07:25','2025-01-03 04:07:25',0,0,NULL,0,0,NULL);
/*!40000 ALTER TABLE `settings_filesystem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings_ratings`
--

DROP TABLE IF EXISTS `settings_ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings_ratings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rating_name` varchar(255) NOT NULL,
  `publish` int(11) NOT NULL,
  `modify` int(11) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `settings_ratings_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings_ratings`
--

LOCK TABLES `settings_ratings` WRITE;
/*!40000 ALTER TABLE `settings_ratings` DISABLE KEYS */;
/*!40000 ALTER TABLE `settings_ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings_security`
--

DROP TABLE IF EXISTS `settings_security`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings_security` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lockout_message` varchar(255) NOT NULL,
  `backlist_offender` int(11) NOT NULL,
  `backlist_threshold` int(11) NOT NULL,
  `lockout_period` int(11) NOT NULL,
  `days_to_keep_logs` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `delete_login_logs_older_than` int(11) NOT NULL DEFAULT 365,
  `is_2fa_enforced` tinyint(1) NOT NULL DEFAULT 0,
  `password_reset_max_attempts` int(11) NOT NULL DEFAULT 3,
  `password_reset_link_expiry` int(11) NOT NULL DEFAULT 15,
  `password_reset_attempts_awaiting_time` bigint(20) NOT NULL DEFAULT 60,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings_security`
--

LOCK TABLES `settings_security` WRITE;
/*!40000 ALTER TABLE `settings_security` DISABLE KEYS */;
INSERT INTO `settings_security` VALUES (1,'You have been locked out of application due to too many failed login attempts.',0,5,30,0,'2025-01-03 04:07:23','2025-01-03 04:07:28',365,0,3,15,60);
/*!40000 ALTER TABLE `settings_security` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings_system`
--

DROP TABLE IF EXISTS `settings_system`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings_system` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `department` varchar(255) NOT NULL,
  `page_size` varchar(255) NOT NULL,
  `log_level` varchar(255) NOT NULL,
  `purge_log` varchar(255) NOT NULL,
  `api_enable` int(11) NOT NULL,
  `api_key_mandatory` int(11) NOT NULL,
  `api_key` varchar(255) NOT NULL,
  `name_format` varchar(255) NOT NULL,
  `time_format` varchar(50) DEFAULT 'g:i a',
  `date_format` varchar(50) DEFAULT 'F j, Y',
  `time_zone_id` varchar(50) DEFAULT NULL,
  `date_time_format` varchar(50) DEFAULT NULL,
  `day_date_time` varchar(255) NOT NULL,
  `content` varchar(255) NOT NULL,
  `version` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `serial_key` varchar(100) DEFAULT NULL,
  `order_number` varchar(100) DEFAULT NULL,
  `is_updated` tinyint(1) NOT NULL DEFAULT 1,
  `limitations` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `time_farmat` (`time_format`),
  KEY `date_format` (`date_format`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings_system`
--

LOCK TABLES `settings_system` WRITE;
/*!40000 ALTER TABLE `settings_system` DISABLE KEYS */;
INSERT INTO `settings_system` VALUES (1,1,'','1','','','',0,0,'','','g:i a','F j, Y','116','F j, Y, g:i a','','en','v9.3.2','2025-01-03 04:07:23','2025-01-03 04:07:23',NULL,NULL,1,NULL);
/*!40000 ALTER TABLE `settings_system` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings_ticket`
--

DROP TABLE IF EXISTS `settings_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings_ticket` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `num_format` varchar(255) NOT NULL,
  `num_sequence` varchar(255) NOT NULL,
  `help_topic` varchar(255) NOT NULL,
  `max_open_ticket` varchar(255) NOT NULL,
  `collision_avoid` varchar(255) NOT NULL,
  `lock_ticket_frequency` varchar(255) NOT NULL DEFAULT '0',
  `captcha` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `claim_response` tinyint(1) NOT NULL,
  `assigned_ticket` tinyint(1) NOT NULL,
  `answered_ticket` tinyint(1) NOT NULL,
  `agent_mask` tinyint(1) NOT NULL,
  `html` tinyint(1) NOT NULL,
  `client_update` tinyint(1) NOT NULL,
  `max_file_size` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `count_internal` tinyint(1) NOT NULL DEFAULT 0,
  `show_status_date` tinyint(1) NOT NULL DEFAULT 0,
  `show_org_details` tinyint(1) NOT NULL DEFAULT 0,
  `custom_field_name` text NOT NULL,
  `waiting_time` int(11) NOT NULL,
  `ticket_number_prefix` varchar(20) NOT NULL,
  `show_user_location` tinyint(4) NOT NULL DEFAULT 0,
  `record_per_page` int(11) NOT NULL DEFAULT 10,
  `append_reply_by_fetching_email` int(11) NOT NULL DEFAULT 0,
  `auto_assign_ticket_to_agent_on_first_reply` int(11) NOT NULL DEFAULT 1,
  `automatic_redaction` int(11) NOT NULL DEFAULT 0,
  `credit_card_number` int(11) NOT NULL DEFAULT 0,
  `show_org_ticket_form` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings_ticket`
--

LOCK TABLES `settings_ticket` WRITE;
/*!40000 ALTER TABLE `settings_ticket` DISABLE KEYS */;
INSERT INTO `settings_ticket` VALUES (1,'$$$$-####-####','sequence','1','','2','0','',1,0,0,0,0,0,0,0,'2025-01-03 04:07:23','2025-01-03 04:07:24',0,0,0,'',17520,'',0,10,0,1,0,0,0);
/*!40000 ALTER TABLE `settings_ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_approach_escalate`
--

DROP TABLE IF EXISTS `sla_approach_escalate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_approach_escalate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sla_plan` int(11) NOT NULL,
  `escalate_time` varchar(255) NOT NULL,
  `escalate_type` varchar(255) NOT NULL,
  `escalate_person` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_approach_escalate`
--

LOCK TABLES `sla_approach_escalate` WRITE;
/*!40000 ALTER TABLE `sla_approach_escalate` DISABLE KEYS */;
/*!40000 ALTER TABLE `sla_approach_escalate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_custom_enforcements`
--

DROP TABLE IF EXISTS `sla_custom_enforcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_custom_enforcements` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `f_name` varchar(255) NOT NULL,
  `f_type` varchar(255) NOT NULL,
  `f_value` varchar(255) NOT NULL,
  `f_label` varchar(255) NOT NULL,
  `sla_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sla_custom_enforcements_sla_id_foreign` (`sla_id`),
  CONSTRAINT `sla_custom_enforcements_sla_id_foreign` FOREIGN KEY (`sla_id`) REFERENCES `ticket_status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_custom_enforcements`
--

LOCK TABLES `sla_custom_enforcements` WRITE;
/*!40000 ALTER TABLE `sla_custom_enforcements` DISABLE KEYS */;
/*!40000 ALTER TABLE `sla_custom_enforcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_plan`
--

DROP TABLE IF EXISTS `sla_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_plan` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `grace_period` varchar(255) NOT NULL,
  `admin_note` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `sla_target` int(11) NOT NULL,
  `apply_sla_depertment` varchar(255) NOT NULL,
  `apply_sla_company` varchar(255) NOT NULL,
  `apply_sla_tickettype` varchar(255) NOT NULL,
  `apply_sla_ticketsource` varchar(255) NOT NULL,
  `transient` tinyint(1) NOT NULL,
  `ticket_overdue` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `apply_sla_helptopic` varchar(255) NOT NULL,
  `apply_sla_orgdepts` varchar(255) NOT NULL,
  `apply_sla_labels` varchar(255) NOT NULL,
  `apply_sla_tags` varchar(255) NOT NULL,
  `order` int(11) NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_plan`
--

LOCK TABLES `sla_plan` WRITE;
/*!40000 ALTER TABLE `sla_plan` DISABLE KEYS */;
INSERT INTO `sla_plan` VALUES (1,'Low','','',1,1,'','','','',0,0,'2025-01-03 04:07:23','2025-01-03 04:07:23','','','','',0,1),(2,'Normal','','',1,2,'','','','',0,0,'2025-01-03 04:07:23','2025-01-03 04:07:23','','','','',0,0),(3,'High','','',1,3,'','','','',0,0,'2025-01-03 04:07:23','2025-01-03 04:07:23','','','','',0,0),(4,'Emergency','','',1,4,'','','','',0,0,'2025-01-03 04:07:23','2025-01-03 04:07:23','','','','',0,0);
/*!40000 ALTER TABLE `sla_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_targets`
--

DROP TABLE IF EXISTS `sla_targets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_targets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `sla_id` int(11) NOT NULL,
  `priority_id` int(11) NOT NULL,
  `respond_within` varchar(255) NOT NULL,
  `resolve_within` varchar(255) NOT NULL,
  `business_hour_id` int(11) NOT NULL,
  `send_email` int(11) NOT NULL,
  `send_sms` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `in_app` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_targets`
--

LOCK TABLES `sla_targets` WRITE;
/*!40000 ALTER TABLE `sla_targets` DISABLE KEYS */;
INSERT INTO `sla_targets` VALUES (1,'Low',1,1,'5-hrs','10-hrs',1,1,0,'2025-01-03 04:07:23','2025-01-03 04:07:23',0),(2,'Normal',2,2,'4-hrs','9-hrs',1,1,0,'2025-01-03 04:07:23','2025-01-03 04:07:23',0),(3,'High',3,3,'2-hrs','4-hrs',1,1,0,'2025-01-03 04:07:23','2025-01-03 04:07:23',0),(4,'Emergency',4,4,'1-hrs','2-hrs',1,1,0,'2025-01-03 04:07:23','2025-01-03 04:07:23',0);
/*!40000 ALTER TABLE `sla_targets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla_violated_escalate`
--

DROP TABLE IF EXISTS `sla_violated_escalate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla_violated_escalate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sla_plan` int(11) NOT NULL,
  `escalate_time` varchar(255) NOT NULL,
  `escalate_type` varchar(255) NOT NULL,
  `escalate_person` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla_violated_escalate`
--

LOCK TABLES `sla_violated_escalate` WRITE;
/*!40000 ALTER TABLE `sla_violated_escalate` DISABLE KEYS */;
/*!40000 ALTER TABLE `sla_violated_escalate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_media`
--

DROP TABLE IF EXISTS `social_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `social_media` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `provider` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_media`
--

LOCK TABLES `social_media` WRITE;
/*!40000 ALTER TABLE `social_media` DISABLE KEYS */;
INSERT INTO `social_media` VALUES (1,'facebook','status','0','2025-01-03 04:07:25','2025-01-03 04:07:25'),(2,'facebook','redirect','https://raffi.helpdesk/faveo/public/social/login/facebook','2025-01-03 04:07:25','2025-01-03 04:07:25'),(3,'google','status','0','2025-01-03 04:07:25','2025-01-03 04:07:25'),(4,'google','redirect','https://raffi.helpdesk/faveo/public/social/login/google','2025-01-03 04:07:25','2025-01-03 04:07:25'),(5,'github','status','0','2025-01-03 04:07:25','2025-01-03 04:07:25'),(6,'github','redirect','https://raffi.helpdesk/faveo/public/social/login/github','2025-01-03 04:07:25','2025-01-03 04:07:25'),(7,'twitter','status','0','2025-01-03 04:07:25','2025-01-03 04:07:25'),(8,'twitter','redirect','https://raffi.helpdesk/faveo/public/social/login/twitter','2025-01-03 04:07:25','2025-01-03 04:07:25'),(9,'linkedin-openid','status','0','2025-01-03 04:07:25','2025-01-03 04:07:30'),(10,'linkedin-openid','redirect','https://raffi.helpdesk/faveo/public/social/login/linkedin-openid','2025-01-03 04:07:25','2025-01-03 04:07:30'),(11,'bitbucket','status','0','2025-01-03 04:07:25','2025-01-03 04:07:25'),(12,'bitbucket','redirect','https://raffi.helpdesk/faveo/public/social/login/bitbucket','2025-01-03 04:07:25','2025-01-03 04:07:25');
/*!40000 ALTER TABLE `social_media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `states` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `country_id` int(10) unsigned NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `states_country_id_foreign` (`country_id`),
  CONSTRAINT `states_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `country_code` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4366 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `states`
--

LOCK TABLES `states` WRITE;
/*!40000 ALTER TABLE `states` DISABLE KEYS */;
INSERT INTO `states` VALUES (1,'Zabol [Zabul]',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(2,'Oruzgan [Uruzgan]',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(3,'Kondoz [Kunduz]',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(4,'Parwan',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(5,'Sar-e Pol',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(6,'Paktika',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(7,'Lowgar',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(8,'Kapisa',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(9,'Herat',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(10,'Kandahar',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(11,'Samangan',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(12,'Takhar',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(13,'Wardak [Wardag]',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(14,'Badakhshan',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(15,'Baghlan',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(16,'Bamian',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(17,'Faryab',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(18,'Ghazni',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(19,'Badghis',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(20,'Balkh',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(21,'Farah',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(22,'Ghowr',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(23,'Khowst',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(24,'Helmand',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(25,'Kabul [Kabol]',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(26,'Laghman',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(27,'Nangrahar [Nangarhar]',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(28,'Nurestan',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(29,'Paktia',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(30,'Jowzjan',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(31,'Konar [Kunar]',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(32,'Nimruz',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(33,'Daykondi',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(34,'Panjshir',1,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(35,'Tiranë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(36,'Shkodër',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(37,'Pogradec',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(38,'Mirditë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(39,'Kolonjë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(40,'Mat',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(41,'Peqin',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(42,'Përmet',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(43,'Pukë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(44,'Sarandë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(45,'Skrapar',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(46,'Tepelenë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(47,'Tropojë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(48,'Vlorë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(49,'Has',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(50,'Kavajë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(51,'Korçë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(52,'Krujë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(53,'Kukës',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(54,'Kurbin',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(55,'Librazhd',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(56,'Lushnjë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(57,'Malësi e Madhe',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(58,'Bulqizë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(59,'Delvinë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(60,'Dibër',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(61,'Durrës',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(62,'Fier',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(63,'Gjirokastër',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(64,'Elbasan',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(65,'Berat',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(66,'Devoll',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(67,'Gramsh',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(68,'Kuçovë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(69,'Lezhë',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(70,'Mallakastër',2,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(71,'Ouargla',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(72,'El Oued',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(73,'Tizi Ouzou',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(74,'Tissemsilt',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(75,'Sidi Bel Abbès',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(76,'Saïda',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(77,'Naama',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(78,'Mila',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(79,'Jijel',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(80,'Annaba',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(81,'Aïn Témouchent',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(82,'Batna',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(83,'Béjaïa',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(84,'Blida',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(85,'Boumerdès',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(86,'Relizane',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(87,'Khenchela',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(88,'Illizi',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(89,'Bouira',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(90,'Bordj Bou Arréridj',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(91,'Ghardaïa',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(92,'Alger',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(93,'Djelfa',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(94,'Médéa',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(95,'Mostaganem',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(96,'Constantine',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(97,'Skikda',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(98,'Laghouat',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(99,'Aïn Defla',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(100,'Béchar',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(101,'El Bayadh',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(102,'Biskra',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(103,'Sétif',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(104,'Souk Ahras',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(105,'El Tarf',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(106,'Tébessa',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(107,'Tindouf',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(108,'Tiaret',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(109,'Oum el Bouaghi',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(110,'Oran',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(111,'Adrar',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(112,'Msila',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(113,'Mascara',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(114,'Guelma',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(115,'Chlef',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(116,'Tamanghasset',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(117,'Tipaza',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(118,'Tlemcen',3,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(119,'Sant Julià de Lòria',5,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(120,'Ordino',5,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(121,'Escaldes-Engordany',5,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(122,'Canillo',5,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(123,'Andorra la Vella',5,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(124,'Encamp',5,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(125,'La Massana',5,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(126,'Zaire',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(127,'Lunda Sul',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(128,'Luanda',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(129,'Cuanza Norte',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(130,'Cunene',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(131,'Bengo',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(132,'Benguela',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(133,'Cabinda',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(134,'Huambo',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(135,'Cuando-Cubango',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(136,'Bié',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(137,'Huíla',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(138,'Cuanza Sul',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(139,'Lunda Norte',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(140,'Malange',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(141,'Uíge',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(142,'Moxico',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(143,'Namibe',6,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(144,'Redonda',9,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(145,'Barbuda',9,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(146,'Saint George',9,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(147,'Saint Mary',9,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(148,'Saint Paul',9,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(149,'Saint Philip',9,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(150,'Saint Johns',9,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(151,'Saint Peter',9,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(152,'Santiago del Estero',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(153,'Santa Cruz',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(154,'Salta',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(155,'La Rioja',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(156,'Ciudad Autónoma de Buenos Aires',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(157,'Catamarca',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(158,'Buenos Aires',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(159,'Chaco',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(160,'Córdoba',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(161,'Corrientes',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(162,'Entre Ríos',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(163,'Jujuy',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(164,'La Pampa',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(165,'Mendoza',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(166,'Neuquén',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(167,'Río Negro',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(168,'San Juan',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(169,'San Luis',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(170,'Santa Fe',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(171,'Tierra del Fuego',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(172,'Tucumán',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(173,'Chubut',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(174,'Formosa',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(175,'Misiones',10,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(176,'Tavuš',11,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(177,'Vayoc Jor',11,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(178,'Širak',11,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(179,'Gegark',11,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(180,'Ararat',11,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(181,'Kotayk',11,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(182,'Syunik',11,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(183,'Erevan',11,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(184,'Lo?y',11,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(185,'Aragac?otn',11,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(186,'Armavir',11,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(187,'Western Australia',13,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(188,'Australian Capital Territory',13,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(189,'South Australia',13,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(190,'Victoria',13,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(191,'Tasmania',13,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(192,'Northern Territory',13,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(193,'Queensland',13,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(194,'New South Wales',13,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(195,'Wien',14,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(196,'Salzburg',14,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(197,'Burgenland',14,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(198,'Kärnten',14,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(199,'Oberösterreich',14,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(200,'Steiermark',14,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(201,'Vorarlberg',14,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(202,'Niederösterreich',14,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(203,'Tirol',14,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(204,'Zängilan',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(205,'Yardimli',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(206,'Xocali',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(207,'Xankändi',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(208,'Sumqayit',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(209,'Samux',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(210,'Agstafa',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(211,'Babäk',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(212,'Bärdä',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(213,'Cäbrayil',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(214,'Daskäsän',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(215,'Äli Bayramli',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(216,'Gäncä',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(217,'Haciqabul',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(218,'Ismayilli',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(219,'Sahbuz',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(220,'Samaxi',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(221,'Sädäräk',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(222,'Säki',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(223,'Särur',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(224,'Siyäzän',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(225,'Susa',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(226,'Tärtär',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(227,'Ucar',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(228,'Goranboy',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(229,'Göyçay',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(230,'Imisli',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(231,'Kälbäcär',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(232,'Kürdämir',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(233,'Länkäran',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(234,'Lerik',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(235,'Mingäçevir',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(236,'Naftalan',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(237,'Abseron',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(238,'Agcabädi',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(239,'Agdas',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(240,'Agsu',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(241,'Astara',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(242,'Baki',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(243,'Balakän',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(244,'Beyläqan',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(245,'Biläsuvar',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(246,'Cälilabab',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(247,'Culfa',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(248,'Däväçi',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(249,'Füzuli',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(250,'Gädäbäy',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(251,'Neftçala',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(252,'Ordubad',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(253,'Qax',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(254,'Qäbälä',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(255,'Qobustan',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(256,'Qubadli',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(257,'Qusar',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(258,'Sabirabad',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(259,'Xaçmaz',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(260,'Xanlar',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(261,'Xizi',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(262,'Xocavänd',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(263,'Yevlax',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(264,'Zaqatala',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(265,'Zärdab',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(266,'Agdam',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(267,'Laçin',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(268,'Masalli',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(269,'Naxçivan',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(270,'Oguz',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(271,'Qazax',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(272,'Quba',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(273,'Saatli',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(274,'Salyan',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(275,'Sämkir',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(276,'Tovuz',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(277,'Länkäran City',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(278,'Säki City',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(279,'Susa City',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(280,'Yevlax City',15,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(281,'Mayaguana',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(282,'Inagua',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(283,'City of Freeport',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(284,'Acklins  Islands',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(285,'Ragged Island',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(286,'Green Turtle Cay',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(287,'Grand Cay',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(288,'Bimini and Cat Cay',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(289,'Cat Island',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(290,'Exuma',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(291,'Harbour Island',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(292,'Long Island',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(293,'Berry Islands',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(294,'Black Point',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(295,'Central Abaco',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(296,'Central Andros',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(297,'Central Eleuthera',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(298,'Crooked Island and Long Cay',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(299,'East Grand Bahama',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(300,'Hope Town',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(301,'Mangrove Cay',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(302,'Moore Island',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(303,'North Abaco',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(304,'North Andros',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(305,'North Eleuthera',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(306,'Rum Cay',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(307,'San Salvador',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(308,'South Abaco',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(309,'South Andros',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(310,'South Eleuthera',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(311,'Spanish Wells',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(312,'West Grand Bahama',16,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(313,'Al Wustá',17,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(314,'Ash Shamaliyah',17,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(315,'Al Muharraq',17,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(316,'Al Manamah',17,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(317,'Al Janubiyah',17,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(318,'Tangail zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(319,'Sirajganj zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(320,'Sherpur zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(321,'Rajshahi zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(322,'Panchagarh zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(323,'Nawabganj zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(324,'Narayanganj zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(325,'Bagerhat zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(326,'Bandarban zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(327,'Barguna zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(328,'Jessore zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(329,'Jhenaidah zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(330,'Kishoreganj zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(331,'Comilla zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(332,'Kushtia zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(333,'Lalmonirhat zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(334,'Magura zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(335,'Manikganj zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(336,'Meherpur zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(337,'Barisal zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(338,'Bhola zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(339,'Bogra zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(340,'Chandpur zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(341,'Dhaka zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(342,'Faridpur zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(343,'Feni zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(344,'Gopalganj zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(345,'Jaipurhat zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(346,'Mymensingh zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(347,'Moulvibazar zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(348,'Munshiganj zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(349,'Narail zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(350,'Narsingdi zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(351,'Naogaon zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(352,'Netrakona zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(353,'Noakhali zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(354,'Pabna zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(355,'Brahmanbaria zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(356,'Chittagong zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(357,'Chuadanga zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(358,'Dinajpur zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(359,'Gaibandha zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(360,'Gazipur zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(361,'Habiganj zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(362,'Jamalpur zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(363,'Jhalakati zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(364,'Khagrachari zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(365,'Khulna zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(366,'Cox',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(367,'Kurigram zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(368,'Lakshmipur zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(369,'Madaripur zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(370,'Patuakhali zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(371,'Rajbari zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(372,'Rangamati zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(373,'Rangpur zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(374,'Shariatpur zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(375,'Sylhet zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(376,'Sunamganj zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(377,'Thakurgaon zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(378,'Natore zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(379,'Nilphamari zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(380,'Pirojpur zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(381,'Satkhira zila',18,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(382,'Saint Thomas',19,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(383,'Saint Michael',19,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(384,'Saint Joseph',19,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(385,'Saint James',19,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(386,'Christ Church',19,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(387,'Saint George',19,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(388,'Saint Andrew',19,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(389,'Saint John',19,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(390,'Saint Lucy',19,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(391,'Saint Peter',19,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(392,'Saint Philip',19,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(393,'Vitsyebskaya voblasts',20,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(394,'Brestskaya voblasts',20,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(395,'Homyel',20,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(396,'Mahilyowskaya voblasts',20,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(397,'Hrodzenskaya voblasts',20,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(398,'Minskaya voblasts',20,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(399,'Horad Minsk',20,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(400,'Vlaams Brabant',21,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(401,'Luxembourg',21,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(402,'Oost-Vlaanderen',21,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(403,'Hainaut',21,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(404,'Brabant Wallon',21,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(405,'Limburg',21,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(406,'West-Vlaanderen',21,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(407,'Brussels',21,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(408,'Antwerpen',21,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(409,'Liège',21,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(410,'Namur',21,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(411,'Stann Creek',22,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(412,'Belize',22,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(413,'Corozal',22,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(414,'Orange Walk',22,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(415,'Toledo',22,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(416,'Cayo',22,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(417,'Zou',23,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(418,'Plateau',23,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(419,'Littoral',23,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(420,'Alibori',23,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(421,'Atlantique',23,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(422,'Borgou',23,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(423,'Kouffo',23,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(424,'Mono',23,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(425,'Ouémé',23,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(426,'Atakora',23,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(427,'Collines',23,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(428,'Donga',23,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(429,'Trongsa',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(430,'Samtse',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(431,'Punakha',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(432,'Zhemgang',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(433,'Trashigang',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(434,'Monggar',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(435,'Dagana',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(436,'Bumthang',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(437,'Tsirang',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(438,'Sarpang',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(439,'Lhuentse',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(440,'Pemagatshel',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(441,'Paro',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(442,'Samdrup Jongkha',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(443,'Thimphu',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(444,'Wangdue Phodrang',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(445,'Gasa',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(446,'Trashi Yangtse',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(447,'Chhukha',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(448,'Ha',25,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(449,'Potosí',26,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(450,'Oruro',26,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(451,'Chuquisaca',26,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(452,'El Beni',26,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(453,'Cochabamba',26,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(454,'La Paz',26,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(455,'Pando',26,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(456,'Santa Cruz',26,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(457,'Tarija',26,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(458,'Federacija Bosna i Hercegovina',27,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(459,'Republika Srpska',27,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(460,'Brčko distrikt',27,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(461,'Bosansko-podrinjski kanton',27,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(462,'Hercegova?ko-neretvanski kanton',27,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(463,'Kanton br. 10 (Livanjski kanton)',27,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(464,'Kanton Sarajevo',27,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(465,'Posavski kanton',27,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(466,'Srednjobosanski kanton',27,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(467,'Tuzlanski kanton',27,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(468,'Unsko-sanski kanton',27,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(469,'Zapadnohercegova?ki kanton',27,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(470,'Zeni?ko-dobojski kanton',27,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(471,'North-East',28,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(472,'South-East',28,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(473,'Ghanzi',28,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(474,'Kweneng',28,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(475,'Kgatleng',28,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(476,'Central',28,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(477,'Kgalagadi',28,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(478,'North-West',28,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(479,'Southern',28,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(480,'São Paulo',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(481,'Rondônia',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(482,'Pernambuco',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(483,'Mato Grosso do Sul',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(484,'Amapá',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(485,'Bahia',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(486,'Distrito Federal',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(487,'Espírito Santo',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(488,'Maranhão',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(489,'Mato Grosso',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(490,'Minas Gerais',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(491,'Paraíba',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(492,'Paraná',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(493,'Alagoas',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(494,'Piauí',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(495,'Rio de Janeiro',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(496,'Rio Grande do Sul',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(497,'Roraima',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(498,'Santa Catarina',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(499,'Sergipe',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(500,'Tocantins',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(501,'Acre',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(502,'Amazonas',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(503,'Ceará',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(504,'Goiás',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(505,'Pará',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(506,'Rio Grande do Norte',30,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(507,'Tutong',32,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(508,'Belait',32,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(509,'Temburong',32,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(510,'Brunei-Muara',32,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(511,'Veliko Tarnovo',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(512,'Smolyan',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(513,'Razgrad',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(514,'Montana',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(515,'Yambol',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(516,'Burgas',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(517,'Plovdiv',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(518,'Ruse',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(519,'Sliven',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(520,'Sofia-Grad',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(521,'Stara Zagora',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(522,'Šumen',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(523,'Varna',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(524,'Vidin',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(525,'Vratsa',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(526,'Gabrovo',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(527,'Haskovo',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(528,'Kardzhali',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(529,'Lovech',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(530,'Pazardzhik',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(531,'Pleven',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(532,'Blagoevgrad',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(533,'Dobrich',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(534,'Kjustendil',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(535,'Pernik',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(536,'Silistra',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(537,'Sofia',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(538,'Targovishte',33,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(539,'Loroum',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(540,'Nahouri',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(541,'Noumbiel',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(542,'Oudalan',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(543,'Sanguié',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(544,'Séno',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(545,'Sissili',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(546,'Soum',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(547,'Sourou',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(548,'Balé',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(549,'Banwa',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(550,'Boulgou',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(551,'Comoé',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(552,'Gourma',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(553,'Ioba',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(554,'Kénédougou',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(555,'Kossi',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(556,'Kouritenga',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(557,'Bam',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(558,'Bazèga',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(559,'Bougouriba',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(560,'Boulkiemdé',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(561,'Ganzourgou',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(562,'Gnagna',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(563,'Houet',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(564,'Kadiogo',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(565,'Komondjari',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(566,'Kompienga',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(567,'Koulpélogo',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(568,'Kourwéogo',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(569,'Léraba',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(570,'Mouhoun',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(571,'Namentenga',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(572,'Nayala',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(573,'Oubritenga',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(574,'Passoré',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(575,'Poni',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(576,'Sanmatenga',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(577,'Ziro',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(578,'Yatenga',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(579,'Yagha',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(580,'Tapoa',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(581,'Tui',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(582,'Zondoma',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(583,'Zoundwéogo',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(584,'Boucle du Mouhoun',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(585,'Cascades',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(586,'Centre',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(587,'Centre-Est',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(588,'Centre-Nord',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(589,'Centre-Ouest',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(590,'Centre-Sud',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(591,'Est',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(592,'Hauts-Bassins',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(593,'Nord',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(594,'Plateau-Central',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(595,'Sahel',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(596,'Sud-Ouest',34,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(597,'Ruyigi',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(598,'Cankuzo',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(599,'Gitega',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(600,'Karuzi',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(601,'Kirundo',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(602,'Makamba',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(603,'Muyinga',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(604,'Ngozi',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(605,'Rutana',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(606,'Bubanza',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(607,'Kayanza',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(608,'Bururi',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(609,'Cibitoke',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(610,'Muramvya',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(611,'Mwaro',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(612,'Bujumbura Mairie',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(613,'Bujumbura Rural',35,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(614,'Pousaat [Pouthisat]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(615,'Otdar Mean Chey [Otdâr Méanchey] ',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(616,'Kampong Thum [Kâmpóng Thum]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(617,'Kampot [Kâmpôt]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(618,'Kandaal [Kândal]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(619,'Kaoh Kong [Kaôh Kong]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(620,'Kracheh [Krâchéh]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(621,'Krong Kaeb [Krong Kêb]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(622,'Krong Pailin [Krong Pailin]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(623,'Krong Preah Sihanouk [Krong Preah Sihanouk]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(624,'Mondol Kiri [Môndól Kiri]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(625,'Banteay Mean Chey [Bântéay Méanchey]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(626,'Kampong Chaam [Kâmpóng Cham]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(627,'Preah Vihear [Preah Vihéar]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(628,'Prey Veaeng [Prey Vêng]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(629,'Siem Reab [Siemréab]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(630,'Svaay Rieng [Svay Rieng]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(631,'Baat Dambang [Batdâmbâng]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(632,'Kampong Chhnang [Kâmpóng Chhnang]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(633,'Kampong Spueu [Kâmpóng Spœ]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(634,'Phnom Penh [Phnum Pénh]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(635,'Rotanak Kiri [Rôtânôkiri]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(636,'Taakaev [Takêv]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(637,'Stueng Traeng [Stœ?ng Trêng]',36,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(638,'South-West',37,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(639,'North-West',37,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(640,'Centre',37,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(641,'Littoral',37,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(642,'West',37,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(643,'North',37,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(644,'Adamaoua',37,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(645,'East',37,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(646,'Far North',37,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(647,'South',37,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(648,'Saskatchewan',38,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(649,'New Brunswick',38,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(650,'British Columbia',38,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(651,'Northwest Territories',38,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(652,'Alberta',38,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(653,'Manitoba',38,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(654,'Newfoundland and Labrador',38,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(655,'Nova Scotia',38,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(656,'Nunavut',38,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(657,'Prince Edward Island',38,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(658,'Quebec',38,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(659,'Yukon Territory',38,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(660,'Ontario',38,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(661,'São Vicente',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(662,'Boa Vista',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(663,'Maio',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(664,'Ribeira Grande',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(665,'São Lourenço dos Órgãos',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(666,'Brava',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(667,'Mosteiros',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(668,'Paul',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(669,'Porto Novo',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(670,'Praia',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(671,'Santa Catarina',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(672,'Santa Cruz',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(673,'São Domingos',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(674,'São Filipe',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(675,'Tarrafal',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(676,'Ilhas de Barlavento',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(677,'Ilhas de Sotavento',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(678,'Ribeira Brava',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(679,'Ribeira Grande de Santiago',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(680,'Santa Catarina do Fogo',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(681,'São Miguel',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(682,'São Salvador do Mundo',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(683,'Tarrafal de São Nicolau',39,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(684,'Little Cayman',40,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(685,'Cayman Brac',40,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(686,'East End',40,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(687,'Bodden Town',40,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(688,'George Town',40,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(689,'North Side',40,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(690,'West Bay',40,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(691,'Sangha',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(692,'Ombella-Mpoko',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(693,'Gribingui',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(694,'Haute-Sangha / Mambéré-Kadéï',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(695,'Kémo-Gribingui',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(696,'Haute-Kotto',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(697,'Bangui',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(698,'Ouham-Pendé',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(699,'Vakaga',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(700,'Bamingui-Bangoran',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(701,'Basse-Kotto',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(702,'Haut-Mbomou',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(703,'Lobaye',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(704,'Mbomou',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(705,'Nana-Mambéré',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(706,'Ouham',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(707,'Ouaka',41,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(708,'Tānjilī',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(709,'Al Baṭḩah',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(710,'Qīrā',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(711,'Kānim',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(712,'Al Buḩayrah',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(713,'Lūqūn al Gharbī',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(714,'Lūqūn ash Sharqī',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(715,'Waddāy',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(716,'Shārī Bāqirmī',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(717,'Shārī al Awsaṭ',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(718,'Salāmāt',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(719,'Ḥajjar Lamīs',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(720,'Māndūl',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(721,'Māyū Kībbī ash Sharqī',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(722,'Māyū Kībbī al Gharbī',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(723,'Madīnat Injamīnā',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(724,'Wādī Fīrā',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(725,'Baḩr al Ghazāl',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(726,'Būrkū',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(727,'Innīdī',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(728,'Sīlā',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(729,'Tibastī',42,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(730,'Tarapacá',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(731,'Maule',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(732,'Coquimbo',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(733,'Araucanía',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(734,'Antofagasta',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(735,'Atacama',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(736,'Libertador General Bernardo Higgins',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(737,'Magallanes',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(738,'Región Metropolitana de Santiago',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(739,'Valparaíso',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(740,'Aisén del General Carlos Ibáñez del Campo',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(741,'Bío-Bío',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(742,'Los Lagos',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(743,'Arica y Parinacota',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(744,'Los Ríos',43,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(745,'Zhejiang',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(746,'Xinjiang',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(747,'Tianjin',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(748,'Shanxi',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(749,'Shandong',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(750,'Anhui',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(751,'Beijing',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(752,'Chongqing',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(753,'Gansu',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(754,'Guangdong',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(755,'Guizhou',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(756,'Hainan',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(757,'Hebei',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(758,'Hubei',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(759,'Jiangxi',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(760,'Jilin',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(761,'Liaoning',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(762,'Nei Mongol (mn)',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(763,'Ningxia',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(764,'Qinghai',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(765,'Shaanxi',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(766,'Heilongjiang',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(767,'Henan',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(768,'Hunan',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(769,'Jiangsu',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(770,'Xizang',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(771,'Yunnan',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(772,'Aomen (zh) ***',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(773,'Fujian',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(774,'Guangxi',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(775,'Shanghai',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(776,'Sichuan',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(777,'Xianggang (zh) **',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(778,'Taiwan *',44,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(779,'Vaupés',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(780,'Sucre',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(781,'Quindío',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(782,'San Andrés, Providencia y Santa Catalina',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(783,'Nariño',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(784,'Amazonas',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(785,'Arauca',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(786,'Atlántico',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(787,'Bolívar',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(788,'Caldas',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(789,'Caquetá',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(790,'Cauca',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(791,'Chocó',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(792,'Córdoba',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(793,'Guainía',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(794,'Antioquia',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(795,'Distrito Capital de Bogotá',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(796,'Boyacá',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(797,'Casanare',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(798,'Cesar',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(799,'Cundinamarca',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(800,'Guaviare',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(801,'Magdalena',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(802,'Huila',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(803,'La Guajira',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(804,'Meta',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(805,'Norte de Santander',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(806,'Putumayo',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(807,'Risaralda',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(808,'Santander',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(809,'Tolima',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(810,'Valle del Cauca',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(811,'Vichada',47,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(812,'Andjouân (Anjwān)',48,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(813,'Andjazîdja',48,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(814,'Moûhîlî (Mūhīlī)',48,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(815,'Cuvette-Ouest',49,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(816,'Cuvette',49,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(817,'Bouenza',49,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(818,'Likouala',49,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(819,'Brazzaville',49,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(820,'Kouilou',49,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(821,'Lékoumou',49,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(822,'Niari',49,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(823,'Pool',49,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(824,'Sangha',49,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(825,'Plateaux',49,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(826,'Nord-Kivu',50,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(827,'Bas-Congo',50,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(828,'Orientale',50,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(829,'Kasai-Oriental',50,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(830,'Kinshasa',50,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(831,'Kasai-Occidental',50,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(832,'Équateur',50,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(833,'Bandundu',50,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(834,'Maniema',50,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(835,'Sud-Kivu',50,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(836,'Katanga',50,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(837,'Puntarenas',52,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(838,'Limón',52,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(839,'Cartago',52,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(840,'Guanacaste',52,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(841,'San José',52,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(842,'Heredia',52,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(843,'Alajuela',52,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(844,'18 Montagnes (Région des)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(845,'Agnébi (Région de l)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(846,'Bafing (Région du)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(847,'Bas-Sassandra (Région du)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(848,'Denguélé (Région du)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(849,'Fromager (Région du)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(850,'Haut-Sassandra (Région du)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(851,'Lacs (Région des)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(852,'Lagunes (Région des)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(853,'Marahoué (Région de la)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(854,'Moyen-Cavally (Région du)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(855,'Moyen-Comoé (Région du)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(856,'Nzi-Comoé (Région)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(857,'Savanes (Région des)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(858,'Sud-Bandama (Région du)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(859,'Sud-Comoé (Région du)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(860,'Vallée du Bandama (Région de la)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(861,'Worodougou (Région du)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(862,'Zanzan (Région du)',53,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(863,'Vukovarsko-srijemska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(864,'Istarska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(865,'Dubrovacko-neretvanska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(866,'Grad Zagreb',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(867,'Karlovacka županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(868,'Krapinsko-zagorska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(869,'Licko-senjska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(870,'Osjecko-baranjska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(871,'Primorsko-goranska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(872,'Šibensko-kninska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(873,'Brodsko-posavska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(874,'Varaždinska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(875,'Viroviticko-podravska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(876,'Zadarska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(877,'Zagrebacka županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(878,'Bjelovarsko-bilogorska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(879,'Koprivnicko-križevacka županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(880,'Splitsko-dalmatinska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(881,'Sisacko-moslavacka županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(882,'Požeško-slavonska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(883,'Medimurska županija',54,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(884,'Ciudad de La Habana',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(885,'Isla de la Juventud',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(886,'Las Tunas',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(887,'Matanzas',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(888,'Sancti Spíritus',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(889,'Villa Clara',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(890,'Camagüey',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(891,'Ciego de Ávila',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(892,'Cienfuegos',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(893,'Granma',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(894,'Holguín',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(895,'Guantánamo',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(896,'Santiago de Cuba',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(897,'La Habana',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(898,'Pinar del Río',55,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(899,'Keryneia',56,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(900,'Larnaka',56,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(901,'Lefkosia',56,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(902,'Lemesos',56,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(903,'Pafos',56,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(904,'Ammochostos',56,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(905,'Karlovarský kraj',57,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(906,'Liberecký kraj',57,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(907,'Olomoucký kraj',57,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(908,'Plzenský kraj',57,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(909,'Stredoceský kraj',57,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(910,'Vysocina',57,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(911,'Jihoceský kraj',57,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(912,'Jihomoravský kraj ',57,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(913,'Královéhradecký kraj',57,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(914,'Moravskoslezský kraj',57,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(915,'Pardubický kraj',57,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(916,'Praha, hlavní mesto',57,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(917,'Ústecký kraj ',57,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(918,'Zlínský kraj',57,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(919,'Bornholm',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(920,'Frederiksborg',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(921,'København City',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(922,'Ringkøbing',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(923,'Sønderjylland',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(924,'Storstrøm',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(925,'Vejle',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(926,'Vestsjælland',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(927,'Viborg',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(928,'Fyn',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(929,'København',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(930,'Nordjylland',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(931,'Ribe',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(932,'Roskilde',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(933,'Århus',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(934,'Frederiksberg City',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(935,'Capital',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(936,'Central Jutland',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(937,'North Jutland',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(938,'Zeeland',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(939,'South Denmark',58,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(940,'Djibouti',59,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(941,'Obock',59,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(942,'Dikhil',59,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(943,'Ali Sabieh',59,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(944,'Tadjourah',59,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(945,'Arta',59,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(946,'Saint Patrick',60,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(947,'Saint Andrew',60,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(948,'Saint Paul',60,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(949,'Saint Peter',60,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(950,'Saint David',60,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(951,'Saint Mark',60,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(952,'Saint Joseph',60,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(953,'Saint John',60,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(954,'Saint George',60,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(955,'Saint Luke',60,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(956,'Barahona',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(957,'La Romana',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(958,'Bahoruco',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(959,'Dajabón',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(960,'Duarte',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(961,'El Seybo [El Seibo]',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(962,'Espaillat',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(963,'Independencia',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(964,'María Trinidad Sánchez',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(965,'Monte Cristi',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(966,'Pedernales',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(967,'Peravia',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(968,'Salcedo',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(969,'Sánchez Ramírez',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(970,'San Jose de Ocoa',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(971,'San Pedro de Macorís',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(972,'Santiago Rodríguez',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(973,'Valverde',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(974,'Azua',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(975,'La Estrelleta [Elías Piña]',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(976,'Hato Mayor',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(977,'La Altagracia',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(978,'La Vega',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(979,'Monseñor Nouel',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(980,'Monte Plata',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(981,'Puerto Plata',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(982,'Samaná',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(983,'San Cristóbal',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(984,'San Juan',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(985,'Santiago',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(986,'Distrito Nacional (Santo Domingo)',61,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(987,'Zamora-Chinchipe',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(988,'Sucumbíos',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(989,'Pastaza',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(990,'Napo',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(991,'Azuay',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(992,'Bolívar',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(993,'Carchi',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(994,'Cotopaxi',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(995,'El Oro',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(996,'Galápagos',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(997,'Guayas',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(998,'Loja',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(999,'Cañar',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1000,'Chimborazo',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1001,'Esmeraldas',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1002,'Imbabura',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1003,'Los Ríos',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1004,'Manabí',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1005,'Morona-Santiago',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1006,'Orellana',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1007,'Pichincha',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1008,'Tungurahua',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1009,'Santa Elena',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1010,'Santo Domingo de los Tsachilas',62,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1011,'Al Wadi al Jadid',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1012,'al-Uqsur',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1013,'Shamal Sina',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1014,'Al Minya',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1015,'Kafr ash Shaykh',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1016,'Būr Sa`īd',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1017,'Dumyat',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1018,'Al Iskandariyah',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1019,'Al Jizah',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1020,'Matrūh',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1021,'Al Qahirah',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1022,'Qina',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1023,'Ash Sharqiyah',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1024,'As Suways',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1025,'Aswan',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1026,'Bani Suwayf',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1027,'Asyut',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1028,'Al Bahr al Ahmar',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1029,'Al Buhayrah',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1030,'Ad Daqahliyah',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1031,'Al Fayyum',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1032,'Al Gharbiyah',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1033,'Al Ismā`īlīyah',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1034,'Janub Sina',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1035,'Al Minufiyah',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1036,'Al Qalyubiyah',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1037,'Suhaj',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1038,'As Sādis min Uktūbar',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1039,'Ḩulwān',63,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1040,'Usulután',64,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1041,'San Vicente',64,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1042,'Morazán',64,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1043,'Chalatenango',64,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1044,'Ahuachapán',64,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1045,'Cabañas',64,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1046,'Cuscatlán',64,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1047,'La Paz',64,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1048,'La Unión',64,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1049,'San Miguel',64,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1050,'Santa Ana',64,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1051,'Sonsonate',64,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1052,'La Libertad',64,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1053,'San Salvador',64,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1054,'Wele-Nzás',65,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1055,'Kie-Ntem',65,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1056,'Litoral',65,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1057,'Bioko Norte',65,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1058,'Centro Sur',65,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1059,'Bioko Sur',65,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1060,'Annobón',65,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1061,'Región Continental',65,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1062,'Región Insular',65,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1063,'Semenawi Keyih Bahri [Semien-Keih-Bahri]',66,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1064,'Gash-Barka',66,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1065,'Anseba',66,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1066,'Debubawi Keyih Bahri [Debub-Keih-Bahri]',66,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1067,'Maakel [Maekel]',66,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1068,'Debub',66,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1069,'Võrumaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1070,'Raplamaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1071,'Viljandimaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1072,'Saaremaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1073,'Ida-Virumaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1074,'Jõgevamaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1075,'Läänemaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1076,'Pärnumaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1077,'Põlvamaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1078,'Valgamaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1079,'Järvamaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1080,'Harjumaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1081,'Hiiumaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1082,'Lääne-Virumaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1083,'Tartumaa',67,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1084,'YeDebub Biheroch Bihereseboch na Hizboch',68,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1085,'Amara',68,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1086,'Tigray',68,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1087,'Adis Abeba',68,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1088,'Afar',68,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1089,'Binshangul Gumuz',68,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1090,'Sumale',68,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1091,'Hareri Hizb',68,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1092,'Gambela Hizboch',68,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1093,'Dire Dawa',68,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1094,'Oromiya',68,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1095,'Western',71,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1096,'Eastern',71,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1097,'Central',71,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1098,'Northern',71,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1099,'Rotuma',71,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1100,'Lapin lääni',72,1,'2025-01-03 04:07:25','2025-01-03 04:07:25'),(1101,'Ahvenanmaan lääni',72,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1102,'Itä-Suomen lääni',72,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1103,'Etelä-Suomen lääni',72,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1104,'Länsi-Suomen lääni',72,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1105,'Oulun lääni',72,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1106,'Yvelines',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1107,'Vosges',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1108,'Val-d Oise',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1109,'Seine-Maritime',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1110,'Somme',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1111,'Tarn-et-Garonne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1112,'Vaucluse',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1113,'Savoie',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1114,'Allier',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1115,'Alpes-Maritimes',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1116,'Ardennes',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1117,'Aude',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1118,'Bas-Rhin',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1119,'Mayotte',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1120,'Nouvelle-Calédonie',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1121,'Polynésie française',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1122,'Saint-Pierre-et-Miquelon',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1123,'Terres Australes Françaises',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1124,'Wallis et Futuna',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1125,'Clipperton',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1126,'Saint-Barthélemy',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1127,'Saint-Martin',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1128,'Calvados',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1129,'Charente',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1130,'Ain',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1131,'Aisne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1132,'Alpes-de-Haute-Provence',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1133,'Ardèche',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1134,'Ariège',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1135,'Aube',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1136,'Aveyron',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1137,'Bouches-du-Rhône',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1138,'Cantal',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1139,'Charente-Maritime',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1140,'Cher',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1141,'Corse-du-Sud',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1142,'Haute-Corse',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1143,'Haute-Loire',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1144,'Hautes-Alpes',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1145,'Haute-Savoie',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1146,'Hautes-Pyrénées',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1147,'Haut-Rhin',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1148,'Hérault',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1149,'Indre',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1150,'Indre-et-Loire',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1151,'Jura',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1152,'Loire',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1153,'Loiret',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1154,'Loir-et-Cher',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1155,'Lot-et-Garonne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1156,'Maine-et-Loire',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1157,'Marne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1158,'Mayenne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1159,'Meuse',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1160,'Moselle',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1161,'Nord',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1162,'Oise',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1163,'Paris',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1164,'Puy-de-Dôme',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1165,'Pyrénées-Orientales',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1166,'Rhône',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1167,'Sarthe',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1168,'Seine-et-Marne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1169,'Seine-Saint-Denis',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1170,'Tarn',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1171,'Territoire de Belfort',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1172,'Val-de-Marne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1173,'Var',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1174,'Vendée',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1175,'Vienne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1176,'Yonne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1177,'Corrèze',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1178,'Côte-d Or',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1179,'Côtes-d Armor',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1180,'Creuse',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1181,'Deux-Sèvres',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1182,'Dordogne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1183,'Doubs',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1184,'Lozère',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1185,'Manche',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1186,'Meurthe-et-Moselle',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1187,'Morbihan',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1188,'Nièvre',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1189,'Orne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1190,'Pas-de-Calais',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1191,'Pyrénées-Atlantiques',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1192,'Saône-et-Loire',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1193,'Haute-Marne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1194,'Haute-Saône',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1195,'Haute-Vienne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1196,'Hauts-de-Seine',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1197,'Ille-et-Vilaine',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1198,'Isère',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1199,'Landes',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1200,'Loire-Atlantique',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1201,'Lot',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1202,'Drôme',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1203,'Essonne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1204,'Eure',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1205,'Eure-et-Loir',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1206,'Finistère',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1207,'Gard',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1208,'Gers',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1209,'Gironde',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1210,'Haute-Garonne',73,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1211,'Iles Eparses',76,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1212,'Ile Saint-Paul et Ile Amsterdam',76,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1213,'Crozet Islands',76,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1214,'Kerguelen',76,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1215,'Woleu-Ntem',77,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1216,'Estuaire',77,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1217,'Ogooué-Maritime',77,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1218,'Moyen-Ogooué',77,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1219,'Ogooué-Ivindo',77,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1220,'Ogooué-Lolo',77,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1221,'Ngounié',77,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1222,'Haut-Ogooué',77,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1223,'Nyanga',77,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1224,'MacCarthy Island',78,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1225,'Banjul',78,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1226,'Upper River',78,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1227,'Western',78,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1228,'North Bank',78,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1229,'Lower River',78,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1230,'Tbilisi',79,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1231,'Ajaria',79,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1232,'Guria',79,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1233,'Kakheti',79,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1234,'Racha-Lechkhumi [and] Kvemo Svaneti',79,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1235,'Kvemo Kartli',79,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1236,'Imereti',79,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1237,'Abkhazia',79,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1238,'Samtskhe-Javakheti',79,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1239,'Shida Kartli',79,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1240,'Mtskheta-Mtianeti',79,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1241,'Samegrelo-Zemo Svaneti',79,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1242,'Bayern',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1243,'Brandenburg',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1244,'Hamburg',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1245,'Mecklenburg-Vorpommern',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1246,'Nordrhein-Westfalen',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1247,'Saarland',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1248,'Sachsen-Anhalt',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1249,'Thüringen',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1250,'Baden-Württemberg',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1251,'Berlin',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1252,'Bremen',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1253,'Hessen',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1254,'Niedersachsen',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1255,'Rheinland-Pfalz',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1256,'Sachsen',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1257,'Schleswig-Holstein',80,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1258,'Upper West',81,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1259,'Western',81,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1260,'Greater Accra',81,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1261,'Brong-Ahafo',81,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1262,'Volta',81,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1263,'Northern',81,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1264,'Ashanti',81,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1265,'Central',81,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1266,'Eastern',81,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1267,'Upper East',81,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1268,'Xanthi',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1269,'Trikala',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1270,'Thesprotia',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1271,'Samos',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1272,'Pieria',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1273,'Lesvos',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1274,'Achaïa',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1275,'Argolida',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1276,'Attiki',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1277,'Agio Oros',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1278,'Evrytania',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1279,'Evvoia',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1280,'Fthiotida',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1281,'Chalkidiki',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1282,'Chios',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1283,'Aitolia kai Akarnania',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1284,'Arkadia',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1285,'Arta',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1286,'Dodekanisos',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1287,'Drama',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1288,'Evros',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1289,'Florina',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1290,'Fokida',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1291,'Grevena',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1292,'Chania',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1293,'Ileia',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1294,'Irakleio',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1295,'Karditsa',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1296,'Kavala',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1297,'Kyklades',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1298,'Korinthia',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1299,'Lakonia',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1300,'Lasithi',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1301,'Lefkada',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1302,'Messinia',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1303,'Pella',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1304,'Preveza',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1305,'Rodopi',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1306,'Serres',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1307,'Thessaloniki',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1308,'Voiotia',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1309,'Zakynthos',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1310,'Imathia',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1311,'Ioannina',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1312,'Kastoria',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1313,'Kefallonia',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1314,'Kerkyra',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1315,'Kilkis',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1316,'Kozani',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1317,'Larisa',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1318,'Magnisia',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1319,'Rethymno',83,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1320,'Kommune Kujalleq (kl)',84,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1321,'Kommuneqarfik Sermersooq (kl)',84,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1322,'Qaasuitsup Kommunia (kl)',84,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1323,'Qeqqata Kommunia (kl)',84,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1324,'Saint Mark',85,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1325,'Southern Grenadine Islands',85,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1326,'Saint Patrick',85,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1327,'Saint John',85,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1328,'Saint Andrew',85,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1329,'Saint George',85,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1330,'Saint David',85,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1331,'Totonicapán',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1332,'Sololá',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1333,'San Marcos',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1334,'Retalhuleu',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1335,'Quetzaltenango',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1336,'Baja Verapaz',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1337,'Chiquimula',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1338,'Escuintla',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1339,'Guatemala',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1340,'Zacapa',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1341,'Alta Verapaz',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1342,'Chimaltenango',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1343,'El Progreso',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1344,'Huehuetenango',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1345,'Izabal',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1346,'Jalapa',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1347,'Jutiapa',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1348,'Petén',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1349,'Quiché',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1350,'Sacatepéquez',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1351,'Santa Rosa',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1352,'Suchitepéquez',88,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1353,'Tougué',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1354,'Pita',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1355,'Mandiana',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1356,'Mali',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1357,'Kouroussa',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1358,'Kérouané',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1359,'Beyla',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1360,'Boffa',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1361,'Boké',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1362,'Conakry',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1363,'Coyah',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1364,'Dalaba',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1365,'Forécariah',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1366,'Gaoual',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1367,'Dubréka',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1368,'Dabola',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1369,'Dinguiraye',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1370,'Faranah',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1371,'Fria',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1372,'Guékédou',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1373,'Kankan',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1374,'Kindia',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1375,'Koubia',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1376,'Koundara',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1377,'Labé',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1378,'Lola',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1379,'Macenta',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1380,'Mamou',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1381,'Nzérékoré',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1382,'Siguiri',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1383,'Télimélé',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1384,'Yomou',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1385,'Kissidougou',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1386,'Lélouma',89,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1387,'Quinara',90,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1388,'Bafatá',90,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1389,'Oio',90,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1390,'Bissau',90,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1391,'Biombo',90,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1392,'Cacheu',90,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1393,'Tombali',90,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1394,'Bolama',90,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1395,'Gabú',90,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1396,'Upper Demerara-Berbice',91,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1397,'Pomeroon-Supenaam',91,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1398,'Barima-Waini',91,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1399,'Demerara-Mahaica',91,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1400,'Essequibo Islands-West Demerara',91,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1401,'Mahaica-Berbice',91,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1402,'Potaro-Siparuni',91,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1403,'Upper Takutu-Upper Essequibo',91,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1404,'East Berbice-Corentyne',91,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1405,'Cuyuni-Mazaruni',91,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1406,'Sud',92,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1407,'Nord-Ouest',92,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1408,'Ouest',92,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1409,'Nord',92,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1410,'Centre',92,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1411,'Nord-Est',92,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1412,'Sud-Est',92,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1413,'Grande-Anse',92,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1414,'Artibonite',92,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1415,'Valle',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1416,'Intibucá',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1417,'Choluteca',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1418,'Colón',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1419,'Copán',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1420,'Francisco Morazán',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1421,'Gracias a Dios',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1422,'Islas de la Bahía',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1423,'Lempira',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1424,'Olancho',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1425,'Santa Bárbara',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1426,'Yoro',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1427,'Atlántida',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1428,'Comayagua',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1429,'Cortés',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1430,'El Paraíso',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1431,'La Paz',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1432,'Ocotepeque',95,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1433,'Békéscsaba',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1434,'Debrecen',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1435,'Dunaújváros',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1436,'Eger',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1437,'Gyor',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1438,'Hódmezovásárhely',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1439,'Kaposvár',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1440,'Kecskemét',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1441,'Miskolc',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1442,'Nagykanizsa',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1443,'Nyíregyháza',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1444,'Pécs',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1445,'Salgótarján',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1446,'Sopron',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1447,'Szeged',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1448,'Székesfehérvár',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1449,'Szekszárd',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1450,'Szolnok',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1451,'Szombathely',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1452,'Tatabánya',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1453,'Veszprém City',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1454,'Zalaegerszeg',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1455,'Erd',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1456,'Zala',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1457,'Tolna',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1458,'Pest',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1459,'Komárom-Esztergom',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1460,'Fejér',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1461,'Baranya',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1462,'Bács-Kiskun',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1463,'Békés',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1464,'Budapest',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1465,'Csongrád',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1466,'Gyor-Moson-Sopron',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1467,'Heves',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1468,'Jász-Nagykun-Szolnok',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1469,'Nógrád',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1470,'Somogy',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1471,'Szabolcs-Szatmár-Bereg',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1472,'Vas',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1473,'Veszprém',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1474,'Borsod-Abaúj-Zemplén',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1475,'Hajdú-Bihar',97,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1476,'Reykjavík',98,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1477,'Vesturland',98,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1478,'Vestfirðir',98,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1479,'Norðurland vestra',98,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1480,'Höfuðborgarsvæði utan Reykjavíkur',98,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1481,'Suðurnes',98,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1482,'Suðurland',98,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1483,'Norðurland eystra',98,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1484,'Austurland',98,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1485,'Uttaranchal',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1486,'Himachal Pradesh',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1487,'Andaman and Nicobar Islands',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1488,'Arunachal Pradesh',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1489,'Assam',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1490,'Bihar',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1491,'Chhattisgarh',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1492,'Dadra and Nagar Haveli',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1493,'Delhi',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1494,'Gujarat',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1495,'Haryana',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1496,'Jammu and Kashmir',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1497,'Karnataka',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1498,'Kerala',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1499,'Madhya Pradesh',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1500,'Maharashtra',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1501,'Meghalaya',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1502,'Nagaland',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1503,'Orissa',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1504,'Punjab',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1505,'Rajasthan',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1506,'Tamil Nadu',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1507,'Tripura',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1508,'Uttar Pradesh',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1509,'Andhra Pradesh',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1510,'West Bengal',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1511,'Chandigarh',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1512,'Daman and Diu',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1513,'Goa',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1514,'Jharkhand',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1515,'Sikkim',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1516,'Mizoram',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1517,'Manipur',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1518,'Lakshadweep',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1519,'Pondicherry',99,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1520,'Papua Barat',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1521,'Sulawesi Barat',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1522,'Sumatera Utara',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1523,'Sulawesi Selatan',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1524,'Riau',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1525,'Nusa Tenggara Timur',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1526,'Maluku Utara',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1527,'Gorontalo',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1528,'Jambi',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1529,'Jawa Tengah',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1530,'Kalimantan Barat',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1531,'Kalimantan Selatan',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1532,'Sulawesi Utara',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1533,'Sumatera Selatan',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1534,'Yogyakarta',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1535,'Bali',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1536,'Aceh',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1537,'Bangka Belitung',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1538,'Bengkulu',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1539,'Banten',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1540,'Jakarta Raya',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1541,'Jawa Barat',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1542,'Jawa Timur',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1543,'Kalimantan Tengah',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1544,'Kalimantan Timur',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1545,'Lampung',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1546,'Maluku',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1547,'Nusa Tenggara Barat',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1548,'Papua',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1549,'Kepulauan Riau',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1550,'Sulawesi Tengah',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1551,'Sumatera Barat',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1552,'Sulawesi Tenggara',100,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1553,'Khorasan-e Janubi',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1554,'Khorasan-e Razavi',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1555,'Khorasan-e Shemali',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1556,'Zanjan',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1557,'Qom',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1558,'Kermanshah',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1559,'Khorasan',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1560,'Khuzestan',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1561,'Kohkiluyeh va Buyer Ahmad',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1562,'Kordestan',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1563,'Lorestan',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1564,'Markazi',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1565,'Mazandaran',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1566,'Qazvin',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1567,'Ardabil',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1568,'Az¯arbayjan-e Sharqi',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1569,'Chahar Mah¸all va Bakhtiari',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1570,'Fars',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1571,'Hamadan',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1572,'Ilam',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1573,'Semnan',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1574,'Tehran',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1575,'Az¯arbayjan-e Gharbi',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1576,'Bushehr',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1577,'Esfahan',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1578,'Gilan',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1579,'Golestan',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1580,'Hormozgan',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1581,'Kerman',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1582,'Yazd',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1583,'Sistan va Baluchestan',101,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1584,'At Tamim',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1585,'Al Qadisiyah',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1586,'Salah ad Din',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1587,'An Najaf',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1588,'Arbil',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1589,'Baghdad',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1590,'Al Anbar',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1591,'Babil',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1592,'Al Basrah',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1593,'Dahuk',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1594,'Diyalá',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1595,'Karbala',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1596,'Al Muthanná',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1597,'Ninawá',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1598,'As Sulaymaniyah',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1599,'Wasit',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1600,'Dhi Qar',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1601,'Maysan',102,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1602,'Wexford',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1603,'Waterford',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1604,'Monaghan',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1605,'Longford',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1606,'Kildare',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1607,'Meath',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1608,'Offaly',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1609,'Sligo',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1610,'Tipperary',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1611,'Westmeath',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1612,'Wicklow',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1613,'Cavan',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1614,'Donegal',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1615,'Galway',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1616,'Carlow',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1617,'Clare',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1618,'Cork',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1619,'Dublin',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1620,'Kerry',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1621,'Kilkenny',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1622,'Leitrim',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1623,'Limerick',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1624,'Louth',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1625,'Laois',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1626,'Mayo',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1627,'Roscommon',103,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1628,'HaDarom',104,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1629,'HaZafon',104,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1630,'Tel-Aviv',104,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1631,'HaMerkaz',104,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1632,'Haifa',104,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1633,'Yerushalayim',104,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1634,'Agrigento',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1635,'Alessandria',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1636,'Ancona',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1637,'Aosta',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1638,'Arezzo',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1639,'Ascoli Piceno',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1640,'Asti',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1641,'Avellino',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1642,'Bari',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1643,'Belluno',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1644,'Benevento',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1645,'Bergamo',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1646,'Biella',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1647,'Bologna',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1648,'Bolzano',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1649,'Brescia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1650,'Brindisi',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1651,'Cagliari',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1652,'Caltanissetta',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1653,'Campobasso',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1654,'Carbonia-Iglesias',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1655,'Caserta',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1656,'Catania',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1657,'Catanzaro',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1658,'Chieti',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1659,'Como',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1660,'Cosenza',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1661,'Cremona',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1662,'Crotone',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1663,'Cuneo',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1664,'Enna',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1665,'Ferrara',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1666,'Firenze',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1667,'Foggia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1668,'Forli-Cesena',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1669,'Frosinone ',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1670,'Genova',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1671,'Gorizia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1672,'Grosseto',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1673,'Imperia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1674,'Isernia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1675,'La Spezia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1676,'L Aquila',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1677,'Latina',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1678,'Lecce',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1679,'Lecco',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1680,'Livorno',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1681,'Lodi',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1682,'Lucca',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1683,'Macerata',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1684,'Mantova',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1685,'Massa-Carrara',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1686,'Matera',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1687,'Medio Campidano',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1688,'Messina',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1689,'Milano',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1690,'Modena',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1691,'Napoli',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1692,'Novara',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1693,'Nuoro',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1694,'Ogliastra',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1695,'Olbia-Tempio',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1696,'Oristano',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1697,'Padova',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1698,'Palermo',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1699,'Parma',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1700,'Pavia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1701,'Perugia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1702,'Pesaro e Urbino',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1703,'Pescara',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1704,'Piacenza',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1705,'Pisa',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1706,'Pistoia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1707,'Pordenone',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1708,'Potenza',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1709,'Prato',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1710,'Ragusa',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1711,'Ravenna',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1712,'Reggio Calabria',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1713,'Reggio Emilia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1714,'Rieti',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1715,'Rimini',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1716,'Roma',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1717,'Rovigo',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1718,'Salerno',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1719,'Sassari',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1720,'Savona',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1721,'Siena',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1722,'Siracusa',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1723,'Sondrio',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1724,'Taranto',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1725,'Teramo',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1726,'Terni',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1727,'Torino',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1728,'Trapani',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1729,'Trento',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1730,'Treviso',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1731,'Trieste',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1732,'Udine',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1733,'Varese',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1734,'Venezia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1735,'Verbano-Cusio-Ossola',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1736,'Vercelli',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1737,'Verona',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1738,'Vibo Valentia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1739,'Vicenza',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1740,'Viterbo',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1741,'Fermo',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1742,'Monza e Brianza',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1743,'Barletta-Andria-Trani',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1744,'Valle d Aosta',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1745,'Sardegna',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1746,'Molise',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1747,'Friuli-Venezia Giulia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1748,'Emilia-Romagna',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1749,'Lazio',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1750,'Lombardia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1751,'Marche',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1752,'Puglia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1753,'Sicilia',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1754,'Trentino-Alto Adige',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1755,'Umbria',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1756,'Veneto',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1757,'Abruzzo',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1758,'Calabria',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1759,'Basilicata',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1760,'Campania',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1761,'Liguria',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1762,'Piemonte',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1763,'Toscana',105,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1764,'Saint Thomas',106,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1765,'Saint Elizabeth',106,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1766,'Saint Ann',106,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1767,'Clarendon',106,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1768,'Kingston',106,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1769,'Portland',106,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1770,'Saint Andrew',106,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1771,'Saint Catherine',106,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1772,'Saint James',106,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1773,'Saint Mary',106,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1774,'Trelawny',106,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1775,'Westmoreland',106,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1776,'Manchester',106,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1777,'Hanover',106,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1778,'Yamagata',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1779,'Tottori',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1780,'Totigi [Tochigi]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1781,'Siga [Shiga]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1782,'Ôita [Oita]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1783,'Miyagi',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1784,'Saitama',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1785,'Simane [Shimane]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1786,'Sizuoka [Shizuoka]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1787,'Tokusima [Tokushima]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1788,'Tôkyô [Tokyo]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1789,'Toyama',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1790,'Wakayama',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1791,'Yamaguti [Yamaguchi]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1792,'Yamanasi [Yamanashi]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1793,'Aiti [Aichi]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1794,'Aomori',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1795,'Tiba [Chiba]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1796,'Hukui [Fukui]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1797,'Hukuoka [Fukuoka]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1798,'Gihu [Gifu]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1799,'Gunma',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1800,'Hirosima [Hiroshima]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1801,'Hyôgo [Hyogo]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1802,'Isikawa [Ishikawa]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1803,'Iwate',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1804,'Kagawa',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1805,'Kanagawa',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1806,'Kôti [Kochi]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1807,'Kyôto [Kyoto]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1808,'Mie',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1809,'Miyazaki',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1810,'Nagano',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1811,'Nara',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1812,'Niigata',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1813,'Okayama',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1814,'Okinawa',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1815,'Saga',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1816,'Akita',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1817,'Ehime',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1818,'Hukusima [Fukushima]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1819,'Hokkaidô [Hokkaido]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1820,'Ibaraki',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1821,'Kagosima [Kagoshima]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1822,'Kumamoto',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1823,'Nagasaki',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1824,'Ôsaka [Osaka]',107,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1825,'At Tafilah',108,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1826,'Az Zarqa',108,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1827,'Ma`an',108,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1828,'?Amman',108,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1829,'Al Balqa',108,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1830,'Jarash',108,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1831,'Al Mafraq',108,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1832,'?Ajlun',108,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1833,'Madaba',108,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1834,'Al Karak',108,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1835,'Aqaba',108,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1836,'Irbid',108,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1837,'Almaty oblysy',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1838,'Astana',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1839,'Bayqongyr',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1840,'Zhambyl oblysy',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1841,'Batys Qazaqstan oblysy',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1842,'Soltüstik Qazaqstan oblysy',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1843,'Qyzylorda oblysy',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1844,'Aqmola oblysy',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1845,'Aqtöbe oblysy',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1846,'Almaty',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1847,'Atyrau oblysy',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1848,'Mangghystau oblysy',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1849,'Shyghys Qazaqstan oblysy',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1850,'Qaraghandy oblysy',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1851,'Pavlodar oblysy',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1852,'Ongtüstik Qazaqstan oblysy',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1853,'Qostanay oblysy',109,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1854,'Nyanza',110,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1855,'Western',110,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1856,'North-Eastern',110,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1857,'Coast',110,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1858,'Eastern',110,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1859,'Rift Valley',110,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1860,'Central',110,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1861,'Nairobi',110,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1862,'Gilbert Islands',111,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1863,'Line Islands',111,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1864,'Phoenix Islands',111,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1865,'Pyongan-bukdo',112,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1866,'Pyongan-namdo',112,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1867,'Yanggang-do',112,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1868,'Hwanghae-namdo',112,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1869,'Hwanghae-bukto',112,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1870,'Hamgyong-namdo',112,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1871,'Hamgyong-bukdo',112,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1872,'Chagang-do',112,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1873,'Nason',112,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1874,'Pyongyang',112,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1875,'Kangwon-do',112,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1876,'Seoul Teugbyeolsi [Seoul-T ukpyolshi]',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1877,'Busan Gwang yeogsi [Pusan-Kwangyokshi]',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1878,'Daegu Gwang yeogsi [Taegu-Kwangyokshi]',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1879,'Incheon Gwang',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1880,'Gwangju Gwang yeogsi [Kwangju-Kwangyokshi]',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1881,'Daejeon Gwang yeogsi [Taejon-Kwangyokshi]',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1882,'Ulsan Gwang yeogsi [Ulsan-Kwangyokshi]',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1883,'Gyeonggido [Kyonggi-do]',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1884,'Chungcheongbugdo [Chungch ongbuk-do]',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1885,'Chungcheongnamdo [Ch ungch ongnam-do',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1886,'Jeonrabugdo[Chollabuk-do]',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1887,'Jeonranamdo [Chollanam-do]',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1888,'Gyeongsangbugdo [Kyongsangbuk-do]',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1889,'Gyeongsangnamdo [Kyongsangnam-do]',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1890,'Jejudo [Cheju-do]',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1891,'Gang weondo [Kang-won-do]',113,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1892,'Al Jahrah',114,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1893,'Al Ahmadi',114,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1894,'Mubarak al-Kabir',114,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1895,'Al Kuwayt',114,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1896,'Hawalli',114,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1897,'Al Farwaniyah',114,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1898,'Osh',115,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1899,'Batken',115,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1900,'Naryn',115,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1901,'Bishkek',115,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1902,'Ysyk-Köl',115,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1903,'Talas',115,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1904,'Jalal-Abad',115,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1905,'Chü',115,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1906,'Louang Namtha',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1907,'Oudômxai [Oudomsai]',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1908,'Phôngsali [Phong Saly]',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1909,'Savannakhét',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1910,'Vientiane Prefecture',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1911,'Xaignabouli [Sayaboury]',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1912,'Bolikhamxai [Borikhane]',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1913,'Xékong [Sékong]',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1914,'Salavan [Saravane]',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1915,'Louangphabang [Louang Prabang]',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1916,'Houaphan',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1917,'Khammouan',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1918,'Vientiane',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1919,'Xaisômboun',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1920,'Xiangkhoang [Xieng Khouang]',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1921,'Attapu [Attopeu]',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1922,'Bokèo',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1923,'Champasak [Champassak]',116,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1924,'Ventspils Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1925,'Ogres Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1926,'Rezekne',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1927,'Rezeknes Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1928,'Rigas Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1929,'Saldus Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1930,'Tukuma Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1931,'Valkas Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1932,'Ventspils',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1933,'Aizkraukles Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1934,'Aluksnes Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1935,'Balvu Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1936,'Bauskas Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1937,'Cesu Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1938,'Daugavpils',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1939,'Daugavpils Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1940,'Dobeles Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1941,'Jekabpils Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1942,'Kraslavas Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1943,'Kuldigas Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1944,'Liepajas Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1945,'Limbažu Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1946,'Madonas Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1947,'Riga',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1948,'Preilu Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1949,'Ludzas Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1950,'Gulbenes Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1951,'Jelgava',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1952,'Jelgavas Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1953,'Jurmala',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1954,'Liepaja',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1955,'Talsu Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1956,'Valmieras Aprinkis',117,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1957,'Loubnâne ech Chemâli',118,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1958,'Nabatîyé',118,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1959,'Jabal Loubnâne',118,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1960,'Beirut',118,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1961,'El Béqaa',118,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1962,'Loubnâne ej Jnoûbi',118,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1963,'Qacha s Nek',119,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1964,'Berea',119,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1965,'Butha-Buthe',119,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1966,'Mafeteng',119,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1967,'Mohale s Hoek',119,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1968,'Mokhotlong',119,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1969,'Quthing',119,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1970,'Thaba-Tseka',119,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1971,'Leribe',119,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1972,'Maseru',119,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1973,'Gbarpolu',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1974,'River Gee',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1975,'Grand Kru',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1976,'Sinoe',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1977,'Bong',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1978,'Rivercess',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1979,'Maryland',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1980,'Grand Gedeh',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1981,'Bomi',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1982,'Grand Bassa',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1983,'Lofa',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1984,'Nimba',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1985,'Grand Cape Mount',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1986,'Montserrado',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1987,'Margibi',120,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1988,'Al Jabal al Gharbī',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1989,'Wādī ash Shāţiʾ',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1990,'Al Marqab',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1991,'Misratah',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1992,'Nalut',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1993,'Tarabulus',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1994,'Wadi al ?ayat',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1995,'Al Wāḩāt',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1996,'Az Zawiyah',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1997,'Al Butnan',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1998,'Ghat',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(1999,'Al Jabal al Akh?ar',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2000,'Al Jufrah',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2001,'Al Kufrah',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2002,'Banghazi',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2003,'Darnah',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2004,'Al Jifarah',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2005,'Al Marj',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2006,'Surt',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2007,'Sabha',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2008,'An Nuqat al Khams',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2009,'Murzuq',121,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2010,'Vaduz',122,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2011,'Ruggell',122,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2012,'Gamprin',122,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2013,'Balzers',122,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2014,'Eschen',122,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2015,'Mauren',122,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2016,'Planken',122,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2017,'Schaan',122,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2018,'Triesen',122,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2019,'Triesenberg',122,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2020,'Schellenberg',122,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2021,'Vilniaus Apskritis',123,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2022,'Panevežio Apskritis',123,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2023,'Utenos Apskritis',123,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2024,'Šiauliu Apskritis',123,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2025,'Kauno Apskritis',123,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2026,'Marijampoles Apskritis',123,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2027,'Telšiu Apskritis',123,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2028,'Klaipedos Apskritis',123,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2029,'Alytaus Apskritis',123,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2030,'Taurages Apskritis',123,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2031,'Grevenmacher',124,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2032,'Diekirch',124,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2033,'Luxembourg (fr)',124,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2034,'Aerodrom *',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2035,'Aracinovo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2036,'Bogdanci',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2037,'Bogovinje',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2038,'Bosilovo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2039,'Brvenica',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2040,'Butel *',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2041,'Cair *',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2042,'Caška',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2043,'Centar *',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2044,'Centar Župa',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2045,'Cešinovo-Obleševo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2046,'Cucer Sandevo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2047,'Demir Kapija',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2048,'Dojran',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2049,'Dolneni',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2050,'Drugovo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2051,'Debarca',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2052,'Kisela Voda *',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2053,'Konce',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2054,'Krivogaštani',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2055,'Lipkovo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2056,'Lozovo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2057,'Makedonska Kamenica',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2058,'Makedonski Brod',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2059,'Mavrovo-i-Rostuša',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2060,'Mogila',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2061,'Novaci',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2062,'Novo Selo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2063,'Oslomej',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2064,'Pehcevo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2065,'Petrovec',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2066,'Plasnica',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2067,'Rankovce',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2068,'Rosoman',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2069,'Saraj *',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2070,'Sopište',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2071,'Staro Nagoricane',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2072,'Studenicani',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2073,'Tearce',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2074,'Vasilevo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2075,'Vevcani',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2076,'Vraneštica',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2077,'Vrapcište',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2078,'Zajas',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2079,'Zelenikovo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2080,'Zrnovci',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2081,'Šuto Orizari *',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2082,'Želino',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2083,'Gazi Baba *',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2084,'Gjorce Petrov *',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2085,'Gradsko',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2086,'Ilinden',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2087,'Jegunovce',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2088,'Karbinci',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2089,'Karpoš *',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2090,'Veles',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2091,'Berovo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2092,'Bitola',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2093,'Debar',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2094,'Delcevo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2095,'Demir Hisar',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2096,'Gevgelija',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2097,'Kavadarci',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2098,'Kocani',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2099,'Gostivar',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2100,'Kicevo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2101,'Kratovo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2102,'Kruševo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2103,'Negotino',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2104,'Ohrid',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2105,'Probištip',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2106,'Resen',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2107,'Štip',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2108,'Struga',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2109,'Sveti Nikole',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2110,'Valandovo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2111,'Vinica',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2112,'Skopje',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2113,'Radoviš',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2114,'Prilep',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2115,'Kriva Palanka',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2116,'Kumanovo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2117,'Strumica',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2118,'Tetovo',126,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2119,'Toamasina',127,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2120,'Antsiranana',127,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2121,'Antananarivo',127,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2122,'Toliara',127,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2123,'Mahajanga',127,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2124,'Fianarantsoa',127,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2125,'Likoma',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2126,'Neno',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2127,'Central Region',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2128,'Northern Region',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2129,'Southern Region',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2130,'Blantyre',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2131,'Chiradzulu',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2132,'Dedza',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2133,'Dowa',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2134,'Kasungu',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2135,'Machinga',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2136,'Mangochi',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2137,'Mulanje',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2138,'Mwanza',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2139,'Nkhotakota',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2140,'Nsanje',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2141,'Ntchisi',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2142,'Phalombe',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2143,'Salima',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2144,'Thyolo',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2145,'Zomba',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2146,'Balaka',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2147,'Chikwawa',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2148,'Chitipa',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2149,'Nkhata Bay',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2150,'Mzimba',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2151,'Mchinji',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2152,'Karonga',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2153,'Lilongwe',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2154,'Ntcheu',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2155,'Rumphi',128,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2156,'Wilayah Persekutuan Putrajaya',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2157,'Terengganu',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2158,'Johor',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2159,'Kelantan',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2160,'Wilayah Persekutuan Labuan',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2161,'Melaka',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2162,'Pahang',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2163,'Perak',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2164,'Pulau Pinang',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2165,'Sabah',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2166,'Selangor',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2167,'Kedah',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2168,'Wilayah Persekutuan Kuala Lumpur',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2169,'Negeri Sembilan',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2170,'Perlis',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2171,'Sarawak',129,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2172,'Thaa',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2173,'Kaafu',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2174,'Gnaviyani',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2175,'Alif',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2176,'Alif Dhaal',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2177,'Baa',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2178,'Dhaalu',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2179,'Faafu',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2180,'Gaaf Alif',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2181,'Gaafu Dhaalu',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2182,'Haa Alif',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2183,'Haa Dhaalu',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2184,'Laamu',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2185,'Male',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2186,'Raa',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2187,'Seenu',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2188,'Vaavu',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2189,'Lhaviyani',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2190,'Shaviyani',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2191,'Noonu',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2192,'Meemu',130,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2193,'Tombouctou',131,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2194,'Mopti',131,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2195,'Bamako',131,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2196,'Kidal',131,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2197,'Gao',131,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2198,'Kayes',131,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2199,'Koulikoro',131,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2200,'Ségou',131,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2201,'Sikasso',131,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2202,'Jabat',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2203,'Wotje',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2204,'Wotho',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2205,'Namu',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2206,'Majuro',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2207,'Ailuk',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2208,'Arno',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2209,'Ebon',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2210,'Jaluit',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2211,'Kwajalein',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2212,'Lib',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2213,'Likiep',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2214,'Maloelap',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2215,'Mili',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2216,'Namdrik',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2217,'Rongelap',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2218,'Ailinglaplap',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2219,'Aur',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2220,'Enewetak',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2221,'Kili',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2222,'Lae',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2223,'Mejit',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2224,'Ujae',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2225,'Utirik',133,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2226,'Trarza',135,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2227,'Assaba',135,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2228,'Adrar',135,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2229,'Dakhlet Nouâdhibou',135,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2230,'Hodh el Gharbi',135,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2231,'Inchiri',135,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2232,'Tiris Zemmour',135,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2233,'Brakna',135,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2234,'Tagant',135,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2235,'Hodh ech Chargui',135,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2236,'Gorgol',135,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2237,'Guidimaka',135,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2238,'Nouakchott',135,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2239,'Agalega Islands',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2240,'Beau Bassin-Rose Hill',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2241,'Cargados Carajos Shoals [Saint Brandon Islands]',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2242,'Curepipe',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2243,'Port Louis District',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2244,'Vacoas-Phoenix',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2245,'Quatre Bornes',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2246,'Savanne',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2247,'Plaines Wilhems',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2248,'Black River',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2249,'Grand Port',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2250,'Moka',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2251,'Flacq',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2252,'Pamplemousses',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2253,'Port Louis City',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2254,'Rodrigues Island',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2255,'Rivière du Rempart',136,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2256,'Yucatán',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2257,'Nuevo León',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2258,'Puebla',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2259,'Querétaro',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2260,'San Luis Potosí',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2261,'Sinaloa',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2262,'Tabasco',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2263,'Tlaxcala',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2264,'Veracruz',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2265,'Zacatecas',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2266,'Baja California',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2267,'Baja California Sur',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2268,'Chiapas',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2269,'Coahuila',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2270,'Colima',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2271,'Durango',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2272,'Guanajuato',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2273,'Hidalgo',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2274,'Jalisco',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2275,'Michoacán',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2276,'Morelos',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2277,'Aguascalientes',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2278,'Campeche',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2279,'Chihuahua',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2280,'Distrito Federal',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2281,'Guerrero',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2282,'México',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2283,'Nayarit',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2284,'Oaxaca',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2285,'Tamaulipas',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2286,'Quintana Roo',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2287,'Sonora',138,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2288,'Pohnpei',139,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2289,'Kosrae',139,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2290,'Chuuk',139,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2291,'Yap',139,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2292,'Stînga Nistrului, unitatea teritoriala din',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2293,'Ştefan Vodă',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2294,'Rezina',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2295,'Ialoveni',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2296,'Floreşti',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2297,'Dubăsari',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2298,'Făleşti',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2299,'Gagauzia, Unitatea teritoriala autonoma (UTAG)',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2300,'Hînceşti',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2301,'Leova',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2302,'Nisporeni',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2303,'Orhei',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2304,'Bălţi',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2305,'Basarabeasca',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2306,'Cahul',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2307,'Cantemir',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2308,'Chisinau',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2309,'Cimişlia',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2310,'Donduşeni',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2311,'Rîşcani',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2312,'Sîngerei',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2313,'Şoldăneşti',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2314,'Soroca',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2315,'Străşeni',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2316,'Teleneşti',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2317,'Tighina',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2318,'Ungheni',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2319,'Anenii Noi',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2320,'Briceni',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2321,'Călăraşi',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2322,'Căuşeni',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2323,'Criuleni',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2324,'Drochia',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2325,'Edinet',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2326,'Glodeni',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2327,'Ocniţa',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2328,'Taraclia',140,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2329,'Ulaanbaatar',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2330,'Selenge',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2331,'Hövsgöl',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2332,'Dundgovi',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2333,'Bayan-Ölgiy',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2334,'Bayanhongor',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2335,'Bulgan',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2336,'Darhan uul',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2337,'Dornogovi',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2338,'Govi-Altay',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2339,'Hentiy',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2340,'Hovd',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2341,'Ömnögovi',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2342,'Övörhangay',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2343,'Sühbaatar',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2344,'Töv',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2345,'Uvs',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2346,'Dzavhan',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2347,'Arhangay',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2348,'Dornod',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2349,'Govi-Sümber',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2350,'Orhon',142,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2351,'Boujdour (EH)',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2352,'Es Smara (EH)',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2353,'Laâyoune*',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2354,'Oued ed Dahab (EH)',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2355,'Laayoune-Boujdour-Sakia El Hamra',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2356,'Chtouka-Ait Baha',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2357,'Al Hoceïma',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2358,'Tiznit',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2359,'Guelmim',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2360,'Tata',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2361,'Chichaoua',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2362,'Essaouira',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2363,'El Hajeb',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2364,'Ifrane',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2365,'Berkane',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2366,'Nador',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2367,'Taourirt',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2368,'Safi',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2369,'Moulay Yacoub',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2370,'Sidi Kacem',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2371,'Mediouna',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2372,'Assa-Zag',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2373,'Tan-Tan',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2374,'Al Haouz',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2375,'Kelaat es Sraghna',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2376,'Errachidia',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2377,'Khenifra',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2378,'Figuig',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2379,'Jrada',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2380,'Khemisset',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2381,'Taroudant',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2382,'Zagora',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2383,'Beni Mellal',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2384,'Chefchaouen',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2385,'Larache',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2386,'Taounate',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2387,'Taza',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2388,'Ben Slimane',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2389,'Khouribga',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2390,'Settat',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2391,'El Jadida',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2392,'Boulemane',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2393,'Sefrou',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2394,'Kénitra',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2395,'Nouaceur',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2396,'Ouarzazate',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2397,'Azilal',144,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2398,'Inhambane',145,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2399,'Manica',145,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2400,'Maputo',145,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2401,'Niassa',145,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2402,'Tete',145,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2403,'Cabo Delgado',145,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2404,'Gaza',145,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2405,'Maputo City',145,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2406,'Nampula',145,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2407,'Sofala',145,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2408,'Zambézia',145,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2409,'Tanintharyi',146,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2410,'Ayeyarwady',146,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2411,'Bago',146,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2412,'Kachin',146,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2413,'Kayin',146,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2414,'Magway',146,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2415,'Mon',146,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2416,'Sagaing',146,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2417,'Shan',146,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2418,'Yangon',146,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2419,'Chin',146,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2420,'Kayah',146,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2421,'Rakhine',146,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2422,'Mandalay',146,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2423,'Oshikoto',147,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2424,'Omaheke',147,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2425,'Hardap',147,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2426,'Khomas',147,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2427,'Caprivi',147,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2428,'Erongo',147,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2429,'Karas',147,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2430,'Okavango',147,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2431,'Kunene',147,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2432,'Ohangwena',147,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2433,'Omusati',147,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2434,'Oshana',147,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2435,'Otjozondjupa',147,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2436,'Yaren',148,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2437,'Nibok',148,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2438,'Anabar',148,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2439,'Uaboe',148,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2440,'Ijuw',148,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2441,'Buada',148,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2442,'Anibare',148,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2443,'Aiwo',148,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2444,'Anetan',148,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2445,'Boe',148,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2446,'Ewa',148,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2447,'Meneng',148,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2448,'Baiti',148,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2449,'Denigomodu',148,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2450,'Bagmati',149,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2451,'Bheri',149,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2452,'Dhawalagiri',149,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2453,'Gandaki',149,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2454,'Janakpur',149,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2455,'Karnali',149,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2456,'Kosi [Koshi]',149,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2457,'Lumbini',149,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2458,'Mahakali',149,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2459,'Mechi',149,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2460,'Narayani',149,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2461,'Rapti',149,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2462,'Sagarmatha',149,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2463,'Seti',149,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2464,'Utrecht',150,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2465,'Gelderland',150,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2466,'Drenthe',150,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2467,'Zeeland',150,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2468,'Noord-Brabant',150,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2469,'Friesland',150,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2470,'Flevoland',150,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2471,'Groningen',150,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2472,'Overijssel',150,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2473,'Zuid-Holland',150,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2474,'Limburg',150,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2475,'Noord-Holland',150,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2476,'Chatham  Islands Territory',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2477,'North Island',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2478,'South Island',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2479,'Waikato',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2480,'Northland',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2481,'Auckland',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2482,'Gisborne District',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2483,'Manawatu-Wanganui',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2484,'Taranaki',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2485,'Bay of Plenty',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2486,'Canterbury',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2487,'Hawkes s Bay',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2488,'Marlborough District',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2489,'Nelson City',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2490,'Otago',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2491,'Southland',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2492,'Tasman District',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2493,'Wellington',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2494,'West Coast',153,1,'2025-01-03 04:07:26','2025-01-03 04:07:26'),(2495,'Río San Juan',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2496,'Masaya',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2497,'Chontales',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2498,'Carazo',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2499,'Nueva Segovia',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2500,'Managua',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2501,'Jinotega',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2502,'Chinandega',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2503,'Atlántico Sur*',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2504,'Boaco',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2505,'Estelí',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2506,'León',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2507,'Matagalpa',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2508,'Rivas',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2509,'Granada',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2510,'Madriz',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2511,'Atlántico Norte*',154,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2512,'Agadez',155,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2513,'Diffa',155,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2514,'Dosso',155,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2515,'Maradi',155,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2516,'Niamey',155,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2517,'Tahoua',155,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2518,'Tillabéri',155,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2519,'Zinder',155,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2520,'Abia',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2521,'Delta',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2522,'Abuja Federal Capital Territory',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2523,'Adamawa',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2524,'Akwa Ibom',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2525,'Anambra',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2526,'Bauchi',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2527,'Borno',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2528,'Ekiti',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2529,'Kebbi',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2530,'Kwara',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2531,'Lagos',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2532,'Niger',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2533,'Ogun',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2534,'Osun',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2535,'Oyo',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2536,'Rivers',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2537,'Sokoto',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2538,'Benue',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2539,'Cross River',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2540,'Ebonyi',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2541,'Edo',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2542,'Enugu',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2543,'Gombe',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2544,'Jigawa',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2545,'Kaduna',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2546,'Katsina',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2547,'Bayelsa',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2548,'Yobe',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2549,'Kano',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2550,'Zamfara',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2551,'Taraba',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2552,'Nassarawa',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2553,'Ondo',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2554,'Plateau',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2555,'Kogi',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2556,'Imo',156,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2557,'Jan Mayen',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2558,'Svalbard',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2559,'Vest-Agder',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2560,'Sør-Trøndelag',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2561,'Østfold',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2562,'Nord-Trøndelag',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2563,'Finnmark',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2564,'Aust-Agder',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2565,'Buskerud',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2566,'Hedmark',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2567,'Møre og Romsdal',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2568,'Nordland',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2569,'Oppland',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2570,'Oslo',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2571,'Rogaland',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2572,'Sogn og Fjordane',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2573,'Telemark',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2574,'Troms',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2575,'Vestfold',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2576,'Akershus',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2577,'Hordaland',160,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2578,'Al Buraymi',161,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2579,'Z̧ufār',161,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2580,'Az̧ Z̧āhirah',161,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2581,'Ash Sharqiyah',161,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2582,'Ad Dakhiliyah',161,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2583,'Al Wustá',161,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2584,'Al Batinah',161,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2585,'Musandam',161,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2586,'Masqat',161,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2587,'Punjab',162,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2588,'Northern Areas',162,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2589,'Federally Administered Tribal Areas',162,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2590,'North-West Frontier',162,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2591,'Sind (en)',162,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2592,'Baluchistan (en)',162,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2593,'Azad Kashmir',162,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2594,'Islamabad',162,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2595,'Sonsorol',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2596,'Ngeremlengui',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2597,'Hatobohei',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2598,'Aimeliik',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2599,'Melekeok',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2600,'Angaur',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2601,'Kayangel',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2602,'Koror',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2603,'Ngaraard',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2604,'Ngardmau',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2605,'Ngatpang',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2606,'Ngchesar',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2607,'Ngiwal',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2608,'Peleliu',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2609,'Airai',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2610,'Ngarchelong',163,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2611,'Kuna Yala',165,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2612,'Panamá',165,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2613,'Los Santos',165,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2614,'Ngöbe-Buglé',165,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2615,'Chiriquí',165,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2616,'Colón',165,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2617,'Darién',165,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2618,'Herrera',165,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2619,'Emberá',165,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2620,'Veraguas',165,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2621,'Bocas del Toro',165,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2622,'Coclé',165,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2623,'Chimbu',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2624,'New Ireland',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2625,'Manus',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2626,'Enga',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2627,'Central',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2628,'Eastern Highlands',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2629,'East Sepik',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2630,'Western',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2631,'Madang',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2632,'Milne Bay',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2633,'Morobe',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2634,'North Solomons',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2635,'Sandaun [West Sepik]',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2636,'Southern Highlands',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2637,'West New Britain',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2638,'East New Britain',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2639,'Gulf',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2640,'National Capital District (Port Moresby)',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2641,'Northern',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2642,'Western Highlands',166,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2643,'Paraguarí',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2644,'Central',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2645,'Boquerón',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2646,'Asunción',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2647,'Caaguazú',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2648,'Canindeyú',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2649,'Concepción',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2650,'Cordillera',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2651,'Itapúa',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2652,'Ñeembucú',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2653,'Presidente Hayes',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2654,'San Pedro',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2655,'Alto Paraguay',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2656,'Alto Paraná',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2657,'Amambay',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2658,'Caazapá',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2659,'Guairá',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2660,'Misiones',167,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2661,'Municipalidad Metropolitana de Lima',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2662,'Lima',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2663,'Madre de Dios',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2664,'Ica',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2665,'Arequipa',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2666,'Lambayeque',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2667,'Loreto',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2668,'Moquegua',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2669,'Piura',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2670,'Puno',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2671,'Tacna',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2672,'Tumbes',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2673,'Ancash',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2674,'Amazonas',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2675,'Apurímac',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2676,'Ayacucho',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2677,'Cajamarca',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2678,'Huancavelica',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2679,'Huánuco',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2680,'Junín',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2681,'Cusco [Cuzco]',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2682,'La Libertad',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2683,'Pasco',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2684,'El Callao',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2685,'Ucayali',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2686,'San Martín',168,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2687,'Shariff Kabunsuan',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2688,'CALABARZON (Region IV-A)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2689,'Davao (Region XI)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2690,'MIMAROPA (Region IV-B)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2691,'Soccsksargen (Region XII)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2692,'Zamboanga Peninsula (Region IX)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2693,'Quirino',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2694,'Cagayan Valley (Region II)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2695,'Caraga (Region XIII)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2696,'Lanao del Sur',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2697,'Sulu',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2698,'Albay',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2699,'Camarines Norte',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2700,'Catanduanes',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2701,'Sorsogon',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2702,'Batanes',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2703,'Isabela',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2704,'Agusan del Norte',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2705,'Surigao del Norte',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2706,'Bataan',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2707,'Nueva Ecija',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2708,'Pampanga',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2709,'Benguet',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2710,'Ifugao',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2711,'Mountain Province',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2712,'Eastern Samar',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2713,'Western Samar',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2714,'Ilocos Norte',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2715,'La Union',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2716,'Pangasinan',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2717,'Bukidnon',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2718,'Camiguin',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2719,'Misamis Oriental',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2720,'Davao del Norte',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2721,'Davao Oriental',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2722,'South Cotabato',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2723,'Cavite',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2724,'Laguna',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2725,'Mindoro Occidental',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2726,'Palawan',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2727,'Zamboanga del Norte',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2728,'Aklan',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2729,'Antique',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2730,'Guimaras',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2731,'Negros Occidental',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2732,'Dinagat Islands',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2733,'Leyte',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2734,'Romblon',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2735,'Aurora',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2736,'Bicol (Region V)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2737,'Central Luzon (Region III)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2738,'Central Visayas (Region VII)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2739,'Cordillera Administrative Region (CAR)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2740,'Eastern Visayas (Region VIII)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2741,'Ilocos (Region I)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2742,'Autonomous Region in Muslim Mindanao (ARMM)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2743,'National Capital Region',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2744,'Northern Mindanao (Region X)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2745,'Western Visayas (Region VI)',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2746,'Abra',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2747,'Apayao',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2748,'Kalinga',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2749,'Biliran',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2750,'Northern Samar',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2751,'Southern Leyte',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2752,'Ilocos Sur',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2753,'Misamis Occidental',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2754,'Compostela Valley',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2755,'Davao del Sur',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2756,'Sarangani',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2757,'Batangas',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2758,'Marinduque',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2759,'Mindoro Oriental',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2760,'Basilan',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2761,'Zamboanga del Sur',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2762,'Capiz',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2763,'Iloilo',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2764,'Maguindanao',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2765,'Tawi-Tawi',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2766,'Camarines Sur',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2767,'Masbate',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2768,'Cagayan',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2769,'Nueva Vizcaya',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2770,'Agusan del Sur',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2771,'Surigao del Sur',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2772,'Bulacan',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2773,'Tarlac',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2774,'Zambales',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2775,'North Cotabato',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2776,'Lanao del Norte',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2777,'Sultan Kudarat',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2778,'Bohol',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2779,'Cebu',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2780,'Negros Oriental',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2781,'Siquijor',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2782,'Rizal',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2783,'Quezon',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2784,'Zamboanga Sibuguey [Zamboanga Sibugay]',169,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2785,'Zachodniopomorskie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2786,'Dolnoslaskie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2787,'Kujawsko-pomorskie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2788,'Lubelskie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2789,'Lódzkie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2790,'Mazowieckie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2791,'Podkarpackie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2792,'Pomorskie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2793,'Swietokrzyskie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2794,'Wielkopolskie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2795,'Lubuskie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2796,'Warminsko-mazurskie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2797,'Podlaskie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2798,'Opolskie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2799,'Malopolskie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2800,'Slaskie',171,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2801,'Aveiro',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2802,'Beja',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2803,'Braga',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2804,'Bragança',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2805,'Castelo Branco',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2806,'Coimbra',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2807,'Évora',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2808,'Faro',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2809,'Guarda',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2810,'Leiria',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2811,'Lisboa',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2812,'Portalegre',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2813,'Porto',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2814,'Santarém',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2815,'Setúbal',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2816,'Viana do Castelo',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2817,'Vila Real',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2818,'Viseu',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2819,'Região Autónoma dos Açores',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2820,'Região Autónoma da Madeira',172,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2821,'Umm Salal',174,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2822,'Al Wakrah',174,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2823,'Al Jumayliyah',174,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2824,'Al Khawr',174,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2825,'Madinat ash Shamal',174,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2826,'Umm Sa id',174,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2827,'Jariyan al Batnah',174,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2828,'Ad Dawhah',174,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2829,'Al Ghuwayriyah',174,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2830,'Ar Rayyan',174,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2831,'Vrancea',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2832,'Ialomita',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2833,'Brasov',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2834,'Buzau',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2835,'Caras-Severin',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2836,'Constanta',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2837,'Dâmbovita',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2838,'Dolj',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2839,'Giurgiu',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2840,'Gorj',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2841,'Hunedoara',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2842,'Iasi',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2843,'Maramures',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2844,'Alba',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2845,'Arad',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2846,'Arges',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2847,'Bacau',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2848,'Bihor',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2849,'Bistrita-Nasaud',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2850,'Botosani',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2851,'Braila',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2852,'Bucuresti',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2853,'Calarasi',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2854,'Cluj',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2855,'Covasna',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2856,'Galati',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2857,'Harghita',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2858,'Mehedinti',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2859,'Neamt',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2860,'Prahova',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2861,'Salaj',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2862,'Sibiu',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2863,'Suceava',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2864,'Timis',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2865,'Tulcea',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2866,'Vaslui',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2867,'Ilfov',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2868,'Vâlcea',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2869,'Satu Mare',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2870,'Olt',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2871,'Mures',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2872,'Teleorman',176,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2873,'Zabajkal skij kraj',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2874,'Vologodskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2875,'Tatarstan, Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2876,'Primorskiy kray',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2877,'Ryazanskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2878,'Sakha, Respublika [Yakutiya]',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2879,'Sakhalinskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2880,'Sankt-Peterburg',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2881,'Smolenskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2882,'Stavropol skiy kray',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2883,'Sverdlovskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2884,'Tambovskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2885,'Mariy El, Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2886,'Moskva',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2887,'Moskovskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2888,'Nenetskiy avtonomnyy okrug',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2889,'Nizhegorodskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2890,'Novosibirskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2891,'Orenburgskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2892,'Orlovskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2893,'Perm',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2894,'Kemerovskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2895,'Kirovskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2896,'Komi, Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2897,'Komi-Permyak',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2898,'Kostromskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2899,'Krasnoyarskiy kray',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2900,'Kurganskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2901,'Leningradskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2902,'Magadanskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2903,'Severnaya Osetiya, Respublika [Alaniya] [Respublika Severnaya Osetiya-Alaniya]',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2904,'Arkhangel skaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2905,'Belgorodskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2906,'Chechenskaya Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2907,'Chuvashskaya Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2908,'Altay, Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2909,'Khanty-Mansiyskiy avtonomnyy okrug [Yugra]',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2910,'Ivanovskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2911,'Krasnodarskiy kray',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2912,'Kurskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2913,'Lipetskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2914,'Mordoviya, Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2915,'Murmanskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2916,'Novgorodskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2917,'Omskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2918,'Penzenskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2919,'Pskovskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2920,'Rostovskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2921,'Samarskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2922,'Saratovskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2923,'Tyumenskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2924,'Tul skaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2925,'Udmurtskaya Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2926,'Vladimirskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2927,'Voronezhskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2928,'Adygeya, Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2929,'Altayskiy kray',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2930,'Amurskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2931,'Astrakhanskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2932,'Bashkortostan, Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2933,'Bryanskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2934,'Buryatiya, Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2935,'Chelyabinskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2936,'Chukotskiy avtonomnyy okrug',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2937,'Dagestan, Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2938,'Khabarovskiy kray',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2939,'Khakasiya, Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2940,'Ingushskaya Respublika [Respublika Ingushetiya]',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2941,'Irkutskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2942,'Yamalo-Nenetskiy avtonomnyy okrug',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2943,'Yaroslavskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2944,'Yevreyskaya avtonomnaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2945,'Kabardino-Balkarskaya Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2946,'Kaliningradskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2947,'Kalmykiya, Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2948,'Kaluzhskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2949,'Kamchatskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2950,'Karachayevo-Cherkesskaya Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2951,'Kareliya, Respublika',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2952,'Tomskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2953,'Volgogradskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2954,'Ul yanovskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2955,'Tyva, Respublika [Tuva]',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2956,'Tverskaya oblast',177,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2957,'Est',178,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2958,'Nord',178,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2959,'Ouest',178,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2960,'Sud',178,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2961,'Ville de Kigali',178,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2962,'Tristan da Cunha',179,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2963,'Ascension',179,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2964,'Saint Helena',179,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2965,'Trinity Palmetto Point',180,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2966,'Saint John Capisterre',180,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2967,'Christ Church Nichola Town',180,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2968,'Saint George Basseterre',180,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2969,'Saint James Windward',180,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2970,'Saint John Figtree',180,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2971,'Saint Paul Capisterre',180,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2972,'Saint Peter Basseterre',180,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2973,'Saint Thomas Middle Island',180,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2974,'Saint Anne Sandy Point',180,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2975,'Saint George Gingerland',180,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2976,'Saint Mary Cayon',180,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2977,'Saint Thomas Lowland',180,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2978,'Saint Paul Charlestown',180,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2979,'Saint George',183,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2980,'Grenadines',183,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2981,'Saint David',183,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2982,'Saint Patrick',183,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2983,'Saint Andrew',183,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2984,'Charlotte',183,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2985,'A ana',184,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2986,'Aiga-i-le-Tai',184,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2987,'Atua',184,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2988,'Fa asaleleaga',184,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2989,'Gaga emauga ',184,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2990,'Gagaifomauga',184,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2991,'Palauli',184,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2992,'Satupa itea',184,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2993,'Tuamasaga',184,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2994,'Va a-o-Fonoti',184,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2995,'Vaisigano',184,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2996,'Serravalle',185,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2997,'Fiorentino',185,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2998,'Domagnano',185,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(2999,'Borgo Maggiore',185,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3000,'Acquaviva',185,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3001,'Chiesanuova',185,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3002,'Faetano',185,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3003,'Montegiardino',185,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3004,'San Marino',185,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3005,'Príncipe',186,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3006,'São Tomé',186,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3007,'Tabuk',187,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3008,'Ar Riya?',187,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3009,'Al Madinah',187,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3010,'Al Ba?ah',187,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3011,'?a il',187,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3012,'Al Jawf',187,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3013,'Najran',187,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3014,'?Asir',187,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3015,'Al ?udud ash Shamaliyah',187,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3016,'Jizan',187,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3017,'Makkah',187,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3018,'Al Qasim',187,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3019,'Ash Sharqiyah',187,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3020,'Kaffrine',188,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3021,'Kédougou',188,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3022,'Sédhiou',188,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3023,'Ziguinchor',188,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3024,'Diourbel',188,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3025,'Saint-Louis',188,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3026,'Kolda',188,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3027,'Matam',188,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3028,'Thiès',188,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3029,'Louga',188,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3030,'Fatick',188,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3031,'Dakar',188,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3032,'Kaolack',188,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3033,'Tambacounda',188,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3034,'Les Mamelles',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3035,'Roche Caiman',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3036,'Takamaka',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3037,'Baie Lazare',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3038,'Grand Anse Praslin',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3039,'Mont Buxton',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3040,'Pointe La Rue',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3041,'Port Glaud',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3042,'Saint Louis',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3043,'Anse aux Pins',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3044,'Anse Royale',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3045,'Anse Boileau',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3046,'Anse Étoile',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3047,'Au Cap',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3048,'Baie Sainte Anne',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3049,'Beau Vallon',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3050,'Bel Ombre',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3051,'English River',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3052,'Glacis',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3053,'Bel Air',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3054,'Plaisance',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3055,'La Digue',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3056,'Grand Anse Mahe Grand Anse Mahe, Grand',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3057,'Cascade',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3058,'Mont Fleuri',190,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3059,'Northern',191,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3060,'Western Area (Freetown)',191,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3061,'Eastern',191,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3062,'Southern',191,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3063,'Singapore - No State',192,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3064,'Trenciansky kraj',193,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3065,'Bratislavský kraj',193,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3066,'Nitriansky kraj',193,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3067,'Prešovský kraj',193,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3068,'Trnavský kraj',193,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3069,'Žilinský kraj',193,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3070,'Košický kraj',193,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3071,'Banskobystrický kraj',193,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3072,'Brežice',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3073,'Cankova',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3074,'Celje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3075,'Cerklje na Gorenjskem',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3076,'Cerknica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3077,'Cerkno',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3078,'Cerkvenjak',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3079,'Crenšovci',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3080,'Crna na Koroškem',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3081,'Crnomelj',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3082,'Destrnik',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3083,'Divaca',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3084,'Dobje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3085,'Dobrepolje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3086,'Dobrna',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3087,'Dobrova-Polhov Gradec',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3088,'Dobrovnik/Dobronak',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3089,'Dol pri Ljubljani',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3090,'Dolenjske Toplice',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3091,'Domžale',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3092,'Dornava',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3093,'Dravograd',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3094,'Duplek',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3095,'Gorenja vas-Poljane',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3096,'Gorišnica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3097,'Gornja Radgona',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3098,'Gornji Grad',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3099,'Gornji Petrovci',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3100,'Grad',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3101,'Grosuplje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3102,'Hajdina',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3103,'Hoce-Slivnica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3104,'Hodoš/Hodos',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3105,'Horjul',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3106,'Hrastnik',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3107,'Hrpelje-Kozina',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3108,'Idrija',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3109,'Ig',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3110,'Ilirska Bistrica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3111,'Ivancna Gorica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3112,'Izola/Isola',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3113,'Jesenice',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3114,'Jezersko',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3115,'Juršinci',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3116,'Kamnik',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3117,'Kanal',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3118,'Kidricevo',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3119,'Kobarid',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3120,'Kobilje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3121,'Kocevje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3122,'Komen',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3123,'Komenda',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3124,'Koper/Capodistria',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3125,'Kostel',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3126,'Kozje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3127,'Kranj',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3128,'Kranjska Gora',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3129,'Križevci',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3130,'Krško',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3131,'Kungota',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3132,'Kuzma',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3133,'Laško',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3134,'Lenart',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3135,'Lendava/Lendva',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3136,'Litija',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3137,'Ljubljana',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3138,'Ljubno',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3139,'Ljutomer',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3140,'Logatec',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3141,'Loška dolina',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3142,'Loški Potok',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3143,'Lovrenc na Pohorju',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3144,'Luce',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3145,'Lukovica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3146,'Majšperk',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3147,'Maribor',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3148,'Markovci',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3149,'Medvode',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3150,'Mengeš',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3151,'Metlika',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3152,'Mežica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3153,'Miklavž na Dravskem polju',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3154,'Miren-Kostanjevica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3155,'Mirna Pec',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3156,'Mislinja',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3157,'Moravce',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3158,'Moravske Toplice',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3159,'Mozirje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3160,'Murska Sobota',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3161,'Muta',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3162,'Naklo',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3163,'Nazarje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3164,'Nova Gorica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3165,'Novo mesto',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3166,'Odranci',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3167,'Oplotnica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3168,'Ormož',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3169,'Osilnica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3170,'Pesnica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3171,'Piran/Pirano',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3172,'Pivka',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3173,'Podcetrtek',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3174,'Podlehnik',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3175,'Podvelka',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3176,'Polzela',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3177,'Postojna',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3178,'Prebold',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3179,'Preddvor',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3180,'Prevalje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3181,'Ptuj',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3182,'Puconci',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3183,'Race-Fram',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3184,'Radece',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3185,'Radenci',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3186,'Radlje ob Dravi',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3187,'Radovljica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3188,'Ravne na Koroškem',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3189,'Razkrižje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3190,'Ribnica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3191,'Ribnica na Pohorju',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3192,'Rogaška Slatina',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3193,'Rogašovci',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3194,'Rogatec',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3195,'Ruše',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3196,'Selnica ob Dravi',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3197,'Semic',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3198,'Sevnica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3199,'Sežana',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3200,'Slovenj Gradec',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3201,'Slovenska Bistrica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3202,'Slovenske Konjice',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3203,'Sodražica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3204,'Solcava',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3205,'Starše',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3206,'Sveta Ana',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3207,'Sveti Andraž v Slovenskih goricah',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3208,'Sveti Jurij',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3209,'Šalovci',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3210,'Šempeter-Vrtojba',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3211,'Šencur',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3212,'Šentilj',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3213,'Šentjernej',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3214,'Šentjur pri Celju',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3215,'Škocjan',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3216,'Škofja Loka',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3217,'Škofljica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3218,'Šmarje pri Jelšah',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3219,'Šmartno ob Paki',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3220,'Šmartno pri Litiji',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3221,'Šoštanj',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3222,'Štore',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3223,'Tabor',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3224,'Tišina',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3225,'Tolmin',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3226,'Trbovlje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3227,'Trebnje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3228,'Trnovska vas',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3229,'Tržic',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3230,'Trzin',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3231,'Turnišce',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3232,'Velenje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3233,'Velika Polana',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3234,'Velike Lašce',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3235,'Veržej',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3236,'Videm',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3237,'Vipava',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3238,'Vitanje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3239,'Vodice',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3240,'Vojnik',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3241,'Vransko',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3242,'Vrhnika',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3243,'Vuzenica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3244,'Zagorje ob Savi',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3245,'Zavrc',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3246,'Zrece',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3247,'Žalec',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3248,'Železniki',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3249,'Žetale',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3250,'Žiri',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3251,'Žirovnica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3252,'Žužemberk',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3253,'Ajdovšcina',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3254,'Beltinci',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3255,'Benedikt',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3256,'Bistrica ob Sotli',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3257,'Bled',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3258,'Bloke',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3259,'Bohinj',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3260,'Borovnica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3261,'Bovec',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3262,'Braslovce',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3263,'Brda',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3264,'Brezovica',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3265,'Šmartno pri Litiji',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3266,'Apače',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3267,'Cirkulane',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3268,'Kosanjevica na Krki',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3269,'Makole',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3270,'Mokronog-Trebelno',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3271,'Poljčane',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3272,'Renče-Vogrsko',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3273,'Rečica ob Savinji',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3274,'Sveti Jurij v Slovenskih Goricah',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3275,'Središče ob Dravi',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3276,'Straža',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3277,'Sveta Trojica v Slovenskih Goricah',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3278,'Sveti Tomaž',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3279,'Šentrupert',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3280,'Šmarješke Toplice',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3281,'Gorje',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3282,'Log-Dragomer',194,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3283,'Temotu',195,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3284,'Central',195,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3285,'Choiseul',195,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3286,'Guadalcanal',195,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3287,'Western',195,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3288,'Rennell and Bellona',195,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3289,'Capital Territory (Honiara)',195,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3290,'Makira',195,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3291,'Isabel',195,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3292,'Malaita',195,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3293,'Sool',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3294,'Galguduud',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3295,'Gedo',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3296,'Jubbada Dhexe',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3297,'Jubbada Hoose',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3298,'Nugaal',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3299,'Shabeellaha Hoose',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3300,'Sanaag',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3301,'Togdheer',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3302,'Woqooyi Galbeed',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3303,'Awdal',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3304,'Bakool',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3305,'Bari',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3306,'Mudug',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3307,'Bay',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3308,'Banaadir',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3309,'Hiiraan',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3310,'Shabeellaha Dhexe',196,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3311,'North-West',197,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3312,'Mpumalanga',197,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3313,'Eastern Cape',197,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3314,'Free State',197,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3315,'Kwazulu-Natal',197,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3316,'Limpopo',197,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3317,'Northern Cape',197,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3318,'Western Cape',197,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3319,'Gauteng',197,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3320,'Melilla',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3321,'Ceuta',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3322,'Zaragoza',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3323,'Valencia',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3324,'Tarragona',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3325,'Vizcaya',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3326,'Zamora',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3327,'Segovia',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3328,'Ourense',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3329,'Soria',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3330,'Teruel',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3331,'Toledo',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3332,'Valladolid',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3333,'Álava',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3334,'Asturias',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3335,'Baleares',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3336,'Burgos',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3337,'Cantabria',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3338,'Ciudad Real',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3339,'Córdoba',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3340,'Girona',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3341,'Granada',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3342,'Guipúzcoa',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3343,'Huesca',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3344,'Jaén',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3345,'Las Palmas',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3346,'Lleida',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3347,'A Coruña',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3348,'Alicante',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3349,'Albacete',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3350,'Almería',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3351,'Ávila',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3352,'Badajoz',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3353,'Barcelona',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3354,'Cáceres',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3355,'Cádiz',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3356,'Castellón',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3357,'Lugo',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3358,'Málaga',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3359,'Navarra',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3360,'Palencia',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3361,'Pontevedra',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3362,'Santa Cruz de Tenerife',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3363,'Sevilla',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3364,'Cuenca',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3365,'Guadalajara',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3366,'Huelva',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3367,'La Rioja',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3368,'León',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3369,'Madrid',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3370,'Murcia',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3371,'Salamanca',199,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3372,'Vavuniyāva',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3373,'Mulativ',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3374,'Mātara',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3375,'Pŏḷŏnnaruva',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3376,'Ratnapura',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3377,'Mahanuvara',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3378,'Kilinŏchchi',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3379,'Mātale',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3380,'Mŏṇarāgala',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3381,'Nuvara Ĕliya',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3382,'Puttalama',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3383,'Trikuṇāmalaya',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3384,'Yāpanaya',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3385,'Anurādhapura',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3386,'Gampaha',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3387,'Kalutara',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3388,'Ampāra',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3389,'Badulla',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3390,'Gālla',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3391,'Hambantŏṭa',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3392,'Kegalla',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3393,'Kŏḷamba',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3394,'Madakalapuva',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3395,'Mannārama',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3396,'Kuruṇægala',200,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3397,'Al Wa?dah',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3398,'Shamal Ba?r al Ghazal',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3399,'Al Qa?arif',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3400,'Ash Shamaliyah',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3401,'Sharq al Istiwa iyah',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3402,'An Nil al Abya?',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3403,'Al Jazirah',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3404,'A?ali an Nil',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3405,'Ba?r al Jabal',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3406,'Gharb Ba?r al Ghazal',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3407,'Al Khartum',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3408,'Janub Kurdufan',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3409,'Junqali',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3410,'An Nil',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3411,'An Nil al Azraq',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3412,'Shamal Darfur',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3413,'Shamal Kurdufan',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3414,'Sinnar',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3415,'Warab',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3416,'Al Ba?r al A?mar',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3417,'Al Bu?ayrat',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3418,'Gharb al Istiwa iyah',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3419,'Gharb Darfur',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3420,'Gharb Kurdufan',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3421,'Janub Darfur',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3422,'Kassala',201,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3423,'Sipaliwini',202,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3424,'Commewijne',202,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3425,'Coronie',202,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3426,'Nickerie',202,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3427,'Paramaribo',202,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3428,'Saramacca',202,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3429,'Wanica',202,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3430,'Brokopondo',202,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3431,'Marowijne',202,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3432,'Para',202,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3433,'Manzini',204,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3434,'Hhohho',204,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3435,'Shiselweni',204,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3436,'Lubombo',204,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3437,'Skåne län [SE-12]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3438,'Dalarnas län [SE-20]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3439,'Gotlands län [SE-09]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3440,'Jönköpings län [SE-06]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3441,'Norrbottens län [SE-25]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3442,'Stockholms län [SE-01]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3443,'Västmanlands län [SE-19]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3444,'Västerbottens län [SE-24]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3445,'Östergötlands län [SE-05]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3446,'Södermanlands län [SE-04]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3447,'Uppsala län [SE-03]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3448,'Värmlands län [SE-17]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3449,'Västernorrlands län [SE-22]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3450,'Västra Götalands län [SE-14]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3451,'Blekinge län [SE-10]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3452,'Gävleborgs län [SE-21]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3453,'Hallands län [SE-13]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3454,'Jämtlands län [SE-23]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3455,'Kalmar län [SE-08]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3456,'Kronobergs län [SE-07]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3457,'Örebro län [SE-18]',205,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3458,'Vaud (fr)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3459,'Zürich (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3460,'Aargau (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3461,'Appenzell Innerrhoden (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3462,'Basel-Stadt (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3463,'Fribourg (fr)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3464,'Glarus (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3465,'Jura (fr)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3466,'Neuchâtel (fr)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3467,'Obwalden (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3468,'Graubünden (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3469,'Luzern (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3470,'Nidwalden (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3471,'Sankt Gallen (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3472,'Schwyz (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3473,'Solothurn (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3474,'Ticino (it)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3475,'Valais (fr)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3476,'Zug (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3477,'Appenzell Ausserrhoden (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3478,'Basel-Landschaft (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3479,'Bern (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3480,'Genève (fr)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3481,'Uri (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3482,'Schaffhausen (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3483,'Thurgau (de)',206,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3484,'Tartus',207,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3485,'Ar Raqqah',207,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3486,'Dimashq',207,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3487,'?ims',207,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3488,'?alab',207,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3489,'Dar?a',207,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3490,'Rif Dimashq',207,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3491,'Al ?asakah',207,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3492,'Al Ladhiqiyah',207,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3493,'Al Qunaytirah',207,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3494,'As Suwayda',207,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3495,'Dayr az Zawr',207,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3496,'?amah',207,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3497,'Idlib',207,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3498,'Yunlin',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3499,'Taoyuan',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3500,'Taitung',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3501,'Taipei',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3502,'Tainan',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3503,'Taichung',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3504,'Chiayi Municipality',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3505,'Hsinchu Municipality',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3506,'Hsinchu',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3507,'Ilan',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3508,'Changhua',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3509,'Chiayi',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3510,'Hualien',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3511,'Kaohsiung',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3512,'Keelung Municipality',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3513,'Miaoli',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3514,'Pingtung',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3515,'Tainan Municipality',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3516,'Kaohsiung Special Municipality',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3517,'Nantou',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3518,'Penghu',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3519,'Taichung Municipality',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3520,'Taipei Special Municipality',208,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3521,'Khatlon',209,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3522,'',209,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3523,'Sughd',209,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3524,'Gorno-Badakhshan',209,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3525,'Kaskazini Pemba',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3526,'Tanga',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3527,'Singida',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3528,'Rukwa',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3529,'Mbeya',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3530,'Kagera',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3531,'Kigoma',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3532,'Kilimanjaro',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3533,'Manyara',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3534,'Mara',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3535,'Morogoro',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3536,'Mwanza',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3537,'Pwani',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3538,'Ruvuma',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3539,'Shinyanga',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3540,'Tabora',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3541,'Arusha',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3542,'Dar es Salaam',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3543,'Dodoma',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3544,'Iringa',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3545,'Lindi',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3546,'Mtwara',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3547,'Kaskazini Unguja',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3548,'Kusini Pemba',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3549,'Kusini Unguja',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3550,'Mjini Magharibi',210,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3551,'Yasothon',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3552,'Surat Thani',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3553,'Phichit',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3554,'Phra Nakhon Si Ayutthaya',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3555,'Prachin Buri',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3556,'Ratchaburi',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3557,'Roi Et',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3558,'Samut Prakan',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3559,'Samut Songkhram',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3560,'Sing Buri',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3561,'Sukhothai',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3562,'Loei',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3563,'Maha Sarakham',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3564,'Nakhon Nayok',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3565,'Nakhon Ratchasima',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3566,'Nakhon Si Thammarat',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3567,'Nong Bua Lam Phu',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3568,'Nonthaburi',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3569,'Phangnga',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3570,'Phayao',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3571,'Si Sa Ket',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3572,'Songkhla',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3573,'Suphan Buri',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3574,'Surin',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3575,'Tak',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3576,'Trat',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3577,'Ubon Ratchathani',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3578,'Uthai Thani',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3579,'Yala',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3580,'Nong Khai',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3581,'Pathum Thani',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3582,'Pattani',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3583,'Phatthalung',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3584,'Phetchabun',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3585,'Phetchaburi',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3586,'Phitsanulok',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3587,'Phrae',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3588,'Phuket',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3589,'Chaiyaphum',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3590,'Chanthaburi',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3591,'Chiang Rai',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3592,'Chumphon',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3593,'Kamphaeng Phet',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3594,'Kanchanaburi',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3595,'Krabi',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3596,'Lampang',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3597,'Lamphun',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3598,'Amnat Charoen',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3599,'Ang Thong',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3600,'Chachoengsao',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3601,'Lop Buri',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3602,'Mae Hong Son',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3603,'Mukdahan',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3604,'Nakhon Pathom',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3605,'Nakhon Phanom',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3606,'Nakhon Sawan',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3607,'Nan',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3608,'Narathiwat',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3609,'Prachuap Khiri Khan',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3610,'Ranong',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3611,'Rayong',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3612,'Sa Kaeo',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3613,'Sakon Nakhon',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3614,'Samut Sakhon',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3615,'Saraburi',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3616,'Satun',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3617,'Buri Ram',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3618,'Chai Nat',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3619,'Chiang Mai',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3620,'Chon Buri',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3621,'Kalasin',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3622,'Khon Kaen',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3623,'Krung Thep Maha Nakhon [Bangkok]',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3624,'Trang',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3625,'Uttaradit',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3626,'Udon Thani',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3627,'Phatthaya',211,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3628,'Manufahi',212,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3629,'Ainaro',212,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3630,'Aileu',212,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3631,'Oecussi',212,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3632,'Bobonaro',212,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3633,'Cova Lima',212,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3634,'Ermera',212,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3635,'Liquiça',212,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3636,'Manatuto',212,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3637,'Viqueque',212,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3638,'Baucau',212,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3639,'Lautem',212,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3640,'Dili',212,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3641,'Savannes',213,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3642,'Kara',213,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3643,'Centre',213,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3644,'Plateaux',213,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3645,'Maritime (Région)',213,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3646,'Vava u',215,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3647,'Ha apai',215,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3648,'Tongatapu',215,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3649,'Eua',215,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3650,'Niuas',215,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3651,'Princes Town',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3652,'Arima',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3653,'Couva-Tabaquite-Talparo',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3654,'Diego Martin',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3655,'Penal-Debe',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3656,'Port of Spain',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3657,'San Fernando',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3658,'San Juan-Laventille',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3659,'Siparia',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3660,'Tunapuna-Piarco',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3661,'Rio Claro-Mayaro',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3662,'Chaguanas',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3663,'Point Fortin',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3664,'Sangre Grande',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3665,'Eastern Tobago',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3666,'Western Tobago',216,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3667,'Zaghouan',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3668,'Tataouine',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3669,'Siliana',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3670,'Sfax',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3671,'L Ariana',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3672,'Ben Arous',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3673,'Jendouba',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3674,'Medenine',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3675,'La Manouba',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3676,'Nabeul',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3677,'Béja',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3678,'Bizerte',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3679,'Le Kef',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3680,'Mahdia',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3681,'Monastir',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3682,'Gabès',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3683,'Gafsa',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3684,'Kasserine',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3685,'Kairouan',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3686,'Kebili',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3687,'Sidi Bouzid',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3688,'Sousse',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3689,'Tozeur',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3690,'Tunis',217,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3691,'Zonguldak',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3692,'Osmaniye',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3693,'Mardin',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3694,'Kirklareli',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3695,'Siirt',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3696,'Sirnak',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3697,'Tekirdag',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3698,'Tokat',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3699,'Trabzon',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3700,'Usak',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3701,'Van',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3702,'Yozgat',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3703,'Diyarbakir',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3704,'Malatya',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3705,'Manisa',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3706,'Mugla',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3707,'Mus',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3708,'Nigde',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3709,'Ordu',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3710,'Rize',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3711,'Sakarya',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3712,'Sanliurfa',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3713,'Erzincan',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3714,'Erzurum',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3715,'Gaziantep',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3716,'Gümüshane',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3717,'Hakkâri',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3718,'Hatay',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3719,'Igdir',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3720,'Istanbul',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3721,'Izmir',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3722,'Aksaray',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3723,'Amasya',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3724,'Antalya',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3725,'Ardahan',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3726,'Aydin',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3727,'Balikesir',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3728,'Batman',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3729,'Bayburt',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3730,'Bingöl',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3731,'Adiyaman',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3732,'Afyon',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3733,'Bitlis',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3734,'Bolu',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3735,'Bursa',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3736,'Çankiri',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3737,'Çorum',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3738,'Denizli',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3739,'Düzce',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3740,'Edirne',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3741,'Karabük',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3742,'Karaman',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3743,'Kastamonu',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3744,'Kayseri',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3745,'Kirikkale',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3746,'Kirsehir',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3747,'Kocaeli',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3748,'Konya',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3749,'Elazig',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3750,'Eskisehir',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3751,'Giresun',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3752,'Içel',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3753,'Isparta',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3754,'Kahramanmaras',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3755,'Kars',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3756,'Kilis',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3757,'Adana',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3758,'Agri',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3759,'Ankara',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3760,'Artvin',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3761,'Bartin',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3762,'Bilecik',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3763,'Burdur',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3764,'Çanakkale',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3765,'Kütahya',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3766,'Nevsehir',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3767,'Samsun',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3768,'Tunceli',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3769,'Sivas',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3770,'Sinop',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3771,'Yalova',218,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3772,'Mary',219,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3773,'',219,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3774,'Balkan',219,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3775,'Ahal',219,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3776,'Dasoguz',219,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3777,'Lebap',219,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3778,'Nukufetau',221,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3779,'Nanumanga',221,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3780,'Nanumea',221,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3781,'Niutao',221,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3782,'Nui',221,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3783,'Nukulaelae',221,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3784,'Vaitupu',221,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3785,'Funafuti',221,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3786,'Kalangala',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3787,'Kampala',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3788,'Kiboga',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3789,'Luwero',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3790,'Masaka',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3791,'Mpigi',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3792,'Mubende',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3793,'Mukono',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3794,'Nakasongola',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3795,'Rakai',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3796,'Sembabule',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3797,'Kayunga',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3798,'Wakiso',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3799,'Bugiri',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3800,'Busia',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3801,'Iganga',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3802,'Jinja',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3803,'Kamuli',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3804,'Kapchorwa',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3805,'Katakwi',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3806,'Kumi',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3807,'Mbale',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3808,'Pallisa',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3809,'Soroti',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3810,'Tororo',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3811,'Kaberamaido',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3812,'Mayuge',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3813,'Sironko',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3814,'Adjumani',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3815,'Apac',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3816,'Arua',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3817,'Gulu',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3818,'Kitgum',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3819,'Kotido',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3820,'Lira',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3821,'Moroto',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3822,'Moyo',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3823,'Nebbi',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3824,'Nakapiripirit',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3825,'Pader',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3826,'Yumbe',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3827,'Bundibugyo',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3828,'Bushenyi',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3829,'Hoima',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3830,'Kabale',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3831,'Kabarole',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3832,'Kasese',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3833,'Kibaale',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3834,'Kisoro',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3835,'Masindi',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3836,'Mbarara',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3837,'Ntungamo',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3838,'Rukungiri',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3839,'Kamwenge',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3840,'Kanungu',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3841,'Kyenjojo',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3842,'Abim',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3843,'Amolatar',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3844,'Amuria',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3845,'Amuru',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3846,'Budaka',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3847,'Bukwa',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3848,'Butaleja',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3849,'Dokolo',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3850,'Ibanda',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3851,'Isingiro',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3852,'Kaabong',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3853,'Kaliro',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3854,'Kiruhura',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3855,'Koboko',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3856,'Manafwa',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3857,'Maracha',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3858,'Nakaseke',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3859,'Namutumba',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3860,'Bukedea',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3861,'Bududa',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3862,'Lyantonde',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3863,'Buliisa',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3864,'Mityana',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3865,'Oyam',222,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3866,'Zhytomyrs ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3867,'Vinnyts ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3868,'Cherkas ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3869,'Chernihivs ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3870,'Chernivets ka Oblas',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3871,'Donets ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3872,'Ivano-Frankivs ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3873,'Kharkivs ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3874,'Khersons ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3875,'Kirovohrads ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3876,'Respublika Krym',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3877,'Dnipropetrovs ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3878,'Khmel nyts',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3879,'Luhans ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3880,'Odes ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3881,'Kyïv',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3882,'Kyïvs ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3883,'L vivs',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3884,'Mykolaïvs ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3885,'Poltavs ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3886,'Rivnens ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3887,'Sevastopol',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3888,'Sums ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3889,'Ternopil s ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3890,'Zaporiz ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3891,'Volyns ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3892,'Zakarpats ka Oblast',223,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3893,'Ras al Khaymah',224,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3894,'Abu Z¸aby [Abu Dhabi]',224,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3895,'Ajman',224,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3896,'Dubayy [Dubai]',224,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3897,'Al Fujayrah',224,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3898,'Ash Shariqah [Sharjah]',224,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3899,'Umm al Qaywayn',224,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3900,'Barking and Dagenham',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3901,'Barnet',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3902,'Barnsley',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3903,'Bexley',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3904,'Birmingham',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3905,'Bolton',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3906,'Bradford',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3907,'Brent',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3908,'Bromley',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3909,'Bury',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3910,'Calderdale',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3911,'Camden',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3912,'Coventry',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3913,'Croydon',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3914,'Doncaster',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3915,'Dudley',225,1,'2025-01-03 04:07:27','2025-01-03 04:07:27'),(3916,'Ealing',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3917,'Enfield',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3918,'Gateshead',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3919,'Greenwich',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3920,'Hackney',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3921,'Hammersmith and Fulham',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3922,'Haringey',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3923,'Harrow',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3924,'Havering',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3925,'Hillingdon',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3926,'Hounslow',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3927,'Isles of Scilly',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3928,'Islington',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3929,'Kensington and Chelsea',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3930,'Kingston upon Thames',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3931,'Kirklees',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3932,'Knowsley',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3933,'Lambeth',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3934,'Leeds',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3935,'Lewisham',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3936,'Liverpool',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3937,'Merton',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3938,'Newcastle upon Tyne',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3939,'Newham',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3940,'North Tyneside',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3941,'Oldham',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3942,'Redbridge',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3943,'Richmond upon Thames',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3944,'Rochdale',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3945,'Rotherham',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3946,'Salford',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3947,'Sandwell',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3948,'Sefton',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3949,'Sheffield',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3950,'Solihull',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3951,'South Tyneside',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3952,'Southwark',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3953,'St. Helens',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3954,'Stockport',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3955,'Sunderland',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3956,'Sutton',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3957,'Tameside',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3958,'Tower Hamlets',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3959,'Trafford',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3960,'Wakefield',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3961,'Walsall',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3962,'Waltham Forest',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3963,'Wandsworth',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3964,'Westminster',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3965,'Wigan',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3966,'Wirral',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3967,'Wolverhampton',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3968,'Kingston upon Hull, City of',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3969,'Kent',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3970,'Isle of Wight',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3971,'Hertfordshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3972,'Herefordshire, County of',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3973,'Hartlepool',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3974,'Hampshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3975,'Halton',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3976,'London, City of',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3977,'Gloucestershire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3978,'Essex',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3979,'East Sussex',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3980,'East Riding of Yorkshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3981,'Durham',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3982,'Dorset',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3983,'Devon',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3984,'Derbyshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3985,'Derby',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3986,'Darlington',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3987,'Cumbria',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3988,'Cornwall',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3989,'Cheshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3990,'Cambridgeshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3991,'Buckinghamshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3992,'Bristol, City of',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3993,'Brighton and Hove',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3994,'Bracknell Forest',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3995,'Bournemouth',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3996,'Blackpool',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3997,'Blackburn with Darwen',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3998,'Bedfordshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(3999,'Bath and North East Somerset',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4000,'Wrexham [Wrecsam GB-WRC]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4001,'Vale of Glamorgan, The [Bro Morgannwg GB-BMG]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4002,'Torfaen [Tor-faen]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4003,'Swansea [Abertawe GB-ATA]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4004,'Rhondda, Cynon, Taff [Rhondda, Cynon,Taf]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4005,'Powys',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4006,'Pembrokeshire [Sir Benfro GB-BNF]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4007,'Newport [Casnewydd GB-CNW]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4008,'Neath Port Talbot [Castell-nedd Port Talbot GB-CTL]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4009,'Monmouthshire [Sir Fynwy GB-FYN]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4010,'Merthyr Tydfil [Merthyr Tudful GB-MTU]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4011,'Gwynedd',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4012,'Flintshire [Sir y Fflint GB-FFL]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4013,'Denbighshire [Sir Ddinbych GB-DDB]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4014,'Conwy',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4015,'Ceredigion [Sir Ceredigion]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4016,'Carmarthenshire [Sir Gaerfyrddin GB-GFY]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4017,'Cardiff [Caerdydd GB-CRD]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4018,'Caerphilly [Caerffili GB-CAF]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4019,'Bridgend [Pen-y-bont ar Ogwr GB-POG]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4020,'Blaenau Gwent',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4021,'Isle of Anglesey [Sir Ynys Môn GB-YNM]',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4022,'West Lothian',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4023,'West Dunbartonshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4024,'Stirling',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4025,'South Lanarkshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4026,'South Ayrshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4027,'Shetland Islands',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4028,'Scottish Borders, The',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4029,'Renfrewshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4030,'Perth and Kinross',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4031,'Orkney Islands',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4032,'North Lanarkshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4033,'North Ayrshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4034,'Moray',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4035,'Midlothian',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4036,'Inverclyde',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4037,'Highland',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4038,'Glasgow City',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4039,'Fife',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4040,'Falkirk',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4041,'Eilean Siar',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4042,'Edinburgh, City of',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4043,'East Renfrewshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4044,'East Lothian',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4045,'East Dunbartonshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4046,'East Ayrshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4047,'Dundee City',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4048,'Dumfries and Galloway',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4049,'Clackmannanshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4050,'Argyll and Bute',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4051,'Angus',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4052,'Aberdeenshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4053,'Aberdeen City',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4054,'Strabane',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4055,'Omagh',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4056,'North Down',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4057,'Newtownabbey',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4058,'Newry and Mourne',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4059,'Moyle',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4060,'Magherafelt',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4061,'Derry',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4062,'Lisburn',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4063,'Limavady',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4064,'Larne',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4065,'Fermanagh',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4066,'Dungannon',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4067,'Down',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4068,'Craigavon',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4069,'Cookstown',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4070,'Coleraine',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4071,'Castlereagh',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4072,'Carrickfergus',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4073,'Belfast',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4074,'Banbridge',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4075,'Ballymoney',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4076,'Ballymena',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4077,'Armagh',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4078,'Ards',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4079,'Antrim',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4080,'York',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4081,'Worcestershire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4082,'Wokingham',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4083,'Windsor and Maidenhead',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4084,'Wiltshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4085,'West Sussex',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4086,'West Berkshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4087,'Warwickshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4088,'Warrington',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4089,'Torbay',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4090,'Thurrock',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4091,'Telford and Wrekin',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4092,'Swindon',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4093,'Surrey',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4094,'Suffolk',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4095,'Stoke-on-Trent',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4096,'Stockton-on-Tees',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4097,'Staffordshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4098,'Southend-on-Sea',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4099,'Southampton',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4100,'South Gloucestershire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4101,'Somerset',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4102,'Slough',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4103,'Shropshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4104,'Rutland',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4105,'Redcar and Cleveland',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4106,'Reading',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4107,'Portsmouth',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4108,'Poole',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4109,'Plymouth',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4110,'Peterborough',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4111,'Oxfordshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4112,'Nottinghamshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4113,'Nottingham',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4114,'Northumberland',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4115,'Northamptonshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4116,'North Yorkshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4117,'North Somerset',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4118,'North Lincolnshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4119,'North East Lincolnshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4120,'Norfolk',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4121,'Milton Keynes',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4122,'Middlesbrough',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4123,'Medway',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4124,'Luton',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4125,'Manchester',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4126,'Lincolnshire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4127,'Leicestershire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4128,'Leicester',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4129,'Lancashire',225,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4130,'West Virginia',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4131,'Virginia',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4132,'Utah',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4133,'Tennessee',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4134,'Pennsylvania',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4135,'North Carolina',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4136,'Minnesota',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4137,'Missouri',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4138,'Montana',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4139,'Nevada',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4140,'New Jersey',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4141,'New York',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4142,'North Dakota',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4143,'Oklahoma',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4144,'Oregon',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4145,'Alabama',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4146,'Arizona',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4147,'California',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4148,'Connecticut',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4149,'District of Columbia',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4150,'Georgia',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4151,'Idaho',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4152,'Indiana',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4153,'Iowa',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4154,'Kentucky',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4155,'Maine',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4156,'Massachusetts',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4157,'Rhode Island',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4158,'South Dakota',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4159,'Texas',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4160,'Vermont',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4161,'Washington',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4162,'Wisconsin',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4163,'Wyoming',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4164,'Illinois',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4165,'Kansas',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4166,'Louisiana',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4167,'Maryland',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4168,'Michigan',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4169,'Mississippi',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4170,'Nebraska',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4171,'New Hampshire',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4172,'New Mexico',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4173,'Alaska',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4174,'Arkansas',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4175,'Colorado',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4176,'Delaware',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4177,'Florida',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4178,'Hawaii',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4179,'Ohio',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4180,'South Carolina',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4181,'American Samoa',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4182,'Guam',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4183,'Northern Mariana Islands',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4184,'Puerto Rico',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4185,'Virgin Islands, U.S.',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4186,'United States Minor Outlying Islands',226,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4187,'Wake Island',227,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4188,'Palmyra Atoll',227,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4189,'Navassa Island',227,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4190,'Midway Islands',227,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4191,'Johnston Atoll',227,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4192,'Howland Island',227,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4193,'Baker Island',227,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4194,'Jarvis Island',227,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4195,'Kingman Reef',227,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4196,'Tacuarembó',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4197,'San José',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4198,'Rivera',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4199,'Paysandú',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4200,'Flores',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4201,'Artigas',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4202,'',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4203,'',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4204,'Durazno',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4205,'Florida',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4206,'Maldonado',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4207,'Montevideo',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4208,'Río Negro',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4209,'Rocha',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4210,'Salto',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4211,'Soriano',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4212,'Treinta y Tres',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4213,'',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4214,'Lavalleja',228,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4215,'Surxondaryo',229,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4216,'Sirdaryo',229,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4217,'Navoiy',229,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4218,'Andijon',229,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4219,'Buxoro',229,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4220,'Qashqadaryo',229,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4221,'Namangan',229,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4222,'Samarqand',229,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4223,'Toshkent',229,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4224,'Jizzax',229,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4225,'Xorazm',229,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4226,'Toshkent City',229,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4227,'Taféa',230,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4228,'Malampa',230,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4229,'Shéfa',230,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4230,'Pénama',230,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4231,'Torba',230,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4232,'Sanma',230,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4233,'Sucre',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4234,'Nueva Esparta',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4235,'Amazonas',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4236,'Aragua',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4237,'Bolívar',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4238,'Delta Amacuro',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4239,'Distrito Federal',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4240,'Guárico',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4241,'Lara',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4242,'Mérida',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4243,'Miranda',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4244,'Monagas',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4245,'Anzoátegui',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4246,'Apure',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4247,'Barinas',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4248,'Carabobo',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4249,'Cojedes',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4250,'Dependencias Federales',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4251,'Falcón',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4252,'Portuguesa',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4253,'Yaracuy',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4254,'Táchira',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4255,'Trujillo',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4256,'Vargas',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4257,'Zulia',231,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4258,'Bac Lieu',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4259,'An Giang',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4260,'Bac Giang',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4261,'Bac Can',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4262,'Ba Ria - Vung Tau',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4263,'Thai Nguyen',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4264,'Lai Chau',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4265,'Lao Cai',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4266,'Ha Giang',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4267,'Cao Bang',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4268,'Son La',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4269,'Yen Bai',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4270,'Tuyen Quang',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4271,'Lang Son',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4272,'Quang Ninh',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4273,'Hoa Binh',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4274,'Ha Tay',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4275,'Ninh Binh',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4276,'Thai Binh',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4277,'Thanh Hoa',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4278,'Nghe An',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4279,'Ha Tinh',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4280,'Quang Binh',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4281,'Quang Tri',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4282,'Thua Thien-Hue',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4283,'Quang Nam',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4284,'Kon Tum',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4285,'Quang Ngai',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4286,'Gia Lai',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4287,'Binh Dinh',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4288,'Phu Yen',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4289,'Dac Lac',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4290,'Khanh Hoa',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4291,'Lam Dong',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4292,'Ninh Thuan',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4293,'Tay Ninh',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4294,'Dong Nai',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4295,'Binh Thuan',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4296,'Long An',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4297,'Dong Thap',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4298,'Tien Giang',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4299,'Kien Giang',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4300,'Can Tho',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4301,'Vinh Long',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4302,'Ben Tre',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4303,'Tra Vinh',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4304,'Soc Trang',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4305,'Bac Ninh',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4306,'Binh Duong',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4307,'Binh Phuoc',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4308,'Ca Mau',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4309,'Da Nang, thanh pho',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4310,'Hai Duong',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4311,'Hai Phong, thanh pho',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4312,'Ha Nam',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4313,'Ha Noi, thu do',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4314,'Ho Chi Minh, thanh pho [Sai Gon]',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4315,'Hung Yen',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4316,'Nam Dinh',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4317,'Phu Tho',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4318,'Vinh Phuc',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4319,'Dien Bien',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4320,'Dak Nong',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4321,'Hau Giang',232,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4322,'Laayoune',236,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4323,'Oued el Dahab',236,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4324,'Boujdour',236,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4325,'Es Semara',236,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4326,'Taʿizz',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4327,'Sanʿā',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4328,'Shabwah',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4329,'Al Mahwit',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4330,'La?ij',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4331,'ʿAdan',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4332,'Al Bay?a',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4333,'Hadramawt',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4334,'Hajjah',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4335,'Abyan',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4336,'Dhamar',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4337,'Al ?udaydah',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4338,'Ibb',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4339,'Al Jawf',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4340,'Al Mahrah',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4341,'Ma rib',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4342,'Sa`dah',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4343,'Amran',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4344,'Ad Dāli',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4345,'Raymah',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4346,'Şanā',237,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4347,'Western',238,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4348,'Northern',238,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4349,'Copperbelt',238,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4350,'Lusaka',238,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4351,'Southern',238,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4352,'Luapula',238,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4353,'North-Western',238,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4354,'Central',238,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4355,'Eastern',238,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4356,'Manicaland',239,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4357,'Midlands',239,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4358,'Mashonaland Central',239,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4359,'Mashonaland East',239,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4360,'Mashonaland West',239,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4361,'Matabeleland North',239,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4362,'Matabeleland South',239,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4363,'Masvingo',239,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4364,'Harare',239,1,'2025-01-03 04:07:28','2025-01-03 04:07:28'),(4365,'Bulawayo',239,1,'2025-01-03 04:07:28','2025-01-03 04:07:28');
/*!40000 ALTER TABLE `states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sub_modules`
--

DROP TABLE IF EXISTS `sub_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sub_modules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` bigint(20) unsigned NOT NULL,
  `key` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sub_modules_module_id_foreign` (`module_id`),
  CONSTRAINT `sub_modules_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sub_modules`
--

LOCK TABLES `sub_modules` WRITE;
/*!40000 ALTER TABLE `sub_modules` DISABLE KEYS */;
INSERT INTO `sub_modules` VALUES (1,1,'ticket-widget','2025-01-03 04:07:30','2025-01-03 04:07:30'),(2,1,'immediate-action','2025-01-03 04:07:30','2025-01-03 04:07:30'),(3,1,'todo','2025-01-03 04:07:30','2025-01-03 04:07:30'),(4,1,'recent-activities','2025-01-03 04:07:30','2025-01-03 04:07:30'),(5,1,'agent-summary','2025-01-03 04:07:30','2025-01-03 04:07:30'),(6,1,'department-summary','2025-01-03 04:07:30','2025-01-03 04:07:30'),(7,1,'agent-performance','2025-01-03 04:07:30','2025-01-03 04:07:30'),(8,1,'system-summary','2025-01-03 04:07:30','2025-01-03 04:07:30');
/*!40000 ALTER TABLE `sub_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sub_reports`
--

DROP TABLE IF EXISTS `sub_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sub_reports` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `report_id` bigint(20) NOT NULL,
  `identifier` varchar(100) NOT NULL,
  `data_type` varchar(30) DEFAULT NULL,
  `data_widget_url` varchar(255) DEFAULT NULL,
  `data_url` varchar(255) DEFAULT NULL,
  `selected_chart_type` varchar(30) DEFAULT NULL,
  `list_view_by` text DEFAULT NULL,
  `selected_view_by` varchar(255) DEFAULT NULL,
  `add_custom_column_url` varchar(255) DEFAULT NULL,
  `layout` varchar(10) NOT NULL DEFAULT 'n*1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sub_reports`
--

LOCK TABLES `sub_reports` WRITE;
/*!40000 ALTER TABLE `sub_reports` DISABLE KEYS */;
INSERT INTO `sub_reports` VALUES (1,1,'helpdesk-in-depth-graph','category-chart','api/agent/helpdesk-in-depth-widget/1','api/agent/helpdesk-in-depth/1','bar','[\"priority\",\"source\",\"type\",\"status\"]','priority',NULL,'n*2','2025-01-03 04:07:24','2025-01-03 04:07:24'),(2,2,'overall-ticket-trend-graph','time-series-chart','api/agent/ticket-volume-trend/overall-ticket-trend-widget/2','api/agent/ticket-volume-trend/overall-ticket-trend/2',NULL,'[\"day\",\"week\",\"month\",\"year\"]','day',NULL,'n*1','2025-01-03 04:07:24','2025-01-03 04:07:24'),(3,2,'weekday-hour-trend-graph','time-series-chart','api/agent/ticket-volume-trend/day-ticket-trend-widget/2','api/agent/ticket-volume-trend/day-ticket-trend/2',NULL,'[\"monday\",\"tuesday\",\"wednesday\",\"thursday\",\"friday\",\"saturday\",\"sunday\"]','monday',NULL,'n*1','2025-01-03 04:07:24','2025-01-03 04:07:24'),(4,3,'management-report-table','datatable',NULL,'api/agent/management-report/3',NULL,NULL,NULL,'api/add-custom-column/4','n*1','2025-01-03 04:07:24','2025-01-03 04:07:31'),(5,4,'agent-performance-table','datatable',NULL,'api/agent/agent-performance-report/4',NULL,NULL,NULL,'api/add-custom-column/5','n*1','2025-01-03 04:07:24','2025-01-03 04:07:25'),(6,5,'department-performance-table','datatable',NULL,'api/agent/department-performance-report/5',NULL,NULL,NULL,'api/add-custom-column/6','n*1','2025-01-03 04:07:24','2025-01-03 04:07:25'),(7,6,'team-performance-table','datatable',NULL,'api/agent/team-performance-report/6',NULL,NULL,NULL,'api/add-custom-column/7','n*1','2025-01-03 04:07:24','2025-01-03 04:07:28'),(8,7,'time-report-chart','category-chart',NULL,'api/agent/performance-distribution/time-report/7','bar',NULL,NULL,NULL,'n*1','2025-01-03 04:07:24','2025-01-03 04:07:24'),(9,7,'trend-report-chart','time-series-chart',NULL,'api/agent/performance-distribution/trend-report/7',NULL,'[\"day\",\"week\",\"month\",\"year\"]','day',NULL,'n*1','2025-01-03 04:07:24','2025-01-03 04:07:24'),(10,8,'top-customer-analysis-chart','category-chart',NULL,'api/agent/top-customer-analysis/8','bar','[\"3\",\"5\",\"10\"]','3',NULL,'n*2','2025-01-03 04:07:24','2025-01-03 04:07:24'),(11,9,'rating-in-depth-graph','category-chart','api/agent/rating-in-depth-widget/9','api/agent/rating-in-depth/9','bar',NULL,'',NULL,'n*1','2025-01-03 04:07:28','2025-01-03 04:07:28'),(12,10,'turn-around-time-report','datatable',NULL,'api/agent/turn-around-time-report/10',NULL,NULL,NULL,'api/add-custom-column/12','n*1','2025-01-03 04:07:28','2025-01-03 04:07:31'),(13,11,'schedule-report','datatable',NULL,'api/agent/schedule-report/11',NULL,NULL,NULL,'api/add-custom-column/13','n*1','2025-01-03 04:07:30','2025-01-03 04:07:30'),(14,12,'user-report','datatable',NULL,'api/agent/user-report/12',NULL,NULL,NULL,'api/add-custom-column/14','n*1','2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `sub_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_activity_log_export_download`
--

DROP TABLE IF EXISTS `system_activity_log_export_download`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_activity_log_export_download` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_activity_log_export_download`
--

LOCK TABLES `system_activity_log_export_download` WRITE;
/*!40000 ALTER TABLE `system_activity_log_export_download` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_activity_log_export_download` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_portal`
--

DROP TABLE IF EXISTS `system_portal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_portal` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `admin_header_color` varchar(255) NOT NULL,
  `agent_header_color` varchar(255) NOT NULL,
  `client_header_color` varchar(10) DEFAULT NULL,
  `client_button_color` varchar(10) DEFAULT NULL,
  `client_button_border_color` varchar(10) DEFAULT NULL,
  `client_input_field_color` varchar(10) DEFAULT NULL,
  `logo` longtext DEFAULT NULL,
  `icon` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `logo_icon_driver` varchar(255) DEFAULT NULL,
  `is_enabled_breadcrumb` tinyint(1) NOT NULL DEFAULT 1,
  `agent_sidebar_color` varchar(255) NOT NULL DEFAULT 'sidebar-dark-black',
  `admin_sidebar_color` varchar(255) NOT NULL DEFAULT 'sidebar-dark-black',
  `client_button_font_color` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_portal`
--

LOCK TABLES `system_portal` WRITE;
/*!40000 ALTER TABLE `system_portal` DISABLE KEYS */;
INSERT INTO `system_portal` VALUES (1,'navbar-light','navbar-light','#009aba','#009aba','#00c0ef','#d2d6de','0','0','2025-01-03 04:07:23','2025-01-03 04:07:31',NULL,1,'sidebar-dark-black','sidebar-dark-black','#ffffff');
/*!40000 ALTER TABLE `system_portal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `visible_to` varchar(255) NOT NULL DEFAULT 'all_users',
  PRIMARY KEY (`id`),
  FULLTEXT KEY `name_index` (`name`),
  FULLTEXT KEY `description_index` (`description`),
  FULLTEXT KEY `name_description_index` (`name`,`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team_assign_agent`
--

DROP TABLE IF EXISTS `team_assign_agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_assign_agent` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `team_id` int(10) unsigned DEFAULT NULL,
  `agent_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `team_id` (`team_id`),
  KEY `agent_id` (`agent_id`),
  CONSTRAINT `team_assign_agent_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `team_assign_agent_ibfk_2` FOREIGN KEY (`agent_id`) REFERENCES `users` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_assign_agent`
--

LOCK TABLES `team_assign_agent` WRITE;
/*!40000 ALTER TABLE `team_assign_agent` DISABLE KEYS */;
/*!40000 ALTER TABLE `team_assign_agent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team_assign_department`
--

DROP TABLE IF EXISTS `team_assign_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_assign_department` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `team_id` varchar(255) NOT NULL,
  `dept_id` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_assign_department`
--

LOCK TABLES `team_assign_department` WRITE;
/*!40000 ALTER TABLE `team_assign_department` DISABLE KEYS */;
/*!40000 ALTER TABLE `team_assign_department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team_department`
--

DROP TABLE IF EXISTS `team_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_department` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `team_id` int(10) unsigned NOT NULL,
  `department_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `team_department_team_id_foreign` (`team_id`),
  KEY `team_department_department_id_foreign` (`department_id`),
  CONSTRAINT `team_department_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`),
  CONSTRAINT `team_department_team_id_foreign` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_department`
--

LOCK TABLES `team_department` WRITE;
/*!40000 ALTER TABLE `team_department` DISABLE KEYS */;
/*!40000 ALTER TABLE `team_department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `teams` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `team_lead_id` int(10) unsigned DEFAULT NULL,
  `assign_alert` tinyint(1) NOT NULL,
  `admin_notes` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `under_deletion` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `team_lead` (`team_lead_id`),
  CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`team_lead_id`) REFERENCES `users` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
INSERT INTO `teams` VALUES (1,'Level 1 Support',1,NULL,0,'','2025-01-03 04:07:23','2025-01-03 04:07:23',0),(2,'Level 2 Support',0,NULL,0,'','2025-01-03 04:07:23','2025-01-03 04:07:23',0),(3,'Developer',0,NULL,0,'','2025-01-03 04:07:23','2025-01-03 04:07:23',0);
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `template_types`
--

DROP TABLE IF EXISTS `template_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `template_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `plugin_name` varchar(50) DEFAULT NULL,
  `template_category` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `template_types`
--

LOCK TABLES `template_types` WRITE;
/*!40000 ALTER TABLE `template_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `template_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `third_party_applications`
--

DROP TABLE IF EXISTS `third_party_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `third_party_applications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `access_token` text DEFAULT NULL,
  `full_access` tinyint(4) NOT NULL DEFAULT 0,
  `author_id` int(10) unsigned NOT NULL,
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`options`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `third_party_applications_author_id_foreign` (`author_id`),
  CONSTRAINT `third_party_applications_author_id_foreign` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `third_party_applications`
--

LOCK TABLES `third_party_applications` WRITE;
/*!40000 ALTER TABLE `third_party_applications` DISABLE KEYS */;
/*!40000 ALTER TABLE `third_party_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `third_party_apps`
--

DROP TABLE IF EXISTS `third_party_apps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `third_party_apps` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `app_id` varchar(255) NOT NULL,
  `app_secret` varchar(255) NOT NULL,
  `app_url` varchar(255) NOT NULL,
  `authentication_endpoint` varchar(255) NOT NULL,
  `token_endpoint` varchar(255) NOT NULL,
  `identity_endpoint` varchar(255) NOT NULL,
  `login_label` varchar(255) NOT NULL,
  `scopes` varchar(255) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_basic` tinyint(1) NOT NULL DEFAULT 0,
  `method` varchar(255) DEFAULT NULL,
  `argument_as` varchar(255) DEFAULT NULL,
  `basic_format` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`basic_format`)),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `third_party_apps`
--

LOCK TABLES `third_party_apps` WRITE;
/*!40000 ALTER TABLE `third_party_apps` DISABLE KEYS */;
/*!40000 ALTER TABLE `third_party_apps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_action_email_user`
--

DROP TABLE IF EXISTS `ticket_action_email_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_action_email_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_action_email_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_action_email_user`
--

LOCK TABLES `ticket_action_email_user` WRITE;
/*!40000 ALTER TABLE `ticket_action_email_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_action_email_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_action_emails`
--

DROP TABLE IF EXISTS `ticket_action_emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_action_emails` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `ticket_action_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_action_emails`
--

LOCK TABLES `ticket_action_emails` WRITE;
/*!40000 ALTER TABLE `ticket_action_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_action_emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_actions`
--

DROP TABLE IF EXISTS `ticket_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_actions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reference_id` int(10) unsigned DEFAULT NULL,
  `reference_type` varchar(255) DEFAULT NULL,
  `field` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_actions`
--

LOCK TABLES `ticket_actions` WRITE;
/*!40000 ALTER TABLE `ticket_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_activity_logs`
--

DROP TABLE IF EXISTS `ticket_activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_activity_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) DEFAULT NULL,
  `field` varchar(255) NOT NULL,
  `action_taker_id` int(11) DEFAULT NULL,
  `action_taker_type` varchar(255) NOT NULL,
  `value` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `category` varchar(100) NOT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ticket_activity_logs_ticket_id_index` (`ticket_id`),
  KEY `field` (`field`),
  KEY `value` (`value`),
  KEY `field_2` (`field`),
  KEY `value_2` (`value`),
  KEY `ticket_activity_logs_parent_id_index` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_activity_logs`
--

LOCK TABLES `ticket_activity_logs` WRITE;
/*!40000 ALTER TABLE `ticket_activity_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_activity_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_archive_database_setting`
--

DROP TABLE IF EXISTS `ticket_archive_database_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_archive_database_setting` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `backup_db_host` varchar(255) NOT NULL,
  `backup_db_database` varchar(255) NOT NULL,
  `backup_db_username` varchar(255) NOT NULL,
  `backup_db_password` varchar(255) NOT NULL,
  `backup_db_port` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_archive_database_setting`
--

LOCK TABLES `ticket_archive_database_setting` WRITE;
/*!40000 ALTER TABLE `ticket_archive_database_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_archive_database_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_attachment`
--

DROP TABLE IF EXISTS `ticket_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_attachment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `thread_id` int(10) unsigned DEFAULT NULL,
  `size` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `poster` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `file` mediumblob DEFAULT NULL,
  `content_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `thread_id` (`thread_id`),
  CONSTRAINT `ticket_attachment_ibfk_1` FOREIGN KEY (`thread_id`) REFERENCES `ticket_thread` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_attachment`
--

LOCK TABLES `ticket_attachment` WRITE;
/*!40000 ALTER TABLE `ticket_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_collaborator`
--

DROP TABLE IF EXISTS `ticket_collaborator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_collaborator` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `isactive` tinyint(1) NOT NULL,
  `ticket_id` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `role` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ticket_id` (`ticket_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `ticket_collaborator_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `ticket_collaborator_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_collaborator`
--

LOCK TABLES `ticket_collaborator` WRITE;
/*!40000 ALTER TABLE `ticket_collaborator` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_collaborator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_department_time_trackings`
--

DROP TABLE IF EXISTS `ticket_department_time_trackings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_department_time_trackings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(10) unsigned NOT NULL,
  `dept_id` int(10) unsigned NOT NULL,
  `started_at` datetime DEFAULT NULL,
  `ended_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ticket_department_time_trackings_ticket_id_foreign` (`ticket_id`),
  KEY `ticket_department_time_trackings_dept_id_foreign` (`dept_id`),
  CONSTRAINT `ticket_department_time_trackings_dept_id_foreign` FOREIGN KEY (`dept_id`) REFERENCES `department` (`id`),
  CONSTRAINT `ticket_department_time_trackings_ticket_id_foreign` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_department_time_trackings`
--

LOCK TABLES `ticket_department_time_trackings` WRITE;
/*!40000 ALTER TABLE `ticket_department_time_trackings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_department_time_trackings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_events`
--

DROP TABLE IF EXISTS `ticket_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `field` varchar(255) NOT NULL,
  `from` int(10) unsigned DEFAULT NULL,
  `to` int(10) unsigned DEFAULT NULL,
  `ticket_listener_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_events`
--

LOCK TABLES `ticket_events` WRITE;
/*!40000 ALTER TABLE `ticket_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_filter_meta`
--

DROP TABLE IF EXISTS `ticket_filter_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_filter_meta` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_filter_id` int(10) unsigned NOT NULL,
  `key` varchar(255) NOT NULL,
  `value_meta` longtext NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ticket_filter_meta_ticket_filter_id_foreign` (`ticket_filter_id`),
  CONSTRAINT `ticket_filter_meta_ticket_filter_id_foreign` FOREIGN KEY (`ticket_filter_id`) REFERENCES `ticket_filters` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_filter_meta`
--

LOCK TABLES `ticket_filter_meta` WRITE;
/*!40000 ALTER TABLE `ticket_filter_meta` DISABLE KEYS */;
INSERT INTO `ticket_filter_meta` VALUES (1,1,'created-at','','s:12:\"last::60~day\";'),(2,2,'created-at','','s:12:\"last::60~day\";'),(3,3,'created-at','','s:12:\"last::30~day\";'),(4,4,'created-at','','s:12:\"last::60~day\";'),(5,5,'created-at','','s:12:\"last::60~day\";'),(6,6,'created-at','','s:12:\"last::60~day\";'),(7,7,'created-at','','s:12:\"last::60~day\";'),(8,8,'created-at','','s:12:\"last::60~day\";'),(9,9,'category','','s:5:\"inbox\";'),(10,10,'category','','s:6:\"closed\";'),(11,11,'created-at','','s:12:\"last::30~day\";'),(12,12,'category','','s:5:\"inbox\";'),(13,13,'category','','s:7:\"overdue\";'),(14,14,'category','','s:10:\"unassigned\";'),(15,15,'category','','s:5:\"inbox\";'),(16,15,'answered','','s:1:\"0\";'),(17,16,'category','','s:5:\"inbox\";'),(18,17,'category','','s:7:\"overdue\";'),(19,18,'category','','s:10:\"unassigned\";'),(20,19,'category','','s:5:\"inbox\";'),(21,19,'answered','','s:1:\"0\";'),(22,20,'category','','s:9:\"mytickets\";'),(23,21,'category','','s:20:\"waiting-for-approval\";'),(24,22,'assignee-ids','','a:0:{}'),(25,22,'due-on','','s:11:\"next::1~day\";'),(26,23,'category','','s:10:\"unapproved\";'),(27,24,'category','','s:6:\"closed\";'),(28,25,'category','','s:4:\"spam\";'),(29,26,'category','','s:7:\"deleted\";'),(30,27,'category','','s:9:\"mytickets\";'),(31,28,'category','','s:20:\"waiting-for-approval\";'),(32,29,'assignee-ids','','a:1:{i:0;i:1;}'),(33,29,'due-on','','s:11:\"next::1~day\";'),(34,30,'category','','s:10:\"unapproved\";'),(35,31,'category','','s:6:\"closed\";'),(36,32,'category','','s:4:\"spam\";'),(37,33,'category','','s:7:\"deleted\";');
/*!40000 ALTER TABLE `ticket_filter_meta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_filter_shareables`
--

DROP TABLE IF EXISTS `ticket_filter_shareables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_filter_shareables` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_filter_id` int(10) unsigned NOT NULL,
  `ticket_filter_shareable_id` int(10) unsigned NOT NULL,
  `ticket_filter_shareable_type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_filter_shareables`
--

LOCK TABLES `ticket_filter_shareables` WRITE;
/*!40000 ALTER TABLE `ticket_filter_shareables` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_filter_shareables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_filters`
--

DROP TABLE IF EXISTS `ticket_filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_filters` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `parent_type` varchar(255) DEFAULT NULL,
  `display_on_dashboard` tinyint(1) DEFAULT NULL,
  `icon_class` varchar(30) DEFAULT NULL,
  `icon_color` varchar(30) DEFAULT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'agent',
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `display_on_navigation_bar` tinyint(1) DEFAULT NULL,
  `is_deletable` tinyint(1) DEFAULT NULL,
  `source` varchar(255) NOT NULL,
  `display_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ticket_filters_user_id_foreign` (`user_id`),
  CONSTRAINT `ticket_filters_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_filters`
--

LOCK TABLES `ticket_filters` WRITE;
/*!40000 ALTER TABLE `ticket_filters` DISABLE KEYS */;
INSERT INTO `ticket_filters` VALUES (1,'',1,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',1,'App\\FaveoReport\\Models\\Report',NULL,NULL,NULL,'agent',0,NULL,NULL,'',NULL),(2,'',1,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',2,'App\\FaveoReport\\Models\\Report',NULL,NULL,NULL,'agent',0,NULL,NULL,'',NULL),(3,'',1,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',3,'App\\FaveoReport\\Models\\Report',NULL,NULL,NULL,'agent',0,NULL,NULL,'',NULL),(4,'',1,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',4,'App\\FaveoReport\\Models\\Report',NULL,NULL,NULL,'agent',0,NULL,NULL,'',NULL),(5,'',1,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',5,'App\\FaveoReport\\Models\\Report',NULL,NULL,NULL,'agent',0,NULL,NULL,'',NULL),(6,'',1,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',6,'App\\FaveoReport\\Models\\Report',NULL,NULL,NULL,'agent',0,NULL,NULL,'',NULL),(7,'',1,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',7,'App\\FaveoReport\\Models\\Report',NULL,NULL,NULL,'agent',0,NULL,NULL,'',NULL),(8,'',1,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24',8,'App\\FaveoReport\\Models\\Report',NULL,NULL,NULL,'agent',0,NULL,NULL,'',NULL),(9,'Open',1,NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30',NULL,NULL,NULL,'fas fa-inbox','#000','admin',1,NULL,NULL,'',NULL),(10,'Closed',1,NULL,'2025-01-03 04:07:28','2025-01-03 04:07:30',NULL,NULL,NULL,'fa fa-minus-circle','#000','admin',1,NULL,NULL,'',NULL),(11,'',1,NULL,'2025-01-03 04:07:28','2025-01-03 04:07:28',10,'App\\FaveoReport\\Models\\Report',NULL,NULL,NULL,'agent',0,NULL,NULL,'',NULL),(12,'open_tickets',0,NULL,NULL,'2025-01-03 04:07:31',NULL,NULL,1,'fas fa-inbox','#007bff','system',1,1,0,'open_tickets',1),(13,'overdue_tickets',0,NULL,NULL,'2025-01-03 04:07:31',NULL,NULL,1,'far fa-calendar-times','#dd4b39','system',1,1,1,'overdue_tickets',4),(14,'unassigned_tickets',0,NULL,NULL,'2025-01-03 04:07:31',NULL,NULL,1,'fas fa-user-times','#f39c12','system',1,1,1,'unassigned_tickets',3),(15,'unanswered_tickets',0,NULL,NULL,'2025-01-03 04:07:31',NULL,NULL,1,'fas fa-reply','#00c0ef','system',1,1,1,'unanswered_tickets',5),(16,'Open Tickets',0,1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,NULL,1,'fas fa-inbox','#007bff','agent',1,1,0,'open_tickets',1),(17,'Overdue Tickets',0,1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,NULL,1,'far fa-calendar-times','#dd4b39','agent',1,1,1,'overdue_tickets',4),(18,'Unassigned Tickets ',0,1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,NULL,1,'fas fa-user-times','#f39c12','agent',1,1,1,'unassigned_tickets',3),(19,'Unanswered Tickets',0,1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,NULL,1,'fas fa-reply','#00c0ef','agent',1,1,1,'unanswered_tickets',5),(20,'my_tickets',0,NULL,NULL,'2025-01-03 04:07:31',NULL,NULL,1,'fas fa-inbox','#007bff','system',1,1,1,'my_tickets',2),(21,'my_pending_approvals',0,NULL,NULL,'2025-01-03 04:07:31',NULL,NULL,1,'far fa-clock','#00c0ef','system',1,1,1,'my_pending_approvals',7),(22,'my_due_today_tickets',0,NULL,NULL,'2025-01-03 04:07:31',NULL,NULL,1,'far fa-calendar-times','#f39c12','system',1,0,1,'my_due_today_tickets',1),(23,'unapproved_tickets',0,NULL,NULL,'2025-01-03 04:07:31',NULL,NULL,0,'fas fa-clock','#00c0ef','system',1,1,1,'unapproved_tickets',6),(24,'closed_tickets',0,NULL,NULL,'2025-01-03 04:07:31',NULL,NULL,0,'fas fa-minus-circle','#00c0ef','system',1,1,1,'closed_tickets',8),(25,'spam',0,NULL,NULL,'2025-01-03 04:07:31',NULL,NULL,0,'fas fa-exclamation-triangle','#00c0ef','system',1,1,1,'spam',9),(26,'trash',0,NULL,NULL,'2025-01-03 04:07:31',NULL,NULL,0,'fas fa-trash','#00c0ef','system',1,1,1,'trash',10),(27,'My Tickets',0,1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,NULL,1,'fas fa-inbox','#007bff','agent',1,1,1,'my_tickets',2),(28,'My Pending Approvals ',0,1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,NULL,1,'far fa-clock','#00c0ef','agent',1,1,1,'my_pending_approvals',7),(29,'My Due Today Tickets ',0,1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,NULL,1,'far fa-calendar-times','#f39c12','agent',1,0,1,'my_due_today_tickets',1),(30,'Unapproved Tickets',0,1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,NULL,0,'fas fa-clock','#00c0ef','agent',1,1,1,'unapproved_tickets',6),(31,'Closed Tickets',0,1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,NULL,0,'fas fa-minus-circle','#00c0ef','agent',1,1,1,'closed_tickets',8),(32,'Spam',0,1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,NULL,0,'fas fa-exclamation-triangle','#00c0ef','agent',1,1,1,'spam',9),(33,'Trash',0,1,'2025-01-03 04:07:31','2025-01-03 04:07:31',NULL,NULL,0,'fas fa-trash','#00c0ef','agent',1,1,1,'trash',10);
/*!40000 ALTER TABLE `ticket_filters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_form_data`
--

DROP TABLE IF EXISTS `ticket_form_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_form_data` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(10) unsigned DEFAULT NULL,
  `title` text NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `key` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ticket_id` (`ticket_id`),
  CONSTRAINT `ticket_form_data_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_form_data`
--

LOCK TABLES `ticket_form_data` WRITE;
/*!40000 ALTER TABLE `ticket_form_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_form_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_listeners`
--

DROP TABLE IF EXISTS `ticket_listeners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_listeners` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `triggered_by` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `order` int(11) NOT NULL,
  `matcher` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `internal_notes` varchar(255) NOT NULL,
  `target` varchar(255) NOT NULL,
  `category_type` varchar(255) NOT NULL DEFAULT 'ticket',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_listeners`
--

LOCK TABLES `ticket_listeners` WRITE;
/*!40000 ALTER TABLE `ticket_listeners` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_listeners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_mentions`
--

DROP TABLE IF EXISTS `ticket_mentions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_mentions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) DEFAULT NULL,
  `mention_id` varchar(255) DEFAULT NULL,
  `mention_type` varchar(255) DEFAULT NULL,
  `channel_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_mentions`
--

LOCK TABLES `ticket_mentions` WRITE;
/*!40000 ALTER TABLE `ticket_mentions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_mentions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_pdf_templates`
--

DROP TABLE IF EXISTS `ticket_pdf_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_pdf_templates` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `template` text NOT NULL,
  `maximum_logs` bigint(20) NOT NULL DEFAULT 50,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_pdf_templates`
--

LOCK TABLES `ticket_pdf_templates` WRITE;
/*!40000 ALTER TABLE `ticket_pdf_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_pdf_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_priority`
--

DROP TABLE IF EXISTS `ticket_priority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_priority` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `priority_desc` varchar(255) NOT NULL,
  `priority_color` varchar(255) NOT NULL,
  `priority_urgency` tinyint(1) NOT NULL,
  `ispublic` tinyint(1) NOT NULL,
  `is_default` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `under_deletion` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_priority`
--

LOCK TABLES `ticket_priority` WRITE;
/*!40000 ALTER TABLE `ticket_priority` DISABLE KEYS */;
INSERT INTO `ticket_priority` VALUES (1,'Low',1,'Low','#00a65a',4,1,0,'2025-01-03 04:07:23','2025-01-03 04:07:23',0),(2,'Normal',1,'Normal','#00bfef',3,1,1,'2025-01-03 04:07:23','2025-01-03 04:07:23',0),(3,'High',1,'High','#f39c11',2,1,0,'2025-01-03 04:07:23','2025-01-03 04:07:23',0),(4,'Emergency',1,'Emergency','#dd4b38',1,1,0,'2025-01-03 04:07:23','2025-01-03 04:07:23',0);
/*!40000 ALTER TABLE `ticket_priority` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_reminders`
--

DROP TABLE IF EXISTS `ticket_reminders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_reminders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(10) unsigned DEFAULT NULL,
  `reminders_count` int(11) NOT NULL DEFAULT 0,
  `reminder_sent_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ticket_reminders_ticket_id_foreign` (`ticket_id`),
  CONSTRAINT `ticket_reminders_ticket_id_foreign` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_reminders`
--

LOCK TABLES `ticket_reminders` WRITE;
/*!40000 ALTER TABLE `ticket_reminders` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_reminders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_rules`
--

DROP TABLE IF EXISTS `ticket_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_rules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reference_id` int(10) unsigned DEFAULT NULL,
  `reference_type` varchar(255) DEFAULT NULL,
  `field` varchar(255) NOT NULL,
  `relation` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `base_rule` tinyint(1) NOT NULL DEFAULT 0,
  `category` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_rules`
--

LOCK TABLES `ticket_rules` WRITE;
/*!40000 ALTER TABLE `ticket_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_sla_approach_escalate`
--

DROP TABLE IF EXISTS `ticket_sla_approach_escalate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_sla_approach_escalate` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) NOT NULL,
  `sla_approach_escalate_id` int(11) NOT NULL,
  `trigger_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_sla_approach_escalate`
--

LOCK TABLES `ticket_sla_approach_escalate` WRITE;
/*!40000 ALTER TABLE `ticket_sla_approach_escalate` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_sla_approach_escalate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_sla_metas`
--

DROP TABLE IF EXISTS `ticket_sla_metas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_sla_metas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_sla_id` int(11) NOT NULL,
  `priority_id` int(11) NOT NULL,
  `respond_within` varchar(255) NOT NULL,
  `resolve_within` varchar(255) NOT NULL,
  `business_hour_id` int(11) NOT NULL,
  `send_email_notification` tinyint(1) NOT NULL DEFAULT 1,
  `send_app_notification` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_sla_metas`
--

LOCK TABLES `ticket_sla_metas` WRITE;
/*!40000 ALTER TABLE `ticket_sla_metas` DISABLE KEYS */;
INSERT INTO `ticket_sla_metas` VALUES (1,1,1,'diff::5~hour','diff::10~hour',1,1,1),(2,1,2,'diff::4~hour','diff::9~hour',1,1,1),(3,1,3,'diff::2~hour','diff::4~hour',1,1,1),(4,1,4,'diff::1~hour','diff::2~hour',1,1,1);
/*!40000 ALTER TABLE `ticket_sla_metas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_sla_violated_escalate`
--

DROP TABLE IF EXISTS `ticket_sla_violated_escalate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_sla_violated_escalate` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) NOT NULL,
  `sla_violated_escalate_id` int(11) NOT NULL,
  `trigger_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_sla_violated_escalate`
--

LOCK TABLES `ticket_sla_violated_escalate` WRITE;
/*!40000 ALTER TABLE `ticket_sla_violated_escalate` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_sla_violated_escalate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_slas`
--

DROP TABLE IF EXISTS `ticket_slas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_slas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `order` int(11) NOT NULL,
  `matcher` varchar(255) NOT NULL,
  `is_default` tinyint(1) NOT NULL,
  `internal_notes` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `category_type` varchar(255) NOT NULL DEFAULT 'ticket',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_slas`
--

LOCK TABLES `ticket_slas` WRITE;
/*!40000 ALTER TABLE `ticket_slas` DISABLE KEYS */;
INSERT INTO `ticket_slas` VALUES (1,'Default',1,1,'',1,NULL,'2025-01-03 04:07:24','2025-01-03 04:07:24','ticket');
/*!40000 ALTER TABLE `ticket_slas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_source`
--

DROP TABLE IF EXISTS `ticket_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_source` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `css_class` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `location` varchar(255) NOT NULL,
  `is_default` int(11) NOT NULL DEFAULT 0,
  `under_deletion` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_source`
--

LOCK TABLES `ticket_source` WRITE;
/*!40000 ALTER TABLE `ticket_source` DISABLE KEYS */;
INSERT INTO `ticket_source` VALUES (1,'Web','Web','fas fa-globe',NULL,'',1,0),(2,'Email','E-mail','fas fa-envelope',NULL,'',1,0),(3,'Agent','Agent Panel','fas fa-user',NULL,'',1,0),(4,'Facebook','Facebook','fab fa-facebook',NULL,'',1,0),(5,'Twitter','Twitter','fab fa-twitter',NULL,'',1,0),(6,'Call','Call','fas fa-phone',NULL,'',1,0),(7,'Chat','Chat','fas fa-comment-dots',NULL,'',1,0),(8,'Widget','Widget','fas fa-comment-dots',NULL,'',1,0),(9,'Instagram','Instagram','fa-brands fa-instagram',NULL,'',1,0),(10,'Intercom','Intercom','fa-brands fa-intercom',NULL,'',1,0);
/*!40000 ALTER TABLE `ticket_source` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_status`
--

DROP TABLE IF EXISTS `ticket_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `message` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `visibility_for_client` tinyint(1) NOT NULL,
  `allow_client` tinyint(1) NOT NULL,
  `visibility_for_agent` tinyint(1) NOT NULL,
  `purpose_of_status` int(11) NOT NULL,
  `secondary_status` int(11) DEFAULT NULL,
  `send_email` varchar(255) DEFAULT NULL,
  `halt_sla` int(11) NOT NULL,
  `order` int(11) NOT NULL,
  `icon` varchar(255) NOT NULL,
  `icon_color` varchar(255) NOT NULL,
  `default` int(11) DEFAULT NULL,
  `send_sms` tinyint(1) NOT NULL DEFAULT 0,
  `auto_close` int(10) unsigned DEFAULT NULL,
  `comment` int(11) NOT NULL DEFAULT 0,
  `under_deletion` tinyint(1) NOT NULL DEFAULT 0,
  `rating_auto_request` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `ticket_status_auto_close_foreign` (`auto_close`),
  CONSTRAINT `ticket_status_auto_close_foreign` FOREIGN KEY (`auto_close`) REFERENCES `workflow_close` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_status`
--

LOCK TABLES `ticket_status` WRITE;
/*!40000 ALTER TABLE `ticket_status` DISABLE KEYS */;
INSERT INTO `ticket_status` VALUES (1,'Open','Ticket has been Reopened by {!!$user!!}','2025-01-03 04:07:23','2025-01-03 04:07:30',1,1,1,1,NULL,'{\"client\":\"1\",\"admin\":\"0\",\"assigned_agent_team\":\"1\"}',0,1,'fas fa-clock','#32c777',1,0,1,0,0,0),(3,'Closed','Ticket has been Closed by {!!$user!!}','2025-01-03 04:07:23','2025-01-03 04:07:31',1,1,1,2,NULL,'{\"client\":\"1\",\"admin\":\"0\",\"assigned_agent_team\":\"1\"}',1,3,'fas fa-minus-circle','#5cb85c',1,0,NULL,0,0,0),(4,'Deleted','Ticket has been Deleted by {!!$user!!}','2025-01-03 04:07:23','2025-01-03 04:07:31',1,1,1,4,NULL,'{\"client\":\"0\",\"admin\":\"0\",\"assigned_agent_team\":\"0\"}',1,4,'fas fa-trash','#f20630',1,0,NULL,0,0,0),(6,'Spam','Ticket has been marked as Spam by {!!$user!!}','2025-01-03 04:07:23','2025-01-03 04:07:31',0,0,1,6,NULL,'{\"client\":\"0\",\"admin\":\"0\",\"assigned_agent_team\":\"0\"}',1,6,'fas fa-exclamation-triangle','#f0ad4e',1,0,NULL,0,0,0),(7,'Unapproved','Ticket has been marked as Unapproved by {!!$user!!}','2025-01-03 04:07:23','2025-01-03 04:07:30',0,0,1,7,1,'{\"client\":\"0\",\"admin\":\"1\",\"assigned_agent_team\":\"0\"}',1,7,'fas fa-clock','#f20630',1,0,NULL,0,0,0),(8,'Merged','Ticket have been marked as Merged by {!!$user!!}','2025-01-03 04:07:24','2025-01-03 04:07:30',0,0,1,8,NULL,'{\"client\":\"0\",\"admin\":\"1\",\"assigned_agent_team\":\"0\"}',1,8,'fas fa-clock','#f20630',1,0,NULL,0,0,0);
/*!40000 ALTER TABLE `ticket_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_status_override`
--

DROP TABLE IF EXISTS `ticket_status_override`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_status_override` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `current_status` int(11) NOT NULL,
  `target_status` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_status_override`
--

LOCK TABLES `ticket_status_override` WRITE;
/*!40000 ALTER TABLE `ticket_status_override` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_status_override` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_status_type`
--

DROP TABLE IF EXISTS `ticket_status_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_status_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_status_type`
--

LOCK TABLES `ticket_status_type` WRITE;
/*!40000 ALTER TABLE `ticket_status_type` DISABLE KEYS */;
INSERT INTO `ticket_status_type` VALUES (1,'open','2025-01-03 04:07:23','2025-01-03 04:07:23'),(2,'closed','2025-01-03 04:07:23','2025-01-03 04:07:23'),(3,'archieved','2025-01-03 04:07:23','2025-01-03 04:07:23'),(4,'deleted','2025-01-03 04:07:23','2025-01-03 04:07:23'),(6,'spam','2025-01-03 04:07:23','2025-01-03 04:07:23'),(7,'unapproved','2025-01-03 04:07:23','2025-01-03 04:07:23'),(8,'merged','2025-01-03 04:07:24','2025-01-03 04:07:24');
/*!40000 ALTER TABLE `ticket_status_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_templates`
--

DROP TABLE IF EXISTS `ticket_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_templates` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `recur_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_templates`
--

LOCK TABLES `ticket_templates` WRITE;
/*!40000 ALTER TABLE `ticket_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_thread`
--

DROP TABLE IF EXISTS `ticket_thread`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_thread` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `thread_type` varchar(255) DEFAULT NULL,
  `poster` varchar(255) NOT NULL,
  `source` int(10) unsigned DEFAULT NULL,
  `reply_rating` int(11) NOT NULL,
  `rating_count` int(11) NOT NULL,
  `is_internal` tinyint(1) NOT NULL,
  `title` longblob DEFAULT NULL,
  `body` longblob DEFAULT NULL,
  `format` varchar(255) NOT NULL,
  `ip_address` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `response_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ticket_id_2` (`ticket_id`),
  KEY `user_id` (`user_id`),
  KEY `source` (`source`),
  KEY `ticket_thread_thread_type_index` (`thread_type`),
  KEY `body` (`body`(768)),
  KEY `is_internal` (`is_internal`),
  KEY `title` (`title`(255)),
  CONSTRAINT `ticket_thread_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `ticket_thread_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `ticket_thread_ibfk_3` FOREIGN KEY (`source`) REFERENCES `ticket_source` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_thread`
--

LOCK TABLES `ticket_thread` WRITE;
/*!40000 ALTER TABLE `ticket_thread` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_thread` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_token`
--

DROP TABLE IF EXISTS `ticket_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_token` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_token`
--

LOCK TABLES `ticket_token` WRITE;
/*!40000 ALTER TABLE `ticket_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_triggers`
--

DROP TABLE IF EXISTS `ticket_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_triggers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `target` varchar(255) NOT NULL,
  `order` int(11) NOT NULL,
  `matcher` varchar(255) NOT NULL,
  `internal_notes` text NOT NULL,
  `category_type` varchar(255) NOT NULL DEFAULT 'ticket',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_triggers`
--

LOCK TABLES `ticket_triggers` WRITE;
/*!40000 ALTER TABLE `ticket_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_type`
--

DROP TABLE IF EXISTS `ticket_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `type_desc` varchar(255) NOT NULL,
  `ispublic` int(11) NOT NULL,
  `is_default` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `under_deletion` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_type`
--

LOCK TABLES `ticket_type` WRITE;
/*!40000 ALTER TABLE `ticket_type` DISABLE KEYS */;
INSERT INTO `ticket_type` VALUES (1,'Question',1,'Question',1,0,'2025-01-03 04:07:23','2025-01-03 04:07:23',0),(2,'Incident',1,'Incident',0,0,'2025-01-03 04:07:23','2025-01-03 04:07:28',0),(3,'Problem',1,'Problem',0,0,'2025-01-03 04:07:23','2025-01-03 04:07:28',0),(4,'Feature Request',1,'Feature Request',0,0,'2025-01-03 04:07:23','2025-01-03 04:07:28',0);
/*!40000 ALTER TABLE `ticket_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_workflows`
--

DROP TABLE IF EXISTS `ticket_workflows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_workflows` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `order` int(11) NOT NULL,
  `matcher` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `internal_notes` text NOT NULL,
  `target` varchar(255) NOT NULL,
  `category_type` varchar(255) NOT NULL DEFAULT 'ticket',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_workflows`
--

LOCK TABLES `ticket_workflows` WRITE;
/*!40000 ALTER TABLE `ticket_workflows` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_workflows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_number` varchar(255) NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `dept_id` int(10) unsigned DEFAULT NULL,
  `team_id` int(10) unsigned DEFAULT NULL,
  `priority_id` int(10) unsigned DEFAULT NULL,
  `sla` int(10) unsigned DEFAULT NULL,
  `help_topic_id` int(10) unsigned DEFAULT NULL,
  `status` int(10) unsigned DEFAULT NULL,
  `rating` tinyint(1) NOT NULL,
  `ratingreply` tinyint(1) NOT NULL,
  `flags` int(11) NOT NULL,
  `ip_address` int(11) NOT NULL,
  `assigned_to` int(10) unsigned DEFAULT NULL,
  `lock_by` int(11) NOT NULL,
  `lock_at` datetime DEFAULT NULL,
  `source` int(10) unsigned DEFAULT NULL,
  `isoverdue` int(11) NOT NULL,
  `reopened` int(11) NOT NULL,
  `isanswered` int(11) NOT NULL,
  `html` int(11) NOT NULL,
  `is_deleted` int(11) NOT NULL,
  `closed` int(11) NOT NULL,
  `is_transferred` tinyint(1) NOT NULL,
  `transferred_at` datetime NOT NULL,
  `reopened_at` datetime DEFAULT NULL,
  `duedate` datetime DEFAULT NULL,
  `closed_at` datetime DEFAULT NULL,
  `last_message_at` datetime DEFAULT NULL,
  `first_response_time` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `resolution_time` int(11) DEFAULT NULL,
  `is_response_sla` tinyint(1) DEFAULT NULL,
  `is_resolution_sla` tinyint(1) DEFAULT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `last_estd_duedate` timestamp NULL DEFAULT NULL,
  `location_id` int(10) unsigned DEFAULT NULL,
  `creator_id` int(10) unsigned DEFAULT NULL,
  `response_due_by` timestamp NULL DEFAULT NULL,
  `is_manual_duedate` tinyint(1) NOT NULL DEFAULT 0,
  `average_response_time` int(11) DEFAULT NULL,
  `resolution_due_by` timestamp NULL DEFAULT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `parent_ticket_id` varchar(255) DEFAULT NULL,
  `category_id` int(10) unsigned DEFAULT NULL,
  `form_category_id` bigint(20) unsigned DEFAULT NULL,
  `status_changed_at` timestamp NULL DEFAULT NULL,
  `assigned_at` timestamp NULL DEFAULT NULL,
  `trigger_count` int(11) NOT NULL DEFAULT 0,
  `is_migrated` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `dept_id` (`dept_id`),
  KEY `team_id` (`team_id`),
  KEY `priority_id` (`priority_id`),
  KEY `sla` (`sla`),
  KEY `help_topic_id` (`help_topic_id`),
  KEY `status` (`status`),
  KEY `assigned_to` (`assigned_to`),
  KEY `source` (`source`),
  KEY `ticket_type` (`type`),
  KEY `tickets_duedate_index` (`duedate`),
  KEY `tickets_ticket_number_index` (`ticket_number`),
  KEY `tickets_form_category_id_foreign` (`form_category_id`),
  FULLTEXT KEY `tickets_ticket_number_fulltext` (`ticket_number`),
  CONSTRAINT `tickets_form_category_id_foreign` FOREIGN KEY (`form_category_id`) REFERENCES `new_form_categories` (`id`),
  CONSTRAINT `tickets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `tickets_ibfk_2` FOREIGN KEY (`dept_id`) REFERENCES `department` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `tickets_ibfk_3` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `tickets_ibfk_4` FOREIGN KEY (`priority_id`) REFERENCES `ticket_priority` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `tickets_ibfk_6` FOREIGN KEY (`help_topic_id`) REFERENCES `help_topic` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `tickets_ibfk_8` FOREIGN KEY (`source`) REFERENCES `ticket_source` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `tickets_ibfk_9` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `tickets_status_foreign` FOREIGN KEY (`status`) REFERENCES `ticket_status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_format`
--

DROP TABLE IF EXISTS `time_format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `time_format` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `format` varchar(255) NOT NULL,
  `hours` varchar(14) NOT NULL,
  `js_format` varchar(14) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_format`
--

LOCK TABLES `time_format` WRITE;
/*!40000 ALTER TABLE `time_format` DISABLE KEYS */;
INSERT INTO `time_format` VALUES (1,'H:i:s','24 Hours','HH:mm',1),(2,'H.i.s','','',0),(3,'g:i a','12 Hours','hh:mm a',1);
/*!40000 ALTER TABLE `time_format` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timezone`
--

DROP TABLE IF EXISTS `timezone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `timezone` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timezone`
--

LOCK TABLES `timezone` WRITE;
/*!40000 ALTER TABLE `timezone` DISABLE KEYS */;
INSERT INTO `timezone` VALUES (1,'Pacific/Midway','(GMT-11:00) Midway Island'),(2,'US/Samoa','(GMT-11:00) Samoa'),(3,'US/Hawaii','(GMT-10:00) Hawaii'),(4,'US/Alaska','(GMT-09:00) Alaska'),(5,'US/Pacific','(GMT-08:00) Pacific Time (US &amp; Canada)'),(6,'America/Tijuana','(GMT-08:00) Tijuana'),(7,'US/Arizona','(GMT-07:00) Arizona'),(8,'US/Mountain','(GMT-07:00) Mountain Time (US &amp; Canada)'),(9,'America/Chihuahua','(GMT-07:00) Chihuahua'),(10,'America/Mazatlan','(GMT-07:00) Mazatlan'),(11,'America/Mexico_City','(GMT-06:00) Mexico City'),(12,'America/Monterrey','(GMT-06:00) Monterrey'),(13,'America/Santo_Domingo','(GMT-04:00) Santo_Domingo'),(14,'Canada/Saskatchewan','(GMT-06:00) Saskatchewan'),(15,'US/Central','(GMT-06:00) Central Time (US &amp; Canada)'),(16,'US/Eastern','(GMT-05:00) Eastern Time (US &amp; Canada)'),(17,'US/East-Indiana','(GMT-05:00) Indiana (East)'),(18,'America/Bogota','(GMT-05:00) Bogota'),(19,'America/Lima','(GMT-05:00) Lima'),(20,'America/Caracas','(GMT-04:30) Caracas'),(21,'Canada/Atlantic','(GMT-04:00) Atlantic Time (Canada)'),(22,'America/La_Paz','(GMT-04:00) La Paz'),(23,'America/Santiago','(GMT-04:00) Santiago'),(24,'Canada/Newfoundland','(GMT-03:30) Newfoundland'),(25,'America/Buenos_Aires','(GMT-03:00) Buenos Aires'),(26,'America/Godthab','(GMT-03:00) Greenland'),(27,'Atlantic/Stanley','(GMT-02:00) Stanley'),(28,'Atlantic/Azores','(GMT-01:00) Azores'),(29,'Atlantic/Cape_Verde','(GMT-01:00) Cape Verde Is.'),(30,'Africa/Casablanca','(GMT) Casablanca'),(31,'Europe/Dublin','(GMT) Dublin'),(32,'Europe/Lisbon','(GMT) Lisbon'),(33,'Europe/London','(GMT) London'),(34,'Africa/Monrovia','(GMT) Monrovia'),(35,'Europe/Amsterdam','(GMT+01:00) Amsterdam'),(36,'Europe/Belgrade','(GMT+01:00) Belgrade'),(37,'Europe/Berlin','(GMT+01:00) Berlin'),(38,'Europe/Bratislava','(GMT+01:00) Bratislava'),(39,'Europe/Brussels','(GMT+01:00) Brussels'),(40,'Europe/Budapest','(GMT+01:00) Budapest'),(41,'Europe/Copenhagen','(GMT+01:00) Copenhagen'),(42,'Europe/Ljubljana','(GMT+01:00) Ljubljana'),(43,'Europe/Madrid','(GMT+01:00) Madrid'),(44,'Europe/Paris','(GMT+01:00) Paris'),(45,'Europe/Prague','(GMT+01:00) Prague'),(46,'Europe/Rome','(GMT+01:00) Rome'),(47,'Europe/Sarajevo','(GMT+01:00) Sarajevo'),(48,'Europe/Skopje','(GMT+01:00) Skopje'),(49,'Europe/Stockholm','(GMT+01:00) Stockholm'),(50,'Europe/Vienna','(GMT+01:00) Vienna'),(51,'Europe/Warsaw','(GMT+01:00) Warsaw'),(52,'Europe/Zagreb','(GMT+01:00) Zagreb'),(53,'Europe/Athens','(GMT+02:00) Athens'),(54,'Europe/Bucharest','(GMT+02:00) Bucharest'),(55,'Africa/Cairo','(GMT+02:00) Cairo'),(56,'Africa/Harare','(GMT+02:00) Harare'),(57,'Europe/Helsinki','(GMT+02:00) Helsinki'),(58,'Europe/Istanbul','(GMT+02:00) Istanbul'),(59,'Asia/Jerusalem','(GMT+02:00) Jerusalem'),(60,'Europe/Kiev','(GMT+02:00) Kyiv'),(61,'Europe/Minsk','(GMT+02:00) Minsk'),(62,'Europe/Riga','(GMT+02:00) Riga'),(63,'Europe/Sofia','(GMT+02:00) Sofia'),(64,'Europe/Tallinn','(GMT+02:00) Tallinn'),(65,'Europe/Vilnius','(GMT+02:00) Vilnius'),(66,'Asia/Baghdad','(GMT+03:00) Baghdad'),(67,'Asia/Kuwait','(GMT+03:00) Kuwait'),(68,'Africa/Nairobi','(GMT+03:00) Nairobi'),(69,'Asia/Riyadh','(GMT+03:00) Riyadh'),(70,'Asia/Tehran','(GMT+03:30) Tehran'),(71,'Europe/Moscow','(GMT+04:00) Moscow'),(72,'Asia/Baku','(GMT+04:00) Baku'),(73,'Europe/Volgograd','(GMT+04:00) Volgograd'),(74,'Asia/Muscat','(GMT+04:00) Muscat'),(75,'Asia/Dubai','(GMT+04:00) Dubai'),(76,'Asia/Tbilisi','(GMT+04:00) Tbilisi'),(77,'Asia/Yerevan','(GMT+04:00) Yerevan'),(78,'Asia/Kabul','(GMT+04:30) Kabul'),(79,'Asia/Karachi','(GMT+05:00) Karachi'),(80,'Asia/Tashkent','(GMT+05:00) Tashkent'),(81,'Asia/Kolkata','(GMT+05:30) Kolkata'),(82,'Asia/Kathmandu','(GMT+05:45) Kathmandu'),(83,'Asia/Yekaterinburg','(GMT+06:00) Ekaterinburg'),(84,'Asia/Almaty','(GMT+06:00) Almaty'),(85,'Asia/Dhaka','(GMT+06:00) Dhaka'),(86,'Asia/Novosibirsk','(GMT+07:00) Novosibirsk'),(87,'Asia/Bangkok','(GMT+07:00) Bangkok'),(88,'Asia/Ho_Chi_Minh','(GMT+07.00) Ho Chi Minh'),(89,'Asia/Jakarta','(GMT+07:00) Jakarta'),(90,'Asia/Krasnoyarsk','(GMT+08:00) Krasnoyarsk'),(91,'Asia/Chongqing','(GMT+08:00) Chongqing'),(92,'Asia/Hong_Kong','(GMT+08:00) Hong Kong'),(93,'Asia/Kuala_Lumpur','(GMT+08:00) Kuala Lumpur'),(94,'Australia/Perth','(GMT+08:00) Perth'),(95,'Asia/Singapore','(GMT+08:00) Singapore'),(96,'Asia/Taipei','(GMT+08:00) Taipei'),(97,'Asia/Ulaanbaatar','(GMT+08:00) Ulaan Bataar'),(98,'Asia/Urumqi','(GMT+08:00) Urumqi'),(99,'Asia/Irkutsk','(GMT+09:00) Irkutsk'),(100,'Asia/Seoul','(GMT+09:00) Seoul'),(101,'Asia/Tokyo','(GMT+09:00) Tokyo'),(102,'Australia/Adelaide','(GMT+09:30) Adelaide'),(103,'Australia/Darwin','(GMT+09:30) Darwin'),(104,'Asia/Yakutsk','(GMT+10:00) Yakutsk'),(105,'Australia/Brisbane','(GMT+10:00) Brisbane'),(106,'Australia/Canberra','(GMT+10:00) Canberra'),(107,'Pacific/Guam','(GMT+10:00) Guam'),(108,'Australia/Hobart','(GMT+10:00) Hobart'),(109,'Australia/Melbourne','(GMT+10:00) Melbourne'),(110,'Pacific/Port_Moresby','(GMT+10:00) Port Moresby'),(111,'Australia/Sydney','(GMT+10:00) Sydney'),(112,'Asia/Vladivostok','(GMT+11:00) Vladivostok'),(113,'Asia/Magadan','(GMT+12:00) Magadan'),(114,'Pacific/Auckland','(GMT+12:00) Auckland'),(115,'Pacific/Fiji','(GMT+12:00) Fiji'),(116,'UTC','(GMT+00:00) UTC'),(117,'Asia/Manila','(GMT+08:00) Manila');
/*!40000 ALTER TABLE `timezone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transactions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `transactionId` varchar(50) NOT NULL,
  `invoice_id` int(10) unsigned NOT NULL,
  `payment_method` varchar(30) NOT NULL,
  `amount_paid` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `comment` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transactions_transactionid_unique` (`transactionId`),
  KEY `transactions_invoice_id_foreign` (`invoice_id`),
  KEY `transactions_user_id_foreign` (`user_id`),
  CONSTRAINT `transactions_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`),
  CONSTRAINT `transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_additional_infos`
--

DROP TABLE IF EXISTS `user_additional_infos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_additional_infos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `owner` int(11) NOT NULL,
  `service` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_additional_infos`
--

LOCK TABLES `user_additional_infos` WRITE;
/*!40000 ALTER TABLE `user_additional_infos` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_additional_infos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_assign_labels`
--

DROP TABLE IF EXISTS `user_assign_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_assign_labels` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `label_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_assign_labels`
--

LOCK TABLES `user_assign_labels` WRITE;
/*!40000 ALTER TABLE `user_assign_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_assign_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_assign_organization`
--

DROP TABLE IF EXISTS `user_assign_organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_assign_organization` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `org_id` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'members',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `org_department` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `org_id` (`org_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_assign_organization_ibfk_1` FOREIGN KEY (`org_id`) REFERENCES `organization` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `user_assign_organization_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_assign_organization`
--

LOCK TABLES `user_assign_organization` WRITE;
/*!40000 ALTER TABLE `user_assign_organization` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_assign_organization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_backup_codes`
--

DROP TABLE IF EXISTS `user_backup_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_backup_codes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `backup_codes` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_backup_codes_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_backup_codes`
--

LOCK TABLES `user_backup_codes` WRITE;
/*!40000 ALTER TABLE `user_backup_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_backup_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_columns`
--

DROP TABLE IF EXISTS `user_columns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_columns` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `report_column_id` bigint(20) unsigned NOT NULL,
  `order` int(10) unsigned NOT NULL DEFAULT 0,
  `sub_report_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_columns_user_id_foreign` (`user_id`),
  KEY `user_columns_report_column_id_foreign` (`report_column_id`),
  CONSTRAINT `user_columns_report_column_id_foreign` FOREIGN KEY (`report_column_id`) REFERENCES `report_columns` (`id`),
  CONSTRAINT `user_columns_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_columns`
--

LOCK TABLES `user_columns` WRITE;
/*!40000 ALTER TABLE `user_columns` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_columns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_import_maps`
--

DROP TABLE IF EXISTS `user_import_maps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_import_maps` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `faveo_attribute` varchar(255) NOT NULL,
  `third_party_attribute` varchar(255) NOT NULL,
  `source_id` int(11) DEFAULT NULL,
  `source_type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_import_maps`
--

LOCK TABLES `user_import_maps` WRITE;
/*!40000 ALTER TABLE `user_import_maps` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_import_maps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_notification_tokens`
--

DROP TABLE IF EXISTS `user_notification_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_notification_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `token` varchar(255) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_notification_tokens_user_id_foreign` (`user_id`),
  CONSTRAINT `user_notification_tokens_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_notification_tokens`
--

LOCK TABLES `user_notification_tokens` WRITE;
/*!40000 ALTER TABLE `user_notification_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_notification_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_order_tickets`
--

DROP TABLE IF EXISTS `user_order_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_order_tickets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `order_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_order_tickets_ticket_id_foreign` (`ticket_id`),
  KEY `user_order_tickets_user_id_foreign` (`user_id`),
  KEY `user_order_tickets_order_id_foreign` (`order_id`),
  CONSTRAINT `user_order_tickets_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `user_order_tickets_ticket_id_foreign` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`),
  CONSTRAINT `user_order_tickets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_order_tickets`
--

LOCK TABLES `user_order_tickets` WRITE;
/*!40000 ALTER TABLE `user_order_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_order_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_permission`
--

DROP TABLE IF EXISTS `user_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_permission` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `permission_id` bigint(20) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_permission`
--

LOCK TABLES `user_permission` WRITE;
/*!40000 ALTER TABLE `user_permission` DISABLE KEYS */;
INSERT INTO `user_permission` VALUES (1,0,1,NULL,NULL),(2,14,1,NULL,NULL);
/*!40000 ALTER TABLE `user_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_permissions`
--

DROP TABLE IF EXISTS `user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_permissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(40) NOT NULL,
  `name` varchar(70) NOT NULL,
  `type` varchar(33) NOT NULL DEFAULT 'helpdesk',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `role` varchar(9) NOT NULL DEFAULT 'agent',
  PRIMARY KEY (`id`),
  KEY `user_permissions_key_index` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_permissions`
--

LOCK TABLES `user_permissions` WRITE;
/*!40000 ALTER TABLE `user_permissions` DISABLE KEYS */;
INSERT INTO `user_permissions` VALUES (1,'create_ticket','Create ticket','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(2,'edit_ticket','Edit ticket','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(3,'close_ticket','Close tickets','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(4,'transfer_ticket','Transfer Ticket','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(5,'delete_ticket','Delete tickets','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(6,'assign_ticket','Tickets Assigned','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(7,'view_unapproved_tickets','View unapproved tickets','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(8,'apply_approval_workflow','Apply Approval Workflow','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(9,'access_kb','Access knowledge base','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(10,'report','Access reports','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(12,'change_duedate','Change duedate','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(13,'re_assigning_tickets','Re assigning tickets','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(14,'global_access','Global access','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(15,'restricted_access','Restricted access (view only tickets assigned to them)','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(16,'access_user_profile','Access user profile','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(17,'access_organization_profile','Access organization profile','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(18,'recur_ticket','Recur Ticket','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(19,'user_activation_deactivaton','Activate or Deactivate user account','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(20,'agent_activation_deactivaton','Activate or Deactivate agent account','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(21,'delete_user_account','Delete user account','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(22,'delete_agent_account','Delete user account','helpdesk','2025-01-03 04:07:25','2025-01-03 04:07:25','agent'),(23,'view_all_tickets','View All Tickets','helpdesk','2025-01-03 04:07:28','2025-01-03 04:07:28','agent'),(24,'edit_articles_created_by_others','Edit articles created by others','helpdesk','2025-01-03 04:07:30','2025-01-03 04:07:30','agent'),(25,'reopen_ticket','Reopen Tickets','helpdesk','2025-01-03 04:07:30','2025-01-03 04:07:30','agent'),(26,'redaction','Redaction','redaction','2025-01-03 04:07:31','2025-01-03 04:07:31','agent'),(27,'delete_tickets_reply','Delete tickets reply','helpdesk','2025-01-03 04:07:31','2025-01-03 04:07:31','agent'),(28,'delete_tickets_internal_note','Delete tickets internal note','helpdesk','2025-01-03 04:07:31','2025-01-03 04:07:31','agent'),(29,'edit_tickets_internal_note','Edit Tickets Internal Note','helpdesk','2025-01-03 04:07:31','2025-01-03 04:07:31','agent'),(30,'allow_to_edit_others_internal_notes','Allow to edit others internal note\'s on tickets','helpdesk','2025-01-03 04:07:31','2025-01-03 04:07:31','agent');
/*!40000 ALTER TABLE `user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_sub_modules`
--

DROP TABLE IF EXISTS `user_sub_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_sub_modules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `sub_module_id` bigint(20) unsigned NOT NULL,
  `cache` int(11) NOT NULL DEFAULT 10,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_sub_modules_user_id_foreign` (`user_id`),
  KEY `user_sub_modules_sub_module_id_foreign` (`sub_module_id`),
  CONSTRAINT `user_sub_modules_sub_module_id_foreign` FOREIGN KEY (`sub_module_id`) REFERENCES `sub_modules` (`id`),
  CONSTRAINT `user_sub_modules_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_sub_modules`
--

LOCK TABLES `user_sub_modules` WRITE;
/*!40000 ALTER TABLE `user_sub_modules` DISABLE KEYS */;
INSERT INTO `user_sub_modules` VALUES (1,1,1,10,NULL,NULL),(2,1,2,10,NULL,NULL),(3,1,3,10,NULL,NULL);
/*!40000 ALTER TABLE `user_sub_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_todos`
--

DROP TABLE IF EXISTS `user_todos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_todos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `name` text NOT NULL,
  `order` int(11) NOT NULL DEFAULT 0,
  `status` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_todos`
--

LOCK TABLES `user_todos` WRITE;
/*!40000 ALTER TABLE `user_todos` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_todos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_types`
--

DROP TABLE IF EXISTS `user_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `key` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_types`
--

LOCK TABLES `user_types` WRITE;
/*!40000 ALTER TABLE `user_types` DISABLE KEYS */;
INSERT INTO `user_types` VALUES (1,'User','user'),(2,'Agent','agent'),(3,'Admin','admin'),(4,'Department Manager','department_manager'),(5,'Team Lead','team_lead'),(6,'Organization Manager','organization_manager'),(7,'Organization Department Manager','organization_department_manager'),(8,'Assignee','assignee');
/*!40000 ALTER TABLE `user_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(60) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `is_delete` tinyint(1) NOT NULL DEFAULT 0,
  `ext` varchar(255) DEFAULT NULL,
  `country_code` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `agent_sign` text NOT NULL,
  `account_type` varchar(255) NOT NULL,
  `account_status` varchar(255) NOT NULL,
  `assign_group` int(10) unsigned DEFAULT NULL,
  `primary_dpt` int(10) unsigned DEFAULT NULL,
  `agent_tzone` varchar(255) NOT NULL,
  `daylight_save` varchar(255) NOT NULL,
  `limit_access` varchar(255) NOT NULL,
  `directory_listing` varchar(255) NOT NULL,
  `vacation_mode` varchar(255) NOT NULL,
  `company` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL,
  `internal_note` varchar(255) DEFAULT NULL,
  `profile_pic` longtext DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `user_language` varchar(10) DEFAULT NULL,
  `mobile_verify` varchar(255) NOT NULL DEFAULT '1',
  `email_verify` varchar(255) NOT NULL DEFAULT '1',
  `location` int(11) DEFAULT NULL,
  `google2fa_secret` text DEFAULT NULL,
  `google2fa_activation_date` timestamp NULL DEFAULT NULL,
  `is_2fa_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `import_identifier` varchar(255) DEFAULT NULL,
  `delete_account_requested` tinyint(1) NOT NULL DEFAULT 0,
  `processing_account_disabling` tinyint(1) NOT NULL DEFAULT 0,
  `iso` varchar(4) DEFAULT NULL,
  `profile_pic_driver` varchar(255) DEFAULT NULL,
  `notify_unrecognized_login` tinyint(1) NOT NULL DEFAULT 0,
  `phone_country_code` varchar(7) DEFAULT NULL,
  `phone_iso` varchar(4) DEFAULT NULL,
  `deactivated_by` bigint(20) DEFAULT NULL,
  `created_by` bigint(20) DEFAULT NULL,
  `deactivated_at` timestamp NULL DEFAULT NULL,
  `logout_time` timestamp NULL DEFAULT NULL,
  `is_migrated` tinyint(4) NOT NULL DEFAULT 0,
  `mobile_ext` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_user_name_unique` (`user_name`),
  UNIQUE KEY `users_email_unique` (`email`),
  UNIQUE KEY `users_mobile_unique` (`mobile`),
  KEY `assign_group_3` (`assign_group`),
  KEY `primary_dpt_2` (`primary_dpt`),
  KEY `users_is_migrated_index` (`is_migrated`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`assign_group`) REFERENCES `groups` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`primary_dpt`) REFERENCES `department` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'demo_admin','Demo','Admin',NULL,'$2y$10$JUaYdbSGrPRHWo9C93arRus6QkHm7Y6J/3Mi590Z/bWOTSgS5OfZe',1,0,NULL,NULL,NULL,NULL,'','','',NULL,1,'81','','','','','','admin',NULL,NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23',NULL,'0','1',NULL,NULL,NULL,0,NULL,NULL,0,0,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `version_check`
--

DROP TABLE IF EXISTS `version_check`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `version_check` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `current_version` varchar(255) NOT NULL,
  `new_version` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `version_check`
--

LOCK TABLES `version_check` WRITE;
/*!40000 ALTER TABLE `version_check` DISABLE KEYS */;
INSERT INTO `version_check` VALUES (1,'','','2025-01-03 04:07:23','2025-01-03 04:07:23');
/*!40000 ALTER TABLE `version_check` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `versions`
--

DROP TABLE IF EXISTS `versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `versions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `versionable_type` varchar(255) NOT NULL,
  `versionable_id` bigint(20) unsigned NOT NULL,
  `contents` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`contents`)),
  `mod_contents` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`mod_contents`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `versions_user_id_foreign` (`user_id`),
  KEY `versions_versionable_type_versionable_id_index` (`versionable_type`,`versionable_id`),
  CONSTRAINT `versions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `versions`
--

LOCK TABLES `versions` WRITE;
/*!40000 ALTER TABLE `versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webhook_configs`
--

DROP TABLE IF EXISTS `webhook_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webhook_configs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `webhook_id` bigint(20) unsigned NOT NULL,
  `configable_id` bigint(20) unsigned NOT NULL,
  `configable_type` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `webhook_configs_webhook_id_foreign` (`webhook_id`),
  CONSTRAINT `webhook_configs_webhook_id_foreign` FOREIGN KEY (`webhook_id`) REFERENCES `webhooks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webhook_configs`
--

LOCK TABLES `webhook_configs` WRITE;
/*!40000 ALTER TABLE `webhook_configs` DISABLE KEYS */;
/*!40000 ALTER TABLE `webhook_configs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webhook_events`
--

DROP TABLE IF EXISTS `webhook_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webhook_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `event` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webhook_events`
--

LOCK TABLES `webhook_events` WRITE;
/*!40000 ALTER TABLE `webhook_events` DISABLE KEYS */;
INSERT INTO `webhook_events` VALUES (1,'ticket_status_updated','2025-01-03 04:07:31','2025-01-03 04:07:31'),(2,'ticket_reply','2025-01-03 04:07:31','2025-01-03 04:07:31'),(3,'ticket_assigned','2025-01-03 04:07:31','2025-01-03 04:07:31'),(4,'ticket_created','2025-01-03 04:07:31','2025-01-03 04:07:31'),(5,'ticket_due_date_updated','2025-01-03 04:07:31','2025-01-03 04:07:31'),(6,'ticket_owner_updated','2025-01-03 04:07:31','2025-01-03 04:07:31'),(7,'ticket_department_updated','2025-01-03 04:07:31','2025-01-03 04:07:31'),(8,'ticket_commented','2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `webhook_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webhook_logs`
--

DROP TABLE IF EXISTS `webhook_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webhook_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `webhook_id` bigint(20) unsigned NOT NULL,
  `event` varchar(255) NOT NULL,
  `payload` longblob DEFAULT NULL,
  `response` varchar(255) NOT NULL,
  `message` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `webhook_logs_webhook_id_foreign` (`webhook_id`),
  CONSTRAINT `webhook_logs_webhook_id_foreign` FOREIGN KEY (`webhook_id`) REFERENCES `webhooks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webhook_logs`
--

LOCK TABLES `webhook_logs` WRITE;
/*!40000 ALTER TABLE `webhook_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `webhook_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webhooks`
--

DROP TABLE IF EXISTS `webhooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webhooks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webhooks`
--

LOCK TABLES `webhooks` WRITE;
/*!40000 ALTER TABLE `webhooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `webhooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `websocket_configurations`
--

DROP TABLE IF EXISTS `websocket_configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `websocket_configurations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `driver` varchar(255) NOT NULL,
  `config` int(11) NOT NULL,
  `tooltip` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`settings`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `websocket_configurations`
--

LOCK TABLES `websocket_configurations` WRITE;
/*!40000 ALTER TABLE `websocket_configurations` DISABLE KEYS */;
INSERT INTO `websocket_configurations` VALUES (1,'redis',1,'lang.redis_hint','Redis',0,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(2,'log',0,'lang.log_hint','Log',0,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(3,'ably',1,'lang.ably_hint','Ably',0,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31'),(4,'pusher',1,'lang.pusher_hint','Pusher',0,NULL,'2025-01-03 04:07:31','2025-01-03 04:07:31');
/*!40000 ALTER TABLE `websocket_configurations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `websockets_statistics_entries`
--

DROP TABLE IF EXISTS `websockets_statistics_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `websockets_statistics_entries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `app_id` varchar(255) NOT NULL,
  `peak_connection_count` int(11) NOT NULL,
  `websocket_message_count` int(11) NOT NULL,
  `api_message_count` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `websockets_statistics_entries`
--

LOCK TABLES `websockets_statistics_entries` WRITE;
/*!40000 ALTER TABLE `websockets_statistics_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `websockets_statistics_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `widgets`
--

DROP TABLE IF EXISTS `widgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `value` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `type` varchar(25) NOT NULL DEFAULT 'social-icon',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `widgets`
--

LOCK TABLES `widgets` WRITE;
/*!40000 ALTER TABLE `widgets` DISABLE KEYS */;
INSERT INTO `widgets` VALUES (1,'footer1',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:25','footer'),(2,'footer2',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:25','footer'),(3,'footer3',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:25','footer'),(4,'footer4',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:25','footer'),(5,'linkedin',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23','social-icon'),(6,'stumble',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23','social-icon'),(7,'google',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23','social-icon'),(8,'deviantart',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23','social-icon'),(9,'flickr',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23','social-icon'),(10,'skype',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23','social-icon'),(11,'rss',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23','social-icon'),(12,'twitter',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23','social-icon'),(13,'facebook',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23','social-icon'),(14,'youtube',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23','social-icon'),(15,'vimeo',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23','social-icon'),(16,'pinterest',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23','social-icon'),(17,'dribbble',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23','social-icon'),(18,'instagram',NULL,NULL,'2025-01-03 04:07:23','2025-01-03 04:07:23','social-icon');
/*!40000 ALTER TABLE `widgets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workflow_action`
--

DROP TABLE IF EXISTS `workflow_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflow_action` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `workflow_id` int(10) unsigned NOT NULL,
  `condition` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `custom_action` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `workflow_action_1` (`workflow_id`),
  CONSTRAINT `workflow_action_1` FOREIGN KEY (`workflow_id`) REFERENCES `workflow_name` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_action`
--

LOCK TABLES `workflow_action` WRITE;
/*!40000 ALTER TABLE `workflow_action` DISABLE KEYS */;
/*!40000 ALTER TABLE `workflow_action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workflow_close`
--

DROP TABLE IF EXISTS `workflow_close`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflow_close` (
  `id` int(10) unsigned NOT NULL,
  `days` int(11) NOT NULL,
  `condition` int(11) NOT NULL,
  `status` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `workflow_close_status_foreign` (`status`),
  CONSTRAINT `workflow_close_status_foreign` FOREIGN KEY (`status`) REFERENCES `ticket_status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_close`
--

LOCK TABLES `workflow_close` WRITE;
/*!40000 ALTER TABLE `workflow_close` DISABLE KEYS */;
INSERT INTO `workflow_close` VALUES (1,2,1,3,'2025-01-03 04:07:23','2025-01-03 04:07:23');
/*!40000 ALTER TABLE `workflow_close` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workflow_name`
--

DROP TABLE IF EXISTS `workflow_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflow_name` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `order` int(11) NOT NULL,
  `target` varchar(255) NOT NULL,
  `internal_note` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `rule_match` varchar(10) NOT NULL DEFAULT 'all',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_name`
--

LOCK TABLES `workflow_name` WRITE;
/*!40000 ALTER TABLE `workflow_name` DISABLE KEYS */;
/*!40000 ALTER TABLE `workflow_name` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workflow_rules`
--

DROP TABLE IF EXISTS `workflow_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflow_rules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `workflow_id` int(10) unsigned NOT NULL,
  `matching_criteria` varchar(255) NOT NULL,
  `matching_scenario` varchar(255) NOT NULL,
  `matching_relation` varchar(255) NOT NULL,
  `matching_value` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `custom_rule` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `workflow_rules_1` (`workflow_id`),
  CONSTRAINT `workflow_rules_1` FOREIGN KEY (`workflow_id`) REFERENCES `workflow_name` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_rules`
--

LOCK TABLES `workflow_rules` WRITE;
/*!40000 ALTER TABLE `workflow_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `workflow_rules` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-03 15:08:55
