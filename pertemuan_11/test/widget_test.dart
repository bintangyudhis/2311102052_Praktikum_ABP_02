import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pertemuan_11/main.dart';

void main() {
  testWidgets('menambah dan menghapus produk memperbarui jumlah keranjang', (
    tester,
  ) async {
    await tester.pumpWidget(const ProductApp());
    expect(find.text('0 item'), findsOneWidget);

    await tester.tap(find.byKey(const Key('add-1')));
    await tester.pump();
    expect(find.text('1 item'), findsOneWidget);
    expect(find.byKey(const Key('quantity-1')), findsOneWidget);

    await tester.tap(find.byKey(const Key('add-1')));
    await tester.pump();
    expect(find.text('2 item'), findsOneWidget);
    expect(find.text('Rp698.000'), findsOneWidget);

    await tester.tap(find.byKey(const Key('remove-1')));
    await tester.pump();
    expect(find.text('1 item'), findsOneWidget);
  });
}
