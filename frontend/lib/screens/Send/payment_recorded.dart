import 'package:aaryapay/global/caching/transaction.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Send/components/green_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aaryapay/components/CustomAnimationWidget.dart';
import 'package:intl/intl.dart';

class PaymentRecorded extends StatelessWidget {
  final Transaction tvc;
  const PaymentRecorded({Key? key, required this.tvc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: body(size, context),
        ));
  }

  Widget body(Size size, BuildContext context) {
    void onClick() {
      // Utils.mainAppNav.currentState!.push(
      //   PageRouteBuilder(
      //     pageBuilder: (context, animation1, animation2) =>
      //         const QrScanScreen(),
      //     transitionDuration: Duration.zero,
      //     reverseTransitionDuration: Duration.zero,
      //   ),
      // );
    }

    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text("Offline Payment Recorded",
                        style: Theme.of(context).textTheme.titleLarge!),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => {
                        Utils.mainAppNav.currentState!
                            .popUntil(ModalRoute.withName("/app"))
                      },
                      icon: SvgPicture.asset('assets/icons/close.svg',
                          width: 15,
                          height: 15,
                          colorFilter: const ColorFilter.mode(
                              Colors.black, BlendMode.srcIn)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      // padding: const EdgeInsets.symmetric(vertical: 2),
                      ),
                  Stack(children: [
                    Container(
                        child: CustomAnimationWidget(
                      assetSrc: 'assets/animations/recorded.json',
                      repeat: true,
                    )

                        // child: SvgPicture.asset('assets/icons/check.svg',
                        //     width: 80,
                        //     colorFilter: const ColorFilter.mode(
                        //         Color(0xff274233), BlendMode.srcIn)),
                        )
                  ]),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Text("Transaction Recorded in your Device!",
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/rupee.svg',
                            width: 24,
                            colorFilter: const ColorFilter.mode(
                                Color(0xff274233), BlendMode.srcIn)),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: Text(
                            tvc.amount.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .merge(
                                  TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GreenBox(
                      receiveruuid: tvc.receiverId.toString(),
                      recipient: tvc.receiverId.toString().substring(0, 8),
                      amount: tvc.amount.toString(),
                      date: DateFormat.yMMMMd().format(tvc.generationTime),
                      sender: tvc.senderId.toString().substring(0, 8),
                      status: "Verified"),
                ],
              ),
            ),
            Positioned(
              top: 100,
              child: Container(child: Utils.background),
            ),
          ],
        ),
      ],
    );
  }
}
