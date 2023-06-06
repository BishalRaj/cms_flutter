import 'dart:io';

class ProductModle {
  int? _barCode;
  String? _productName;
  double? _wholesalePrice;
  double? _retailPrice;
  int? _quantity;
  String? _imageURL;
  File? _imageFile;

  ProductModle.withoutBarcode(this._productName, this._wholesalePrice,
      this._retailPrice, this._quantity, this._imageURL);
  ProductModle.withBarcode(this._barCode, this._productName,
      this._wholesalePrice, this._retailPrice, this._quantity, this._imageURL);
  ProductModle.orders(
      this._barCode, this._productName, this._quantity, this._imageURL);

  ProductModle(this._barCode, this._productName, this._wholesalePrice,
      this._retailPrice, this._quantity, this._imageFile);

  get barCode => _barCode;

  set barCode(value) => this._barCode = value;

  get productName => this._productName;

  set productName(value) => this._productName = value;

  get wholesalePrice => this._wholesalePrice;

  set wholesalePrice(value) => this._wholesalePrice = value;

  get retailPrice => this._retailPrice;

  set retailPrice(value) => this._retailPrice = value;

  get quantity => this._quantity;

  set quantity(value) => this._quantity = value;

  get imageURL => this._imageURL;

  set imageURL(value) => this._imageURL = value;

  get imageFile => this._imageFile;

  set imageFile(value) => this._imageFile = value;
}
