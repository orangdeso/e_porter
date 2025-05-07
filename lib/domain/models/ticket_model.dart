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

    // print("TicketModel.fromDocument - Doc ID: ${doc.id}, data: $data");
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
  final String airLines;
  final String flightClass;
  final String code;
  final String cityDeparture;
  final String cityArrival;
  final String codeDeparture;
  final String codeTransit;
  final String codeArrival;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String transitAirplane;
  final String stop;
  final int price;
  final String airlineLogo;
  final Map<String, SeatInfo> seat;

  FlightModel({
    required this.id,
    required this.airLines,
    required this.flightClass,
    required this.code,
    required this.cityDeparture,
    required this.cityArrival,
    required this.codeDeparture,
    required this.codeTransit,
    required this.codeArrival,
    required this.departureTime,
    required this.arrivalTime,
    required this.transitAirplane,
    required this.stop,
    required this.price,
    required this.airlineLogo,
    required this.seat,
  });

  factory FlightModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final seatData = data['seat'] as Map<String, dynamic>? ?? {};
    final seatMap = seatData.map<String, SeatInfo>((key, value) {
      return MapEntry(
        key,
        SeatInfo.fromMap(value as Map<String, dynamic>),
      );
    });

    return FlightModel(
      id: doc.id,
      airLines: data['airlines'] ?? '',
      flightClass: data['seatClass'] ?? '',
      code: data['code'] ?? '',
      cityDeparture: data['cityDeparture'] ?? '',
      cityArrival: data['cityArrival'] ?? '',
      codeDeparture: data['codeDeparture'] ?? '',
      codeTransit: data['codeTransit'] ?? '',
      codeArrival: data['codeArrival'] ?? '',
      departureTime: (data['dateDeparture'] as Timestamp).toDate(),
      arrivalTime: (data['dateArrival'] as Timestamp).toDate(),
      transitAirplane: data['transitAirplane'] ?? '',
      stop: data['stop'] ?? '',
      price: data['price'] ?? 0,
      airlineLogo: data['airlineLogo'] ?? '',
      seat: seatMap, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'airlines': airLines,
      'seatClass': flightClass,
      'code': code,
      'cityDeparture': cityDeparture,
      'cityArrival': cityArrival,
      'codeDeparture': codeDeparture,
      'codeTransit': codeTransit,
      'codeArrival': codeArrival,
      'dateDeparture': Timestamp.fromDate(departureTime),
      'dateArrival': Timestamp.fromDate(arrivalTime),
      'transitAirplane': transitAirplane,
      'stop': stop,
      'price': price,
      'airlineLogo': airlineLogo,
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
