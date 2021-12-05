class PaymentRequestModel {
  final String tranRef;
  final String cartId;
  final String redirectUrl;

  PaymentRequestModel(
      {required this.tranRef, required this.cartId, required this.redirectUrl});
}
