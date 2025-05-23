import 'package:http/http.dart' as http;
import 'package:raw_material/features/inventory/domain/entities/inventory_entity.dart';
import 'dart:convert';

class SheetsInventoryDatasource {
  final String scriptUrl;

  SheetsInventoryDatasource(this.scriptUrl);

  Future<List<MaterialEntity>> getAll() async {
    final res = await http.get(Uri.parse(scriptUrl));
    final rows = json.decode(res.body) as List;
    return rows
        .map((r) => MaterialEntity(
              name: r[0],
              quantity: int.parse(r[1].toString()),
              threshold: int.parse(r[2].toString()),
            ))
        .toList();
  }

  Future<void> upsert(MaterialEntity m) async {
    await http.post(Uri.parse(scriptUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'material': m.name,
          'quantity': m.quantity,
          'threshold': m.threshold,
        }));
  }
}
