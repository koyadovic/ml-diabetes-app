import 'dart:math';

double num(double n) {
  return n ?? 0.0;
}


double round(double n, int decimals) {
  return (n * 10 * decimals).round().toDouble() / (10 * decimals);
}
