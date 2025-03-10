import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  final String id; // ID dokumen Firestore
  final String from; // Contoh: "YIA - Yogyakarta"
  final String to; // Contoh: "LOP - Lombok"
  final DateTime leavingDate; // Tanggal berangkat

  TicketModel({
    required this.id,
    required this.from,
    required this.to,
    required this.leavingDate,
  });

  factory TicketModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    print("TicketModel.fromDocument - Doc ID: ${doc.id}, data: $data");
    return TicketModel(
      id: doc.id,
      from: data['from'] ?? '',
      to: data['to'] ?? '',
      leavingDate: (data['leavingDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'leavingDate': Timestamp.fromDate(leavingDate),
    };
  }
}

class FlightModel {
  final String id;
  final String flightClass;
  final String code;
  final String cityDeparture;
  final String cityArrival;
  final String codeDeparture;
  final String codeArrival;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int price;
  final Map<String, SeatInfo> seat;

  FlightModel({
    required this.id,
    required this.flightClass,
    required this.code,
    required this.cityDeparture,
    required this.cityArrival,
    required this.codeDeparture,
    required this.codeArrival,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.seat,
  });

  factory FlightModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Ambil field seat (Map) dari Firestore
    final seatData = data['seat'] as Map<String, dynamic>? ?? {};

    // Konversi setiap entry di seatData menjadi SeatInfo
    final seatMap = seatData.map<String, SeatInfo>((key, value) {
      return MapEntry(
        key,
        SeatInfo.fromMap(value as Map<String, dynamic>),
      );
    });

    print("FlightModel.fromDocument - Doc ID: ${doc.id}, data: $data");

    return FlightModel(
      id: doc.id,
      flightClass: data['seatClass'] ?? '',
      code: data['code'] ?? '',
      cityDeparture: data['cityDeparture'] ?? '',
      cityArrival: data['cityArrival'] ?? '',
      codeDeparture: data['codeDeparture'] ?? '',
      codeArrival: data['codeArrival'] ?? '',
      departureTime: (data['dateDeparture'] as Timestamp).toDate(),
      arrivalTime: (data['dateArrival'] as Timestamp).toDate(),
      price: data['price'] ?? 0,
      seat: seatMap, // masukkan Map<String, SeatInfo>
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'seatClass': flightClass,
      'code': code,
      'cityDeparture': cityDeparture,
      'cityArrival': cityArrival,
      'codeDeparture': codeDeparture,
      'codeArrival': codeArrival,
      'dateDeparture': Timestamp.fromDate(departureTime),
      'dateArrival': Timestamp.fromDate(arrivalTime),
      'price': price,
      // Konversi Map<String, SeatInfo> jadi Map<String, Map<String,dynamic>>
      'seat': seat.map((key, value) => MapEntry(key, value.toMap())),
    };
  }
}

class SeatInfo {
  final List<bool> isTaken;
  final int totalSeat;

  SeatInfo({
    required this.isTaken,
    required this.totalSeat,
  });

  factory SeatInfo.fromMap(Map<String, dynamic> map) {
    final isTakenList = (map['isTaken'] as List<dynamic>? ?? []).map((item) => item as bool).toList();

    return SeatInfo(
      isTaken: isTakenList,
      totalSeat: map['totalSeat'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isTaken': isTaken,
      'totalSeat': totalSeat,
    };
  }
}

class TicketFlightModel {
  final TicketModel ticket;
  final FlightModel flight;

  TicketFlightModel({
    required this.ticket,
    required this.flight,
  });
}
