#!/bin/bash

if ! command -v mint &> /dev/null
then
    echo "Mint could not be found. Please install it first: https://github.com/yonaskolb/Mint#installing"
    exit
fi

# Use SwiftyBridges to generate server and client communication code:
echo "This script may take several minutes on first run."
mint run SwiftyBridges/SwiftyBridgesVapor@0.1.2 Sources/App --server-output Sources/App/Generated/Generated.swift --client-output ../IceCreamCustomer/IceCreamCustomer/API/Generated.swift

# Copy API structs to client:
cp Sources/App/APIs/APIData.swift ../IceCreamCustomer/IceCreamCustomer/API
