import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/core/utils/image_circle.dart';
import 'package:application_one/feature/search/presentation/bloc/search_bloc.dart';
import 'package:application_one/feature/showprofile/presentation/bloc/user_profile_bloc.dart';
import 'package:application_one/feature/showprofile/presentation/views/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            // Search Input Field
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
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
                  fillColor: Colors.grey[800],
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              context.read<SearchBloc>().add(ClearSearchResults());
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (query) {
                  if (query.trim().isNotEmpty) {
                    context.read<SearchBloc>().add(SearchUserByName(query));
                  }
                },
              ),
            ),

            // Display search results
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchUserLoaded) {
                    return state.users.isNotEmpty
                        ? ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (context, index) {
                              final User user = state.users[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => UserProfileScreen(userId: user.id),
                                    ),
                                  );
                                  // Dispatch the event to fetch the user profile
                                  context.read<UserProfileBloc>().add(FetchUserProfile(user.id));
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 2,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(8),
                                    leading: ImageCircle(radius: 20, url: user.metadata.image),
                                    title: Text(
                                      user.metadata.name,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                    trailing: const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(Icons.message, color: Colors.blueAccent),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(child: Text('No users found'));
                  } else if (state is SearchUserError) {
                    return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                  }

                  return const Center(child: Text('Search for users...'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
