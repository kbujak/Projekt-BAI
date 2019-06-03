class User {
  String _displayName, _email, _photoURL, _uid;


  String get displayName => _displayName;

  set displayName(String value) {
    _displayName = value;
  }

  User(String email, String photoUrl) {
    this._email = email;
    this._photoURL = photoUrl;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  get photoURL => _photoURL;

  set photoURL(value) {
    _photoURL = value;
  }

  get uid => _uid;

  set uid(value) {
    _uid = value;
  }
}