import 'package:mu_dart/common/model/map.dart' as mp;

class MapService {
  final maps = <int, mp.Map>{};
  final mapsIndex = <int>[
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    36,
    37,
    38,
    39
  ];

  void init() {
    for (var index in mapsIndex) {
      var map = mp.Map();
      map.mapIndex = index;
      maps.addAll({
        index: map,
      });
    }
  }
}
