import 'package:arduino_wifi/helpers/snackbar_global.dart';
import 'package:arduino_wifi/services/geometry_service.dart';
import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  final GeometryService geometryService = GeometryService();

  // Computer polygon coordinates
  final List<List<double>> computerPolygon = [
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
  final List<List<double>> phonePolygon = [
    [290, 172],
    [324, 172],
    [328, 176],
    [335, 240],
    [331, 244],
    [298, 244],
    [293, 238]
  ];

  // Coffee polygon coordinates
  final List<List<double>> coffeePolygon = [
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

  void handleTapEvent(TapDownDetails details, BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);

    final List<Offset> computerPoly =
        computerPolygon.map((point) => Offset(point[0], point[1])).toList();

    final List<Offset> coffeePoly =
        coffeePolygon.map((point) => Offset(point[0], point[1])).toList();

    final List<Offset> phonePoly =
        phonePolygon.map((point) => Offset(point[0], point[1])).toList();

    final bool isInComputer =
        GeometryService.isPointInPolygon(localPosition, computerPoly);

    if (isInComputer) {
      // Handle computer tap event
      print("Computer tapped at: $localPosition");
      SnackbarGlobal.show("Computer tapped at: $localPosition");
      return;
    }
    final bool isInPhone =
        GeometryService.isPointInPolygon(localPosition, phonePoly);

    if (isInPhone) {
      // Handle phone tap event
      print("Phone tapped at: $localPosition");
      SnackbarGlobal.show("Phone tapped at: $localPosition");
      return;
    }

    final bool isInCoffee =
        GeometryService.isPointInPolygon(localPosition, coffeePoly);

    if (isInCoffee) {
      // Handle coffee tap event
      print("Coffee tapped at: $localPosition");
      SnackbarGlobal.show("Coffee tapped at: $localPosition");
      return;
    }
  }
}
