# Queries

{{ version }}

!!! danger

    The legacy queries module was removed.
    Use the new [queries](./../queries) of v2 instead, which provides better usability.

SADU provides a query builder, which allows easy guidance through requesting data from your database.
Import it into your project to use it.

```java
dependencies {
    implementation("de.chojo.sadu", "sadu-queries", "<version>")
}
```

## Why use the query builder?

Before I give you a long talk about how much nicer the syntax and code is let me simple show you a comparison.

=== "Plain java"

    Without the query builder your code would ideally look like this:

    ```java
    class MyQueries {
        
        DataSource dataSource;
        
        MyQueries(DataSource dataSource){
            this.dataSource = dataSource;
        }
    
        public CompletableFuture<Optional<MyResultClass>> getResultOld(int id) {
            return CompletableFuture.supplyAsync(() -> {
                try (Connection conn = source().getConnection(); PreparedStatement stmt = conn.prepareStatement("SELECT result FROM results WHERE id = ?")) {
                    stmt.setInt(id);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        return Optional.of(new MyResultClass(rs.getString("result"));
                    }
                } catch (SQLException e) {
                    logger.error("Something went wrong", e);
                }
                return Optional.empty();
            });
        }
    }
    ```

=== "Query Builder"

    Using the query builder your code becomes this:

    ```java
    class MyQueries extends QueryFactory {
        MyQueries(DataSource dataSource){
            super(dataSource);
        }
    
        public CompletableFuture<Optional<MyResultClass>> getResultNew(int id) {
            return builder(MyResultClass.class)
                    .query("SELECT result FROM results WHERE id = ?")
                    .parameter(stmt -> stmt.setInt(id))
                    .readRow(rs -> new MyResultClass(rs.getString("result")))
                    .first();
        }
    }
    ```

Beautiful, isn't it?
The query builder will:

- Enforce try with resources
- Set parameters in the order defined by you
- Read the result set
- Handle the exceptions for you.

## How does it work?

The query builder guides you through different stages.
These stages will allow you to only call methods which make sense in the current context.
It is for exampe not possible to read a row without defining a query first.
