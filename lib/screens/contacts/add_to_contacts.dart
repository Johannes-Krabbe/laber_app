import 'package:flutter/material.dart';
import 'package:laber_app/api/models/types/public_user.dart';
import 'package:laber_app/state/bloc/contacts_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddToContacts extends StatefulWidget {
  final ApiPublicUser user;
  final String? phoneNumber;

  const AddToContacts({super.key, required this.user, this.phoneNumber});

  @override
  State<AddToContacts> createState() => _AddToContactsState();
}

class _AddToContactsState extends State<AddToContacts> {
  late ContactsBloc contactsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contactsBloc = context.watch<ContactsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add to contacts',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Add ${widget.user.name} to contacts?'),
            ElevatedButton(
              onPressed: () {
                contactsBloc.add(
                  AddContactEvent(widget.user, widget.phoneNumber),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
