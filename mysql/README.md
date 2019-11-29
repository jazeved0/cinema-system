# MySQL Database Dump

This directory contains all of the SQL files needed to recreate the database developed in Phase 3 of the project, including the concrete schema, imported data, and stored procedures.

**Note that these files are not used in the final project. They were created as a result of the class, CS 4400, being taught using MySQL and requiring these files to be written as a phase of the project. They should be functionally equivalent to the files on `/database`, which are written for PostgreSQL (the ORDBMS used in the final project).**

## Execution Order

In order to be loaded, the files needed to be executed in the following order:

1. `schema.sql`
2. `data.sql`
3. `views.sql`
4. `procedures.sql`

> Note that the order of 2, 3 and 4 doesn't particularly matter-- the most important restriction is that `schema.sql` must be run **first**
