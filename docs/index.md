{{ version }}

# SADU - SQL and damn Utilities

## [Javadocs](https://rainbowdashlabs.github.io/sadu/)

This project contains serveral things that were found useful when working with sql.

SADU is divided in several subprojects which allow to only import what you need. You find the documentation for the subprojects in the top nav bar.

SADU is by far not a replacement for large Frameworks like Hibernate, JPA or others, but a solid ground to reduce boilerplate code when
you work with plain SQL like I do most of the time.

## Dependency

If you want to use all projects simply import the whole thing.

```java
dependencies {   
    implementation("de.chojo.sadu", "sadu", "version")
}
```

!!! warning "Warning"

    Usage of this super module is discouraged and exists purely for testing and evaluation.
    It should not be used in an production environment.
    Import the specific modules you need instead

## Database dependencies

SADU offers support for four different databases at the moment. Import the modules you need like this:

<!-- @formatter:off -->

!!! note

    Learn more about types at the [types page](types/index.md)

!!! warning

    The database modules contain only database specific information for the other modules. You still need to explicitly import other modules like the queries and data source modules.

=== "postgres"
    ```java
    dependencies {   
        implementation("de.chojo.sadu", "sadu-postgresql", "version")
    }
    ```
=== "mariadb"
    ```java
    dependencies {   
        implementation("de.chojo.sadu", "sadu-mariadb", "version")
    }
    ```
=== "mysql"
    ```java
    dependencies {   
        implementation("de.chojo.sadu", "sadu-mysql", "version")
    }
    ```
=== "sqlite"
    ```java
    dependencies {   
        implementation("de.chojo.sadu", "sadu-sqlite", "version")
    }
    ```
