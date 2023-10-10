import 'dart:convert';

class Items {
  String? version;
  List<Item> items = [];

  Items.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    (json['data'] as Map<String, dynamic>)
        .forEach((key, value) => items.add(Item.fromJson(key, value)));
  }
}

class Item {
  String? id;
  String? name;
  String? description;

  double? ap;
  double? armor;
  double? armorPen; //Percentage

  double? ad;
  double? attackSpeed;
  double? cdr;

  double? crit; //Percentage
  double? health;
  double? healthRegen;

  double? lifesteal;
  double? magicPen;
  double? magicResist;

  double? mana;
  double? manaRegen;
  double? moveSpeed;

  double? omnivamp;
  double? range;
  double? tenacity;

  double? letalidad;

  Item();

  Item.fromJson(String key, dynamic value) {
    id = key;
    name = utf8.decode(value['name'].codeUnits);
    var des = utf8
        .decode(eliminarContenidoEntreSimbolos(value['description']).codeUnits)
        .toLowerCase();

    ap = extraerValor(des, " ability power", "");
    armor = extraerValor(des, " armor", "");
    armorPen = extraerValor(des, "% armor penetration", "");

    ad = extraerValor(des, " attack damage", "");
    attackSpeed = extraerValor(des, "% attack speed", "");
    cdr = extraerValor(des, " ability haste", "");

    crit = extraerValor(des, "% critical strike chance", "");
    health = extraerValor(des, " health", "");
    healthRegen = extraerValor(des, "% base health regen", "");

    lifesteal = extraerValor(des, "% life steal", "% physical vamp");
    magicPen = extraerValor(des, " magic penetration", "");
    magicResist = extraerValor(des, " magic resist", "");

    mana = extraerValor(des, " mana", "");
    manaRegen = extraerValor(des, "% base mana regen", "");
    moveSpeed = extraerValor(des, " move speed", "");

    omnivamp = extraerValor(des, "% omnivamp", "");
    range = extraerValor(des, " range", "");
    tenacity = extraerValor(des, "% tenacity", "");

    letalidad = extraerValor(des, " lethality", "");

    description = des;
  }
}

String eliminarContenidoEntreSimbolos(String entrada) {
  return entrada.replaceAll(RegExp(r'<.*?>'), '');
}

double extraerValor(String cadena, String etiqueta, String alt) {
  RegExp regex = RegExp(r'(\d+(?:\.\d+)?)(?:% )?' + etiqueta);
  Match? match = regex.firstMatch(cadena);

  if (match != null) {
    String valorStr = match.group(1)!;
    return double.parse(valorStr);
  } else {
    if (alt.isNotEmpty) {
      RegExp regex = RegExp(r'(\d+(?:\.\d+)?)(?:% )?' + alt);
      Match? match = regex.firstMatch(cadena);
      if (match != null) {
        String valorStr = match.group(1)!;
        return double.parse(valorStr);
      } else {
        return 0.0;
      }
    } else {
      return 0.0;
    }
  }
}
