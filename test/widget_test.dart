// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:progetto_its/main.dart';

void main() {
  testWidgets('La lista della spesa parte vuota', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ListaSpesaPage()));

    expect(find.text("Lista della spesa"), findsOneWidget);
    expect(find.text("La lista è vuota"), findsOneWidget);
    expect(find.text("Aggiungi il primo articolo"), findsOneWidget);
  });

  testWidgets('Aggiunge, svuota il campo, segna e rimuove', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ListaSpesaPage()));

    await tester.enterText(find.byType(TextField), "Latte");
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();

    expect(find.text("Latte"), findsOneWidget);
    expect(find.text("1 da comprare"), findsOneWidget);
    expect(find.text("0 comprati"), findsOneWidget);

    await tester.tap(find.byIcon(Icons.circle_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(find.text("0 da comprare"), findsOneWidget);
    expect(find.text("1 comprati"), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await tester.pumpAndSettle();

    expect(find.text("Latte"), findsNothing);
    expect(find.text("La lista è vuota"), findsOneWidget);
  });
}
