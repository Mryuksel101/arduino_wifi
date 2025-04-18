import 'package:flutter/material.dart';

class GeometryService {
  /// Checks if a point is inside a polygon using the ray casting algorithm
  static bool isPointInPolygon(Offset point, List<Offset> polygon) {
    int intersectCount = 0;
    for (int j = 0; j < polygon.length; j++) {
      int i = (j + 1) % polygon.length;
      // Noktanın y koordinatı ile kenar arasında kesişim kontrolü
      if (((polygon[j].dy > point.dy) != (polygon[i].dy > point.dy)) &&
          (point.dx <
              (polygon[i].dx - polygon[j].dx) *
                      (point.dy - polygon[j].dy) /
                      (polygon[i].dy - polygon[j].dy) +
                  polygon[j].dx)) {
        intersectCount++;
      }
    }
    // Eğer kesişim sayısı tek ise nokta polygon içindedir.
    return (intersectCount % 2) == 1;
  }
}
