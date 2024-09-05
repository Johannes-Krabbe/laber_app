import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/components/blur_background.dart';
import 'package:laber_app/screens/chat.dart';
import 'package:laber_app/screens/contacts/add_by_phone.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:laber_app/state/bloc/chat_bloc.dart';
import 'package:laber_app/state/bloc/contacts/contacts_bloc.dart';
import 'package:laber_app/state/bloc/contacts/discover_phone_number_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:laber_app/state/types/contacts/contacts_state.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  late AuthBloc authBloc;
  late ContactsBloc contactsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authBloc = context.read<AuthBloc>();
    contactsBloc = context.watch<ContactsBloc>();
    contactsBloc.add(RefetchAllContactsEvent());
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 48),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Contacts",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return NewWidget(
                                    contactsBloc: contactsBloc,
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              IconoirIcons.plus,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          contactsBloc.add(ApiRefetchAllContactsEvent());
          return () async {
            var loopCount = 0;
            do {
              await Future.delayed(const Duration(milliseconds: 100));
              if (++loopCount > 30) break;
            } while (contactsBloc.state.state == ContactsStateEnum.loading);
            return;
          }();
        },
        color: Colors.white,
        edgeOffset: 100,
        child: Builder(builder: (context) {
          var contacts = contactsBloc.state.sortedContacts;
          return ListView.builder(
            itemCount: contactsBloc.state.sortedContacts.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return BlocProvider(
                          create: (context) {
                            return ChatBloc(contacts[index].apiId);
                          },
                          child: const ChatScreen(),
                        );
                      },
                    ),
                  );
                },
                title: Text(contacts[index].name ??
                    contacts[index].username ??
                    'no name/username'),
                subtitle: Text(contacts[index].phoneNumber ??
                    contacts[index].username ??
                    'no phone number/username'),
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(contacts[index].profilePicture ?? ''),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  final ContactsBloc contactsBloc;
  const NewWidget({
    required this.contactsBloc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Text(
              'Add Contacts',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              IconoirIcons.phone,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: const Text('by Phone Number'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        lazy: false,
                        create: (_) => DiscoverPhoneNumberBloc(),
                      ),
                      BlocProvider.value(
                        value: contactsBloc,
                      ),
                    ],
                    child: const AddByPhone(),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              IconoirIcons.user,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: const Text('by Username'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Placeholder(
                    child: Center(child: Text("Not Implemented")),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
