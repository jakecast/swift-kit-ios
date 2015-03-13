#!/bin/bash

project_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function main() {
    cd "$project_dir"
    mkdir -p "SwiftKit"
    cp -r "../../swiftkit-ios/SwiftKit" "SwiftKit/"
    cp -r "../../swiftkit-ios/SwiftKit.xcodeproj" "SwiftKit/"
}

main
