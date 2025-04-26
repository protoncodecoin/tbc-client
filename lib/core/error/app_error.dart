// Handle Errors that are generated accross the application

// TODO: Add status code field
class AppError {
  final String message;

  AppError([this.message = "Sorry, an unexpected error occurred"]);

  @override
  String toString() => 'AppError(message: $message)';
}

// TODO 1. seal class to handle various errors
