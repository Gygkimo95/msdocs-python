use app_test;
create table if not exists t4(id BIGINT UNSIGNED auto_increment primary key, xname varchar(200) default 'test');
create table if not exists customer(id BIGINT UNSIGNED auto_increment primary key, xname varchar(200) default 'test');
