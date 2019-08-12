GURPS Dice
==========

GURPS Dice is a library for any Dart (or Flutter) developer who needs
to handle the specific way the GURPS and Dungeon Fantasy RPGs handle
dice.

![Coverage Status](coverage_badge.svg)

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
main() {
  // Create based on a string
  DieRoll twoDminus1 = DieRoll.fromString('2d-1');

  // Create based on number of dice and adds
  DieRoll d2 = DieRoll(dice: 2);

  // Do dice math
  assert(twoDminus1 + 1 == d2);
  assert(twoDminus1 * 2 == DieRoll.fromString('3d+2'));
  assert(twoDminus1 / 2 == DieRoll.fromString('1d-1'));

  // By default, dice are 'normalized' -- each +4 is adds equals +1 dice.
  // Normal dice progression is 1d-1, 1d, 1d+1, 1d+2, 2d-1, 2d, ...
  assert(DieRoll(dice: 1) + 4 == DieRoll(dice: 2));
  assert(DieRoll(dice: 2) + 7 == DieRoll(dice: 4, adds: -1));
  assert(DieRoll.fromString('3d-3') == DieRoll(dice: 2, adds: 1));

  // Normalization can be turned off.
  var roll1d = DieRoll(dice: 1, normalize: false);

  assert(roll1d + 4 != DieRoll(dice: 2));
  assert(roll1d + 4 == DieRoll(dice: 1, adds: 4, normalize: false));

  var roll2d = DieRoll(dice: 2, normalize: false);
  assert(roll2d + 7 == DieRoll(dice: 2, adds: 7, normalize: false));

  assert(DieRoll.fromString('3d-3', normalize: false) ==
      DieRoll(dice: 3, adds: -3, normalize: false));

  // You can roll dice:
  var dThree = DieRoll.fromString('3d');
  for (var i = 0; i < 1000; i++) {
    int roll = dThree.roll();
    assert(roll >= 3 && roll <= 18);
  }
}
```

