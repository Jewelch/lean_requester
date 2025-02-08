<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Dart HTTP Requester Library

This package provides a robust and flexible HTTP requester built on top of the Dio library. It includes features such as caching, mocking, and retry mechanisms, making it suitable for applications that require efficient data handling and network communication.

## Features

- **Advanced Request Handling**: Supports various HTTP methods (GET, POST, PUT, DELETE, PATCH).
- **Caching**: Automatically caches responses for efficient data retrieval.
- **Mocking**: Allows for easy mocking of responses during development and testing.
- **Retry Mechanism**: Configurable retry logic for failed requests.
- **Data Models**: Utilizes Data Access Objects (DAOs) and Data Transfer Objects (DTOs) for structured data management.
- **Error Handling**: Comprehensive error handling with custom exceptions.

## Getting Started

### Prerequisites

- Dart SDK (version 2.12 or higher)
- Dio package

### Installation

Add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  your_package_name: ^1.0.0
```

Then, run the following command to install the package:

```bash
flutter pub get
```

## Usage

Here's a simple example of how to use the library to make a GET request:

```dart
import 'package:your_package_name/requester.dart';

void main() async {
  final requester = _LeanRequester(dio, cacheManager, connectivityMonitor);
  
  try {
    final response = await requester.request(
      dao: YourDao(),
      path: '/your/api/endpoint',
      method: RestfulMethods.get,
      cachingKey: 'your_cache_key',
    );
    print(response);
  } catch (e) {
    print('Error: $e');
  }
}
```

For more detailed examples, check the `/example` folder.

## Additional Information

For more information about the package, including advanced usage and configuration options, please refer to the following resources:

- [Dio Documentation](https://pub.dev/packages/dio)
- [Dart Language Documentation](https://dart.dev/guides)
- [Contributing Guidelines](CONTRIBUTING.md)

### Contributing

Contributions are welcome! If you would like to contribute to this package, please fork the repository and submit a pull request. You can also open issues for any bugs or feature requests.

### License

This project is licensed under the MIT License. See the LICENSE file for details.
