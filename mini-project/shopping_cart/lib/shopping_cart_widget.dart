import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_cart/shopping_cart.dart';

class ShoppingCartWidget extends StatefulWidget {
  const ShoppingCartWidget(
      {Key key,
      @required this.shoppingItems,
      @required this.pageRoute,
      this.extraCost,
      this.height,
      this.locale,
      this.buttonMenu})
      : assert(shoppingItems.length >
            1), // Make sure the shopping cart doesnt have only one item
        assert(pageRoute == null),
        super(key: key);

  final List<ShoppingModel> shoppingItems;
  final double height;
  final String locale;
  final List<ExtraCostModel> extraCost;
  final Widget buttonMenu;
  final MaterialPageRoute pageRoute;

  @override
  _ShoppingCartWidgetState createState() => _ShoppingCartWidgetState();
}

class _ShoppingCartWidgetState extends State<ShoppingCartWidget> {
  // void itemHandler(int, int)
  // Handles the nr of duplicates of an item and opens a dialogue box
  // if nr duplicates is zero.
  // ----------------------------
  // INPUT
  // value: Nr of duplicates for an item
  // index: index value from the list of items
  void itemHandler(int value, int index) {
    setState(() {
      //If value is zero then check if user wants to remove item
      (widget.shoppingItems[index].nrItems + value < 1)
          ? showAlertDialog(index, context)
          : widget.shoppingItems[index].nrItems += value;
    });
    print(widget.shoppingItems.length);
  }

  // double totalPriceCalc(double, List<ExtraCostModel>)
  // ----------------------------
  // INPUT
  // subPrice: Total price from the items displayed
  // extra: User can send in a list of tax, shipping cost etc.
  // through a list of ExtraCostModel
  // ----------------------------
  // OUTPUT: The total price
  double getTotalPrice(
      List<ShoppingModel> shoppingItems, List<ExtraCostModel> extra) {
    var subPrice = getSubPrice(shoppingItems);
    var extraSum =
        (extra != null) ? extra.fold(0, (sum, a) => sum + a.cost) : 0.0;

    return subPrice + extraSum;
  }

  double getSubPrice(List<ShoppingModel> shoppingItems) {
    return shoppingItems.fold(0, (sum, a) => sum + a.price * a.nrItems);
  }

  NumberFormat format;

  @override
  void initState() {
    super.initState();

    format = NumberFormat.simpleCurrency(locale: widget.locale);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Column(children: [
      Expanded(
        child: ListView.builder(
            //padding: EdgeInsets.only(bottom: 120),
            itemCount: widget.shoppingItems.length + 1,
            itemBuilder: (BuildContext context, int i) {
              if (i == widget.shoppingItems.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: subPrices(context),
                );
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.0),
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
                                          // changes position of shadow
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
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 16,
                                  wordSpacing: 0.1,
                                  color: Colors.indigo[900].withOpacity(0.9),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${format.format(widget.shoppingItems[i].price * widget.shoppingItems[i].nrItems)}',
                                style: GoogleFonts.nunitoSans(
                                  textStyle:
                                      Theme.of(context).textTheme.subtitle1,
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
                              Text(
                                widget.shoppingItems[i].nrItems.toString(),
                                style: GoogleFonts.nunitoSans(
                                  textStyle:
                                      Theme.of(context).textTheme.subtitle1,
                                  fontSize: 14,
                                  color: Colors.indigo[900].withOpacity(0.9),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              MaterialButton(
                                height: 28,
                                onPressed: () {
                                  itemHandler(-1, i);
                                },
                                splashColor: Colors.blueAccent,
                                color: (widget.shoppingItems[i].nrItems == 1)
                                    ? Colors.red
                                    : Colors.white,
                                child: FaIcon(
                                  (widget.shoppingItems[i].nrItems == 1)
                                      ? FontAwesomeIcons.trash
                                      : FontAwesomeIcons.minus,
                                  color: (widget.shoppingItems[i].nrItems == 1)
                                      ? Colors.white
                                      : Colors.black,
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
            }),
      ),
      footerMenu(context)
    ]);
  }

  Container footerMenu(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(26.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 10,
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${format.format(getTotalPrice(widget.shoppingItems, widget.extraCost))}',
            style: GoogleFonts.nunitoSans(
              textStyle: Theme.of(context).textTheme.subtitle1,
              fontSize: 24,
              wordSpacing: 0.1,
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(22.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 2,
                    blurRadius: 12,
                    offset: Offset(-2, 2)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(22.0)),
              child: MaterialButton(
                height: 46,
                onPressed: () {
                  if (widget.pageRoute != null)
                    Navigator.push(context, widget.pageRoute);
                },
                splashColor: Colors.blueAccent,
                color: Colors.indigo[900].withOpacity(0.9),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.nunitoSans(
                      textStyle: Theme.of(context).textTheme.subtitle1,
                      fontSize: 16,
                      wordSpacing: 0.1,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: FaIcon(
                          FontAwesomeIcons.shoppingBag,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      TextSpan(
                        text: "   Check out",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ); //Buttons
  }

  Row subPrices(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.nunitoSans(
                textStyle: Theme.of(context).textTheme.subtitle1,
                fontSize: 18,
                color: Colors.grey,
              ),
              children: <TextSpan>[
                TextSpan(text: 'Subprice: '),
                TextSpan(
                    text: '${format.format(getSubPrice(widget.shoppingItems))}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.extraCost
              .map((item) => Container(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.nunitoSans(
                          textStyle: Theme.of(context).textTheme.subtitle1,
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: "${item.name}: "),
                          TextSpan(
                              text: '${format.format(item.cost)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
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
