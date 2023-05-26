import 'package:aaryapay/components/CircularLoadingAnimation.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/global/bloc/data_bloc.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/repository/favourites.dart';
import 'package:aaryapay/screens/Home/components/bloc/home_favorites_bloc.dart';
import 'package:aaryapay/screens/Send/send_money.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Favourites extends StatelessWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<DataBloc, DataState>(
      listener: (context, dataState) {
      },
      builder: (context, dataState) {
        return dataState.isLoaded
            ? BlocProvider<HomeFavoritesBloc>(
                create: (context) {
                  final authenticationBloc = context.read<AuthenticationBloc>();
                  return HomeFavoritesBloc(
                    favouritesRepository: FavouritesRepository(
                        token: authenticationBloc.state.token),
                  )..add(HomeFavoritesLoadEvent(
                      favorites: dataState.favorites,
                      amount: dataState.balance));
                },
                child: BlocConsumer<HomeFavoritesBloc, HomeFavoritesState>(
                  listener: (context, state) {
                    if (state.particularUser != null) {
                      Utils.mainAppNav.currentState!.push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SendMoney(
                            uuid: state.particularUser!['id'],
                            firstname: state.particularUser!['first_name'],
                            lastname: state.particularUser!['last_name'],
                            displayAmount: state.displayAmount!,
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            final curve = CurvedAnimation(
                              parent: animation,
                              curve: Curves.decelerate,
                            );

                            return Stack(
                              children: [
                                FadeTransition(
                                  opacity: Tween<double>(
                                    begin: 1.0,
                                    end: 0.0,
                                  ).animate(curve),
                                ),
                                SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 1.0),
                                    end: Offset.zero,
                                  ).animate(curve),
                                  child: FadeTransition(
                                    opacity: Tween<double>(
                                      begin: 0.0,
                                      end: 1.0,
                                    ).animate(curve),
                                    child: SendMoney(
                                      uuid: state.particularUser!['id'],
                                      firstname:
                                          state.particularUser!['first_name'],
                                      lastname:
                                          state.particularUser!['last_name'],
                                      displayAmount: state.displayAmount!,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Container(
                      width: size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      // height: size.height * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Send Money",
                                style: textTheme.titleMedium,
                              ),
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child: Row(
                                children: state.isLoaded
                                    ? state.favouritesList!
                                        .map(
                                          (item) => GestureDetector(
                                            onTap: () => context
                                                .read<HomeFavoritesBloc>()
                                                .add(LoadParticularUser(
                                                    uuid: item.id.toString(),
                                                    favorites:
                                                        state.favouritesList!)),
                                            child: imageLoader(
                                              imageUrl: item.id.toString(),
                                              shape: ImageType.initial,
                                              width: 60,
                                              height: 60,
                                            ),
                                          ),
                                        )
                                        .toList()
                                    : [
                                        CircularLoadingAnimation(
                                            width: 60, height: 60)
                                      ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            : CircularLoadingAnimation(width: 60, height: 60);
      },
    );
  }
}
//
