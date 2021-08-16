import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// WIDGETS
import '../../widgets/button.dart';

// PROVIDERS
import '../../providers/auth.dart';
import '../../providers/movie.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Future<void> logout() async {
    Provider.of<MovieProvider>(context, listen: false).resetMovies();
    await Provider.of<Auth>(context, listen: false).logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
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
            ListTile(
              title: Text('Movies Count'),
              trailing: Text(
                  Provider.of<MovieProvider>(context).movies.length.toString()),
            ),
            SizedBox(height: 16),
            Button(
              title: 'LOGOUT',
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }
}
