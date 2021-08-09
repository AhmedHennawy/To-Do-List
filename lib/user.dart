class User
{
  String _username;
  String _pass;
  int _id;
  User(this._username,this._pass);
  String get username =>_username;
  String get password => _pass;
  int get id => _id;
  User.map(dynamic obj){
    this._username = obj["username"];
    this._pass = obj["password"];
    this._id = obj["id"];
  }
  Map<String,dynamic> toMap(){
    var m = new Map<String,dynamic>();
    
    m["password"] = _pass;
    m["username"] = _username;
    if(id != null)
    {m["id"] = _id;}
    return m;
  }
}