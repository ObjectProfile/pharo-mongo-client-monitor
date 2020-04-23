# pharo-mongo-client-monitor

A visual monitor the Pharo client for Mongodb


# Installation

Evaluate the following script in a Pharo 8:

~~~Smalltalk
Metacello new
    baseline: 'MongoClientMonitor';
    repository: 'github://tinchodias/pharo-mongo-client-monitor';
    load.
~~~

It will load Mongo client and Roassal3 as dependencies.
