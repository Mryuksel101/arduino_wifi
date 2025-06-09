import 'dart:developer';

import 'package:arduino_wifi/helpers/snackbar_global.dart';
import 'package:arduino_wifi/services/geometry_service.dart';
import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  final GeometryService geometryService = GeometryService();
  Offset? tapPosition;
  String tapInfoText = "No tap detected";
  final double originalImageWidth = 400;
  final double originalImageHeight = 379;

  Map<String, List<Offset>> get normalizedpolygons => {
        "computer": _computerPolygon
            .map((point) => Offset(
                point[0] / originalImageWidth, point[1] / originalImageHeight))
            .toList(),
        "phone": _phonePolygon
            .map((point) => Offset(
                point[0] / originalImageWidth, point[1] / originalImageHeight))
            .toList(),
        "coffee": _coffeePolygon
            .map((point) => Offset(
                point[0] / originalImageWidth, point[1] / originalImageHeight))
            .toList(),
      };

  List<Offset> scaledPoints(
    List<List<double>> points,
    Size actualSize,
  ) {
    return points
        .map((point) =>
            Offset(point[0] * actualSize.width, point[1] * actualSize.height))
        .toList();
  }

  Size _imageActualSize(GlobalKey imageKey) {
    final RenderBox box =
        imageKey.currentContext?.findRenderObject() as RenderBox;
    // Assuming the image is displayed at its original size
    return Size(box.size.width, box.size.height);
  }

  // Computer polygon coordinates
  final List<List<double>> _computerPolygon = [
    [32, 42],
    [268, 41],
    [274, 46],
    [264, 186],
    [258, 188],
    [266, 192],
    [273, 340],
    [272, 346],
    [259, 349],
    [172, 348],
    [37, 347],
    [32, 340],
    [43, 184],
    [40, 146]
  ];

  // Phone polygon coordinates
  final List<List<double>> _phonePolygon = [
    [290, 172],
    [324, 172],
    [328, 176],
    [335, 240],
    [331, 244],
    [298, 244],
    [293, 238]
  ];

  // Coffee polygon coordinates
  final List<List<double>> _coffeePolygon = [
    [329, 257],
    [344, 258],
    [350, 259],
    [356, 262],
    [361, 266],
    [367, 270],
    [376, 271],
    [393, 271],
    [397, 274],
    [395, 279],
    [386, 279],
    [374, 278],
    [378, 283],
    [380, 289],
    [382, 296],
    [382, 305],
    [381, 313],
    [380, 325],
    [373, 332],
    [365, 338],
    [357, 342],
    [347, 344],
    [336, 344],
    [325, 342],
    [312, 334],
    [298, 320],
    [292, 298],
    [296, 277],
    [310, 262]
  ];

  void handleTapEvent(TapDownDetails details, GlobalKey imageKey) {
    // Get the RenderBox of the image widget specifically
    final RenderBox box =
        imageKey.currentContext?.findRenderObject() as RenderBox;

    // Calculate position relative to the image
    final Offset localPosition = box.globalToLocal(details.globalPosition);

    // Update tap position for display
    tapPosition = localPosition;

    log("Tap event detected at: ${details.globalPosition}");
    log("Local position relative to image: $localPosition");

    for (final MapEntry<String, List<Offset>> polygon
        in normalizedpolygons.entries) {
      final List<Offset> scaledPoints = this.scaledPoints(
        polygon.value.map((point) => [point.dx, point.dy]).toList(),
        _imageActualSize(imageKey),
      );
      if (geometryService.isPointInPolygon(localPosition, scaledPoints)) {
        SnackbarGlobal.show("${polygon.key} tapped at: $localPosition");
        tapInfoText = "${polygon.key} tapped at: $localPosition";
        notifyListeners();
        return;
      }
    }
  }
}
