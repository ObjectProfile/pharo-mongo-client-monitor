# Pharo MongoClientMonitor

[![Build Status](https://travis-ci.org/tinchodias/pharo-mongo-client-monitor.png)](http://travis-ci.org/tinchodias/pharo-mongo-client-monitor)


A visual monitor for the [Pharo client](https://github.com/pharo-nosql/mongotalk) of [Mongodb](https://www.mongodb.com/).

:warning: WORK IN PROGRESS :warning:

# Installation

1. Download a Pharo 8 with latest headless vm:
~~~
curl https://get.pharo.org/64/80+vmHeadlessLatest | bash
~~~

2. Evaluate the following script:
~~~Smalltalk
Metacello new
    baseline: 'MongoClientMonitor';
    repository: 'github://tinchodias/pharo-mongo-client-monitor';
    load.
~~~
It will load Mongo client and Roassal3 as dependencies.

3. Install a recent version of mongodb, such as 4.0, and evaluate:
~~~Smalltalk
MongoTestServer mongodPathString: '<PATH_TO_MONGODB>/bin/mongod'.
~~~
