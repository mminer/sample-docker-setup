To set up Nginx as a reverse proxy, we need to add the addresses of the
back-end servers to its configuration when the container runs. This is what
`run.sh` does, pulling the dynamically assigned IP addresses of the back-end
servers from Docker environment variables.
