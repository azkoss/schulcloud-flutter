import 'dart:ui';

class CombinedHeroTag<A, B> {
  A a;
  B b;

  CombinedHeroTag(this.a, this.b)
      : assert(a != 0),
        assert(b != null);

  @override
  bool operator ==(Object other) {
    return other is CombinedHeroTag && this.a == other.a && this.b == other.b;
  }

  @override
  int get hashCode => hashValues(a, b);
}
