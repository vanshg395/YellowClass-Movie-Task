import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

// WIDGETS
import '../widgets/button.dart';

// MODELS
import '../models/movie.dart';

// PROVIDERS
import '../providers/auth.dart';
import '../providers/movie.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({Key? key}) : super(key: key);

  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = true;
  Map<String, dynamic> data = {};
  String? imagePath;
  String? genre;

  Future<void> addMovie() async {
    FocusScope.of(context).unfocus();
    try {
      if (!formKey.currentState!.validate()) return;
      if (imagePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please pick a poster.'),
            duration: const Duration(seconds: 3),
            // margin: EdgeInsets.all(12),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      formKey.currentState!.save();
      final movie = Movie(
        id: Uuid().v4(),
        name: data['name'],
        directorName: data['director'],
        genre: data['genre'],
        posterPath: data['poster'],
      );
      await Provider.of<MovieProvider>(context, listen: false).addMovie(
        Provider.of<Auth>(context, listen: false).userId!,
        movie,
      );
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Movie Added Successfully'),
          duration: const Duration(seconds: 3),
          // margin: EdgeInsets.all(12),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 3),
          // margin: EdgeInsets.all(12),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Add Movie'),
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          width: double.infinity,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 24),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      filled: true,
                      fillColor: Color(0xFFEBEBEB).withOpacity(0.7),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is required.';
                      }
                    },
                    onSaved: (value) {
                      data['name'] = value;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Director',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      filled: true,
                      fillColor: Color(0xFFEBEBEB).withOpacity(0.7),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is required.';
                      }
                    },
                    onSaved: (value) {
                      data['director'] = value;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    items: [
                      DropdownMenuItem(
                        child: Text('Action'),
                        value: 'Action',
                      ),
                      DropdownMenuItem(
                        child: Text('Adventure'),
                        value: 'Adventure',
                      ),
                      DropdownMenuItem(
                        child: Text('Comedy'),
                        value: 'Comedy',
                      ),
                      DropdownMenuItem(
                        child: Text('Drama'),
                        value: 'Drama',
                      ),
                      DropdownMenuItem(
                        child: Text('Horror'),
                        value: 'Horror',
                      ),
                      DropdownMenuItem(
                        child: Text('Romance'),
                        value: 'Romance',
                      ),
                      DropdownMenuItem(
                        child: Text('Sci-Fi'),
                        value: 'Sci-Fi',
                      ),
                      DropdownMenuItem(
                        child: Text('Thriller'),
                        value: 'Thriller',
                      ),
                      DropdownMenuItem(
                        child: Text('Other'),
                        value: 'Other',
                      ),
                    ],
                    value: genre,
                    onChanged: (value) {
                      setState(() {
                        genre = value as String;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Genre',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB2B2B2).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      filled: true,
                      fillColor: Color(0xFFEBEBEB).withOpacity(0.7),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    validator: (value) {
                      if (genre == null) {
                        return 'This field is required.';
                      }
                    },
                    onSaved: (value) {
                      data['genre'] = value;
                    },
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFEBEBEB).withOpacity(0.7),
                      border: Border.all(
                        color: Color(0xFFB2B2B2).withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: imagePath == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload),
                              SizedBox(height: 6),
                              Text(
                                'Upload Movie Poster',
                              ),
                            ],
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.file(
                                File(imagePath!),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  onTap: () async {
                    final image = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image == null) return;
                    setState(() {
                      imagePath = image.path;
                    });
                    data['poster'] = imagePath;
                  },
                ),
                Spacer(),
                Button(
                  title: 'ADD',
                  onTap: addMovie,
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
