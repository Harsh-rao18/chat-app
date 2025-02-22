import 'package:application_one/feature/home/presentation/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:application_one/feature/home/presentation/bloc/home_bloc.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Dispatch event when the page is first loaded
    context.read<HomeBloc>().add(HomeFetchPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                  height: 40,
                ),
              ),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is HomeError) {
                    // Show Snackbar when an error occurs
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator(),);
                  } else if (state is HomeLoaded) {
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) => PostCard(
                        post: state.posts[index],
                      ),
                    );
                  } else if (state is HomeError) {
                    return Center(
                      child: Text(state.message, style: const TextStyle(color: Colors.red)),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
