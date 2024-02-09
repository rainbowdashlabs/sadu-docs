# Updater

{{ version }}

SADU provides a database updater which deploys patch to your database. Which scripts are deployed is defined by a database version in
the database itself and in your project.

The patches are semi failsave. If one of the queries fails the upgrade will be aborted. This avoids that the database ends up in a
partially migrated state.

```js
dependencies {
    implementation("de.chojo.sadu", "sadu-updater", "<version>")
}
```

{{ type_selection }}
