# Custom Mapper

For creating a custom mapper we have two approaches.
One approach is a more manual way, while the second approach is an annotation based way.

For our example we will use this class:

```java
public class MappedClass {

    String test;

    public MappedClass(String test) {
        this.test = test;
    }
}
```

## Manual way

The manual way requires us to create a RowMapper for each class we want to map and register it manually.

```java
RowMapperRegistry registry = new RowMapperRegistry();
RowMapper<MappedClass> mapper = RowMapper.forClass(MappedClass.class)
        .mapper(row -> new MappedClass(row.getString("test")))
        .addColumn("test")
        .build();
registry.register(mapper);
```

The column call should add all columns that need to be present for the row mapper to map the row.
Multiple row mappers can exist for the same class, requiring different amounts of rows.
If a row mapper has zero columns it is considered a wildcard and will be used when no other matching mapper is found.

## Annotation Based

Instead of manually registering all classes at the mapper registry, you can use an annotation based approach.

Annotated classes don't need to be registered at startup. They will be registered when first being serialized.

Annotations can be either be attached to a static method that returns a `RowMapping` or a constructor that accepts a `Row` as input parameter.

=== "Static Method"
    
    The annotation is added to a static method that returns a `RowMapping` for this class.
    The annotation also signals that a single column named "test" is required.
    ```java
    public class MappedClass {
    
        String test;
    
        public MappedClass(String test) {
            this.test = test;
        }
        
        @MappingProvider({"test"})
        public static RowMapping<MappedClass> map() {
            return row -> new MappedClass(row.getString("test"));
        }
    }
    ```

=== "Constructor" 

    The annotation is added to a constructor that accepts a single argument of type Row.
    The annotation also signals that a single column named "test" is required.

    ```java
    public class MappedClass {
    
        String test;
    
        @MappingProvider({"test"})
        public MappedClass(Row row) throws SQLException {
            test = row.getString("test");
        }
        
        public MappedClass(String test) {
            this.test = test;
        }
    }
    ```
