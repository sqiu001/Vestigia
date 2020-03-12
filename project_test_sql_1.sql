DROP DATABASE IF EXISTS DATABASE_PROJECT;
CREATE DATABASE DATABASE_PROJECT;
use DATABASE_PROJECT;

--  create table user
CREATE TABLE user ( 
	user_id INTEGER PRIMARY KEY AUTO_INCREMENT = 100,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(100)
);

-- create table profile
CREATE TABLE profile (
	user_id INTEGER PRIMARY KEY AUTO_INCREMENT = 100,
	display_name VARCHAR(50),
	avatar BIT default 1,       -- 0 means job seeker, 1 means HR 
);

-- create table follows
CREATE TABLE follows (
	user_id INTEGER not null,
	followed_user_id INTEGER PRIMARY KEY not null,
);
    
-- create table post
CREATE TABLE post (
	post_id INTEGER PRIMARY KEY,
	job_id INTEGER,
	user_id INTEGER not null,
	time_stamp DATETIME,
	foreign key (user_id) references user (user_id)
);

-- create table replies
CREATE TABLE replY (
	reply_id INTEGER PRIMARY KEY not null,
	post_id INTEGER,
	user_id INTEGER not null,
	text VARCHAR(5000),
	time_stamp DATETIME,
	foreign key (user_id) references user (user_id)
);

-- create table job
CREATE TABLE job (
	id INTEGER PRIMARY KEY not null,
	user_id INTEGER not null,
	company_name VARCHAR(100),
	position VARCHAR(100),
	location VARCHAR(100),
	status VARCHAR(100),
	link VARCHAR(100)
);

-- create table status
CREATE TABLE status (
	id INTEGER PRIMARY KEY not null,
	type VARCHAR(100),
	time_stamp DATETIME,
);

-- insert test data for user
INSERT INTO user (first_name, last_name, email) VALUES 
	('YIFENG', 'Jin', 'www.111@111.com'),
	('Niharika', 'Alam', 'www.222@222.com'),
	('Sandy', 'Qiu', 'www.333@333.com'),
	('Silvija', 'Skemaite', 'www.444@444.com');

-- insert test data for profile
INSERT INTO profile (display_name, avatar) VALUES 
	('AAA', 0),
	('BBB', 1),
	('CCC', 0),
	('DDD', 1);
	
