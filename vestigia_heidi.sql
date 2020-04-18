-- Dumping database structure for vestigia
CREATE DATABASE IF NOT EXISTS `vestigia` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `vestigia`;

-- Dumping structure for table vestigia.tb_follows
CREATE TABLE IF NOT EXISTS `tb_follows` (
  `user_id` int(11) NOT NULL,
  `followed_user_id` int(11) NOT NULL,
  KEY `FK_tb_follows_tb_user` (`user_id`),
  KEY `FK_tb_follows_tb_user_2` (`followed_user_id`),
  CONSTRAINT `FK_tb_follows_tb_user` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`user_id`),
  CONSTRAINT `FK_tb_follows_tb_user_2` FOREIGN KEY (`followed_user_id`) REFERENCES `tb_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table vestigia.tb_follows: ~5 rows (approximately)
/*!40000 ALTER TABLE `tb_follows` DISABLE KEYS */;
INSERT INTO `tb_follows` (`user_id`, `followed_user_id`) VALUES
	(5, 6),
	(6, 5),
	(5, 7),
	(7, 5),
	(7, 6),
	(5, 8);
/*!40000 ALTER TABLE `tb_follows` ENABLE KEYS */;

-- Dumping structure for table vestigia.tb_job
CREATE TABLE IF NOT EXISTS `tb_job` (
  `job_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `job_company_name` varchar(100) DEFAULT NULL,
  `job_position` varchar(100) DEFAULT NULL,
  `job_location` varchar(100) DEFAULT NULL,
  `job_status` varchar(100) DEFAULT NULL,
  `job_link` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table vestigia.tb_job: ~0 rows (approximately)
/*!40000 ALTER TABLE `tb_job` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_job` ENABLE KEYS */;

