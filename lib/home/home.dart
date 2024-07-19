import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

import 'package:laber_app/screens/chat_list.dart';
import 'package:laber_app/screens/contacts.dart';
import 'package:laber_app/screens/settings.dart';
import 'package:laber_app/state/bloc/contacts_bloc.dart';

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
    contactsBloc.add(FetchContactsContactsEvent());

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
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            ),
            child: BottomNavigationBar(
                currentIndex: currentIndex,
                backgroundColor: Colors.transparent,
                elevation: 0,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat),
                    label: 'Chat',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_alt),
                    label: 'Contacts',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
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
        ),
      ),
    );
  }
}
