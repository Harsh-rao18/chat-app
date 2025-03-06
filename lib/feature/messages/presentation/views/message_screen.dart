import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/feature/messages/presentation/bloc/message_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageScreen extends StatelessWidget {
   MessageScreen({super.key});

   final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Users')),
      body: Column(
        children: [
          // Search Input Field
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  context.read<MessageBloc>().add(SearchUserByName(query));
                }
              },
            ),
          ),

          // Display search results
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
              print("📌 Current State: $state");
                if (state is MessageLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchUserLoaded) {
                   print("👥 Showing ${state.users.length} users");
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final User user = state.users[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(user.metadata.name),
                        subtitle: Text(user.email),
                        onTap: () {
                          // Handle user selection
                        },
                      );
                    },
                  );
                } else if (state is SearchUserError) {
                  return Center(child: Text(state.message));
                }

                return const Center(child: Text('Search for users...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
