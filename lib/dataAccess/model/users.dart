


class Users{

  final String userID;
  final String fullName;
  final DateTime birthday;
  final Map address; 
  final String phonenumber;
  final List<String> preferenceTags;
  final List<String> forbiddenTags;
  final String authUserID;
  final String email;
  final String password;

  Users({required this.userID, required this.fullName, required this.birthday, required this.address, required this.phonenumber, required this.preferenceTags, required this.forbiddenTags, required this.authUserID, required this.email, required this.password});

}