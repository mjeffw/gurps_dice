import 'package:gurps_dice/gurps_dice.dart';
import 'package:gurps_dice/src/die_roll.dart';

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
}
