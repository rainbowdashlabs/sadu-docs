# Testing

{{ version }}

The testing module provides a simple way to validate integrity of you patch files for the updater.
It makes use of junit and allows quick assertions for all your files.
Import it into your project to use it.

```java
dependencies {
    implementation("de.chojo.sadu", "sadu-testing", "<version>")
}
```

## Usage

To use it create a unit test with junit and simply call the SaduTests class:

```java
public class SaduTest {
    @Test
    public void checkDatabase() throws IOException {
        SaduTests.execute(1, PostgreSql.get());
    }
}
```

Add all the databases you use here.

The test will:

- Ensure that all database directories are there
- All setup files are there
- All migration files are there
- All patches between base and current version are there
