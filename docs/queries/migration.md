# Migrate from queries v1 to v2

Queries 2 is a complete replacement for the old queries module.
While it is the successor, there are some features that are not implemented on purpose in v2.

## Migrating QueryFactory and QueryBuilderConfig

The functionality of the `QueryFactory` and `QueryBuilderConfig` are merged into `QueryConfiguration`.

The `builder()` method is now either `Query.query(String)` or `QueryConfiguration#query(String)`.

## Migrating calls to builder()

The type is no longer declared in `builder()`. Just remove it.

## Migrating calls to query()

Nothing changed for passing queries.

## Migrating getKey()

the getKey Option is now available via the insertAndGetKeys method. All keys will always be resolved.

## Migrating async calls

It wasn't really the scope to support threading in sadu.
Therefore, this feature was removed.
Use Completable futures yourself on the correct level to restore that functionality.

## Migrating atomic multi query calls

v1 executed all appended queries in one transaction, v2 doesn't do this anymore.
To do this you have to create a connected configuration.
Look at the [examples](examples.md#single-transaction-mode) for that.
