class Identification
{
  String userID="";
  bool isAdmin=false;
  String email="";
 
  static final Identification _instance = Identification._internal();

  factory Identification() {
    return _instance;
  }

  Identification._internal();

  
  
}