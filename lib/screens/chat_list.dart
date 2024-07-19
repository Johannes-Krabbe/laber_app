import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/components/chat_tile.dart';
import 'package:laber_app/state/bloc/contacts_bloc.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);
  double scrollPosition = 0;
  Widget? appBarTitle;
  late ContactsBloc contactsBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contactsBloc = context.watch<ContactsBloc>();
  }

  void _scrollListener() {
    setState(() {
      scrollPosition = _scrollController.offset;

      if (scrollPosition > 50) {
        appBarTitle = Text("Chats",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ));
      } else {
        appBarTitle = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              ),
              child: Column(
                children: [
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {},
                          ),
                          SizedBox(
                            height: 50,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: appBarTitle,
                            ),
                          ),
                          IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                showSearch(
                                  context: context,
                                  delegate: ChatSearchDelegate(
                                    contactsBloc: contactsBloc,
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // text
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 120,
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                height: 50,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Chats",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              bottom: 100,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return contactsBloc.state.contacts != null
                      ? ChatTile(
                          contact: contactsBloc
                              .state.sortedContactsByLastMessage[index],
                          message: contactsBloc
                              .state
                              .sortedContactsByLastMessage[index]
                              .latestMessage
                              ?.message,
                          time: contactsBloc
                              .state
                              .sortedContactsByLastMessage[index]
                              .latestMessage
                              ?.formattedLongTime,
                        )
                      : const SizedBox();
                },
                childCount:
                    contactsBloc.state.sortedContactsByLastMessage.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatSearchDelegate extends SearchDelegate<String> {
  final ContactsBloc contactsBloc;

  ChatSearchDelegate({required this.contactsBloc});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Builder(builder: (context) {
        if (query.isNotEmpty) {
          return IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              query = '';
            },
          );
        } else {
          return const SizedBox();
        }
      }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('No results for $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: contactsBloc.state.search(query).length,
      itemBuilder: (BuildContext context, int index) {
        var searchResult = contactsBloc.state.search(query);
        searchResult.sort((a, b) {
          if (a.latestMessage == null) return 1;
          if (b.latestMessage == null) return -1;
          return a.latestMessage!.unixTime
              .compareTo(b.latestMessage!.unixTime * -1);
        });
        return ChatTile(
          contact: searchResult[index],
          message:
              searchResult[index].latestMessage?.message ?? "NO MESSAGE YET",
          time: searchResult[index].latestMessage?.formattedLongTime ?? "",
        );
      },
    );
  }
}
