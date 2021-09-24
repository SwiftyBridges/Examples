# SwiftyBridges Examples

This repository contains a server app and a matching iOS app that use [SwiftyBridges](https://github.com/SwiftyBridges/SwiftyBridgesVapor) to communicate.

## IceCreamServer

IceCreamServer is a server written using [Vapor](https://vapor.codes/).

To run the server on the local machine, simply execute `./run.sh` in Terminal.

If you make changes to the API definitions or the data structures used by them, just run `./generate-code.sh`.
This will invoke SwiftyBridges to generate new code for both server and client.
Additionally, `APIData.swift` containing the data structures used by the API definitions will be copied to the client project.

## IceCreamCustomer

IceCreamCustomer is an iOS app acting as a client to the server.

To ensure that it finds the local server, run it in Simulator.
