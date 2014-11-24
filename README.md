# Sample Docker Stack

This is an attempt to create a multi-container Docker setup that resembles a
production web app. A front-end web server acts as a reverse proxy and load
balancer for several back-end servers (in this case, four of them), which
themselves access a shared cache / database.

Three containers are employed. Nginx acts as the front-end server, a basic
Python app provides the back-end server, and Redis is used for the cache.

```
                            +------------------+
                       +--> | back-end server  |---+
                       |    | (Python / Flask) |   |
                       |    +------------------+   |
                       |                           |
                       |    +------------------+   |
                       +--> | back-end server  |---+
+------------------+   |    | (Python / Flask) |   |    +------------------+
| front-end server |---+    +------------------+   +--> | cache / database |
| (Nginx)          |   |                           |    |     (Redis)      |
+------------------+   |    +------------------+   |    +------------------+
                       +--> | back-end server  |---+
                       |    | (Python / Flask) |   |
                       |    +------------------+   |
                       |                           |
                       |    +-------------------   |
                       +--> | back-end server  |---+
                            | (Python / Flask) |
                            +------------------+
```

The Redis container is the
[unmodified image](https://registry.hub.docker.com/_/redis/) provided by the
official Docker Hub Registry. We supply custom Dockerfiles for the front-end
and back-end servers, though they inherit from other official images themselves
and are minimal.


## Linking

One advantage of Docker is that containers are isolated from each other unless
explicitly linked together. For example, Nginx cannot talk directly to Redis,
nor can any other process. Only the back-end servers can access the database,
minimizing unexpected interference.

The containers in this project are linked thus: Nginx -> Python -> Redis

Only port 8000, which hits the front-end server, is exposed to the outside
world. In production we'd make this port 80.


# Running

A Vagrantfile is provided. After creating the virtual machine it downloads and
installs Docker then builds and runs the Docker containers. This takes a long
time. Once ready, access the web server via http://localhost:8000. Subsequent
visits demonstrates the database connection working.
