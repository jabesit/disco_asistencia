import 'dart:developer';

class User {
  String? rut;
  String? name;
  String? lastname;
  String? birthday;
  String? fechaEmision;
  String? fechaExpiration;
  String? serie;
  bool isAdmisible = true;

  User({
    required this.rut,
    required this.name,
    required this.lastname,
    required this.birthday,
    required this.fechaEmision,
    required this.fechaExpiration,
    required this.isAdmisible,
  });

  User._(this.rut, this.name, this.isAdmisible);
  User copyWith(
    bool? today,
    DateTime? fromDate,
    DateTime? toDate,
  ) {
    return User._(
      rut ?? this.rut,
      name ?? this.name,
      isAdmisible ?? this.isAdmisible,
    );
  }

  User registerNewToDate(bool value) {
    this.isAdmisible = value;
    return this;
  }

  User.isAdmisible(bool value) : isAdmisible = value;
  User.empty();

  get fullName => "$name $lastname";

  @override
  String toString() {
    return 'rut: $rut, Serie: $serie,  Nombre: $name, Apellido: $lastname, fecha Cumpleaños: $birthday, fecha Emision: $fechaEmision, fecha Expiracion: $fechaExpiration, isAdmisible: $isAdmisible, ';
  }

  Map<String, dynamic> toJson() => {
        'rut': rut,
        'Serie': serie,
        'name': name,
        'lastname': lastname,
        'birthday': birthday,
        'fechaEmision': fechaEmision,
        'fechaExpiration': fechaExpiration,
        'isAdmisible': isAdmisible,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        rut: json['rut'],
        name: json['name'],
        lastname: json['lastname'],
        birthday: json['birthday'],
        fechaEmision: json['fechaEmision'],
        fechaExpiration: json['fechaExpiration'],
        isAdmisible: json['isAdmisible']);
  }

  String? rutFromQR(String text) {
    final regexp = RegExp(r'RUN=[^&]+');
    final match = regexp.firstMatch(text);
    final String? isMatch = match?.group(0)?.toString();
    if (isMatch != null) {
      return isMatch.replaceAll("RUN=", "");
    }
    return null;
  }

  User.fromString(String text) {
    RegExp regexNombre = RegExp(r'NOMBRES\n(.+)\nNACIONALIDAD');
    for (RegExpMatch match in regexNombre.allMatches(text)) {
      if (match.group(1) != null) {
        String name = match.group(1)!;
        log("---> name $name");
        this.name = name;
      }
    }
    log("---> regexName");
    RegExp regexLastname = RegExp(r'APELLIDOS\n(.+)\nNOMBRES', dotAll: true);
    for (RegExpMatch match in regexLastname.allMatches(text)) {
      if (match.group(1) != null) {
        String lastname = match.group(1)!.replaceAll('\n', ' ');
        log("---> lastname $lastname");
        this.lastname = lastname;
      }
    }

    log("---> regexSerie");
    RegExp regexSerie = RegExp(r'\b\d{3}\.\d{3}\.\d{3}\b');
    for (RegExpMatch match in regexSerie.allMatches(text)) {
      if (match.group(0) != null) {
        String numeroSerie = match.group(0)!;
        log("---> nroDocumento $numeroSerie");
        serie = numeroSerie;
      }
    }

    log("---> regexID");
    RegExp regexID = RegExp(r'\b\d{1,3}\.\d{3}\.\d{3}-[\dkK]\b');
    Iterable<RegExpMatch> matches2 = regexID.allMatches(text);
    for (RegExpMatch match in matches2) {
      if (match.group(0) != null) {
        String id = match.group(0)!;
        log("---> rut $id");
        rut = id;
      }
    }

    log("---> regexFechaDocumento");
    RegExp regexFechaDocumento = RegExp(r'\b\d{1,2} [A-Z]{3} \d{4}\b');
    Map<int, String> myMap = {};
    Iterable<RegExpMatch> matches3 = regexFechaDocumento.allMatches(text);
    for (RegExpMatch match in matches3) {
      if (match.group(0) != null) {
        String fechasDocumento = match.group(0)!;
        log("---> fechasDocumento $fechasDocumento");
        myMap[int.parse(fechasDocumento.split(" ")[2])] = fechasDocumento;
      }
    }
    List<int> sortedKeys = myMap.keys.toList()..sort();

    if (myMap.isNotEmpty) {
      if (myMap.length == 2) {
        String fechaNacimiento = myMap[sortedKeys[0]]!;
        String fechaEmision = myMap[sortedKeys[1]]!;

        birthday ??= fechaNacimiento;
        this.fechaEmision = fechaEmision;

        log("---> fechaNacimiento: $fechaNacimiento");
        log("---> fechaEmision: $fechaEmision");
      } else if (myMap.length == 3) {
        String fechaNacimiento = myMap[sortedKeys[0]]!;
        String fechaEmision = myMap[sortedKeys[1]]!;
        String fechaVencimiento = myMap[sortedKeys[2]]!;

        birthday ??= fechaNacimiento;

        this.fechaEmision = fechaEmision;
        fechaExpiration = fechaVencimiento;

        log("---> fechaNacimiento: $fechaNacimiento");
        log("---> fechaEmision: $fechaEmision");
        log("---> fechaVencimiento: $fechaVencimiento");
      }
    }
  }
}
