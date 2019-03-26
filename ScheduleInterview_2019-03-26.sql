# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.24)
# Database: ScheduleInterview
# Generation Time: 2019-03-26 07:41:04 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table event_global
# ------------------------------------------------------------

DROP TABLE IF EXISTS `event_global`;

CREATE TABLE `event_global` (
  `event_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `publisher_id` int(8) unsigned zerofill NOT NULL,
  `event_name` varchar(256) NOT NULL DEFAULT '',
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `introduction` varchar(256) NOT NULL DEFAULT '',
  PRIMARY KEY (`event_id`),
  UNIQUE KEY `eventName` (`event_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `event_global` WRITE;
/*!40000 ALTER TABLE `event_global` DISABLE KEYS */;

INSERT INTO `event_global` (`event_id`, `publisher_id`, `event_name`, `start_time`, `end_time`, `introduction`)
VALUES
	(00000001,00000001,'name','2019-01-01 00:00:00','2019-01-02 00:00:00','test');

/*!40000 ALTER TABLE `event_global` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table event_global_00000001
# ------------------------------------------------------------

DROP TABLE IF EXISTS `event_global_00000001`;

CREATE TABLE `event_global_00000001` (
  `clause_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `clause_name` varchar(256) NOT NULL DEFAULT '',
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `auth_level` int(1) NOT NULL,
  `introduction` varchar(256) NOT NULL DEFAULT '',
  `limit` int(4) NOT NULL,
  `total` int(4) DEFAULT '0',
  `members` varchar(1024) DEFAULT '',
  PRIMARY KEY (`clause_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `event_global_00000001` WRITE;
/*!40000 ALTER TABLE `event_global_00000001` DISABLE KEYS */;

INSERT INTO `event_global_00000001` (`clause_id`, `clause_name`, `start_time`, `end_time`, `auth_level`, `introduction`, `limit`, `total`, `members`)
VALUES
	(00000001,'test name','2019-01-01 00:00:00','2019-01-02 00:00:00',1,'test',5,0,'');

/*!40000 ALTER TABLE `event_global_00000001` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table event_group
# ------------------------------------------------------------

DROP TABLE IF EXISTS `event_group`;

CREATE TABLE `event_group` (
  `event_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `group_id` int(8) unsigned zerofill NOT NULL,
  `publisher_id` int(8) unsigned zerofill NOT NULL,
  `event_name` varchar(256) NOT NULL DEFAULT '',
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `introduction` varchar(256) NOT NULL DEFAULT '',
  PRIMARY KEY (`event_id`),
  UNIQUE KEY `group_id` (`group_id`,`event_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `event_group` WRITE;
/*!40000 ALTER TABLE `event_group` DISABLE KEYS */;

INSERT INTO `event_group` (`event_id`, `group_id`, `publisher_id`, `event_name`, `start_time`, `end_time`, `introduction`)
VALUES
	(00000001,00000001,00000001,'name','2019-01-01 00:00:00','2019-01-02 00:00:00','test');

/*!40000 ALTER TABLE `event_group` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table event_group_00000001
# ------------------------------------------------------------

DROP TABLE IF EXISTS `event_group_00000001`;

CREATE TABLE `event_group_00000001` (
  `clause_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `clause_name` varchar(256) NOT NULL DEFAULT '',
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `auth_level` int(1) NOT NULL,
  `introduction` varchar(256) NOT NULL DEFAULT '',
  `limit` int(4) NOT NULL,
  `total` int(4) DEFAULT '0',
  `members` varchar(1024) DEFAULT '',
  PRIMARY KEY (`clause_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table group
# ------------------------------------------------------------

DROP TABLE IF EXISTS `group`;

CREATE TABLE `group` (
  `group_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `creator_id` int(8) unsigned zerofill NOT NULL,
  `group_name` varchar(64) NOT NULL DEFAULT '',
  `introduction` varchar(256) NOT NULL DEFAULT '',
  PRIMARY KEY (`group_id`),
  UNIQUE KEY `group_name` (`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `group` WRITE;
/*!40000 ALTER TABLE `group` DISABLE KEYS */;

INSERT INTO `group` (`group_id`, `creator_id`, `group_name`, `introduction`)
VALUES
	(00000001,00000001,'group1','test group');

/*!40000 ALTER TABLE `group` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table group_00000001
# ------------------------------------------------------------

DROP TABLE IF EXISTS `group_00000001`;

CREATE TABLE `group_00000001` (
  `member_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `user_id` int(8) unsigned zerofill NOT NULL,
  `auth_level` int(1) unsigned NOT NULL,
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `group_00000001` WRITE;
/*!40000 ALTER TABLE `group_00000001` DISABLE KEYS */;

INSERT INTO `group_00000001` (`member_id`, `user_id`, `auth_level`)
VALUES
	(00000001,00000001,5);

/*!40000 ALTER TABLE `group_00000001` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table invitation
# ------------------------------------------------------------

DROP TABLE IF EXISTS `invitation`;

CREATE TABLE `invitation` (
  `invitation_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `group_id` int(8) unsigned zerofill NOT NULL,
  `inviter_id` int(8) unsigned zerofill NOT NULL,
  `invitee_id` int(8) unsigned zerofill NOT NULL,
  PRIMARY KEY (`invitation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table order_global
# ------------------------------------------------------------

DROP TABLE IF EXISTS `order_global`;

CREATE TABLE `order_global` (
  `order_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `user_id` int(8) unsigned zerofill NOT NULL,
  `event_id` int(8) unsigned zerofill NOT NULL,
  `clause_id` int(8) unsigned zerofill NOT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table order_group
# ------------------------------------------------------------

DROP TABLE IF EXISTS `order_group`;

CREATE TABLE `order_group` (
  `order_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `user_id` int(8) unsigned zerofill NOT NULL,
  `group_id` int(8) unsigned zerofill NOT NULL,
  `event_id` int(8) unsigned zerofill NOT NULL,
  `clause_id` int(8) unsigned zerofill NOT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `user_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `user_name` varchar(16) NOT NULL DEFAULT '',
  `password` varchar(16) NOT NULL DEFAULT '',
  `phone` varchar(11) NOT NULL DEFAULT '',
  `gender` tinyint(1) DEFAULT NULL,
  `introduction` varchar(256) NOT NULL DEFAULT '',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;

INSERT INTO `user` (`user_id`, `user_name`, `password`, `phone`, `gender`, `introduction`)
VALUES
	(00000001,'root','123','13862735550',0,'root用户'),
	(00000006,'test','111','1234567890',1,'test user'),
	(00000007,'(userName)','(vo.password)','(vo.phone)',NULL,'');

/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
