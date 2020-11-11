class CardModel {
  const CardModel({
    this.cardHolderLabel = _cardHolderLabelDefault,
    this.cardHolderHint = _cardHolderHintDefault,
    this.cardNr = _cardNrDefault,
    this.cardNrHint = _cardNrHintDefault,
    this.expDateLabel = _expDateLabelDefault,
    this.expDateHint = _expDateHintDefault,
    this.cvvLabel = _cvvLabelDefault,
    this.cvvHint = _cvvHintDefault,
  });

  static const String _cardHolderLabelDefault = 'Card Holder';
  static const String _cardHolderHintDefault = 'Full name';
  static const String _cardNrDefault = 'Card Number';
  static const String _cardNrHintDefault = '#### #### #### ####';
  static const String _expDateLabelDefault = 'Expires';
  static const String _expDateHintDefault = 'MM/YY';
  static const String _cvvLabelDefault = 'CVV';
  static const String _cvvHintDefault = '';

  final String cardHolderLabel;
  final String cardHolderHint;
  final String cardNr;
  final String cardNrHint;
  final String expDateLabel;
  final String expDateHint;
  final String cvvLabel;
  final String cvvHint;
}
