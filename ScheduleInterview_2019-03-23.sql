# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.24)
# Database: ScheduleInterview
# Generation Time: 2019-03-23 05:23:06 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table event_00000001
# ------------------------------------------------------------

DROP TABLE IF EXISTS `event_00000001`;

CREATE TABLE `event_00000001` (
  `clauseID` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`clauseID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table events
# ------------------------------------------------------------

DROP TABLE IF EXISTS `events`;

CREATE TABLE `events` (
  `eventID` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `publisherID` int(8) unsigned zerofill NOT NULL,
  PRIMARY KEY (`eventID`),
  KEY `publisherID` (`publisherID`),
  CONSTRAINT `events_ibfk_1` FOREIGN KEY (`publisherID`) REFERENCES `users` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;

INSERT INTO `events` (`eventID`, `publisherID`)
VALUES
	(00000001,00000001);

/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table g_event_00000001
# ------------------------------------------------------------

DROP TABLE IF EXISTS `g_event_00000001`;

CREATE TABLE `g_event_00000001` (
  `clauseID` int(8) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`clauseID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table group_00000001
# ------------------------------------------------------------

DROP TABLE IF EXISTS `group_00000001`;

CREATE TABLE `group_00000001` (
  `id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `memberID` int(8) unsigned zerofill NOT NULL,
  `authLv` int(1) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `memberID` (`memberID`),
  CONSTRAINT `group_00000001_ibfk_2` FOREIGN KEY (`memberID`) REFERENCES `users` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `group_00000001` WRITE;
/*!40000 ALTER TABLE `group_00000001` DISABLE KEYS */;

INSERT INTO `group_00000001` (`id`, `memberID`, `authLv`)
VALUES
	(00000001,00000001,5);

/*!40000 ALTER TABLE `group_00000001` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table group_events
# ------------------------------------------------------------

DROP TABLE IF EXISTS `group_events`;

CREATE TABLE `group_events` (
  `gEventID` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `groupID` int(8) unsigned zerofill NOT NULL,
  `publisher` int(8) unsigned zerofill NOT NULL,
  PRIMARY KEY (`gEventID`),
  KEY `groupID` (`groupID`),
  KEY `publisher` (`publisher`),
  CONSTRAINT `group_events_ibfk_1` FOREIGN KEY (`groupID`) REFERENCES `groups` (`groupID`),
  CONSTRAINT `group_events_ibfk_2` FOREIGN KEY (`publisher`) REFERENCES `users` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `group_events` WRITE;
/*!40000 ALTER TABLE `group_events` DISABLE KEYS */;

INSERT INTO `group_events` (`gEventID`, `groupID`, `publisher`)
VALUES
	(1,00000001,00000001);

/*!40000 ALTER TABLE `group_events` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table groups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `groups`;

CREATE TABLE `groups` (
  `groupID` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `creatorID` int(8) unsigned zerofill NOT NULL,
  PRIMARY KEY (`groupID`),
  KEY `creatorID` (`creatorID`),
  CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`creatorID`) REFERENCES `users` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;

INSERT INTO `groups` (`groupID`, `creatorID`)
VALUES
	(00000001,00000001);

/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table invitation
# ------------------------------------------------------------

DROP TABLE IF EXISTS `invitation`;

CREATE TABLE `invitation` (
  `invitationID` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `groupID` int(8) unsigned zerofill NOT NULL,
  `inviterID` int(8) unsigned zerofill NOT NULL,
  `inviteeID` int(8) unsigned zerofill NOT NULL,
  PRIMARY KEY (`invitationID`),
  KEY `groupID` (`groupID`),
  KEY `userID` (`inviterID`),
  KEY `inviteeID` (`inviteeID`),
  CONSTRAINT `invitation_ibfk_1` FOREIGN KEY (`groupID`) REFERENCES `groups` (`groupID`),
  CONSTRAINT `invitation_ibfk_2` FOREIGN KEY (`inviterID`) REFERENCES `users` (`userID`),
  CONSTRAINT `invitation_ibfk_3` FOREIGN KEY (`inviteeID`) REFERENCES `users` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `userID` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `userName` varchar(16) NOT NULL DEFAULT '',
  `password` varchar(16) NOT NULL DEFAULT '',
  `phone` varchar(11) NOT NULL DEFAULT '',
  PRIMARY KEY (`userID`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`userID`, `userName`, `password`, `phone`)
VALUES
	(00000001,'root','123','13862735550'),
	(00000006,'test','111','1234567890');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
