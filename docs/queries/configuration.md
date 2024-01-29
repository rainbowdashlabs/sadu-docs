# Configuration

You can set a default configuration for the query builder.
That will make it much easier for us and will avoid of code repetitions.
The config will be applied to all created query builders.
No matter where or when they are created.

```java
import static org.slf4j.LoggerFactory.getLogger;

public class Main {
    private static final org.slf4j.Logger log = getLogger(Main.class);
    
    public static void main(String[] args) {
        QueryBuilderConfig.setDefault(QueryBuilderConfig.builder()
            .withExceptionHandler(err -> {
                log.error("An error occured during a database request",err);
            })
            .withExecutor(Executors.newCachedThreadPool())
            .build());
    }
}
```
## Executor
The excecutor for the completable futures can be set via `QueryBuilderConfig.Builder#withExecutor()`

## Exception handler
Make sure to add an exception handler. Otherwise error will be silent.

## Throwing

By default, the query builder will catch all SQL Exceptions and log them properly.\
If you want to log them by yourself you should call `QueryBuilderConfig.Builder#throwing()` on the builder. As an
alterantive you can set a LoggingAdapter in the `QueryBuilderConfig`

## Atomic Transaction

By default, the query builder will execute all queries in one atomic transaction. This has the effect, that the data will
only be changed if all queries were executed succesfully. This is especially usefull, when executing multiple queries.
If you don't want this call `QueryBuilderConfig.Builder#notAtomic()`. Tbh there is no real reason why you would want
this.
