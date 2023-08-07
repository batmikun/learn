# What is PostgreSQL?

Is a powerful, open source object-relational database system. It supports a large part of the SQL standard and offers many modern features:

- Comples Queries
- Foreign Keys
- Triggers
- Updatable views
- Transactional Integrity

Also can be extended by the user in many ways, for example by adding new

- Data ypes
- Functions
- Operators
- Aggregate Functions
- Index Methods
- Procedural Languages

## Conventions

Are used in the synopsis of a command: brackets ([ and ]) indicate optional parts,
Braces ({ and }) and vertical lines (|) indicate that you must choose one alternative. Dots (...) mean that the preceding element can be repeated. All other symbols, including paretheses, should be taken literally.

Where it enhances the clarity, SQL commands are preceded by the prompt =>, and shell command are preceded by the prompt $. Normally prompts are not shown

An administratr is generally a person who is in charge of installing and running the server.A user could be anyone who is using, or wants to use, any port of the PostgreSQL system.

## Architectural Fundamentals

Before we proceed, you should understand the basic PostgreSQL system architecture.

In database jargon,PostgreSQL uses a client/server model. A PostgreSQL session consists of the following cooperating processes (programs):

- A server process, which manages the databse file, accepts connecctions to the database from client applications, and performs database actions on behalf of the clients. The database server program is called postgres.

- The user's client (frontend) application that want to perfom database operations.

# The SQL Language
