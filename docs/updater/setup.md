# Setup

Setting up the updater is quite straight forward.

## Base Setup

Create a structure like this in your resources.
We will configure our updater to update a postgres database.

```md
resources
└── database                # The database directory holds all information
    ├── postgresql          # All script for postgresql are stored here
    │   └── 1               # All scripts for 1.x are contained in this directory
    │       └── setup.sql   # The initial setup of the database 
    └── version             # The current database version. Currently 1.0
```

Of course, you can add scripts for multiple databases.
All database directories need all setup and other scripts.

!!! note
    
    While they need the scripts, those scripts may be empty.

### Setting the version

To set the version simply enter a major and patch version separated by a dot in your version file.

```
1.0
```

### Adding the setup script

Enter all your queries for the initial database setup into the setup.sql file.

For our example we add a simple table we want to deploy:

```sql
CREATE TABLE dev_schema.test
(
    id   SERIAL,
    name TEXT,
    age  INTEGER
); -- Make sure to end your statement with a semicolon
```
