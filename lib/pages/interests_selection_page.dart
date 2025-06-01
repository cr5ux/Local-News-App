import 'package:flutter/material.dart';
import 'package:localnewsapp/business/identification.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';
import 'package:localnewsapp/login.dart';
import 'package:localnewsapp/constants/app_colors.dart';
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Image.asset(
            'assets/logo.png',
            height: 32,
            width: 32,
          ),
        ),
        title: const Text(
          'Choose Your Interests',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 8, // Increased for visible shadow
        shadowColor: Colors.black.withOpacity(0.25), // Drop shadow color
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
                  crossAxisCount: 2,  // Increased to show more items per row
                  childAspectRatio: 1.5,  // Made cards wider than tall
                  crossAxisSpacing: 8,  // Reduced spacing
                  mainAxisSpacing: 8,
                ),
                itemCount: NewsCategories.allCategories.length,
                itemBuilder: (context, index) {
                  final category = NewsCategories.allCategories[index];
                  final isSelected = NewsCategories.userPreferences[category] ?? true;

                  // Sanitize category name for file path (e.g., "World News" -> "world_news.png")
                  final imageName = 'assets/${category.toLowerCase().replaceAll(' ', '_')}.jpg';

                  return GestureDetector(
                    onTap: () => _toggleInterest(category),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black.withOpacity(0.7) : Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.grey[300]!,
                          width: 1,
                        ),
                        image: DecorationImage(
        
                          image: AssetImage(imageName),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            isSelected ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.6),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                shadows: [
                                  Shadow(
                                    blurRadius: 4,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(1, 1),
                                  ),
                                ],
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
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
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
                    backgroundColor: AppColors.primary,
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