DROP DATABASE IF EXISTS DATABASE_PROJECT;
CREATE DATABASE DATABASE_PROJECT;
use DATABASE_PROJECT;

--  create table user
CREATE TABLE tb_user ( 
	user_id INT AUTO_INCREMENT,
    user_name varchar(50),
    user_password varchar(50),
	-- first_name VARCHAR(50),
	-- last_name VARCHAR(50),
	email VARCHAR(100),
     PRIMARY KEY (user_id)
	);
 
-- setting user_id auto increment from 100
ALTER TABLE tb_user AUTO_INCREMENT = 100;

-- insert test data for user
insert into tb_user (user_name, user_password, email) values 
('test1', '1', 'www.111@111.com'),
('test2', '1', 'www.222@222.com'),
('test3', '1', 'www.333@333.com'),
('test4', '1', 'www.444@444.com');

-- create table profile
create table tb_profile (
	user_id INT auto_increment,
    profile_display_name varchar (50),
    profile_avatar bit default 1,       -- 0 means job seeker, 1 means HR 
    primary key (user_id)
    );

-- setting user_id auto increment from 100
ALTER TABLE tb_profile AUTO_INCREMENT = 100;

-- insert test data for profile
insert into tb_profile (profile_display_name, profile_avatar) values 
('AAA', 0),
('BBB', 1),
('CCC', 0),
('DDD', 1);

-- create table follows
create table tb_follows (
	user_id int,
    followed_user_id int
    );
    
-- create table post
create table tb_post (
	post_id int auto_increment,
    post_job_id int,
    user_name varchar(50) not null,
    user_id int not null,
    post_title varchar (100),
    post_content text,
    post_time timestamp default current_timestamp,
    primary key (post_id),
    foreign key (user_id) references tb_user (user_id)
	);
    
ALTER TABLE tb_post AUTO_INCREMENT = 500;

-- create table reply
create table tb_reply (
	reply_id int auto_increment,
    post_id int,
    user_id int,
    user_name varchar (50),
    reply_content text,
    reply_time timestamp default current_timestamp,
    primary key (reply_id),
    foreign key (user_id) references tb_user (user_id),
    foreign key (post_id) references tb_post (post_id)
	);
ALTER TABLE tb_reply AUTO_INCREMENT = 500;

-- create table job
create table tb_job (
	job_id int not null,
    user_id int not null,
    job_company_name varchar(100),
    job_position varchar (100),
    job_location varchar (100),
    job_status varchar (100),
    job_link varchar (100),
    primary key (job_id)
	);

-- create table status
create table tb_status (
	job_id int not null,
    status_type varchar (100),
    status_time_stamp datetime,
    primary key (job_id)
	);

    
	