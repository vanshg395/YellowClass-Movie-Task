import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// WIDGETS
import '../widgets/button.dart';

// PROVIDERS
import '../providers/auth.dart';
import '../providers/movie.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> logout() async {
    Provider.of<MovieProvider>(context, listen: false).resetMovies();
    await Provider.of<Auth>(context, listen: false).logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Provider.of<Auth>(context).name!,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          Provider.of<Auth>(context).email!,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    radius: 28,
                    backgroundImage: NetworkImage(
                      Provider.of<Auth>(context).imageUrl!,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),
            Container(
              color: Colors.white,
              child: ListTile(
                title: Text('Movies Count'),
                trailing: Text(Provider.of<MovieProvider>(context)
                    .movies
                    .length
                    .toString()),
              ),
            ),
            Spacer(),
            Button(
              title: 'LOGOUT',
              onTap: logout,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
