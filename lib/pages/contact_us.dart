import 'package:eRoomApp/app_launcher_utils.dart';
import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ContactUs extends StatelessWidget {
  static Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white70),
        title: Text(
          'Contact Us',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white70,
          ),
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ListView(
                    children: [
                      Container(
                        height: 240.0,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          image: new DecorationImage(
                            image: new AssetImage('assets/img/living_room.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      titleSection,
                      buttonSection,
                      textSection,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Container(
          width: 600.0,
          child: Text(
            'Copyright 2021, All Rights Reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
            softWrap: true,
          ),
        ),
        GestureDetector(
          onTap: () => AppLauncherUtils.openLink(url: 'https://flutter.dev/'),
          child: Container(
            width: 600.0,
            child: Text(
              'Powered by ReaCode',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueAccent[900],
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget titleSection = Container(
    padding: const EdgeInsets.all(32.0),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'eRoom for the win',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
              ),
              Text(
                'Johannesburg, South Africa',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget buttonSection = Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () =>
              AppLauncherUtils.openPhoneCall(phoneNumber: '+27680308734'),
          child: _buildButtonColumn(MyColors.primaryColor, Icons.call, 'CALL'),
        ),
        GestureDetector(
          onTap: () => AppLauncherUtils.openWhatsApp(
              phoneNumber: '+27680308734', message: 'The room is available.'),
          child: _buildButtonColumn(
              MyColors.primaryColor, Icons.near_me, 'WHATSAPP'),
        ),
        GestureDetector(
          onTap: () => AppLauncherUtils.openEmail(
              toEmail: 'lodrick.mpanze0@gmail.com',
              subject: 'Subject',
              body: 'Hi how are you.'),
          child:
              _buildButtonColumn(MyColors.primaryColor, Icons.email, 'Email'),
        ),
      ],
    ),
  );

  Widget textSection = Container(
    padding: const EdgeInsets.all(32.0),
    child: Text(
      'Its a great platform that connects the property owners who have  '
      'available rooms or cottages for rental. '
      'Its a platform that showcases rooms and cottages for people to rent. '
      'If you are renting out rooms or cottages or you are simply looking for a '
      'room or cottage to rent you have made an incredible choice by '
      'downloading this App. The Simplicity of finding everything suitable to '
      'your needs right at your fingertips, worry not, you have found what you'
      'are looking for. Welcome to eRoom',
      softWrap: true,
    ),
  );
}
