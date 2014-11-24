This is a basic Flask web server with one endpoint (the root). Each visit
increments a hit counter stored in Redis. The Redis database isn't part of this
Docker container -- it's expected to run in a separate container which this
one links to. You can also set the `REDIS_PORT_6379_TCP_ADDR` and
`REDIS_PORT_6379_TCP_PORT` environment variables to the respective host address
and port of a Redis server running elsewhere.
