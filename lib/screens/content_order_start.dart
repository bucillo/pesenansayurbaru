import 'package:PesenSayur/screens/content_home.dart';
import 'package:PesenSayur/screens/content_order_history.dart';
import 'package:PesenSayur/util/const.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';
import 'package:PesenSayur/models/api.dart';
import 'package:PesenSayur/models/auth.dart';
import 'package:PesenSayur/models/cart.dart';
import 'package:PesenSayur/models/category.dart';
import 'package:PesenSayur/models/paymentmethod.dart';
import 'package:PesenSayur/models/product.dart';
import 'package:PesenSayur/models/salestype.dart';
import 'package:PesenSayur/models/shift.dart';
import 'package:PesenSayur/models/syncronize.dart';

class ContentOrderStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image_onboarding.png',
                    width: 355,
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Text(
                    'Order',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Reseller silakan order ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Global.materialNavigateReplace(
                              context, ContentOrderHistory());
                          Global.materialNavigate(
                              context, ContentOrderHistory());
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Start order >',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
