import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/components/blur_background.dart';
import 'package:laber_app/components/profile_picture.dart';
import 'package:laber_app/screens/settings/devices.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late AuthBloc authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authBloc = context.watch<AuthBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BlurBackground(
          child: Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 50,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Settings",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[900],
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      ProfilePicture(
                        radius: 30,
                        imageUrl: authBloc.state.meUser?.profilePicture,
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                authBloc.state.meUser?.name ??
                                    authBloc.state.meUser?.phoneNumber ??
                                    "ERROR",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Hello there I'm using LaberApp!",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Divider(
                    color: Colors.grey[700],
                    height: 0,
                    thickness: 0.5,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const Devices(),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Row(
                        children: [
                          const Icon(
                            IconoirIcons.computer,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            "Devices",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Divider(
                    color: Colors.grey[700],
                    height: 0,
                    thickness: 0.5,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: const Text("Logout"),
                              content: const SizedBox(
                                height: 100,
                                child: Column(
                                  children: [
                                    Text(
                                      "This will delete all you local data.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("Are you sure you want to logout?"),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    authBloc.add(LogoutAuthEvent());
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("YES"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("NO"),
                                ),
                              ],
                            ));
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      alignment: Alignment.center,
                      child: const Row(
                        children: [
                          Icon(
                            IconoirIcons.logOut,
                            color: Colors.red,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.red,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
