-- create a keyspace
DROP KEYSPACE IF EXISTS my_keyspace;
CREATE KEYSPACE my_keyspace WITH REPLICATION={'class':'SimpleStrategy', 'replication_factor':1};
USE my_keyspace;

-- create table users
CREATE TABLE IF NOT EXISTS users (
 firstname text, 
 lastname text, 
 age int, 
 email text, 
 city text, 
 PRIMARY KEY (lastname)
);

-- insert data in users
INSERT INTO users (firstname, lastname, age, email, city) VALUES ('John', 'Smith', 46, 'johnsmith@email.com', 'Sacramento'); 
INSERT INTO users (firstname, lastname, age, email, city) VALUES ('Jane', 'Doe', 36, 'janedoe@email.com', 'Beverly Hills'); 
INSERT INTO users (firstname, lastname, age, email, city) VALUES ('Rob', 'Byrne', 24, 'robbyrne@email.com', 'San Diego');

-- create table timetest
CREATE TABLE IF NOT EXISTS timetest (
  key uuid,
  activation_time timeuuid,
  value text,
  PRIMARY KEY(key,activation_time)
);

-- insert data
insert into timetest (key, activation_time, value) VALUES (uuid(), now(), 'some value 1'); 
insert into timetest (key, activation_time, value) VALUES (uuid(), now(), 'some value 2'); 
insert into timetest (key, activation_time, value) VALUES (uuid(), now(), 'some value 3'); 
insert into timetest (key, activation_time, value) VALUES (uuid(), now(), 'some value 4'); 
insert into timetest (key, activation_time, value) VALUES (uuid(), now(), 'some value 5'); 