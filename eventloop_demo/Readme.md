Recursive Callback
----

### Description

Simple practical demo of event loops in node. 2 scripts each calculate the factorial of every number up to a number provided as an argument. Each script has a different implementation of factorial:

1. Calculating each step using recursion starting from the end case and returning back to the top of the stack. This is the common implementation in every introductory computer science courses.
2. Calculating each step and pushing the next step onto the event loop with setImmediate.

### Usage

To calculate factorials up to x!:

    node <script> <x>

### Example

Calculating factorials up to 3!

    > node factorial_recursive.js 3
    2014-11-24T03:40:05.063Z - info: 0) Start 0!
    2014-11-24T03:40:05.074Z - info: 0) End 0! = 1
    2014-11-24T03:40:05.074Z - info: 1) Start 1!
    2014-11-24T03:40:05.074Z - info: 1) End 1! = 1
    2014-11-24T03:40:05.074Z - info: 2) Start 2!
    2014-11-24T03:40:05.074Z - info: 2) End 2! = 2

    > node factorial_eventloop.js 3
    2014-11-24T03:39:49.127Z - info: 0) Start 0!
    2014-11-24T03:39:49.138Z - info: 0) End 0! = 1
    2014-11-24T03:39:49.138Z - info: 1) Start 1!
    2014-11-24T03:39:49.138Z - info: 2) Start 2!
    2014-11-24T03:39:49.139Z - info: 1) End 1! = 1
    2014-11-24T03:39:49.139Z - info: 2) End 2! = 2

To include more detail set environment variable `LOG_LEVEL=debug`

    > LOG_LEVEL=debug node factorial_recursive.js 3
    2014-11-24T03:43:38.538Z - info: 0) Start 0!
    2014-11-24T03:43:38.548Z - debug: 0) returning 1
    2014-11-24T03:43:38.549Z - info: 0) End 0! = 1
    2014-11-24T03:43:38.549Z - info: 1) Start 1!
    2014-11-24T03:43:38.549Z - debug: 1) calculating 1 * 0!
    2014-11-24T03:43:38.549Z - debug: 1) returning 1
    2014-11-24T03:43:38.549Z - info: 1) End 1! = 1
    2014-11-24T03:43:38.549Z - info: 2) Start 2!
    2014-11-24T03:43:38.549Z - debug: 2) calculating 2 * 1!
    2014-11-24T03:43:38.549Z - debug: 2) calculating 1 * 0!
    2014-11-24T03:43:38.549Z - debug: 2) returning 1
    2014-11-24T03:43:38.549Z - info: 2) End 2! = 2
