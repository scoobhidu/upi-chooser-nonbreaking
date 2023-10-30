import 'dart:typed_data';

class UpiApps {
  /// This is Unique serial no - [int]
  int? id;

  /// This is for displaying purpose - [String]
  String? displayName;

  /// Icon for the package - [String]
  String? iconUrl;

  /// App URI for the package - [String]
  String? appUri;

  /// Icon for the package - [bool]
  bool? isAvailable;

  /// Scheme for the package - [String]
  String? scheme;

  /// Image for the package - [ByteData]
  Uint8List? imageData;

  /// Default constructor for UpiApps
  UpiApps({
    this.id,
    this.displayName,
    this.iconUrl,
    this.appUri,
    this.isAvailable,
    this.scheme,
    this.imageData,
  });
}
