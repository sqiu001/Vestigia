DROP DATABASE IF EXISTS vestigia;
CREATE DATABASE vestigia;
use vestigia;

CREATE TABLE `tb_user` (
	`user_id` INT(11) NOT NULL AUTO_INCREMENT,
	`first_name` VARCHAR(50) NOT NULL,
	`last_name` VARCHAR(50) NOT NULL,
	`username` VARCHAR(50) NOT NULL,
	`password` VARCHAR(50) NOT NULL,
	`email` VARCHAR(100) NOT NULL,
	PRIMARY KEY (`user_id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=5
;

CREATE TABLE `tb_status` (
	`job_id` INT(11) NOT NULL,
	`status_type` VARCHAR(100) NULL DEFAULT NULL,
	`status_time_stamp` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`job_id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `tb_reply` (
	`reply_id` INT(11) NOT NULL AUTO_INCREMENT,
	`post_id` INT(11) NOT NULL,
	`user_id` INT(11) NOT NULL,
	`username` VARCHAR(50) NOT NULL,
	`reply_content` TEXT NULL DEFAULT NULL,
	`reply_time` TIMESTAMP NULL DEFAULT current_timestamp(),
	PRIMARY KEY (`reply_id`),
	INDEX `user_id` (`user_id`),
	INDEX `post_id` (`post_id`),
	CONSTRAINT `tb_reply_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`user_id`),
	CONSTRAINT `tb_reply_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `tb_post` (`post_id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=2
;


CREATE TABLE `tb_profile` (
	`user_id` INT(11) NOT NULL AUTO_INCREMENT,
	`profile_display_name` VARCHAR(50) NULL DEFAULT NULL,
	`profile_avatar` VARBINARY(50) NULL DEFAULT NULL,
	PRIMARY KEY (`user_id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=5
;

CREATE TABLE `tb_post` (
	`post_id` INT(11) NOT NULL AUTO_INCREMENT,
	`post_job_id` INT(11) NULL DEFAULT NULL,
	`post_title` VARCHAR(100) NOT NULL DEFAULT '',
	`post_content` TEXT NOT NULL DEFAULT '',
	`user_id` INT(11) NOT NULL,
	`username` VARCHAR(50) NOT NULL DEFAULT '',
	`post_time` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	PRIMARY KEY (`post_id`),
	INDEX `user_id` (`user_id`),
	CONSTRAINT `tb_post_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`user_id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=3
;


CREATE TABLE `tb_job` (
	`job_id` INT(11) NOT NULL,
	`user_id` INT(11) NOT NULL,
	`job_company_name` VARCHAR(100) NULL DEFAULT NULL,
	`job_position` VARCHAR(100) NULL DEFAULT NULL,
	`job_location` VARCHAR(100) NULL DEFAULT NULL,
	`job_status` VARCHAR(100) NULL DEFAULT NULL,
	`job_link` VARCHAR(100) NULL DEFAULT NULL,
	PRIMARY KEY (`job_id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `tb_follows` (
	`user_id` INT(11) NOT NULL,
	`followed_user_id` INT(11) NOT NULL,
	PRIMARY KEY (`followed_user_id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

