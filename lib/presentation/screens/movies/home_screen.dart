import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_slideshow_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);

    // if (initialLoading) return const FullScreenLoader();

    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  MoviesSlideshow(movies: slideShowMovies),
                  MovieHorizontalListview(
                    movies: nowPlayingMovies,
                    title: 'En Cines',
                    subtitle: 'Martes 21',
                    loadNextPage: () {
                      ref
                          .read(nowPlayingMoviesProvider.notifier)
                          .loadNextPage();
                    },
                  ),
                  MovieHorizontalListview(
                    movies: popularMovies,
                    title: 'Populares',
                    subtitle: 'Martes 2',
                    loadNextPage: () {
                      ref.read(popularMoviesProvider.notifier).loadNextPage();
                    },
                  ),
                  MovieHorizontalListview(
                    movies: upcomingMovies,
                    title: 'Upcoming',
                    subtitle: 'Martes 2',
                    loadNextPage: () {
                      ref.read(upcomingMoviesProvider.notifier).loadNextPage();
                    },
                  ),
                  MovieHorizontalListview(
                    movies: topRatedMovies,
                    title: 'Top Rated',
                    subtitle: 'Martes 2',
                    loadNextPage: () {
                      ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }
}
