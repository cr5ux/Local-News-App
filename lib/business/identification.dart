class Identification
{
  String userID="";
  bool isAdmin=false;
 
  static final Identification _instance = Identification._internal();

  factory Identification() {
    return _instance;
  }

  Identification._internal();

  
  
}