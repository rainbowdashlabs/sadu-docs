# Migrating to a major version

At some point you probably want a fresh start and not deploy 20 patches everytime your setup your database again.

That's where the migration files comes in handy. Add a new version directory `/2/`. Add a `migrate.sql` script to
your old version. Add a `/2/setup.sql` script which represents the state of the database after a successful migration.

```
resources
  database
    postgresql
      1
        setup.sql
        patch_1.sql
        patch_2.sql
        patch_3.sql
        patch_4.sql     # Patch for 1.4
        migrate.sql     # Migration from 1.4 to 2.0
      2
        setup.sql       # Setup for 2.0
        patch_1.sql     # Patch for 2.1
    version             # The version is now 2.1
```

This is what the updater will do when encountering a database with version 1.3.

1. Compare the versions
2. Load all patches after the 1.3 patch (`/1/patch_4.sql`)
3. Execute the patches
4. Load the `/1/migrate.sql` script
5. Execute the migration
6. Load all patches after 2.0 (`/2/patch_1.sql`)
7. Execute all patches

!!! note
    
    The `/1/migrate.sql` needs to create the same state as the `/2/setup.sql`

!!! Note

    When a basic setup would be performed now, the updater would skip everything in `/1/` and directly deploy `/2/setup.sql`.
