# Mapping

{{ version }}

SADU provides a mapping module to easily register mappings from rows to java objects.
Import into your project to use it.

```java
dependencies {
    implementation("de.chojo.sadu", "sadu-mapping", "<version>")
}
```

Every class that has a registered row mapping can then be passed into the mapAs method during query retrieval.

```java
MappedClass methodMappedClass = query("Select 'test' as test")
        .single()
        .mapAs(MappedClass.class)
        .first()
        .get();
```
