import 'package:aaryapay/global/caching/transaction.dart';
import 'package:aaryapay/screens/Send/components/trans_details_outlined.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiverConfirmation extends StatelessWidget {
  Transaction? transaction;
  ReceiverConfirmation({Key? key, this.transaction}) : super(key: key);
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
                    child: Text("Transfer Initiated",
                        style: Theme.of(context).textTheme.headlineMedium!),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(context),
                      icon: SvgPicture.asset('assets/icons/close.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                              Colors.black, BlendMode.srcIn)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: QrImageView(
                data:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
                size: 240,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text("Let the Sender Scan the",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                "QR Code to complete Offline Transaction",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            TransactionDetailsOutlineBox(
              initiator: transaction!.senderId.toString().substring(0, 8),
              amount: "Rs. ${transaction?.amount}",
              date: DateFormat.yMMMMEEEEd().format(transaction!.generationTime),
            ),
          ],
        )
      ],
    );
  }
}
