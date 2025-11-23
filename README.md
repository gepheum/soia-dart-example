# Soia Dart example

Example showing how to use soia's [Dart code generator](https://github.com/gepheum/soia-dart-gen) in a project.

## Build and run the example

```shell
# Download this repository
git clone https://github.com/gepheum/soia-dart-example.git

cd soia-dart-example

# Install all dependencies, which include the soia compiler and the soia
# Dart code generator
npm i

npm run run:snippets
# Same as:
#   npm run build  # .soia to .dart codegen
#   dart run bin/snippets.dart
```

### Start a soia service

From one process, run:
```shell
npm run run:start-service
#  Same as:
#    npm run build
#    dart run bin/start_service.dart
```

From another process, run:
```shell
npm run run:call-service
#  Same as:
#    npm run build
#    dart run bin/call_service.dart
```

