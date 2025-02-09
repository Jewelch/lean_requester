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

## Table of Contents
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Core Components](#core-components)
  - [Request Base](#request-base)
  - [Request Mixin](#request-mixin)
  - [Requester](#requester)
  - [Transformer](#transformer)
- [Data Models](#data-models)
  - [DAO and DTO](#dao-and-dto)
  - [Data Handling](#data-handling)
- [Error Handling](#error-handling)
- [Retry Mechanism](#retry-mechanism)
- [Enums](#enums)
- [Typedefs](#typedefs)
- [Implementation Examples](#implementation-examples)
  - [Setting Up the Requester](#setting-up-the-requester)
  - [Implementing a Use Case](#implementing-a-use-case)
- [Additional Information](#additional-information)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Advanced Request Handling**: Supports various HTTP methods (GET, POST, PUT, DELETE, PATCH) to interact with RESTful APIs.
- **Caching**: Automatically caches responses for efficient data retrieval, reducing the need for repeated network calls.
- **Mocking**: Allows for easy mocking of responses during development and testing, enabling developers to simulate API behavior without actual network requests.
- **Retry Mechanism**: Configurable retry logic for failed requests, allowing for resilience in network communication.
- **Data Models**: Utilizes Data Access Objects (DAOs) and Data Transfer Objects (DTOs) for structured data management, ensuring type safety and clarity.
- **Error Handling**: Comprehensive error handling with custom exceptions to manage various failure scenarios gracefully.

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

## Core Components

### Request Base
The `LeanRequesterBase` class serves as the foundation for making HTTP requests. It encapsulates the configuration of Dio, including timeouts, content types, and default headers. This class provides a centralized way to manage request settings.

```dart
class LeanRequesterBase {
  // Configuration for timeouts and content types
}
```

### Request Mixin
The `LeanRequesterMixin` provides methods for making requests, handling retries, and managing connectivity checks. It integrates with the base request class to enhance functionality, allowing for a more modular approach to request handling.

```dart
mixin LeanRequesterMixin on LeanRequesterBase {
  Future<R> request<R, M extends DAO>({ /* parameters */ }) async {
    // Logic for making requests and handling retries
  }
}
```

### Requester
The `_LeanRequester` class combines the base and mixin to create a complete requester that can be used throughout the application. This class is the main entry point for making HTTP requests.

```dart
class _LeanRequester extends LeanRequesterBase with LeanRequesterMixin {
  // Combines base and mixin functionalities
}
```

### Transformer
The `LeanTransformer` class is responsible for transforming responses and caching data. It handles both synchronous and asynchronous data processing, ensuring that data is correctly serialized and deserialized.

```dart
final class LeanTransformer<R, M extends DAO> extends FullSyncTransformer {
  // Logic for transforming and caching data
}
```

## Data Models

### DAO and DTO
Data Access Objects (DAOs) and Data Transfer Objects (DTOs) are used to represent and manipulate data structures. The `DAO` interface defines methods for JSON serialization and deserialization, ensuring that data can be easily converted to and from JSON format.

```dart
abstract class DAO<T> {
  T fromJson(dynamic json);
  Map<String, dynamic> toJson();
}
```

### Data Handling
The `DaoList` class manages lists of DAOs, providing methods for JSON conversion and data manipulation. This class ensures that collections of data are handled consistently and efficiently.

```dart
final class DaoList<M extends DAO> extends DAO {
  // Logic for managing lists of DAOs
}
```

## Error Handling
The project includes custom error classes to handle various exceptions that may occur during data processing and network requests. This allows developers to manage errors gracefully and provide meaningful feedback to users.

```dart
class ServerException implements Exception {
  // Custom exception for server errors
}
```

## Retry Mechanism

The system implements a retry mechanism for network requests to handle transient errors effectively. This mechanism is designed to automatically retry failed requests a specified number of times before giving up.

### Exponential Backoff Strategy

To avoid overwhelming the server during retries, an exponential backoff strategy is employed. The delay between each retry increases exponentially based on the number of attempts made. The delay is calculated using the following formula:

```
delay = (1 << (attempt - 1)) * retryDelayMs
```

Where:
- `attempt` is the current retry attempt number (starting from 1).
- `retryDelayMs` is the base delay in milliseconds.

### Delay Calculations

Here are the calculated delays for each retry attempt:

- **Attempt 1**: `1 * retryDelayMs` (e.g., 1000 ms)
- **Attempt 2**: `2 * retryDelayMs` (e.g., 2000 ms)
- **Attempt 3**: `4 * retryDelayMs` (e.g., 4000 ms)
- **Attempt 4**: `8 * retryDelayMs` (e.g., 8000 ms)
- **Attempt 5**: `16 * retryDelayMs` (e.g., 16000 ms)
- **Attempt 6**: `32 * retryDelayMs` (e.g., 32000 ms)

### Example

If `retryDelayMs` is set to `1000` ms (1 second), the delays for each attempt would be:

- **Attempt 1**: 1000 ms (1 second)
- **Attempt 2**: 2000 ms (2 seconds)
- **Attempt 3**: 4000 ms (4 seconds)
- **Attempt 4**: 8000 ms (8 seconds)
- **Attempt 5**: 16000 ms (16 seconds)
- **Attempt 6**: 32000 ms (32 seconds)

This strategy helps to manage network load and increases the chances of successful requests in the face of temporary issues.

## Enums
The `RestfulMethods` enum defines the HTTP methods supported by the library, providing a clear and type-safe way to specify the method for each request.

```dart
enum RestfulMethods {
  get("GET"),
  post("POST"),
  // Other methods
}
```

## Typedefs
Typedefs are used to simplify function signatures and improve code readability. They provide a way to define common function types that can be reused throughout the codebase.

```dart
typedef DataSourceSingleResult<M extends DAO> = Future<M>;
```

## Implementation Examples

### Setting Up the Requester
To set up the requester, you can create an abstract base class that extends `LeanRequester`. This class will configure the Dio client, caching manager, and connectivity monitor.

```dart
import 'package:lean_requester/datasource_exp.dart';
import '../app/environment/app_environment.dart';

export 'package:cg_core_defs/cg_core_defs.dart' show CacheManager, ConnectivityMonitor;
export 'package:lean_requester/datasource_exp.dart';
export 'package:lean_requester/models_exp.dart';

abstract base class LeanRequesterConfig extends LeanRequester {
  LeanRequesterConfig(
    super.dio,
    super.cacheManager,
    super.connectivityMonitor,
  );

  @override
  int get maxRetriesPerRequest => 2;

  @override
  BaseOptions baseOptions = BaseOptions(
    baseUrl: AppEnvironment.current.baseUrl,
    connectTimeout: Duration(milliseconds: AppEnvironment.current.connectTimeout),
    sendTimeout: Duration(milliseconds: AppEnvironment.current.sendTimeout),
    receiveTimeout: Duration(milliseconds: AppEnvironment.current.receiveTimeout),
    contentType: ContentType.json.mimeType,
  );

  @override
  QueuedInterceptorsWrapper? queuedInterceptorsWrapper = QueuedInterceptorsWrapper(
    onRequest: (options, handler) {
      handler.next(options);
    },
    onResponse: (response, handler) {
      handler.next(response);
    },
    onError: (error, handler) {
      handler.next(error);
    },
  );
}
```

### Implementing a Use Case
To implement a specific use case, such as fetching a product by its ID, you can create a data source class that extends the `LeanRequesterConfig` class.

```dart
import '../../../../api/data_source.dart';
import '../models/product_model.dart';

abstract interface class ProductDataSource {
  /// Calls the https://dummyjson.com/products/{id} endpoint.
  DataSourceSingleResult<ProductModel> getProductById(String id);
}

final class ProductDataSourceImpl extends LeanRequesterConfig implements ProductDataSource {
  ProductDataSourceImpl({
    required Dio client,
    required CacheManager cacheManager,
    required ConnectivityMonitor connectivityMonitor,
  }) : super(client, cacheManager, connectivityMonitor);

  @override
  DataSourceSingleResult<ProductModel> getProductById(String id) async => await request(
        dao: ProductModel(),
        method: RestfulMethods.get,
        path: "products/$id",
        cachingKey: "productKey",
        mockingData: _mockProductData,
        mockIt: false,
      );

  Map<String, dynamic> get _mockProductData => {
        "id": 2,
        "title": "iPhone de Zahra",
        "description":
            "SIM-Free, Model A19211 6.5-inch Super Retina HD display with OLED technology A12 Bionic chip...",
        "price": 899,
        "rating": 4.44,
        "stock": 34,
        "thumbnail":
            "https://content.kaspersky-labs.com/fm/press-releases/fb/fbc851c5d96f312341ef4430d7052abb/processed/holding-iphone-3-q75.jpg",
      };
}
```

## Additional Information

For more information about the package, including advanced usage and configuration options, please refer to the following resources:

- [Dio Documentation](https://pub.dev/packages/dio)
- [Dart Language Documentation](https://dart.dev/guides)
- [Contributing Guidelines](CONTRIBUTING.md)

### Contributing

Contributions are welcome! If you would like to contribute to this package, please fork the repository and submit a pull request. You can also open issues for any bugs or feature requests.

### License

This project is licensed under the MIT License. See the LICENSE file for details.
