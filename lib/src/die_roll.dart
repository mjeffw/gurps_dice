import 'package:quiver/core.dart';

/// Represents a DieRoll in GURPS.
///
/// GURPS uses, for all die rolls, a number of 6-sided dice, modified by adding
/// or subtracting an integer. For example, 2d equals "roll 2 six-sided dice",
/// while 3d-1 means "roll 3 six-sided dice, subtracting 1 from the total.
///
/// GURPS die rolls are usually 'normalized' such that the modifier can only be
/// in the range of [-1 to 2], inclusive.  The number of dice is increased or
/// decreased as the modifier moves beyond that range.
class DieRoll {
  final int _numberOfDice;
  final int _adds;
  final bool _normalize;

  DieRoll({int dice = 0, int adds = 0, bool normalize = true})
      : this._numberOfDice =
            normalize ? DieRoll.normalize(dice, adds)[0] : dice,
        this._adds = normalize ? DieRoll.normalize(dice, adds)[1] : adds,
        this._normalize = normalize;

  factory DieRoll.fromString(String text, {bool normalize = true}) {
    final natural_number = r'\d+'; // all positive integers
    final signed_integer =
        r'(?:\+|-)' + natural_number; // either (plus OR minus) plus an integer

    // ^(\d+)d((?:\+|-)\d+)?$
    RegExp e = RegExp(r'^(?<dice>' +
        natural_number +
        r')d(?<adds>' +
        signed_integer +
        r')?$');

    if (e.hasMatch(text)) {
      return DieRoll(
          dice: int.tryParse(e.firstMatch(text).namedGroup('dice')),
          adds: int.tryParse(e.firstMatch(text).namedGroup('adds') ?? '0'),
          normalize: normalize);
    }
    return null;
  }

  /// Return the equivalent add value if dice is converted to use (base)d as
  /// its base.
  ///
  /// For example, denormalize(3d+1, 1) should return 9, because 1d+9 will be
  /// normalized to 3d+1.
  static int denormalize(DieRoll dice, [int base = 1]) {
    int adds = 0;
    int numberOfDice = dice.numberOfDice;

    // if dice.numberOfDice is greater than base
    while (numberOfDice > base) {
      adds += 4;
      numberOfDice--;
    }

    // if dice.numberOfDice is less than base
    while (numberOfDice < base) {
      adds -= 4;
      numberOfDice++;
    }

    adds += dice.adds;
    return adds;
  }

  /// Converts to GURPS standard form, i.e., the adds cannot be anything other
  /// than -1, 0, +1, or +2.
  ///
  /// The normalization algorithm is hard to describe, but it is clear with
  /// some examples:
  ///
  /// (N)d(-2) == (N-1)d(+2) -- 5d-2 == 4d+2
  /// (N)d(-1) == (N)d(-1)   -- 5d-1 == 5d-1
  /// (N)d(+0) == (N)d(+0)   -- 5d   == 5d
  /// (N)d(+1) == (N)d(+1)   -- 5d+1 == 5d+1
  /// (N)d(+2) == (N)d(+2)   -- 5d+2 == 5d+2
  /// (N)d(+3) == (N+1)d(-1) -- 5d+3 == 6d-1
  /// (N)d(+4) == (N+1)d(+0) -- 5d+4 == 6d
  /// (N)d(+5) == (N+1)d(+1) -- 5d+5 == 6d+1
  /// (N)d(+6) == (N+1)d(+2) -- 5d+6 == 6d+2
  /// (N)d(+7) == (N+2)d(-1) -- 5d+7 == 7d-1
  static List<int> normalize(int numberOfDice, int adds) {
    if (adds > 2) {
      return [
        ((numberOfDice + (adds + 1) / 4).floor()),
        (((adds + 1) % 4) - 1)
      ];
    } else if (adds < -1 && numberOfDice > 1) {
      return normalize(numberOfDice - 1, adds + 4);
    }
    return [numberOfDice, adds];
  }

  int get adds => _adds;

  int get numberOfDice => _numberOfDice;

  DieRoll operator +(int adds) => DieRoll(
      dice: this._numberOfDice,
      adds: this._adds + adds,
      normalize: this._normalize);

  DieRoll operator -(int adds) => DieRoll(
      dice: this._numberOfDice,
      adds: this._adds - adds,
      normalize: this._normalize);

  DieRoll operator *(int factor) =>
      DieRoll(adds: DieRoll.denormalize(this, 0) * factor);

  DieRoll operator /(int divisor) =>
      DieRoll(adds: (DieRoll.denormalize(this, 0) / divisor).floor());

  @override
  String toString() {
    if (_adds == 0) {
      return "${_numberOfDice}d";
    }

    String sign = "";
    if (!_adds.isNegative) {
      sign = "+";
    }
    return "${this._numberOfDice}d${sign}${_adds}";
  }

  @override
  bool operator ==(Object o) =>
      o is DieRoll && o._numberOfDice == _numberOfDice && o._adds == _adds;

  @override
  int get hashCode => hash2(_adds.hashCode, _numberOfDice.hashCode);
}
