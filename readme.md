# apache-cassandra-test
A small study project on Apache Cassandra, what it is, where does it come from and how to use it.

## Running Cassandra
Have [docker](https://www.docker.com/) and [docker-compose](https://www.docker.com/products/docker-compose) installed and launch the script `launsh.sh` to start Apache Cassandra v2.x, afterwards run `cqlsh.sh` to get access to the [CQL shell](http://docs.datastax.com/en/cql/3.1/cql/cql_intro_c.html) which is an interactive terminal for communicating with the Cassandra database, so no need to install any deamons on your system other than Docker and maybe VirtualBox.

## Nodetool
Using the `nodetool.sh` script, you get access to nodetool. The nodetool utility is a command line interface for managing a cassandra cluster. To get an overview of 

## cqlsh
Using the `cqlsh.sh` script, you get access to cqlsh, which you can use to create keyspaces and tables, insert and query tables, plus much more.

## Introduction to processing data
There are multiple ways to process data. Lets start simple and then ramp it up.

# What is Cassandra?
[Apache Cassandra](http://cassandra.apache.org/), is born at Facebook and built on [Amazon’s Dynamo and Google’s BigTable](http://docs.datastax.com/en/articles/cassandra/cassandrathenandnow.html), is a distributed database for managing large amounts of structured data across many commodity servers, while providing highly available service and no single point of failure. Cassandra offers capabilities that relational databases and other NoSQL databases simply cannot match such as: continuous availability, linear scale performance, operational simplicity and easy data distribution across multiple data centers and cloud availability zones.

Cassandra’s architecture is responsible for its ability to scale, perform, and offer continuous uptime. Rather than using a legacy master-slave or a manual and difficult-to-maintain sharded architecture, Cassandra has a [masterless “ring” design](https://academy.datastax.com/resources/brief-introduction-apache-cassandra) that is elegant, easy to setup, and easy to maintain.

In Cassandra, all nodes play an identical role; there is no concept of a master node, with all nodes communicating with each other equally. Cassandra’s built-for-scale architecture means that it is capable of handling large amounts of data and thousands of concurrent users or operations per second—​even across multiple data centers—​as easily as it can manage much smaller amounts of data and user traffic. Cassandra’s architecture also means that, unlike other master-slave or sharded systems, it has no single point of failure and therefore is capable of offering true continuous availability and uptime — simply add new nodes to an existing cluster without having to take it down.

Note, Apache Cassandra aims for high availability and is therefor **eventually consistent**, contrary to a relational database, which aims for consistency but not for high availability, both are limitations put upon these systems by the [CAP Theorem](https://en.wikipedia.org/wiki/CAP_theorem) which states that it is impossible for a distributed system to simultaneously provide all three of the following guarantees:

- __Consistency:__ (all nodes see the same data at the same time)
- __Availability:__ (every request receives a response about whether it succeeded or failed)
- __Partition tolerance:__ (the system continues to operate despite arbitrary partitioning due to network failures)

According to [NoSQL - Your ultimate guide to the Non-Relational Universe](http://nosql-database.org/), Cassandra is a Wide Column Store / Column Families architected database that is a massively scalable, partitioned row store, masterless architecture, linear scale performance, no single points of failure, read/write support across multiple data centers & cloud availability zones. API / Query Method: CQL and Thrift, replication: peer-to-peer, written in: Java, Concurrency: tunable consistency, Misc: built-in data compression, MapReduce support, primary/secondary indexes, security features.

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

## Weaknesses of Cassandra
Because cassandra has its strength in availabilty and partition tolerance (AP), it does not support transactions. It uses replication extensively to enable availability so that the data in the cluster might be momentarily inconsistent (although it is eventually consistent). It does not support relations so no joins, foreign keys or referential integrity. In addition, the range queries are not available Furthermore, the flexible schema might lead to problems with efficient searches.

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
inet | strings | An IP address. It can be either 4 bytes long [IPv4](https://en.wikipedia.org/wiki/IPv4) or 16 bytes long [IPv6](https://en.wikipedia.org/wiki/IPv6). There is no inet constant, IP address should be inputed as strings
tinyint | integers | 8-bit signed int
smallint | integers | 16-bit signed int
decimal | integers, float | Variable-precision decimal
**int** | integers | 32-bit signed int
**float** | integers, floats | 32-bit [IEEE-754](https://en.wikipedia.org/wiki/IEEE_754_revision) floating point
**double** | integers | 64-bit [IEEE-754](https://en.wikipedia.org/wiki/IEEE_754_revision) floating point
**timestamp** | integers, strings | A timestamp. Strings constant are allow to input timestamps as dates
**timeuuid** | uuids | [Type 1](https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_1_.28date-time_.26_MAC_address.29) [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier). This is generally used as a “conflict-free” timestamp.
**uuid** | uuids | [Type 1](https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_1_.28date-time_.26_MAC_address.29) or [Type 4](https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_.28random.29) [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier)
**text** | strings | UTF-8 encoded string note that text is an alias for varchar
**varchar** | strings | UTF-8 encoded string 
time | integers, strings | A time with nanosecond precision.
date | integers, strings | A date (with no corresponding time value)

## Keyspaces
A 'cluster' is a container for 'keyspaces'. A 'keyspace' is a container for 'tables'. Keyspaces correspond closely to a database schema in a relational database. The keyspace can include operational elements, such as replication factor and data center awareness. Let's create a keyspace:

Note: the 'replication_factor' parameter is required.

```cql
-- create a keyspace 'my_keyspace'
CREATE KEYSPACE my_keyspace 
with REPLICATION = {
 'class' : 'SimpleStrategy', 
 'replication_factor' : 1
};

-- switch to the keyspace with the 'USE' keyword
USE my_keyspace;

-- drop the keyspace with the 'DROP' keyword
DROP keyspace my_keyspace;
```

## Creating a table
To create a table you must first create a keyspace and then use that keyspace. To create a table the structure looks a lot like a SQL-DDL CREATE command. Every row in a table must be uniquely identifiable, we do that with a primary key. 

Cassandra offers several data types like:

- UUID (Universally Unique Identifier, generate via 'uuid()'), 
- TIMEUUID (Embeds a timestamp value, is sortable, generate via 'now()'),
- TEXT (utf-8 encoded, any length), 
- INT (signed, 32 bit)
- TIMESTAMP (Stores date and time, 64 bit integer, millis since epoch)

Note: Generally in Cassandra we use UUID or TIMEUUID as an identifier.

```cql
CREATE TABLE users (
 user UUID,
 email TEXT, 
 name INT, 
 PRIMARY KEY (user)
);
```

## Describe a table
To see detail information about a table type:

```
DESCRIBE TABLE users;
```

## COPY (Bulk loading data)
The copy command allows for bulk loading data into cassandra from a CSV file:

```cql
COPY table_name (column1, column2, column3) FROM 'table1data.csv';

-- to skip the header
COPY table_name (column1, column2, column3) FROM 'table1data.csv'
WITH HEADER = true;
```

## Querying a table
To query a table type the following:

```cql
SELECT * 
 FROM table1;

SELECT column1, column2, column3
 FROM table1;

SELECT COUNT(*)
 FROM table1;

SELECT *
 FROM table1
 LIMIT 10;
```

We can filter the result by using a predicate:

```cql
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

## UUID (Universally Unique Identifiers)
[UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier) uses 32 hex digits, 0-9 or a-f, which are case-insensitive, separated by dashes, -, after the 8th, 12th, 16th, and 20th digits. For example: 01234567-0123-0123-0123-0123456789ab. A UUID should be 128 bits or 16 bytes long.

When generated according to the standard methods, UUIDs are for practical purposes unique, without depending for their uniqueness on a central registration authority or coordination between the parties generating them, unlike most other numbering schemes. While the probability that a UUID will be duplicated is not zero, it is so close to zero as to be negligible.

Thus, anyone can create a UUID and use it to identify something with near certainty that the identifier does not duplicate one that has already been, or will be, created to identify something else. Information labeled with UUIDs by independent parties can therefore be later combined into a single database, or transmitted on the same channel, without needing to resolve conflicts between identifiers.

Adoption of UUIDs and GUIDs is widespread, with many computing platforms providing support for generating them, and for parsing their textual representation.

## TIMEUUID
[TIMEUUID](https://docs.datastax.com/en/cql/3.3/cql/cql_reference/valid_literal_r.html) uses the time in 100 nanosecond intervals since 00:00:00.00 UTC (60 bits), a clock sequence number for prevention of duplicates (14 bits), plus the IEEE 801 MAC address (48 bits) to generate a unique identifier. For example: d2177dd0-eaa2-11de-a572-001b779c76e3 which makes 60 bits, 14 bits and 48 bits 

# UUID vs TIMEUUID
[UUID and TIMEUUID](https://docs.datastax.com/en/cql/3.3/cql/cql_reference/uuid_type_r.html?hl=uuid) are stored the same way in Cassandra, and they only really represent two different sorting implementations.

TIMEUUID columns are sorted by their time components first, and then by their raw bytes, whereas UUID columns are sorted by their version first, then if both are version 1 by their time component, and finally by their raw bytes. Curiously the time component sorting implementations are duplicated between UUIDType and TimeUUIDType in the Cassandra code, except for different formatting.

I think of the UUID vs. TIMEUUID question primarily as documentation: if you choose TIMEUUID you're saying that you're storing things in chronological order, and that these things can occur at the same time, so a simple timestamp isn't enough. TIMEUUIDs are used for time-series data. As we are recording records we want to maintain the order of the time that they were inserted thus no timestamp column is necessary. If we sort by a TIMEUUID the data will be sorted by a time seried fashion.  

Using UUID says that you don't care about order (even if in practice the columns will be ordered by time if you put version 1 UUIDs in them), you just want to make sure that things have unique IDs.

Even if using NOW() to generate UUID values is convenient, it's also very surprising to other people reading your code.

It probably does not matter much in the grand scheme of things, but sorting non-version 1 UUIDs is a bit faster than version 1, so if you have a UUID column and generate the UUIDs yourself, go for another version.

The UUID (universally unique id) comparator type is used to avoid collisions in column names. Alternatively, you can use the TIMEUUID.

TIMEUUID types can be entered as integers for CQL input. A value of the TIMEUUID type is a Type 1 UUID. A Version 1 UUID includes the time of its generation and are sorted by timestamp, making them ideal for use in applications requiring 'conflict-free timestamps'. For example, you can use this type to identify a column (such as a blog entry) by its timestamp and allow multiple clients to write to the same partition key simultaneously. Collisions that would potentially overwrite data that was not intended to be overwritten cannot occur.

A valid timeuuid conforms to the timeuuid format shown in [valid literals](https://docs.datastax.com/en/cql/3.3/cql/cql_reference/valid_literal_r.html).

## Telling the difference between a UUID and TIMEUUD
When you visually see a UUID or TimeUUID representation you must look for the third set of numbers. For example:

```
- UUID    : '7ae6918b-5bcf-40f1-8068-2ed179a5f9eb' 
- TIMEUUID: 'd2177dd0-eaa2-11de-a572-001b779c76e3'
```

The third set of number for the UUID example is '40f1' which starts with a '4' which means 'Version 4' and is the version identifier of the UUID String. The third set of numbers for the TIMEUUID example is '11de' which starts with '1' which means 'Version 1' and identifies a TIMEUUID. 

So both UUID and TIMEUUID are valid 128 bit UUID identifiers, but now you can visually inspect the version by looking at the third set of numbers and identify which UUID version it is, either '1 - TimeUUID' or '4 - UUID'.

## Used Sources
- [Cassandra Courses](https://academy.datastax.com/courses)
- [Planet Cassandra - What is Cassandra?](http://planetcassandra.org/what-is-apache-cassandra/)
- [Cassandra Keyspaces - what are they ?](http://gettingstartedwithcassandra.blogspot.nl/2011/06/cassandra-keyspaces-what-are-they.html)
- [Dynamo -  Amazon’s Highly Available Key-value Store](http://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf)
- [Bigtable - A Distributed Storage System for Structured Data](http://static.googleusercontent.com/media/research.google.com/nl//archive/bigtable-osdi06.pdf)
- [Are there any performance penalties when using a TEXT as a Primary Key?](http://stackoverflow.com/questions/28191761/are-there-any-performance-penalties-when-using-a-text-as-a-primary-key/28194884#28194884)
- [Select 2000 most recent log entries in cassandra table using CQL (Latest version)](http://stackoverflow.com/questions/18274007/select-2000-most-recent-log-entries-in-cassandra-table-using-cql-latest-version)
- [Selecting timeuuid columns corresponding to a specific date](http://stackoverflow.com/questions/19104629/selecting-timeuuid-columns-corresponding-to-a-specific-date)
- [Cassandra UUID vs TimeUUID benefits and disadvantages](http://stackoverflow.com/questions/17945677/cassandra-uuid-vs-timeuuid-benefits-and-disadvantages/17946236#17946236)

## Courses
- [(0'30 hr) Introduction - DataStax](https://academy.datastax.com/resources/ds101-introduction-cassandra)
- [(6'00 hr) Core Concepts - DataStax](https://academy.datastax.com/resources/ds201-foundations-apache-cassandra)
- [(12'00 hr) Data Modeling - DataStax](https://academy.datastax.com/resources/ds220-data-modeling)

## Videos
- [(0'35 hr) Building a Fast, Resilient Time Series Store with Cassandra - Alex Petrov](https://www.youtube.com/watch?v=3pPser3MYEE)
- [(0'34 hr) C* Keys: Partitioning, Clustering, & CrossFit - Adam Hutson](https://www.youtube.com/watch?v=L0XqRF8C6D0)