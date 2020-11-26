import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_cart/shopping_cart.dart';

class ShoppingCartWidget extends StatefulWidget {
  const ShoppingCartWidget({
    Key key,
    @required this.shoppingItems,
    this.height,
    this.locale,
  })  : assert(shoppingItems.length >
            1), // Make sure the shopping cart doesnt have only one item
        super(key: key);

  final List<ShoppingModel> shoppingItems;
  final double height;
  final String locale;

  @override
  _ShoppingCartWidgetState createState() => _ShoppingCartWidgetState();
}

class _ShoppingCartWidgetState extends State<ShoppingCartWidget> {
  void itemHandler(int value, int index) {
    setState(() {
      //If value is zero then check if user wants to remove item
      (widget.shoppingItems[index].nrItems + value < 1)
          ? showAlertDialog(index, context)
          : widget.shoppingItems[index].nrItems += value;
    });
    print(widget.shoppingItems.length);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final NumberFormat format =
        NumberFormat.simpleCurrency(locale: widget.locale);

    return ListView.builder(
        itemCount: widget.shoppingItems.length,
        itemBuilder: (BuildContext context, int i) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
            child: Container(
                height: 120,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Stack(
                          overflow: Overflow.visible,
                          children: [
                            bgCircle(width, height,
                                widget.shoppingItems[i].color, context),
                            Positioned(
                              right: 10,
                              bottom: 10,
                              child: Container(
                                height: 10,
                                width: width / 7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 10,
                                      blurRadius: 13,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: CachedNetworkImage(
                                imageUrl: widget.shoppingItems[i].img,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fitWidth,
                                      alignment: FractionalOffset.topCenter,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            widget.shoppingItems[i].name,
                            style: GoogleFonts.nunitoSans(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 16,
                              wordSpacing: 0.1,
                              color: Colors.indigo[900].withOpacity(0.9),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${format.format(widget.shoppingItems[i].price * widget.shoppingItems[i].nrItems)}',
                            style: GoogleFonts.nunitoSans(
                              textStyle: Theme.of(context).textTheme.subtitle1,
                              fontSize: 20,
                              wordSpacing: 0.1,
                              color: Colors.indigo[900].withOpacity(0.9),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MaterialButton(
                            height: 28,
                            onPressed: () {
                              itemHandler(-1, i);
                            },
                            splashColor: Colors.blueAccent,
                            color: Colors.white,
                            child: FaIcon(
                              FontAwesomeIcons.minus,
                              color: Colors.black,
                              size: 14,
                            ),
                            shape: CircleBorder(),
                          ),
                          Text(
                            widget.shoppingItems[i].nrItems.toString(),
                            style: GoogleFonts.nunitoSans(
                              textStyle: Theme.of(context).textTheme.subtitle1,
                              fontSize: 14,
                              color: Colors.indigo[900].withOpacity(0.9),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          MaterialButton(
                            height: 28,
                            onPressed: () {
                              itemHandler(1, i);
                            },
                            splashColor: Colors.blueAccent,
                            color: Colors.white,
                            child: FaIcon(
                              FontAwesomeIcons.plus,
                              color: Colors.black,
                              size: 14,
                            ),
                            shape: CircleBorder(),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          );
        });
  }

  Container bgCircle(
      double width, double height, Color color, BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
          color: Colors.grey,
          gradient: RadialGradient(
            colors: [color.withOpacity(0.6), color.withOpacity(0.4)],
          ), // Colors.orangeAccent[200].withOpacity(0.6),
          shape: BoxShape.circle),
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            shape: BoxShape.circle),
      ),
    );
  }

  showAlertDialog(int index, BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: GoogleFonts.nunitoSans(
          textStyle: Theme.of(context).textTheme.subtitle1,
          fontSize: 14,
          color: Colors.indigo[900].withOpacity(0.9),
          fontWeight: FontWeight.w800,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Continue",
        style: GoogleFonts.nunitoSans(
          textStyle: Theme.of(context).textTheme.subtitle1,
          fontSize: 14,
          color: Colors.indigo[900].withOpacity(0.9),
          fontWeight: FontWeight.w800,
        ),
      ),
      onPressed: () {
        setState(() {
          widget.shoppingItems.removeAt(index);
          Navigator.pop(context);
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Whoops!"),
      content: Text(
        "Are you sure you want to remove it from your shopping cart?",
        style: GoogleFonts.nunitoSans(
          textStyle: Theme.of(context).textTheme.subtitle1,
          fontSize: 14,
          color: Colors.indigo[900].withOpacity(0.9),
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
