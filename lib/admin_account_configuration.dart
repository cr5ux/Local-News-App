import 'package:flutter/material.dart';
import 'package:localnewsapp/constants/app_colors.dart';
// import 'package:localnewsapp/dataAccess/dto/user_basic.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';
import 'package:string_validator/string_validator.dart';

class AdminAccountConfiguration extends StatefulWidget {
  const AdminAccountConfiguration({super.key});

  @override
  State<AdminAccountConfiguration> createState() => _AdminAccountConfigurationState();
}

class _AdminAccountConfigurationState extends State<AdminAccountConfiguration> {




  // List<UsersBasic> admins=[];
  // List<UsersBasic> nonAdmins=[];

  List<String> selectedFromAdmins=[];
  List<String> selectedFromNonAdmins=[];

  final uR=UsersRepo();

  String _searchValue="";
  final _isSelecteda = {};
  final _isSelectedn = {};

  TextEditingController cont = TextEditingController();


  Future<List<dynamic>>  _loadAllAdmins() async
  {
    return uR.getAllAdmin();
  }
 Future<List<dynamic>> _loadAllNonAdmins(String searchValue) async
  {

    return searchValue.isNotEmpty?await uR.getAllNonAdmin(searchValue):[];

  }

  _checkPresence(valueToBeChecked, from) // 1 is selectedfromadmin      2 is selectedfromnonadmin
  {
    
    bool isFound=false; 

      
    for (var i  in from==1?selectedFromAdmins:selectedFromNonAdmins)
    {
        if(i==valueToBeChecked)
        {
          isFound=true;
          break;
        }
    }
      
       

     return isFound;

  }

  
  _removeItemFromList(value, from)
  {
 
      
      for (var i  in from==1?selectedFromAdmins:selectedFromNonAdmins)
      {
          
          if(i==value)
          {
                     
            from==1?selectedFromAdmins.remove(i):selectedFromNonAdmins.remove(i);
            
            break;
          }

        
      }

  }

  _addItemtoList(value, from)
  { 
    bool found=_checkPresence(value, from);
    if(!found)
    {
         from==1?selectedFromAdmins.add(value):selectedFromNonAdmins.add(value);
    }
    

  }

  _update()
  {
      setState(() {
          cont.clear();
      });

      if(selectedFromAdmins.isNotEmpty)
      {
         for(var i in selectedFromAdmins)
         {

             uR.updateAsAdminAccount(i, false);
             selectedFromAdmins.remove(i);
         }
      }
      if(selectedFromNonAdmins.isNotEmpty)
      {
         for(var i in selectedFromNonAdmins)
         {
            uR.updateAsAdminAccount(i, true);
            selectedFromNonAdmins.remove(i);

          
         }
      }


    
  }

    String? _validateEmail(String value){
    
    if(value.isEmpty)
    {
      return 'Item is Required';
    }
    else if(!value.isEmail)
    {
      return "Input needs to be email address";
    }
    return null;
   
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
              backgroundColor: AppColors.background,
              appBar: AppBar(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
              ),
              body:Column(
                  children: [

                      const Padding(padding: EdgeInsets.all(20.0)),
                      const Text("Non-Admins",style: TextStyle(fontSize: 18),),
                    
                              
                      TextFormField(
                        controller: cont,
                        decoration: const InputDecoration(
                              label: Text("Search "),
                              icon: Icon(Icons.search),
                              hintText: "email address"
                        ),
                        onChanged: (value){
                          setState(() {
                              _searchValue=value;
                          });
                        },
                        validator:(value)=>_validateEmail(value!) ,
                        
                      ),
                     FutureBuilder<List<dynamic>>(
                        future:_loadAllNonAdmins(_searchValue), 
                        builder: (context, snapshot)
                              {
                                 if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }

                                  if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  }

                                  if (!snapshot.hasData) {
                                    return const Center(child: Text('No articles available'));
                                  }
                                  return  ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount:snapshot.data!.length,
                                              itemBuilder: (context,index)
                                                        {
                                                          if (!_isSelectedn.containsKey(index)) _isSelectedn[index] = false; 
         
                                                            return ListTile(

                                                                    selected: _isSelectedn[index],
                                                                    selectedTileColor: AppColors.primary,
                                                                    selectedColor: AppColors.background,
                                                                    
                                                                    title: Text(snapshot.data![index].fullName),
                                                                    subtitle: Text(snapshot.data![index].email),
                                                                    onTap: (){
                                                                             setState(() => _isSelectedn[index] = !_isSelectedn[index] );


                                                                          //  _checkPresence(nonAdmins[index].userID, 2);
                                                                          
                                                                            if(_isSelectedn[index]==true)
                                                                            {
                                                                                _addItemtoList(snapshot.data![index].userID,2);
                                                                            }
                                                                            else
                                                                            {
                                                                              
                                                                               _removeItemFromList(snapshot.data![index].userID, 2);
                                                                            }
                                                                              

                                                                             
                                                                                   
                                                                                  

                                                                          } ,
                                                                    
                                                                    );
                                                        }
                                          
                                  );
                                        
                            
                              },
                        
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                const Divider(thickness: 5,),
                const Text("Admins",style: TextStyle(fontSize: 18),),
                FutureBuilder <List<dynamic>>(
                        future:_loadAllAdmins(), 
                        builder: (context, snapshot)
                              {

                                   if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }

                                  if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  }

                                  if (!snapshot.hasData ) {
                                    return const Center(child: Text('No articles available'));
                                  }
                                  return  ListView.builder(
                                    
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount:snapshot.data!.length,
                                              itemBuilder: (context,index)
                                                        {
                                                           if (!_isSelecteda.containsKey(index)) _isSelecteda[index] = false; 

                                                            
                                                            return ListTile(
                                                                    
                                                                   selected: _isSelecteda[index],
                                                                   selectedTileColor: AppColors.primary,
                                                                   selectedColor: AppColors.background,

                                                                    title: Text(snapshot.data![index].fullName),
                                                                    subtitle: Text(snapshot.data![index].email),
                                                                   
                                                                    onTap: (){

                                                                              setState(() => _isSelecteda[index] = !_isSelecteda[index] );

                                                                               if(_isSelecteda[index]==true)
                                                                              {
                                                                                  _addItemtoList(snapshot.data![index].userID,1);
                                                                              }
                                                                              else
                                                                              {
                                                                                
                                                                                _removeItemFromList(snapshot.data![index].userID, 1);
                                                                              }
                                                                               
                                                                          } 
                                                                    );
                                                        }
                                  );
                                 
                            
                              },
                              
                      ),
                    
                    const Padding(padding: EdgeInsets.all(30.0)),

                     SizedBox(

                          width: 500,

                          height: 56,

                          child: ElevatedButton(

                                  onPressed: selectedFromAdmins.isNotEmpty || selectedFromNonAdmins.isNotEmpty
                                      ? () => _update()
                                      : null,

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 4,
                                  ),

                                  child:  selectedFromAdmins.isNotEmpty || selectedFromNonAdmins.isNotEmpty ? const Text("Update", style: TextStyle(fontSize: 18.0)) : const Center(child: CircularProgressIndicator()),
                          ),
                      ),
                  ]
              ),
    );
  }
}