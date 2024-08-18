import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/components/blur_background.dart';
import 'package:laber_app/screens/chat_list.dart';
import 'package:laber_app/screens/contacts.dart';
import 'package:laber_app/screens/settings/settings.dart';
import 'package:laber_app/state/bloc/contacts_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    var contactsBloc = context.read<ContactsBloc>();
    contactsBloc.add(LoadContactsContactsEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;

    switch (currentIndex) {
      case 0:
        currentPage = const ChatList();
        break;
      case 1:
        currentPage = const Contacts();
        break;
      case 2:
        currentPage = const Settings();
        break;
      default:
        currentPage = const Placeholder();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: currentPage,
      bottomNavigationBar: BlurBackground(
        child: BottomNavigationBar(
            currentIndex: currentIndex,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey[800],
            selectedIconTheme: const IconThemeData(color: Colors.white),
            unselectedIconTheme: IconThemeData(color: Colors.grey[800]),
            selectedFontSize: 14,
            unselectedFontSize: 14,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  (currentIndex == 0
                      ? IconoirIconsBold.chatLines
                      : IconoirIcons.chatLines),
                ),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  (currentIndex == 0
                      ? IconoirIconsBold.group
                      : IconoirIcons.group),
                ),
                label: 'Contacts',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  (currentIndex == 0
                      ? IconoirIconsBold.settings
                      : IconoirIcons.settings),
                ),
                label: 'Settings',
              ),
            ],
            onTap: (index) {
              if (index == currentIndex) {
                return;
              } else {
                setState(() {
                  currentIndex = index;
                });
              }
            }),
      ),
    );
  }
}
