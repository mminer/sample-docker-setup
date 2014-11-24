"""Basic web server which increments a hit counter on each visit."""

import os
from flask import Flask
from redis import StrictRedis


app = Flask(__name__)

# Initialize Redis connection.
redis_host = os.environ['REDIS_PORT_6379_TCP_ADDR']
redis_port = int(os.environ['REDIS_PORT_6379_TCP_PORT'])
db = StrictRedis(host=redis_host, port=redis_port, db=0)


@app.route('/')
def index():
    hits = db.incr('hits')
    return 'This page has been accessed {0} times.'.format(hits)


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
