# Components

The query builder has several components with their own feature set.

## Query

### Defining Arguments

The query supports named and indexed arguments

Instead of writing `?` you can use named arguments with `:argument_name`.

Examples:

=== "Indexed only"

    ```sql
    SELECT *
    FROM table
    WHERE id = ?
      AND name = ?;
    ```

=== "Named only"

    ```sql
    SELECT *
    FROM table
    WHERE id = :id
      AND name = :name;
    ```

=== "Mixed"
 
    ```sql
    SELECT *
    FROM table
    WHERE id = :id
      AND name = ?;
    ```

=== "Duplicate"

    Use the argument name multiple times.
    
    ```sql
    SELECT *
    FROM table
    WHERE id = :id AND name = :name
       OR name = lower(:name);
    ```
    
    !!! note
    
        All named arguments of the same name have the same value

### Formatting

!!! danger

    Do not use that feature with untrusted user input!

When defining a query you can append objects which are used in a `String#formatted` call.
This allows you to inject row or table names in runtime to reuse queries.

```java
Query.query("SELECT * FROM %s;", tableName)
```

## Calls

Calls are used to define the amount of calls.

!!! note
    All examples are without binding a parameter.
    See [call](#call) for examples for binding parameter.

### Singleton Call

A singleton call is a single execution of your query.

There are several ways to define your singleton query.

=== "Empty"

    This is an empty call without any parameter
    
    ```java
    Query.query("SELECT * FROM table;")
            .single(Calls.empty())
    ```

    or

    ```java
    Query.query("SELECT * FROM table;")
            .single()
    ```

=== "Simple"

    This version is shorter and quicker to write
    
    ```java
    Query.query("SELECT * FROM table;")
            .single(Call.of())
    ```

=== "Access Storage"

    In case you have saved something into your query storage you can access the storage here
    ```java
    Query.query("SELECT * FROM table;")
            .single(storage -> Call.of().asSingleCall());
    ```

### Batch calls

Batch calls are similar to singleton calls.

!!! warning
    
    Batch queries do not support selects


=== "Short"

    This version is shorter and quicker to write
    
    ```java
    query.query("INSERT INTO table(a,b) VALUES (:a, :b)")
            .batch(Call.of(),
                    Call.of());
    ```

=== "List"

    Use a list of calls
    
    ```java
    query.query("INSERT INTO table(a,b) VALUES (:a, :b)")
            .batch(List.of(Call.of(), Call.of()));
    ```

=== "Stream"

    Use a stream of calls
    
    ```java
    query.query("INSERT INTO table(a,b) VALUES (:a, :b)")
            .batch(Stream.generate(Call::of).limit(5));
    ```

=== "Access Storage"

    ```java
    query.query("INSERT INTO table(a,b) VALUES (:a, :b)")
            .batch(storage -> Call.of().asBatchCall().add(Call.of()));
    ```

## Call

A call is used to define the parameters of a query execution.

You can define a parameter by calling `bind(String, Object)` or `bind(Object)`

### Indexed parameter

To bind an indexed parameter (Parameters that are defined with `?`) use the `bind(Object)` method.

The type of your parameter will be automatically defined.

### Named parameter

To bind a named parameter (Parameter that are defined with `:parameter_name`) use the `bind(String, Object)` method.

The string is the name of the parameter without `:`

The type of your parameter will be automatically determined.

### Mixed parameter

When indexed and named parameter are mixed, the indexed parameters are filled independent of the named ones.
Only the order in which the indexed parameters are provided matters.

### Auto binding and Adapters

The `bind` method has several overloads for all common types of SQL.
If there is a method lacking for a common object, or you need a specific layout you can use Adapters.

A good example for that is UUID, which can be either serialized as bytes or as a string.

To use an adapter pass the adapter after your object as second or third argument.

=== "Write UUID as bytes"

```java
query.query("INSERT INTO table(a,b) VALUES (:a, :b)")
        .single(Call.of().bind(UUID.randomUUID(), UUIDAdapter.AS_BYTES));
```

=== "Write UUID as String"

```java
query.query("INSERT INTO table(a,b) VALUES (:a, :b)")
        .single(Call.of().bind("a", UUID.randomUUID(), UUIDAdapter.AS_STRING));
```

## Adapter

Adapter are used to transform a java object into a sql object and apply it on a statement.

### Custom Adapter

To define a custom adapter you can use the `Adapter.create(Class<T> class, AdapterMapping<T> mapping, int type)` method.

This method has three important parameter:

1. clazz
    This is the java class that the adapter will convert into a sql type.
2. AdapterMapping
    The AdapterMapping maps the java type to the sql type and applies it to the statement on the provided index.
3. Type
    The sql type to be used if the type is null.

## Row Mapping

A row mapping is simply a mapping of a row in a sql result into a java object. 

## Results

There are four types of results, which differ between read and write operations.
Results contain information of the operation results and also allow access to exceptions via the `exceptions()` method.

### Read Results

For reading, you can either use the `first()` or `all()` methods to directly retrieve your object.
If you need more information you can use `firstResult()` or `allResults()`, which return either a SingleResult or a MultiResult.
This Result still allows you to access your read objects via the `result()` method.

### Write Results

For writing, you have two results, which differ depending on your call.
You will always end up with a `ManipulationResult`, which provides the changed `rows()` and a boolean `changed()` to indicate that rows is not zero. 
If you execute a batch call you will get a `ManipulationBatchResult`, which has the same methods that return the sum of all rows.
Additionally, you have access to all individual `ManipulationResult`s.
