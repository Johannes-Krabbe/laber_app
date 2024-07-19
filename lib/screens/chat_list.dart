import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:laber_app/components/chat_tile.dart';

import 'package:laber_app/state/bloc/chat_list_bloc.dart';

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
  late ChatListBloc chatListBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    chatListBloc = context.read<ChatListBloc>(); // Add the line here
    chatListBloc.add((FetchChatsChatListEvent()));
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
    chatListBloc = context.watch<ChatListBloc>(); // Add the line here
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
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: appBarTitle,
                          ),
                          IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                showSearch(
                                  context: context,
                                  delegate: ChatSearchDelegate(
                                    chatListBloc: chatListBloc,
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
                  return chatListBloc.state.chats != null
                      ? ChatTile(
                          name: chatListBloc.state.chats![index].name,
                          message: chatListBloc
                              .state.chats![index].latestMessage.message,
                          time: chatListBloc
                              .state.chats![index].latestMessage.formattedTime,
                          avatarUrl: chatListBloc.state.chats![index].avatarUrl,
                        )
                      : const SizedBox();
                },
                childCount: chatListBloc.state.chats?.length ?? 0,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            ),
            child: BottomNavigationBar(
              currentIndex: 0,
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
            ),
          ),
        ),
      ),
    );
  }
}

class ChatSearchDelegate extends SearchDelegate<String> {
  final ChatListBloc chatListBloc;

  ChatSearchDelegate({required this.chatListBloc});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Builder(
        builder: (context) {
          if(query.isNotEmpty) {
            return IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
              },
            );
          } else {
            return const SizedBox();
          }
        }
      ),
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
      itemCount: chatListBloc.state.searchByName(query).length,
      itemBuilder: (BuildContext context, int index) {
        var searchResult = chatListBloc.state.searchByName(query);
        searchResult.sort((a, b) =>
            a.latestMessage.unixTime.compareTo(b.latestMessage.unixTime));
        return ChatTile(
          name: searchResult[index].name,
          message: searchResult[index].latestMessage.message,
          time: searchResult[index].latestMessage.formattedTime,
          avatarUrl: searchResult[index].avatarUrl,
        );
      },
    );
  }
}
