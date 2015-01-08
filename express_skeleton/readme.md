Express Skeleton
====================

This is a bare-bones implementation of the express module intended to test the limits of Express.

#### Install

    npm install

#### Start Server

    node express-skeleton.js

### Examples

Express appears to behave very poorly with file uploads of a particular file: `bad.tif`

    curl -d "Filedata=@bad.tif" http://localhost:8000/files/upload

Watch the effects on memory and event loop lag

* `event_loop_lag` - lag time between when a function in the event loop queue should get executed and when it does get executed.
* `estimated_base` - Estimated memory base size as measured by memwatch. Measurement taken on every garbage collection.
* `HeapDiff_change` - Byte sized change in heap between measurements taken on every garbage collection.

Additional Notes

* [event_loop_lag documentation](https://www.npmjs.com/package/event-loop-lag)
* [memwatch documentation](https://www.npmjs.com/package/memwatch)
