import 'dart:math';

import 'package:aaryapay/components/RecentPaymentCard.dart';
import 'package:aaryapay/global/bloc/data_bloc.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/TransactionHistory/bloc/transaction_bloc.dart';
import 'package:aaryapay/screens/TransactionHistory/components/transaction_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  Widget body(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DataBloc>().add(RequestSyncEvent());
      },
      child: BlocConsumer<DataBloc, DataState>(
        listener: (context, dataState) {},
        builder: (context, dataState) {
          return BlocProvider(
            create: (context) => TranscationBloc()
              ..add(LoadTransaction(
                  transactions:
                      dataState.transactions.getSubmittedTransactions())),
            child: BlocConsumer<TranscationBloc, TranscationState>(
              listener: (context, state) {
                if (state.senderName != null &&
                    state.receiverName != null &&
                    state.item != null) {
                  Utils.mainAppNav.currentState!.push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          TransactionDetailsScreen(
                        transactionItem: state.item,
                        recieverName: state.receiverName,
                        senderName: state.senderName,
                      ),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
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
                              child: child,
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
                                child: child,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
              },
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                return Container(
                  clipBehavior: Clip.hardEdge,
                  width: size.width,
                  height: size.height * 0.75,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                    color: Color(0xfff4f6f4),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (dataState.isReady &&
                                dataState.transactions
                                    .getSubmittedTransactions()
                                    .isNotEmpty)
                            ? [
                                ...dataState.transactions
                                    .getSubmittedTransactions()
                                    .take(min(
                                        dataState.transactions
                                            .getSubmittedTransactions()
                                            .length,
                                        5))
                                    .map(
                                      (item) => GestureDetector(
                                        onTapDown: (details) {
                                          context.read<TranscationBloc>().add(
                                                LoadParticularUser(
                                                  item: item,
                                                  receiverID: item
                                                      .receiverTvc!.bkvc.userID
                                                      .toString(),
                                                  senderID: item
                                                      .senderTvc!.bkvc.userID
                                                      .toString(),
                                                ),
                                              );
                                        },
                                        onTapUp: (details) {
                                          context
                                              .read<TranscationBloc>()
                                              .add(ClearLoadedUser());
                                        },
                                        child: RecentPaymentCard(
                                          finalAmt: dataState
                                              .bkvc!.availableBalance
                                              .toString(),
                                          transaction: item,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ]
                            : [
                                Center(
                                  child: Text("No Recent Transactions",
                                      style:
                                          Theme.of(context).textTheme.titleMedium),
                                )
                              ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: body(context),
    );
  }
}
