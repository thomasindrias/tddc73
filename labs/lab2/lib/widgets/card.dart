import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab2/models/card_model.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({
    Key key,
    this.cardHolder,
    this.cardNr,
    this.expDate,
    this.cvv,
    this.bgNr,
    this.isCardFlipped,
    this.cardModel = const CardModel(),
    this.backgroundImage,
  }) : super(key: key);

  final String cardHolder;
  final String cardNr;
  final String expDate;
  final String cvv;
  final int bgNr;
  final bool isCardFlipped;
  final CardModel cardModel;
  final int backgroundImage;

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return AnimatedCrossFade(
      firstChild: buildBackCard(width, height, widget.backgroundImage, context),
      secondChild:
          buildFrontCard(width, height, widget.backgroundImage, context),
      crossFadeState: widget.isCardFlipped
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 500),
    );
  }

  Container buildFrontCard(
      double width, double height, int backgroundImage, BuildContext ctx) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/cards/$backgroundImage.jpeg'),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.srcOver))),
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/cards/chip.png',
                      width: 48,
                      height: 48,
                    ),
                    Image.asset(
                      'assets/cards/${getCardType(widget.cardNr)}.png',
                      width: 64,
                      height: 64,
                    ),
                  ]),
            ),
            Flexible(
              flex: 1,
              child: Text(
                widget.cardNr.isEmpty || widget.cardNr == null
                    ? widget.cardModel.cardNrHint
                    : widget.cardNr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    wordSpacing: 20,
                    letterSpacing: 3,
                    shadows: [
                      Shadow(
                        offset: Offset(-2, 4),
                        blurRadius: 18.0,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ]),
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cardModel.cardHolderLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.sourceSansPro(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        widget.cardHolder.isEmpty || widget.cardHolder == null
                            ? widget.cardModel.cardHolderHint.toUpperCase()
                            : widget.cardHolder.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.sourceSansPro(
                            color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.cardModel.expDateLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.sourceSansPro(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        widget.expDate.isEmpty || widget.expDate == null
                            ? widget.cardModel.expDateHint
                            : widget.expDate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.sourceSansPro(
                            color: Colors.white, fontSize: 16),
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

  Container buildBackCard(
      double width, double height, int backgroundImage, BuildContext ctx) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/cards/$backgroundImage.jpeg'),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.srcOver))),
      width: width,
      height: height / 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(top: 28),
              height: 48,
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 13.0, right: 16, left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        widget.cardModel.cvvLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.sourceSansPro(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      height: 38,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${widget.cvv.replaceAll(RegExp(r"."), "*")}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  'assets/cards/${getCardType(widget.cardNr)}.png',
                  width: 64,
                  height: 64,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getCardType(String cardNumber) {
    RegExp re = new RegExp("^4");
    if (re.hasMatch(cardNumber)) return "visa";

    re = new RegExp("^(34|37)");
    if (re.hasMatch(cardNumber)) return "amex";

    re = new RegExp("^5[1-5]");
    if (re.hasMatch(cardNumber)) return "mastercard";

    re = new RegExp("^6011");
    if (re.hasMatch(cardNumber)) return "discover";

    re = new RegExp('^9792');
    if (re.hasMatch(cardNumber)) return 'troy';

    return "visa"; // default type
  }
}
