# SQL Types

{{ version }}

SADU has implementations for four different sql types. Simply import the artifact you need into your project.

```js
dependencies {
    implementation("de.chojo.sadu", "sadu-postgresql", "<version>")
    implementation("de.chojo.sadu", "sadu-mariadb", "<version>")
    implementation("de.chojo.sadu", "sadu-mysql", "<version>")
    implementation("de.chojo.sadu", "sadu-sqlite", "<version>")
}
```

The type itself can be retrieved from the type class. Each typeclass provides one general getter via `Type.get()`
and one by its name via `Type.type()`.

=== "PostgreSQL"

    Adds support for PostgreSQL database
    
    ```js
    implementation("de.chojo.sadu", "sadu-postgresql", "<version>")
    ```

    Type Class: `Postgres`

=== "MariaDB"

    Adds support for MariaDB database
    
    ```js
    implementation("de.chojo.sadu", "sadu-mariadb", "<version>")
    ```
    
    Type Class: `MariaDb`

=== "MySQL"

    Adds support for MySQL database
    
    ```js
    implementation("de.chojo.sadu", "sadu-mysql", "<version>")
    ```
    
    Type Class: `MySql`

=== "SqLite"

    Adds support for SqLite database
    
    ```js
    implementation("de.chojo.sadu", "sadu-sqlite", "<version>")
    ```
    
    Type Class: `SqLite`
