import 'dart:io';

import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieTile extends StatelessWidget {
  const MovieTile({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              image: DecorationImage(
                image: FileImage(
                  File(movie.posterPath!),
                ),
                fit: BoxFit.cover,
              ),
            ),
            width: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: ListTile(
              title: Text(
                movie.name!,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                movie.directorName!,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[400],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
