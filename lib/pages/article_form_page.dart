

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localnewsapp/constants/app_colors.dart';
import 'package:localnewsapp/singleton/identification.dart';
import '../constants/categories.dart';
import '../dataAccess/model/document.dart'; // Import Document model
import '../dataAccess/document_repo.dart'; // Import DocumentRepo

import 'package:easy_localization/easy_localization.dart'; // Add easy_localization import

class ArticleFormPage extends StatefulWidget {
  const ArticleFormPage({super.key});

  @override
  State<ArticleFormPage> createState() => _ArticleFormPageState();
}

class _ArticleFormPageState extends State<ArticleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _articleController = TextEditingController();
  final _linkController = TextEditingController(); // New controller for link
  final List<String> _availableTags = NewsCategories.allCategories;
  final List<String> _selectedTags = [];

  final DocumentRepo _documentRepo = DocumentRepo(); // Instantiate DocumentRepo


  


  // ignore: prefer_typing_uninitialized_variables
  var imageBytes ;

 // ignore: prefer_typing_uninitialized_variables
  var imageExtension; 




  // Language and Document Type state variables
  final List<String> _languages = ['en', 'am'];
  String? _selectedLanguage;

  final List<String> _documentTypes = ['text', 'video'];
  String? _selectedDocumentType;

  @override
  void initState() {

    super.initState();
    _selectedLanguage = _languages.first; // Set default language
    _selectedDocumentType = _documentTypes.first; // Set default document type


  }

  void _toggleTag(String tag) {

    setState(() {

      if (_selectedTags.contains(tag)) {

        _selectedTags.remove(tag);

      } else {

        _selectedTags.add(tag);

      }
    });
  }

  Future<void> _submitForm() async {

    if (_formKey.currentState!.validate()) {

      if (_selectedDocumentType!=_documentTypes.first && _linkController.text.isEmpty) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('please_enter_valid_url'.tr())),
        );
        return;

      }

      if (_selectedTags.isEmpty) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('please_select_at_least_one_tag'.tr())),

        );
        return;
      }

      if (_selectedLanguage == null) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('please_select_language'.tr())),
        );
        return;
      }

      if (_selectedDocumentType == null) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('please_select_document_type'.tr())),
        );
        return;
      }


      // Form is valid, process the submission
      // Create a Document object from form data
      final newDocument = Document(
        
        documentID: null, // Firestore will generate this
        documentName: _titleController.text, // Using title as document name
        title: _titleController.text,
        documentPath: [
          _linkController.text
        ], // Assuming link is the primary path
        content: _articleController.text,
        language: _selectedLanguage!, // Use selected language
        indexTermsAM: [], // Placeholder
        indexTermsEN: [], // Placeholder
        registrationDate: DateTime.now().toIso8601String(), // Current date/time
        isActive: true, // Default to active
        authorID: Identification().userID, // Use current user's ID
        tags: _selectedTags,
        documentType: _selectedDocumentType!, // Use selected document type
      );

      try {

       
        // Call addDocument to submit the article
       final result= await _documentRepo.addDocument(newDocument,imageBytes,imageExtension);

      

       if(result.contains('failure'))
       {
                 // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
       }
       else
       {
          // Provide user feedback
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('article_submitted_successfully'.tr())),
          );

       }

        
        // Clear the form
        _formKey.currentState!.reset();
        _titleController.clear();
        _articleController.clear();
        _linkController.clear();
        setState(() {
          _selectedTags.clear();
          _selectedLanguage = _languages.first; // Reset language
          _selectedDocumentType = _documentTypes.first;  // Reset document type
          imageBytes=null;
        });
      } catch (e) {
        // Handle submission errors
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error_submitting_article'.tr())),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _articleController.dispose();
    _linkController.dispose(); // Dispose the new controller
    super.dispose();
  }

  imageGetter(XFile image) async {

        final bytes =await image.readAsBytes();
      setState(() {
                  imageBytes = bytes;
                  imageExtension= image.name.split('.').last.toLowerCase();
                              
      });
       
      return imageBytes;
                                  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'create_new_article'.tr(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                 
                  Row(
                    children: [

                       imageBytes==null? const Icon(Icons.image, size: 100)
                              : Image.memory(imageBytes,
                                            height:100 ,
                                            width:100,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              // Fallback if the image fails to load (e.g., network error, invalid URL)
                                              return const Icon(Icons.image, size: 80);
                                            }),   
                       ElevatedButton(
                            onPressed: () async {

                                ImagePicker picker = ImagePicker();
                                XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                if (image == null) {
                                  return; // User cancelled image selection
                                }

                                await imageGetter(image);

                           
                                    
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              "upload Image",
                            ),
                          ),
                    ],
                  ),


                  const SizedBox(height: 20),


                  // Title Field
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'title'.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_title'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Language and Document Type Dropdowns (Side by side)
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'language'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          value: _selectedLanguage,
                          items: _languages.map((String language) {
                            return DropdownMenuItem<String>(
                              value: language,
                              child: Text(language),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedLanguage = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'please_select_language'.tr();
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16), // Spacing between dropdowns
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'document_type'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          value: _selectedDocumentType,
                          items: _documentTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedDocumentType = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null ) {
                              return 'please_select_document_type'.tr();
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Article Content Field
                  TextFormField(
                    controller: _articleController,
                    decoration: InputDecoration(
                      labelText: 'article_content'.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_article_content'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Link Input Section (replacing PDF upload)
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'article_link'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _linkController,
                          decoration: InputDecoration(
                            hintText: 'enter_article_url'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null && _selectedDocumentType!=_documentTypes.first) {
                              return 'please_enter_valid_url'.tr();
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tags Selection
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'select_tags'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableTags.map((tag) {
                            final isSelected = _selectedTags.contains(tag);
                            return FilterChip(
                              label: Text('filters.${tag.toLowerCase()}'.tr()),
                              selected: isSelected,
                              onSelected: (_) => _toggleTag(tag),
                              backgroundColor: Colors.white,
                              selectedColor: Colors.white,
                              checkmarkColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.black
                                      : const Color.fromARGB(
                                          255, 220, 220, 220),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Submit Button
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation:
                            0, // Remove default elevation as we're using custom shadow
                      ),
                      child: Text(
                        'submit'.tr(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
 
}
