import 'package:flutter/material.dart';
import 'package:localnewsapp/business/identification.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';
import 'package:localnewsapp/login.dart';

import '../constants/categories.dart';


class InterestsSelectionPage extends StatefulWidget {
  const InterestsSelectionPage({super.key});

  @override
  State<InterestsSelectionPage> createState() => _InterestsSelectionPageState();
}

class _InterestsSelectionPageState extends State<InterestsSelectionPage> {

  
  @override
  void initState() {
    super.initState();
    // Initialize preferences if not already done
    if (NewsCategories.userPreferences.isEmpty) {
      NewsCategories.initPreferences();
    }
  }

  void _toggleInterest(String category) {
    setState(() {
      NewsCategories.togglePreference(category);
    });
  }
  List _getInterest()
  {
    List<dynamic> interests ;
    
    interests=NewsCategories.getInterestedCategories();
   

    return interests;
  }

  void updateTags() async
  {
    final uR=UsersRepo();

    var interest=_getInterest();

    String result= await uR.addPreferenceTags(Identification().userID,interest);

    if (result.startsWith("failure"))
    {
      // ignore: use_build_context_synchronously
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));

    }
    else
    {
      // ignore: use_build_context_synchronously
       Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Login())///RejectionSelectionPage(rejection:NewsCategories.getUnselectedCategories())),
                      );

    }
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose Your Interests',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Select topics you are interested in to personalize your feed',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),  // Reduced padding
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,  // Increased to show more items per row
                  childAspectRatio: 2.0,  // Made cards wider than tall
                  crossAxisSpacing: 8,  // Reduced spacing
                  mainAxisSpacing: 8,
                ),
                itemCount: NewsCategories.allCategories.length,
                itemBuilder: (context, index) {
                  final category = NewsCategories.allCategories[index];
                  final isSelected = NewsCategories.userPreferences[category] ?? true;
                  
                  return GestureDetector(
                    onTap: () => _toggleInterest(category),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      // Navigate to login page
                    
                       updateTags();
                     
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}