-- Dumping structure for table vestigia.tb_post
CREATE TABLE IF NOT EXISTS `tb_post` (
  `post_id` int(11) NOT NULL AUTO_INCREMENT,
  `post_job_id` int(11) DEFAULT NULL,
  `post_title` varchar(100) NOT NULL DEFAULT '',
  `post_content` text NOT NULL DEFAULT '',
  `user_id` int(11) NOT NULL,
  `user_name` varchar(50) NOT NULL DEFAULT '',
  `post_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`post_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `tb_post_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- Dumping data for table vestigia.tb_post: ~11 rows (approximately)
/*!40000 ALTER TABLE `tb_post` DISABLE KEYS */;
INSERT INTO `tb_post` (`post_id`, `post_job_id`, `post_title`, `post_content`, `user_id`, `user_name`, `post_time`) VALUES
	(1, NULL, 'fdfdfd', 'ffd', 5, 'test', '2020-03-29 15:15:21'),
	(2, NULL, 'example', 'example post', 6, 'example', '2020-03-29 15:17:24'),
	(3, NULL, '[SUPERDAY] at Citi', 'Applied for summer internship as Technology Analyst for Summer 2020 in NYC! Looking forward to the interview!\r\n\r\nLink to site is here: https://jobs.citi.com/job/tampa/icg-technology-summer-analyst-north-america-2020/287/12665279', 7, 'sandy', '2020-04-11 00:20:46'),
	(4, NULL, '[FIRST ROUND INTERVIEW] with JP Morgan', 'fhihgdigbdsbfds;gfdslbvd.sbvdjs;fgdgudsfbjdlsvfdgldhsvfhldsfldsbfdjsfdvi;dfdsfdfhsjjytyh', 9, 'star', '2020-04-11 00:50:15'),
	(5, NULL, '[ACCEPTED] Full Time with Boeing', 'looking forward to working with Boeing in the new year\r\n', 9, 'star', '2020-04-11 00:51:04'),
	(6, NULL, 'fdsfdsgoids;gb;dmcl[saf', 'qwertyuioplkjhgfdsazxcvbnm,qwertyuiopoijhgfdcvbnmjk,,kjhgfdxcvb', 6, 'example', '2020-04-11 00:51:39'),
	(7, NULL, 'fdsfdsfdsfdsf', 'fdsfdsfdsfdsfdsfdfd', 6, 'example', '2020-04-11 00:51:50'),
	(8, NULL, 'ACCEPTED job at Bob The Builder', 'WE CAN FIX IT!', 8, 'bob', '2020-04-11 00:52:41'),
	(9, NULL, 'bfkdgbf;ilfosadj\'efi0td', 'fdjewgt79ew8duixsdhjvbds', 8, 'bob', '2020-04-11 00:52:55'),
	(10, NULL, 'gfdgfdgfdgfd', 'gfdgfdgfdgfdgfdgfd', 8, 'bob', '2020-04-11 00:53:06'),
	(11, NULL, 'fdsfdsfds', 'dfdsfdsfds', 5, 'test', '2020-04-11 01:11:34'),
	(12, NULL, 'fdfdfdsfds', 'fdsfdsfdsfd', 5, 'test', '2020-04-11 01:21:17'),
	(13, NULL, 'dfdsfds', 'fdsfdss', 7, 'sandy', '2020-04-11 01:21:31');
/*!40000 ALTER TABLE `tb_post` ENABLE KEYS */;

-- Dumping structure for table vestigia.tb_profile
CREATE TABLE IF NOT EXISTS `tb_profile` (
  `user_id` int(11) NOT NULL,
  `profile_display_name` varchar(50) DEFAULT NULL,
  `profile_avatar` varbinary(50) DEFAULT NULL,
  KEY `FK_tb_profile_tb_user` (`user_id`),
  CONSTRAINT `FK_tb_profile_tb_user` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table vestigia.tb_profile: ~0 rows (approximately)
/*!40000 ALTER TABLE `tb_profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_profile` ENABLE KEYS */;

-- Dumping structure for table vestigia.tb_reply
CREATE TABLE IF NOT EXISTS `tb_reply` (
  `reply_id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `reply_content` text DEFAULT NULL,
  `reply_time` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`reply_id`),
  KEY `user_id` (`user_id`),
  KEY `post_id` (`post_id`),
  CONSTRAINT `tb_reply_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`user_id`),
  CONSTRAINT `tb_reply_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `tb_post` (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table vestigia.tb_reply: ~0 rows (approximately)
/*!40000 ALTER TABLE `tb_reply` DISABLE KEYS */;
INSERT INTO `tb_reply` (`reply_id`, `post_id`, `user_id`, `username`, `reply_content`, `reply_time`) VALUES
	(1, 2, 5, 'test', 'hello how are you?', '2020-03-30 19:48:44');
/*!40000 ALTER TABLE `tb_reply` ENABLE KEYS */;

-- Dumping structure for table vestigia.tb_status
CREATE TABLE IF NOT EXISTS `tb_status` (
  `job_id` int(11) NOT NULL,
  `status_type` varchar(100) DEFAULT NULL,
  `status_time_stamp` datetime DEFAULT NULL,
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table vestigia.tb_status: ~0 rows (approximately)
/*!40000 ALTER TABLE `tb_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_status` ENABLE KEYS */;

-- Dumping structure for table vestigia.tb_user
CREATE TABLE IF NOT EXISTS `tb_user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `user_password` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- Dumping data for table vestigia.tb_user: ~5 rows (approximately)
/*!40000 ALTER TABLE `tb_user` DISABLE KEYS */;
INSERT INTO `tb_user` (`user_id`, `first_name`, `last_name`, `user_name`, `user_password`, `email`) VALUES
	(5, 'test', 'test', 'test', 'test', 'test@test.com'),
	(6, 'example', 'example', 'example', 'example', 'example@example.com'),
	(7, 'sandy', 'qiu', 'sandy', '1', 'sandy@gmail.com'),
	(8, 'bob', 'builder', 'bob', 'bob', 'bob@pbs.com'),
	(9, 'star', 'twinkle', 'star', 'star', 'star@star.com');
/*!40000 ALTER TABLE `tb_user` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
