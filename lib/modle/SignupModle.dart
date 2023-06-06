class SignupModle {
  String? _fullname;
  String? _username;
  String? _password;
  String? _cPassword;
  DateTime? _dob;
  String? _userType;

  SignupModle(this._fullname, this._username, this._password, this._cPassword,
      this._dob, this._userType);

  get fullname => _fullname;
  set fullname(value) => _fullname = value;

  get username => _username;
  set username(value) => _username = value;

  get password => _password;
  set password(value) => _password = value;

  get cPassword => _cPassword;
  set cPassword(value) => _cPassword = value;

  get dob => _dob;
  set dob(value) => _dob = value;

  get userType => _userType;
  set userType(value) => _userType = value;
}
