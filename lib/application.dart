import 'package:intl/intl.dart';

String dbName = 'minha_carteira.db';

int dbVersion = 1;

List<String> dbCreeate = [
  // tb lista
  """CREATE TABLE lista(
  pk_lista INTEGER PRIMARY KEY,
  name TEXT,
  created TEXT
  )""",

  // tb item
  """CREATE TABLE item(
  pk_item INTEGER PRIMARY KEY,
  fk_lista INTEGER,
  name TEXT,
  data DECIMAL(10, 3),
  valor DECIMAL(10,2),
  saldo DECIMAL(10,2),
  checked INTEGER DEFAULT 0,
  created TEXT
  )"""
];

double currencyToDouble(String value) {
  value = value.replaceFirst('R\$ ', '');
  value = value.replaceAll(RegExp(r'\.'), '');
  value = value.replaceAll(RegExp(r'\,'), '.');

  return double.tryParse(value) ?? null;
}

double currencyToFloat(String value) {
  return currencyToDouble(value);
}

String doubleToCurrency(double value) {
  NumberFormat nf =
      NumberFormat.compactCurrency(locale: 'pt_BR', symbol: 'R\$');
  return nf.format(value);
}
