# Migrate from queries v1 to v2

Queries 2 is a complete replacement for the old queries module.
While it is the successor, there are some features that are not implemented on purpose in v2.

## Migrating QueryFactory and QueryBuilderConfig

The functionality of the `QueryFactory` and `QueryBuilderConfig` are merged into `QueryConfiguration`.

The `builder()` method is now either `Query.query(String)` or `QueryConfiguration#query(String)`.

## Migrating calls to builder()

The type is no longer declared in `builder()`. Just remove it.

## Migrating calls to query()

Nothing changed for passing queries.

## Migrating getKey()

the getKey Option is now available via the insertAndGetKeys method. All keys will always be resolved.

## Migrating async calls

It wasn't really the scope to support threading in sadu.
Therefore, this feature was removed.
Use Completable futures yourself on the correct level to restore that functionality.

## Migrating atomic multi query calls

v1 executed all appended queries in one transaction, v2 doesn't do this anymore.
To do this you have to create a connected configuration.
Look at the [examples](examples.md#single-transaction-mode) for that.

## Regex migration

You can speed up migration by a lot using these regular expressions:

| Replace                                                                 | Replacement                                                                                                           |
|-------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| `builder\(.*?\)\s*\.`                                                   | ` ` (this is a space)                                                                                                 |
| `\.(setInt\|setString\|setLong\|\|setBoolean\|setEnum\|setTimestamp)\(` | `.bind(`                                                                                                              |
| `\.parameter\(\w+ -> \w+`                                               | `.single(call()`                                                                                                      |
| `\.setUuidAsBytes\((.+?)\)`                                             | `.bind($1, UUID_BYTES)`                                                                                               |
| `getUuidFromBytes\((.*?)\)`                                             | `get($1, UUID_BYTES)`                                                                                                 |
| `\s*\.sendSync\(\)`                                                     | ` ` (this is a space)                                                                                                 |
| `readRow`                                                               | `map`                                                                                                                 |
| `firstSync`                                                             | `first`                                                                                                               |
| `allSync`                                                               | `all`                                                                                                                 |
| `queryWithoutParams\((.+?)\)`                                           | `query($1).single()`                                                                                                  |
| `de.chojo.sadu.wrapper.util.Row`                                        | `de.chojo.sadu.mapper.wrapper.Row`                                                                                    |
| `emptyParams\(\)`                                                       | `single()`                                                                                                            |
| `extends QueryFactory`                                                  | ` ` (this is empty)                                                                                                   |
| `import de.chojo.sadu.base.QueryFactory;`                               | `import static de.chojo.sadu.queries.api.call.Call.call;\nimport static de.chojo.sadu.queries.api.query.Query.query;` |

### Python script

To make your life easier, I created an extensive python script, that does 95% of the work for you.

Copy it into the root of your project and execute it. Of course, it requires python to be installed.


<details>
<summary>Script</summary>

```python
import os
import re
import sys


def add_import(curr: str, append):
    return re.sub(r"(package .+?;)", r"\1\n" + append, curr)


def replace_in_files(folder):
    replacements = {
        r'builder\((?:.*?\.class)?\)\s*\.':
            ['',
             lambda x: add_import(x, 'import static de.chojo.sadu.queries.api.query.Query.query;')],
        r'\.(setInt|setString|setLong|setBoolean|setDouble|setEnum|setTimestamp)\(': '.bind(',
        r'\.parameter\(\w+ -> \w+':
            ['.single(call()',
             lambda x: add_import(x, "import static de.chojo.sadu.queries.api.call.Call.call;")],
        r'\.setUuidAsBytes\((.+?(?:\(\))?)\)':
            [r'.bind(\1, UUID_BYTES)',
             lambda x: add_import(x,
                                  "import static de.chojo.sadu.queries.converter.StandardValueConverter.UUID_BYTES;")],
        r'getUuidFromBytes\((.*?)\)':
            [r'get(\1, UUID_BYTES)',
             lambda x: add_import(x,
                                  "import static de.chojo.sadu.queries.converter.StandardValueConverter.UUID_BYTES;")],
        r'\s*\.sendSync\(\)': ' ',
        r'\.all\((.*?(\(\)?))\)': '.all() /* TODO: Wrap with CompletableFuture.supplyAsync */',
        r'\.first\(\)': '.first() /* TODO: Wrap with CompletableFuture.supplyAsync */',
        r'readRow': 'map',
        r'firstSync': 'first',
        r'allSync': 'all',
        r'queryWithoutParams\((.+?)\)': r'query(\1).single()',
        r'de\.chojo\.sadu\.wrapper\.util\.Row': 'de.chojo.sadu.mapper.wrapper.Row',
        r'emptyParams\(\)': 'single()',
        r'extends QueryFactory': '',
        r'import de\.chojo\.sadu\.base\.QueryFactory;': '',
        r'import de.chojo.sadu.wrapper.QueryBuilderConfig;': '',
        r'.append()': '.append() /* TODO: Append is no longer supported.\nUse a single transaction configuration instead. https://sadu.docs.chojo.dev/queries/examples/#single-transaction-mode.\nIf you are submitting in a for loop consider a batch statement instead. https://sadu.docs.chojo.dev/queries/components/#__tabbed_3_3*/',
        r'de.chojo.sadu.databases.SqLite': 'de.chojo.sadu.sqlite.databases.SqLite',
        r'de.chojo.sadu.databases.MariaDb': 'de.chojo.sadu.mariadb.databases.MariaDb',
        r'de.chojo.sadu.databases.PostgreSql': 'de.chojo.sadu.postgresql.databases.PostgreSql',
        r'de.chojo.sadu.databases.MySql': 'de.chojo.sadu.mysql.databases.MySql',
    }

    for subdir, dirs, files in os.walk(folder):
        for file in files:
            if file.endswith('.java'):
                file_path = subdir + os.sep + file
                with open(file_path, 'r') as f:
                    file_contents = f.read()
                for src, target in replacements.items():
                    if isinstance(target, str):
                        file_contents = re.sub(src, target, file_contents)
                    if isinstance(target, list):
                        before = hash(file_contents)
                        file_contents = re.sub(src, target[0], file_contents)
                        after = hash(file_contents)
                        if len(target) > 1 and before != after:
                            file_contents = target[1](file_contents)

                with open(file_path, 'w') as f:
                    f.write(file_contents)


if len(sys.argv) > 1:
    folder = sys.argv[1]
else:
    folder = os.getcwd()
replace_in_files(folder)
```

</details>
