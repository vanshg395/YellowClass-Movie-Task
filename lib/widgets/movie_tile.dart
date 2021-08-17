import 'dart:io';

import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieTile extends StatelessWidget {
  const MovieTile({
    Key? key,
    required this.movie,
    required this.editHandler,
    required this.deleteHandler,
  }) : super(key: key);

  final Movie movie;
  final Function editHandler;
  final Function deleteHandler;

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
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: Border.all(
                color: Color(0xFF000000).withOpacity(0.2),
              ),
            ),
            child: ListTile(
              title: Text(
                movie.name!,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                movie.directorName! + '\n' + movie.genre!,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => editHandler(),
                    icon: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () => deleteHandler(),
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
