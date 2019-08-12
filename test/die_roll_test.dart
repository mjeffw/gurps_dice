import "package:test/test.dart";

import 'package:gurps_dice/gurps_dice.dart';

void main() {
  test("can be constructed from a String", () {
    expect(DieRoll.fromString("1d-1"), equals(DieRoll(dice: 1, adds: -1)));
    expect(DieRoll.fromString("1d"), equals(DieRoll(dice: 1, adds: 0)));
    expect(DieRoll.fromString("1d+1"), equals(DieRoll(dice: 1, adds: 1)));
    expect(DieRoll.fromString("1d+2"), equals(DieRoll(dice: 1, adds: 2)));
    expect(DieRoll.fromString("4d-1"), equals(DieRoll(dice: 4, adds: -1)));
    expect(DieRoll.fromString("4d"), equals(DieRoll(dice: 4, adds: 0)));
    expect(DieRoll.fromString("4d+1"), equals(DieRoll(dice: 4, adds: 1)));
    expect(DieRoll.fromString("4d+2"), equals(DieRoll(dice: 4, adds: 2)));
  });

  test("should create normalized DieRoll", () {
    DieRoll d = DieRoll(dice: 1, adds: 0);
    expect(d.numberOfDice, equals(1));
    expect(d.adds, equals(0));

    d = DieRoll(dice: 1, adds: -2);
    expect(d.numberOfDice, equals(1));
    expect(d.adds, equals(-2));

    d = DieRoll(dice: 1, adds: 1);
    expect(d.numberOfDice, equals(1));
    expect(d.adds, equals(1));

    d = DieRoll(dice: 1, adds: 2);
    expect(d.numberOfDice, equals(1));
    expect(d.adds, equals(2));

    d = DieRoll(dice: 1, adds: 3);
    expect(d.numberOfDice, equals(2));
    expect(d.adds, equals(-1));

    d = DieRoll(dice: 3, adds: 2);
    expect(d.numberOfDice, equals(3));
    expect(d.adds, equals(2));

    d = DieRoll(dice: 3, adds: 3);
    expect(d.numberOfDice, equals(4));
    expect(d.adds, equals(-1));

    d = DieRoll(dice: 5, adds: -1);
    expect(d.numberOfDice, equals(5));
    expect(d.adds, equals(-1));

    d = DieRoll(dice: 5, adds: -2);
    expect(d.numberOfDice, equals(4));
    expect(d.adds, equals(2));

    d = DieRoll(dice: 5, adds: 20);
    expect(d.numberOfDice, equals(10));
    expect(d.adds, equals(0));

    d = DieRoll(dice: 7, adds: -21);
    expect(d.numberOfDice, equals(2));
    expect(d.adds, equals(-1));
  });

  test("can denormalize", () {
    expect(DieRoll.denormalize(DieRoll(dice: 1, adds: 0)), equals(0));
    expect(DieRoll.denormalize(DieRoll(dice: 1, adds: 1)), equals(1));
    expect(DieRoll.denormalize(DieRoll(dice: 1, adds: 2)), equals(2));
    expect(DieRoll.denormalize(DieRoll(dice: 2, adds: -1)), equals(3));
    expect(DieRoll.denormalize(DieRoll(dice: 4, adds: 2)), equals(14));
    expect(DieRoll.denormalize(DieRoll(dice: 10, adds: 0)), equals(36));
    // 5d+0 == 2d+12
    expect(DieRoll.denormalize(DieRoll(dice: 5, adds: 0), 2), equals(12));
    // 0d+20 ==
    expect(DieRoll.denormalize(DieRoll(dice: 0, adds: 0), 1), equals(-4));
  });

  test("can add", () {
    expect(DieRoll(dice: 1, adds: 0) + 1, equals(DieRoll(dice: 1, adds: 1)));

    expect(DieRoll(dice: 2, adds: 0) + 2, equals(DieRoll(dice: 2, adds: 2)));
    expect(DieRoll(dice: 2, adds: 2) + 2, equals(DieRoll(dice: 3, adds: 0)));
    expect(DieRoll(dice: 5, adds: 0) + 2, equals(DieRoll(dice: 5, adds: 2)));
    expect(DieRoll(dice: 1, adds: -1) + 2, equals(DieRoll(dice: 1, adds: 1)));

    expect(DieRoll(dice: 2, adds: 0) + 3, equals(DieRoll(dice: 3, adds: -1)));
    expect(DieRoll(dice: 2, adds: 3) + 3, equals(DieRoll(dice: 3, adds: 2)));
    expect(DieRoll(dice: 5, adds: 0) + 3, equals(DieRoll(dice: 6, adds: -1)));
    expect(DieRoll(dice: 1, adds: -1) + 3, equals(DieRoll(dice: 1, adds: 2)));

    expect(DieRoll(dice: 2, adds: 0) + -3, equals(DieRoll(dice: 1, adds: 1)));
    expect(DieRoll(dice: 2, adds: 3) + -3, equals(DieRoll(dice: 2, adds: 0)));
    expect(DieRoll(dice: 5, adds: 0) + -3, equals(DieRoll(dice: 4, adds: 1)));
  });

  test("can subtract", () {
    expect(DieRoll(dice: 2, adds: 0) - 3, equals(DieRoll(dice: 1, adds: 1)));
    expect(DieRoll(dice: 2, adds: 3) - 3, equals(DieRoll(dice: 2, adds: 0)));
    expect(DieRoll(dice: 5, adds: 0) - 3, equals(DieRoll(dice: 4, adds: 1)));
  });

  test("can multiply", () {
    expect(DieRoll(dice: 1, adds: 0) * 1, equals(DieRoll(dice: 1, adds: 0)));

    expect(DieRoll(dice: 2, adds: 0) * 2, equals(DieRoll(dice: 4, adds: 0)));
    expect(DieRoll(dice: 2, adds: 2) * 2, equals(DieRoll(dice: 5, adds: 0)));
    expect(DieRoll(dice: 5, adds: 0) * 2, equals(DieRoll(dice: 10, adds: 0)));
    expect(DieRoll(dice: 1, adds: -1) * 2, equals(DieRoll(dice: 1, adds: 2)));

    expect(DieRoll(dice: 2, adds: 0) * 3, equals(DieRoll(dice: 6, adds: 0)));
    expect(DieRoll(dice: 2, adds: 3) * 3, equals(DieRoll(dice: 8, adds: 1)));
    expect(DieRoll(dice: 5, adds: 0) * 3, equals(DieRoll(dice: 15, adds: 0)));
    expect(DieRoll(dice: 1, adds: -1) * 3, equals(DieRoll(dice: 2, adds: 1)));
  });

  test("can divide", () {
    expect(DieRoll(dice: 1, adds: 0) / 1, equals(DieRoll(dice: 1, adds: 0)));

    expect(DieRoll(dice: 2, adds: 0) / 2, equals(DieRoll(dice: 1, adds: 0)));
    expect(DieRoll(dice: 2, adds: 2) / 2, equals(DieRoll(dice: 1, adds: 1)));
    expect(DieRoll(dice: 5, adds: 0) / 2, equals(DieRoll(dice: 2, adds: 2)));
    expect(DieRoll(dice: 1, adds: -1) / 2, equals(DieRoll(dice: 0, adds: 1)));

    expect(DieRoll(dice: 2, adds: 0) / 3, equals(DieRoll(dice: 0, adds: 2)));
    expect(DieRoll(dice: 2, adds: 3) / 3, equals(DieRoll(dice: 1, adds: -1)));
    expect(DieRoll(dice: 5, adds: 0) / 3, equals(DieRoll(dice: 1, adds: 2)));
    expect(DieRoll(dice: 1, adds: -1) / 3, equals(DieRoll(dice: 0, adds: 1)));

    expect(DieRoll(dice: 0, adds: 6) / 2, equals(DieRoll(dice: 1, adds: -1)));
    expect(DieRoll(dice: 0, adds: 7) / 2, equals(DieRoll(dice: 1, adds: -1)));
    expect(DieRoll(dice: 0, adds: 8) / 2, equals(DieRoll(dice: 1, adds: 0)));
  });

  test('can print', () {
    expect(DieRoll(dice: 4, adds: -2).toString(), equals('3d+2'));
    expect(DieRoll(dice: 4, adds: -1).toString(), equals('4d-1'));
    expect(DieRoll(dice: 4, adds: 0).toString(), equals('4d'));
    expect(DieRoll(dice: 4, adds: 1).toString(), equals('4d+1'));
    expect(DieRoll(dice: 4, adds: 2).toString(), equals('4d+2'));
    expect(DieRoll(dice: 4, adds: 3).toString(), equals('5d-1'));
  });

  test('has hashcode', () {
    expect(DieRoll(dice: 4, adds: -2).hashCode,
        equals(DieRoll(dice: 3, adds: 2).hashCode));
  });

  test('you can roll dice', () {
    // You can roll dice:
    var dThree = DieRoll.fromString('3d-2');
    for (var i = 0; i < 1000; i++) {
      int roll = dThree.roll();
      expect(roll, inInclusiveRange(1, 16));
    }
  });
}
