# Configuration

To configure automatic mapping of rows into objects, we start by creating a <RowMapperRegistry>.

```java
var registry = new RowMapperRegistry()
```

After that we start with registering the default mapper, which You can find at `<Database>Mapper`.
Mapper for Postgres are located as <PostgresqlMapper> and can always be retrieved via <PostgresqlMapper#getDefaultMapper()>.

```java
var registry = new RowMapperRegistry()
registry.register(PostgresqlMapper.getDefaultMapper())
```

After that we register our registry at our <de.chojo.sadu.queries.api.configuration.QueryConfiguration>.

```java
QueryConfiguration.setDefault(QueryConfiguration.builder(dc)
        .setRowMapperRegistry(new RowMapperRegistry().register(PostgresqlMapper.getDefaultMapper()))
        .build());
```
