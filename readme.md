# apache-cassandra-test
A small study project on Apache Cassandra, what it is, where does it come from and how to use it.

## Running Cassandra
Have [docker](https://www.docker.com/) and [docker-compose](https://www.docker.com/products/docker-compose) installed and launch the script `launsh.sh` to start Apache Cassandra v2.x, afterwards run `cqlsh.sh` to get access to the [CQL shell](http://docs.datastax.com/en/cql/3.1/cql/cql_intro_c.html) which is an interactive terminal for communicating with the Cassandra database, so no need to install any deamons on your system other than Docker and maybe VirtualBox.

## Nodetool
Using the `nodetool.sh` script, you get access to nodetool. The nodetool utility is a command line interface for managing a cassandra cluster. To get an overview of 

## cqlsh
Using the `cqlsh.sh` script, you get access to cqlsh, which you can use to create keyspaces and tables, insert and query tables, plus much more.

# What is Cassandra?
[Apache Cassandra](http://cassandra.apache.org/), is born at Facebook and built on [Amazon’s Dynamo and Google’s BigTable](http://docs.datastax.com/en/articles/cassandra/cassandrathenandnow.html), is a distributed database for managing large amounts of structured data across many commodity servers, while providing highly available service and no single point of failure. Cassandra offers capabilities that relational databases and other NoSQL databases simply cannot match such as: continuous availability, linear scale performance, operational simplicity and easy data distribution across multiple data centers and cloud availability zones.

Cassandra’s architecture is responsible for its ability to scale, perform, and offer continuous uptime. Rather than using a legacy master-slave or a manual and difficult-to-maintain sharded architecture, Cassandra has a [masterless “ring” design](https://academy.datastax.com/resources/brief-introduction-apache-cassandra) that is elegant, easy to setup, and easy to maintain.

In Cassandra, all nodes play an identical role; there is no concept of a master node, with all nodes communicating with each other equally. Cassandra’s built-for-scale architecture means that it is capable of handling large amounts of data and thousands of concurrent users or operations per second—​even across multiple data centers—​as easily as it can manage much smaller amounts of data and user traffic. Cassandra’s architecture also means that, unlike other master-slave or sharded systems, it has no single point of failure and therefore is capable of offering true continuous availability and uptime — simply add new nodes to an existing cluster without having to take it down.

Note, Apache Cassandra aims for high availability and is therefor eventually consistent, contrary to a relational database, which aims for consistency but not for high availability, both are limitations put upon these systems by the [CAP Theorem](https://en.wikipedia.org/wiki/CAP_theorem) which states that it is impossible for a distributed system to simultaneously provide all three of the following guarantees:

- __Consistency:__ (all nodes see the same data at the same time)
- __Availability:__ (every request receives a response about whether it succeeded or failed)
- __Partition tolerance:__ (the system continues to operate despite arbitrary partitioning due to network failures)

## Cassandra Architecture
Cassandra's architecture is modeled in two ways:

- For distribution: Dynamo which means dynamic partitioning, which means cassandra can scale horizontally dynamically,
- For storage: BigTable model which means a distributed storage system,
- For node architecture: peer-to-peer,
- Data model: column oriented which means it is very flexible, but does also means it does not support relations so __no__ foreign keys, __no__ referential integrity and __no__ joins,
- For data durability cassandra uses a commit log,
- For high availability cassandra uses data replication (strategy) at a configurable number of nodes,
- For speed cassandra uses in-memory caches (memtable),
- For failure tolerance, cassandra supports repair mechanisms.

## Consistency
Okay, Cassandra is very cool as we can see of the feature above, but what about consistency eg. read after write? Well, for that Cassandra provides tunable consistency levels for read and write operations, which in practise means for a write and read operation, the number of nodes we wish to acknowledge the write or read operation, so for a certain operation on the cluster we can, per use case, define the required level of consistency which yes is cool.

# Cassandra Query Language (CQL)
Cassandra provides a SQL like language called [Cassandra Query Language v3 (CQL)](http://cassandra.apache.org/doc/cql3/CQL.html). CQL is the primary language for communicating with the Cassandra database by means of the cqlsh interactive terminal. 

CQL v3 offers a model very close to SQL in the sense that data is put in _tables_ containing _rows_ of _columns_. For that reason, the terms tables, rows and columns have the same definition than they have in SQL (phew). The internal implementation of Cassandra doesn't use said model so you won't find it in the source code, in the thrift and in the CQL v2 API.

## Statements
CQL consists of statements. As in SQL, these statements can be divided in 3 categories:

- [Data definition statements](http://cassandra.apache.org/doc/cql3/CQL.html#dataDefinition): allow to set and change the way data is stored.
  - [CREATE KEYSPACE](http://cassandra.apache.org/doc/cql3/CQL.html#createKeyspaceStmt): The CREATE KEYSPACE statement creates a new top-level keyspace. A keyspace is a namespace that defines a replication strategy and some options for a set of tables. Valid keyspaces names are identifiers composed exclusively of alphanumerical characters and whose length is lesser or equal to 32. Note that as identifiers, keyspace names are case insensitive: use a quoted identifier for case sensitive keyspace names. 
  - [USE](http://cassandra.apache.org/doc/cql3/CQL.html#useStmt): The USE statement takes an existing keyspace name as argument and set it as the per-connection current working keyspace. All subsequent keyspace-specific actions will be performed in the context of the selected keyspace, unless otherwise specified, until another USE statement is issued or the connection terminates.
  - [DROP KEYSPACE](http://cassandra.apache.org/doc/cql3/CQL.html#dropKeyspaceStmt): A DROP KEYSPACE statement results in the immediate, irreversible removal of an existing keyspace, including all column families in it, and all data contained in those column families. If the keyspace does not exists, the statement will return an error, unless IF EXISTS is used in which case the operation is a no-op.
  - [CREATE TABLE](http://cassandra.apache.org/doc/cql3/CQL.html#createTableStmt): The CREATE TABLE statement creates a new table. Each such table is a set of rows (usually representing related entities) for which it defines a number of properties. A table is defined by a name, it defines the columns composing rows of the table and have a number of options. Note that the CREATE COLUMNFAMILY syntax is supported as an alias for CREATE TABLE (for historical reasons).
Attempting to create an already existing table will return an error unless the IF NOT EXISTS option is used. If it is used, the statement will be a no-op if the table already exists.
  - [ALTER TABLE](http://cassandra.apache.org/doc/cql3/CQL.html#alterTableStmt): The ALTER statement is used to manipulate table definitions. It allows for adding new columns, dropping existing ones, changing the type of existing columns, or updating the table options. As with table creation, ALTER COLUMNFAMILY is allowed as an alias for ALTER TABLE.
  - [DROP TABLE](http://cassandra.apache.org/doc/cql3/CQL.html#dropTableStmt): The DROP TABLE statement results in the immediate, irreversible removal of a table, including all data contained in it. As for table creation, DROP COLUMNFAMILY is allowed as an alias for DROP TABLE. If the table does not exist, the statement will return an error, unless IF EXISTS is used in which case the operation is a no-op.
  - [CREATE INDEX](http://cassandra.apache.org/doc/cql3/CQL.html#createIndexStmt): The CREATE INDEX statement is used to create a new (automatic) secondary index for a given (existing) column in a given table. A name for the index itself can be specified before the ON keyword, if desired. If data already exists for the column, it will be indexed asynchronously. After the index is created, new data for the column is indexed automatically at insertion time.
Attempting to create an already existing index will return an error unless the IF NOT EXISTS option is used. If it is used, the statement will be a no-op if the index already exists.
  - [DROP INDEX](http://cassandra.apache.org/doc/cql3/CQL.html#dropIndexStmt): The DROP INDEX statement is used to drop an existing secondary index. The argument of the statement is the index name, which may optionally specify the keyspace of the index. If the index does not exists, the statement will return an error, unless IF EXISTS is used in which case the operation is a no-op.
  - [many more](http://cassandra.apache.org/doc/cql3/CQL.html#dataDefinition).

- [Data manipulation statements](http://cassandra.apache.org/doc/cql3/CQL.html#dataManipulation): allow to change data.
  - [INSERT](http://cassandra.apache.org/doc/cql3/CQL.html#insertStmt): The INSERT statement writes one or more columns for a given row in a table. Note that since a row is identified by its PRIMARY KEY, at least the columns composing it must be specified. The list of columns to insert to must be supplied when using the VALUES syntax.
  - [UPDATE](http://cassandra.apache.org/doc/cql3/CQL.html#updateStmt): The UPDATE statement writes one or more columns for a given row in a table. The <where-clause> is used to select the row to update and must include all columns composing the PRIMARY KEY (the IN relation is only supported for the last column of the partition key). Other columns values are specified through <assignment> after the SET keyword.
  - [DELETE](http://cassandra.apache.org/doc/cql3/CQL.html#deleteStmt): The DELETE statement deletes columns and rows. If column names are provided directly after the DELETE keyword, only those columns are deleted from the row indicated by the <where-clause>.
  - [BATCH](http://cassandra.apache.org/doc/cql3/CQL.html#batchStmt): The BATCH statement group multiple modification statements (insertions/updates and deletions) into a single statement. 
    
- [Queries](http://cassandra.apache.org/doc/cql3/CQL.html#queries): to look up data.
  - [SELECT](http://cassandra.apache.org/doc/cql3/CQL.html#selectStmt): The SELECT statements reads one or more columns for one or more rows in a table. It returns a result-set of rows, where each row contains the collection of columns corresponding to the query.



## Data Types
CQL supports a rich set of [data types](http://cassandra.apache.org/doc/cql3/CQL.html#types) for columns defined in a table, including [collection types](http://cassandra.apache.org/doc/cql3/CQL.html#collections). Cassandra supports a lot of data types, the following is a a short list:

type | constants supported | description 
 --- | --- |--- 
boolean | booleans | true or false|
counter | integers | Counter column (64-bit signed value)
blob | blobs | Arbitrary bytes (no validation)
tinyint | integers | 8-bit signed int
smallint | integers | 16-bit signed int
int | integers | 32-bit signed int
decimal | integers, float | Variable-precision decimal
float | integers, floats | 32-bit IEEE-754 floating point
double | integers | 64-bit IEEE-754 floating point
time | integers, strings | A time with nanosecond precision.
timestamp | integers, strings | A timestamp. Strings constant are allow to input timestamps as dates
timeuuid | uuids | Type 1 UUID. This is generally used as a “conflict-free” timestamp.
date | integers, strings | A date (with no corresponding time value)
uuid | uuids | Type 1 or type 4 UUID
varchar | strings | UTF-8 encoded string
text | strings | UTF-8 encoded string

## Keyspaces
A cluster is a container for keyspaces. A keyspace is the outermost container for data in Cassandra, corresponding closely to a schema in a relational database. The keyspace can include operational elements, such as replication factor and data center awareness. Let's create a keyspace:

```
-- create a keyspace 'my_keyspace'
create keyspace my_keyspace with replication={'class':'SimpleStrategy', 'replication_factor':1};

-- use the keyspace
use my_keyspace;

-- drop the keyspace
drop keyspace my_keyspace;
```

## Creating a table
To create a table type the following in cqlsh, note that you must first create a keyspace and then use that keyspace:

```
CREATE TABLE users (
 firstname text, 
 lastname text, 
 age int, 
 email text, 
 city text, 
 PRIMARY KEY (lastname)
);
```

## Describe a table
To see detail information about a table type:

```
DESCRIBE TABLE users;
```

## Insert records
To insert records in the table type:

```
INSERT INTO users (firstname, lastname, age, email, city) VALUES ('John', 'Smith', 46, 'johnsmith@email.com', 'Sacramento'); 
INSERT INTO users (firstname, lastname, age, email, city) VALUES ('Jane', 'Doe', 36, 'janedoe@email.com', 'Beverly Hills'); 
INSERT INTO users (firstname, lastname, age, email, city) VALUES ('Rob', 'Byrne', 24, 'robbyrne@email.com', 'San Diego');
```

## Querying a table
To query a table type the following:

```
SELECT * FROM users;

 lastname | age | city          | email               | firstname
----------+-----+---------------+---------------------+-----------
      Doe |  36 | Beverly Hills |   janedoe@email.com |      Jane
    Byrne |  24 |     San Diego |  robbyrne@email.com |       Rob
    Smith |  46 |    Sacramento | johnsmith@email.com |      John

(3 rows)
```

We can filter the result by using a predicate:

```
SELECT * FROM users WHERE lastname= 'Doe';

 lastname | age | city          | email             | firstname
----------+-----+---------------+-------------------+-----------
      Doe |  36 | Beverly Hills | janedoe@email.com |      Jane

(1 rows)
```

## Updating records
To update a record in a table type the following:

```
UPDATE users SET city= 'San Jose' WHERE lastname= 'Doe';
```

The update should be available almost instantly (remember that cassandra is eventually consistent):

```
SELECT * FROM users where lastname= 'Doe';

 lastname | age | city     | email             | firstname
----------+-----+----------+-------------------+-----------
      Doe |  36 | San Jose | janedoe@email.com |      Jane

(1 rows)
```

## Deleting records
To delete a record type:

```
DELETE from users WHERE lastname = 'Doe';
```

which should result in:

```
SELECT * FROM users where lastname= 'Doe';

 lastname | age | city | email | firstname
----------+-----+------+-------+-----------

(0 rows)

SELECT * from users;

 lastname | age | city       | email               | firstname
----------+-----+------------+---------------------+-----------
    Byrne |  24 |  San Diego |  robbyrne@email.com |       Rob
    Smith |  46 | Sacramento | johnsmith@email.com |      John

(2 rows)
```

# Used Sources
- [Planet Cassandra - What is Cassandra?](http://planetcassandra.org/what-is-apache-cassandra/)
- [Cassandra Keyspaces - what are they ?](http://gettingstartedwithcassandra.blogspot.nl/2011/06/cassandra-keyspaces-what-are-they.html)
- [Dynamo -  Amazon’s Highly Available Key-value Store](http://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf)
- [Bigtable - A Distributed Storage System for Structured Data](http://static.googleusercontent.com/media/research.google.com/nl//archive/bigtable-osdi06.pdf)
