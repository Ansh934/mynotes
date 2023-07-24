//REGISTER
class EmailAlreadyInUseAuthException implements Exception {}

//REGISTER & lOGIN
class InvalidEmailAuthException implements Exception {}

//REGISTER
class OperationNotAllowedAuthException implements Exception {}

//REGISTER
class WeakPasswordAuthException implements Exception {}

//LOGIN
class UserDisabledAuthException implements Exception {}

//LOGIN
class UserNotFoundAuthException implements Exception {}

//LOGIN
class WrongPasswordAuthException implements Exception {}

//EMAIL-VERIFICATION
class TooManyRequestsAuthException implements Exception {}

//GENERAL
class GenericAuthException implements Exception {}

//USER
class UserNotLoggedInAuthException implements Exception {}
