/// This file contains the code for Pindery's settings page.
///

// External libraries imports
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Internal imports
import 'theme.dart';
import 'user.dart';
import 'utils.dart';
import 'drawer.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({this.user, this.firebaseMessaging});

  static const routeName = '/settings';

  final User user;
  final FirebaseMessaging firebaseMessaging;

  static const List<Map<String, dynamic>> _settingsTiles = const [
    {'icon': Icons.lock, 'data': 'Change password', 'widgedBuilder': null},
    {'icon': Icons.mail, 'data': 'Change email', 'widgedBuilder': null},
    {
      'icon': Icons.photo_camera,
      'data': 'Change profile picture',
      'widgedBuilder': null
    }
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Settings'),
      ),
      drawer: new PinderyDrawer(
        user: user,
        previousRoute: routeName,
      ),
      body: new Column(children: <Widget>[
        new Container(
          height: 175.0,
          width: 400.0,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/img/movingParty.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(20.0),
                child: new SizedBox(
                  child: new PinderyCircleAvatar(user: user),
                ),
              ),
              new Expanded(
                flex: 1,
                child: new Column(
                  children: <Widget>[
                    new Text(
                      '${user.name} ${user.surname}',
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500),
                    ),
                    new Text(
                      user.email,
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        new Expanded(
            child: new Column(
                children: _settingsTiles.map((Map<String, dynamic> tile) {
          return new SettingsBlock(
            data: tile['data'],
            icon: tile['icon'],
            widgetBuilder: tile['widgetBuilder'],
          );
        }).toList())),
        new AboutListTile(
          applicationName: 'Pindery',
          applicationVersion: '0.0.1-alpha0',
          applicationLegalese: 'By AEEooTo',
          icon: new Icon(
            Icons.info,
            color: Colors.white,
          ),
          applicationIcon: new Container(
              height: 50.0,
              width: 50.0,
              child: Image.asset('assets/img/logo_v_2_rosso.png')),
        ),
        new ListTile(
          leading: new Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          title: new Text('Log Out'),
          onTap: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new SigninOutPage()));
            await FirebaseAuth.instance.signOut();
            Navigator
                .of(context)
                .pushNamedAndRemoveUntil('/welcome', (_) => false);
          },
        )
      ]),
    );
  }
}

class SettingsBlock extends StatelessWidget {
  SettingsBlock({this.data, this.icon, this.widgetBuilder});

  final String data;
  final IconData icon;
  final WidgetBuilder widgetBuilder;

  Widget build(BuildContext context) {
    return new Container(
      child: new DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: new SafeArea(
            top: false,
            bottom: false,
            child: new ListTile(
              leading: new Icon(icon, color: Colors.white, size: 21.0),
              title: new Text(
                data,
                textAlign: TextAlign.start,
                style: new TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                if (widgetBuilder != null) {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: widgetBuilder),
                  );
                }
              },
            )),
      ),
    );
  }
}

class SigninOutPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: new BoxDecoration(color: Colors.white),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 96.0),
              child: new Container(
                height: 214.0,
                width: 214.0,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                  image: new AssetImage('assets/img/logo_v_2_rosso.png'),
                  fit: BoxFit.fitHeight,
                )),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(bottom: 81.0),
              child: new Text(
                'Signing Out!',
                style: new TextStyle(
                    fontSize: 40.0,
                    color: primary,
                    fontWeight: FontWeight.w600),
              ),
            ),
            new Padding(
              padding: EdgeInsets.all(16.0),
              child: new Container(
                height: 1.5,
                margin: EdgeInsets.only(top: 16.0),
                child: new LinearProgressIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
