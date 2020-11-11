import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab2/models/card_information.dart';
import 'package:lab2/models/card_model.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm(
      {Key key, this.onChange, this.cardModel = const CardModel()})
      : super(key: key);

  final CardModel cardModel;
  final void Function(CardInformation) onChange;

  @override
  CreditCardFormState createState() => CreditCardFormState();
}

class CreditCardFormState extends State<CreditCardForm> {
  String cardHolder;
  String cardNr;
  String expDate;
  String chosenMonth;
  String chosenYear;
  String cvv;
  bool isCardFlipped;

  TextEditingController cardHolderController;
  TextEditingController cardNrController;
  TextEditingController cvvController;

  void Function(CardInformation) onChange;
  CardModel cardModel = CardModel();
  CardInformation cardInfo;

  String formatCardNr(String nr) {
    var nrList = nr.split(" ");

    if (nrList.length > 1) nrList[1] = nrList[1].replaceAll(RegExp("."), "*");
    if (nrList.length > 2) nrList[2] = nrList[2].replaceAll(RegExp("."), "*");

    return nrList.join(" ");
  }

  var months = List<DropdownMenuItem<String>>.generate(12, (i) {
    return DropdownMenuItem(
        value: (i + 1).toString().padLeft(2, '0'),
        child: Text((i + 1).toString().padLeft(2, '0')));
  });

  var years = List<DropdownMenuItem<String>>.generate(5, (i) {
    return DropdownMenuItem(
        value: (DateTime.now().year + i).toString(),
        child: Text((DateTime.now().year + i).toString()));
  });

  FocusNode cvvFocus = FocusNode();

  void cvvFocused() {
    cardInfo.isCardFlipped = cvvFocus.hasFocus;
    onChange(cardInfo);
  }

  void expDateController(String nr, bool isMM) {
    var expDateList = expDate.split("/");
    var expDateFormated = (isMM)
        ? "$nr/${expDateList[1]}"
        : "${expDateList[0]}/${nr.substring(2, 4)}";

    setState(() {
      expDate = expDateFormated;
      cardInfo.expDate = expDate;
      onChange(cardInfo);
    });
  }

  @override
  void initState() {
    super.initState();

    cardHolder = '';
    cardNr = '';
    expDate = 'MM/YY';
    chosenMonth = months[1].value;
    chosenYear = years[1].value;
    cvv = '';
    isCardFlipped = false;

    cardHolderController = TextEditingController();
    cardNrController = MaskedTextController(mask: '0000 **** **** 0000');
    cvvController = MaskedTextController(mask: '0000');

    cardInfo = CardInformation(cardHolder, cardNr, expDate, cvv, isCardFlipped);
    onChange = widget.onChange;

    cvvFocus.addListener(cvvFocused);

    cardNrController.addListener(() {
      String cardNrFormated = cardNrController.text;
      if (cardNrFormated.length > 4)
        cardNrFormated = formatCardNr(cardNrController.text);

      setState(() {
        cardNr = cardNrFormated;
        cardInfo.cardNr = cardNr;
        onChange(cardInfo);
      });
    });

    cardHolderController.addListener(() {
      setState(() {
        cardHolder = cardHolderController.text;
        cardInfo.cardHolder = cardHolder;
        onChange(cardInfo);
      });
    });

    cvvController.addListener(() {
      setState(() {
        cvv = cvvController.text;
        cardInfo.cvv = cvv;
        onChange(cardInfo);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Form(
        child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
          child: TextFormField(
            controller: cardNrController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.cardModel.cardNr,
              hintText: widget.cardModel.cardNrHint,
            ),
            onEditingComplete: () => node.nextFocus(),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
          child: TextFormField(
            controller: cardHolderController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.cardModel.cardHolderLabel,
              hintText: widget.cardModel.cardHolderHint,
            ),
            onEditingComplete: () => node.nextFocus(),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                          value: chosenMonth,
                          items: months,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(7.0),
                            border: const OutlineInputBorder(),
                            labelText: "Month",
                            hintText: "MM",
                          ),
                          style: GoogleFonts.sourceSansPro(
                              color: Colors.black87, fontSize: 18),
                          onChanged: (String month) {
                            setState(() {
                              //FocusScope.of(context).requestFocus(FocusNode());
                              node.nextFocus();

                              chosenMonth = month;
                              expDateController(chosenMonth, true);
                            });
                          }),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Flexible(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                          value: chosenYear,
                          items: years,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8.0),
                            border: const OutlineInputBorder(),
                            labelText: "Year",
                            hintText: "YY",
                          ),
                          style: GoogleFonts.sourceSansPro(
                              color: Colors.black87, fontSize: 18),
                          onChanged: (String year) {
                            //FocusScope.of(context).requestFocus(FocusNode());
                            node.nextFocus();
                            chosenYear = year;
                            expDateController(year, false);
                          }),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0, 0, 0),
                  child: TextFormField(
                    controller: cvvController,
                    focusNode: cvvFocus,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      border: const OutlineInputBorder(),
                      labelText: widget.cardModel.cvvLabel,
                      hintText: widget.cardModel.cvvHint,
                    ),
                    onFieldSubmitted: (_) => node.unfocus(),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
