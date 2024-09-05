import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:laber_app/components/phone_number_input.dart';
import 'package:laber_app/screens/contacts/add_to_contacts.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:laber_app/state/bloc/contacts/contacts_bloc.dart';
import 'package:laber_app/state/bloc/contacts/discover_phone_number_bloc.dart';
import 'package:laber_app/state/types/contacts/discover_phone_number_state.dart';

class AddByPhone extends StatefulWidget {
  const AddByPhone({super.key});

  @override
  State<AddByPhone> createState() => _AddByPhoneState();
}

class _AddByPhoneState extends State<AddByPhone> {
  late AuthBloc authBloc;
  late ContactsBloc contactsBloc;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late DiscoverPhoneNumberBloc discoverPhoneNumberBloc;

  @override
  void initState() {
    super.initState();
    discoverPhoneNumberBloc = context.read<DiscoverPhoneNumberBloc>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authBloc = context.read<AuthBloc>();
    contactsBloc = context.watch<ContactsBloc>();
    discoverPhoneNumberBloc = context.watch<DiscoverPhoneNumberBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiscoverPhoneNumberBloc, DiscoverPhoneNumberState>(
      listener: (context, state) {
        if (state.state == DiscoverPhoneNumberStateEnum.found) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider.value(
                  value: contactsBloc,
                  child: AddToContacts(
                    user: state.contact!,
                    phoneNumber: state.phoneNumber,
                  ),
                );
              },
            ),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          title: Text(
            'Add Contacts',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              const ListTile(
                title: Text('Add by username'),
              ),
              const ListTile(
                title: Text('Add by phone number'),
              ),
              PhoneNumberInput(
                onSaved: (PhoneNumber number) {
                  var isValid = formKey.currentState?.validate();
                  if (isValid == true) {
                    discoverPhoneNumberBloc.add(
                      SearchDiscoverPhoneNumberEvent(
                        number.phoneNumber!,
                        authBloc,
                        contactsBloc,
                      ),
                    );
                  } else {
                    print('saved invalid');
                  }
                },
              ),
              Builder(builder: (context) {
                if (discoverPhoneNumberBloc.state.state ==
                    DiscoverPhoneNumberStateEnum.loading) {
                  return const CircularProgressIndicator();
                }

                if (discoverPhoneNumberBloc.state.state ==
                    DiscoverPhoneNumberStateEnum.error) {
                  return Text(
                    discoverPhoneNumberBloc.state.error ?? 'An error occurred',
                    style: const TextStyle(color: Colors.red),
                  );
                }

                return const SizedBox();
              }),
              const Spacer(),
              SafeArea(
                child: TextButton(
                  onPressed: () {
                    formKey.currentState?.save();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    width: double.infinity,
                    child: const Text(
                      'hello',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
