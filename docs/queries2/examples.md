# Examples

This page contains several examples for the usage of the query builder.
For in depth examples for the components have a look at the [components page](components.md)

## Select

We always read a User object in that section, which looks like that:

```java
public record User(int id, UUID uuid, String name) {
    public static RowMapping<User> map() {
        return row -> new User(row.getInt("id"), row.getUuidFromString("uuid"), row.getString("name"));
    }
}
```

This is an example for a [RowMapping](components.md#row-mapping)

### Get All

This returns all matching entries for our query and maps it to a user.

```java
List<User> users = query.query("SELECT * FROM users WHERE id = ? AND name ILIKE :name")
        .single(Calls.single(call -> call.bind(1).bind("name", "lilly")))
        .map(User.map())
        .allAndGet();
```

### Get First

This returns the first row of our result and terminates after that.

If a result was returned the option won't be empty.

```java
Optional<User> user = query.query("SELECT * FROM users where id = :id")
        .single(Calls.single(call -> call.bind("id", 1)))
        .map(User.map())
        .oneAndGet();
```



## Insert, Update and Delete

Inserts, updates and deletes are currently all handled the same.
The only difference is the last call, which are only an alias.

### Single

Insert a single value.

```java
// Insert multiple entries at the same time
ManipulationResult change = query
        // Define the query
        .query("INSERT INTO users(uuid, name) VALUES(:uuid::uuid,?)")
        // Create a new call
        // First parameter is named and second indexed
        .single(Call.of().bind("uuid", UUID.randomUUID(), UUIDAdapter.AS_STRING).bind("someone"))
        // Insert the data
        .insert();

// Check that something changed
Assertions.assertTrue(change.changed());
// Check that two rows were added
Assertions.assertEquals(change.rows(), 1);
```

### Batch

Execute multiple inserts.

```java
// Insert multiple entries at the same time
ManipulationBatchResult change = query
        // Define the query
        .query("INSERT INTO users(uuid, name) VALUES(?::uuid,?)")
        // Create a new batch call
        .batch(
                // Define the first call
                Call.of().bind(UUID.randomUUID(), UUIDAdapter.AS_STRING).bind("someone"),
                // Define the second call
                Call.of().bind(UUID.randomUUID(), UUIDAdapter.AS_STRING).bind("someone else"))
        // Insert the data
        .insert();

// Check that something changed
Assertions.assertTrue(change.changed());
// Check that two rows were added
Assertions.assertEquals(2, change.rows());

// Check how many rows for each batch execution were changed
for (ManipulationResult result : change.results()) {
    Assertions.assertEquals(1, result.rows());
}
```

## Single transaction mode

To execute queries in a single transaction you need to create a connected configuration.
The connected configuration has to be used in a try with resources.

```java
// atomic transaction
try (var conn = query.withSingleTransaction()) {
    // Retrieve the first user and store them it to use it again later
    // From here on another query could be issued that uses the results of this query
    ManipulationResult manipulation = conn.query("INSERT INTO users(uuid, name) VALUES (:uuid::uuid, :name) RETURNING id, uuid, name")
            .single(Calls.single(call -> call.bind("uuid", UUID.randomUUID(), AS_STRING).bind("name", "lilly")))
            .map(User::map)
            .storeOneAndAppend("user")
            .query("INSERT INTO birthdays(user_id, birth_date) VALUES (:id, :date)")
            // produce error
            .single(storage -> Calls.single(r -> r.bind("id", storage.getAs("user", User.class).get().id()).bind("date", "")))
            .insert();
}

List<User> users = query.query("SELECT * FROM users")
        .single(Calls.empty())
        .map(User::map)
        .allAndGet();

// Make sure that the first insert was not commited
Assertions.assertEquals(0, users.size());
}
```

## Query Storage

As you can see in the previous example we store the result of the first query and access it in the second one.

Another good example for that is this query:

```java
// Retrieve the first user and store them it to use it again later
// From here on another query could be issued that uses the results of this query
ManipulationResult manipulation = query.query("INSERT INTO users(uuid, name) VALUES (:uuid::uuid, :name) RETURNING id, uuid, name")
        .single(Calls.single(call -> call.bind("uuid", UUID.randomUUID(), AS_STRING).bind("name", "lilly")))
        .map(User.map())
        .storeOneAndAppend("user")
        .query("INSERT INTO birthdays(user_id, birth_date) VALUES (:id, :date)")
        .single(storage -> Calls.single(r -> r.bind("id", storage.getAs("user", User.class).get().id()).bind("date", LocalDate.of(1990, 1, 1))))
        .insert();
```

It inserts a user into the user table and use the returned id directly to insert something with it into another table.
