// Handle Errors that are generated accross the application

class AppError {
  final String message;
  final int statusCode;

  AppError(
      [this.message = "Sorry, an unexpected error occurred",
      this.statusCode = 500]);

  @override
  String toString() => 'AppError(message: $message)';
}

// TODO 1. seal class to handle various errors
