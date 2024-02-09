# Data Source

{{ version }}

SADU has implementations to easily create datasources for different RDBMS. Use this to import it.

```kts
dependencies {
    implementation("de.chojo.sadu", "sadu-datasource", "<version>")
}
```

{{ type_selection }}

## HikariCP

SADU provides a datasource creator to create a datasource using [HikariCP](https://github.com/brettwooldridge/HikariCP).

> Fast, simple, reliable. HikariCP is a "zero-overhead" production ready JDBC connection pool. At roughly 130Kb, the library is very light.

## Creating a datasource

The DataSourceCreator can be used to build a HikariDataScource with a builder pattern.

Choose the correct SqlType for your data source. The methods available in the configuration depend on the SqlType.

!!! note

    Every value which is not set will be the default value provided by the database driver.


```java
class Main {
    public static void main(String[] args) {
        // Create a new datasource for a postgres database
        HikariDataSource dataSource = DataSourceCreator.create(PostgreSql.get())
                // Configure the usual stuff.
                .configure(config -> config.host("localhost")
                        .port(5432)
                        .user("root")
                        .password("passy")
                        .database("db")
                        // Additionally we set some postgres specific stuff.
                        // This is only possible because we chose the postgres database type.
                        // First we set the schema to use
                        .currentSchema("default")
                        // We also set an application name
                        .applicationName("SADU-Examples")
                )
                // Create the hikari data source
                .create()
                // Set a max of 3 parallel connections.
                .withMaximumPoolSize(3)
                // Define that we want to keep always at least one connecction.
                .withMinimumIdle(1)
                // Build our datasource.
                .build();
    }
}
```

## Using relocation

When using relocation you need to call `#driverClass` in the configure call and provide your driver class.
This will avoid issues caused by the relocation which might block loading of the driver class.

```java
class Main {
    public static void main(String[] args) {
        HikariDataSource dataSource = DataSourceCreator.create(PostgreSql.get())
                .configure(config -> config
                        ...
                        // provide the driver class.
                        .driverClass(Driver.class)
                )
                ...
                .build();
    }
}
```
