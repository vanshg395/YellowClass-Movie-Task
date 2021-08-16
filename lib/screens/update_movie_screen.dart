import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';

// WIDGETS
import '../widgets/button.dart';

// MODELS
import '../models/movie.dart';

// PROVIDERS
import '../providers/auth.dart';
import '../providers/movie.dart';

class UpdateMovieScreen extends StatefulWidget {
  const UpdateMovieScreen({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  _UpdateMovieScreenState createState() => _UpdateMovieScreenState();

  final Movie movie;
}

class _UpdateMovieScreenState extends State<UpdateMovieScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = true;
  Map<String, dynamic> data = {};
  String? imagePath;

  @override
  void initState() {
    super.initState();
    imagePath = widget.movie.posterPath;
    data['poster'] = imagePath;
  }

  Future<void> updateMovie() async {
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
        id: widget.movie.id,
        name: data['name'],
        directorName: data['director'],
        posterPath: data['poster'],
      );
      await Provider.of<MovieProvider>(context, listen: false).updateMovie(
        Provider.of<Auth>(context, listen: false).userId!,
        movie,
      );
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Movie Updated Successfully'),
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
          title: Text('Update Movie'),
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
                    initialValue: widget.movie.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
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
                    initialValue: widget.movie.directorName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Director',
                      border: OutlineInputBorder(),
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
                  alignment: Alignment.centerLeft,
                  child: Text('Poster'),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: imagePath == null
                        ? Icon(Icons.upload)
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.file(
                                File(imagePath!),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Icon(
                                  Icons.edit,
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
                  title: 'UPDATE',
                  onTap: updateMovie,
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
