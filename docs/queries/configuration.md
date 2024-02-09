# Configuration

When configuring your query object you have two options.
In general, you always need a configured Queryconfiguration.

## Using a QueryConfiguration instance

The `QueryConfiguration` class allows you to configure the behaviour of your query.

```java
QueryConfiguration config = QueryConfiguration.builder(dataSource)
        // Register a handler to log exceptions
        .setExceptionHandler(err -> log.error("An error occured during a database request", err))
        // As an alternative you can make the query throw the exception instead of just logging it
        .setThrowExceptions(true)
        // This only affects batch queries.
        // This will cause all batch queries being executed in a single transaction
        // True is the default
        .setAtomic(true)
        // Register a RowMapperRegistry to map results.
        .setRowMapperRegistry(new RowMapperRegistry().register(PostgresqlMapper.getDefaultMapper()))
        .build();
```

After that you can use that config to create new queries

```java
config.query("SELECT ...")
```

## Using the static global configuration

Instead of passing your config everywhere, you can set the global configuration.

The default configuration is always used when the `Query` class is used to create a query.

To define the global configuration you just need to create it as in the previous section and pass it into the QueryConfiguration class.

```java
QueryConfiguration.setDefault(config);
```

Now you can use the `Query` class to directly dispatch queries.

```java
Query.query("SELECT ...")
```
