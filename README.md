# pharo-mongo-client-monitor [![Build Status](https://travis-ci.org/tinchodias/pharo-mongo-client-monitor.png)](http://travis-ci.org/tinchodias/pharo-mongo-client-monitor)


A visual monitor the [Pharo client](https://github.com/pharo-nosql/mongotalk) for [Mongodb](https://www.mongodb.com/).


# Installation

Evaluate the following script in a Pharo 8:

~~~Smalltalk
Metacello new
    baseline: 'MongoClientMonitor';
    repository: 'github://tinchodias/pharo-mongo-client-monitor';
    load.
~~~

It will load Mongo client and Roassal3 as dependencies.

**IMPORTANT:** You need to install a recent version such as 4.0 of mongodb and evaluate:
~~~Smalltalk
MongoTestServer mongodPathString: '<PATH_TO_MONGODB>/bin/mongod'.
~~~
