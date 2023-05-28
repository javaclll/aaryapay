import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomAnimationWidget.dart';
import 'package:aaryapay/global/bloc/data_bloc.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/SplashScreen/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider<SplashBloc>(
      create: (context) => SplashBloc(),
      child: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state.isBiometricAuthSuccess == true) {
            Utils.mainAppNav.currentState!
                .pushNamedAndRemoveUntil("/app", (_) => false);
          }
        },
        builder: (context, state) {
          return BlocConsumer<DataBloc, DataState>(
            listener: (context, dataState) {
              if (dataState.isReady == true &&
                  dataState.isLoaded == false &&
                  dataState.profile == null) {
                Utils.mainAppNav.currentState!
                    .pushNamedAndRemoveUntil("/welcome", (_) => false);
              }
            },
            buildWhen: (previous, current) =>
                current.isLoaded == true ? true : false,
            builder: (context, dataState) {
              return SafeArea(
                top: false,
                bottom: true,
                left: true,
                right: true,
                child: Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.3,
                          child: Utils.mainlogo,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                        margin: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            'AaryaPay',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .merge(
                                    const TextStyle(fontWeight: FontWeight.w800)),
                          ),
                        ),
                        dataState.isLoaded == true
                            ? CustomActionButton(
                                width: size.width * 0.60,
                                height: size.height * 0.07,
                                margin: 20,
                                borderRadius: 10,
                                label: "Finger",
                                onClick: () => context
                                    .read<SplashBloc>()
                                    .add(InitiateBiometricAuth()),
                              )
                            : CustomAnimationWidget(
                                width: 50,
                                height: 50,
                                repeat: true,
                                assetSrc: "assets/animations/loading.json",
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}