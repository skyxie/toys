Heil Hydra
----

Quick test of Typhoeus gem.
Uses unicorn to run server with multiple processes.
Uses Typhoeus gem to run parallel requests to server.

To run the server:

    unicorn -c config

To change the number of parallel servers, adjust config.

To run hydra script

    ./heil_hydra.rb --url localhost:8080/5 --timeouts 3,4,5,6,7

