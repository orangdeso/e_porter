# E-Porter 🛫

> **Sistem Aplikasi E-Porter Berbasis Mobile untuk Meningkatkan Jasa Prioritas Bandara**

E-Porter adalah aplikasi mobile Flutter yang dirancang untuk meningkatkan efisiensi layanan porter di bandara melalui digitalisasi proses pemesanan tiket dan manajemen layanan prioritas.

## 📱 Screenshots

*Screenshots aplikasi akan ditambahkan di sini*

## ✨ Fitur Utama

### 🎫 Pemesanan Tiket
- Pencarian dan pemilihan penerbangan
- Pemilihan kursi (seat) secara real-time
- Manajemen data penumpang
- Sistem pembayaran dengan QRIS

### 🧳 Layanan Porter
- **Porter VIP**: Pengalaman perjalanan tanpa repot
- **Fast Track**: Cocok untuk jadwal padat
- **Transit Service**: Khusus untuk penerbangan transit
- QR Code scanner untuk memanggil porter terdekat

### 💳 Sistem Pembayaran
- Payment timer dengan countdown real-time
- Upload bukti pembayaran
- Tracking status transaksi
- Riwayat pembayaran lengkap

### 📊 Dashboard & Monitoring
- Real-time status tracking
- Notifikasi transaksi kedaluwarsa
- Sistem pembatalan otomatis
- Boarding pass digital

## 🏗️ Arsitektur

Aplikasi ini menggunakan **Clean Architecture** dengan pembagian layer:

```
lib/
├── presentation/           # UI Layer
│   ├── screens/           # Flutter Screens
│   └── controllers/       # GetX Controllers
├── domain/                # Business Logic Layer
│   ├── usecases/         # Business Use Cases
│   ├── models/           # Data Models
│   └── repositories/     # Repository Interfaces
├── data/                 # Data Layer
│   └── repositories/     # Repository Implementations
└── _core/
    └── service/          # Background Services
```

## 🛠️ Tech Stack

### Frontend
- **Flutter** - Cross-platform mobile framework
- **GetX** - State management dan dependency injection
- **Dart** - Programming language

### Backend & Database
- **Firebase Firestore** - Primary database untuk data utama
- **Firebase Realtime Database** - Real-time synchronization
- **Firebase Storage** - File storage untuk bukti pembayaran
- **Firebase Authentication** - User authentication

### Architecture Pattern
- **Clean Architecture** - Separation of concerns
- **Repository Pattern** - Data access abstraction
- **UseCase Pattern** - Business logic encapsulation

## 📋 Prasyarat

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Firebase account dan project setup

## 🚀 Instalasi

1. **Clone repository**
```bash
git clone https://github.com/orangdeso/e_porter.git
cd e_porter
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Setup Firebase**
   - Buat project Firebase baru
   - Download `google-services.json` untuk Android
   - Download `GoogleService-Info.plist` untuk iOS
   - Tempatkan file konfigurasi di direktori yang sesuai

4. **Konfigurasi Firebase**
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login ke Firebase
firebase login

# Inisialisasi Firebase di project
firebase init
```

5. **Setup Firestore Rules**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Rules untuk collection tickets
    match /tickets/{ticketId} {
      allow read, write: if request.auth != null;
      
      match /payments/{paymentId} {
        allow read, write: if request.auth != null;
      }
    }
    
    // Rules untuk collection bandara
    match /bandara/{bandaraId} {
      allow read: if true;
    }
  }
}
```

6. **Setup Realtime Database Rules**
```json
{
  "rules": {
    "transactions": {
      "$userId": {
        ".read": "$userId === auth.uid",
        ".write": "$userId === auth.uid"
      }
    }
  }
}
```

7. **Run aplikasi**
```bash
flutter run
```

## 📱 Platform Support

| Platform | Status |
|----------|--------|
| Android  | ✅ Supported |
| iOS      | ✅ Supported |
| Web      | 🚧 In Development |

## 🗄️ Struktur Database

### Firestore Collections

#### `tickets/{ticketId}`
```javascript
{
  status: "pending_payment" | "awaiting_verification" | "verified" | "expired",
  lastUpdated: timestamp,
  userId: "user_id",
  
  // Sub-collection: flights
  flights/{flightId}: {
    airLines: "Lion Air",
    code: "22",
    seat: {
      a: { isTaken: [false, true, false, ...], totalSeat: 10 },
      b: { isTaken: [false, true, false, ...], totalSeat: 10 },
      // ... kelas f
    }
  },
  
  // Sub-collection: payments
  payments/{paymentId}: {
    id: "payment_id",
    amount: 1010000,
    method: "QRIS",
    status: "pending" | "paid" | "verified" | "cancelled",
    expiryTime: timestamp,
    proofUrl: "url_bukti_pembayaran",
    // ... data lainnya
  }
}
```

#### `bandara/{bandaraId}`
```javascript
{
  id: "document_id",
  city: "Jakarta",
  code: "CGK", 
  name: "Soekarno-Hatta International Airport"
}
```

### Realtime Database Structure
```javascript
{
  "transactions": {
    "{userId}": {
      "{ticketId}": {
        "{transactionId}": {
          "payment": { /* payment data */ },
          "flight": { /* flight data */ },
          "bandara": { /* airport data */ },
          "user": { /* user data */ },
          "passenger": 1,
          "passengerDetails": [],
          "numberSeat": []
        }
      }
    }
  }
}
```

## 🔄 Flow Aplikasi

### 1. Pemesanan Tiket
```
User memilih tiket → Pilih layanan porter → Pilih penumpang → Review pesanan → Buat transaksi
```

### 2. Proses Pembayaran
```
Generate QRIS → Timer countdown → Upload bukti → Verifikasi admin → Tiket confirmed
```

### 3. Manajemen Kursi
```
Pilih kursi → Update status "taken" → Jika expired → Reset ke "available"
```

## 🧪 Testing

### Black Box Testing
Aplikasi telah diuji menggunakan metode **Equivalence Partitioning** dengan tingkat keberhasilan **100%**.

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## 🎯 Roadmap

### Phase 1 (Current) ✅
- [x] Basic booking system
- [x] Payment integration
- [x] Seat management
- [x] Transaction expiry system

### Phase 2 (In Progress) 🚧
- [ ] Push notifications
- [ ] Payment gateway integration
- [ ] Real-time airport data integration
- [ ] Geofencing for porter location

### Phase 3 (Planned) 📋
- [ ] Admin dashboard
- [ ] Analytics & reporting
- [ ] Multi-language support
- [ ] Offline mode support

## 🤝 Contributing

1. Fork repository
2. Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buka Pull Request

### Code Style
- Gunakan `dart format` untuk formatting
- Ikuti [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Tambahkan documentation untuk public APIs

## 🐛 Bug Reports

Jika menemukan bug, silakan buat issue dengan template:

```markdown
**Describe the bug**
Deskripsi singkat tentang bug

**To Reproduce**
Langkah-langkah untuk reproduce:
1. Go to '...'
2. Click on '....'
3. See error

**Expected behavior**
Behavior yang diharapkan

**Screenshots**
Screenshot jika ada

**Device info:**
 - Device: [e.g. Samsung Galaxy S21]
 - OS: [e.g. Android 11]
 - App Version: [e.g. 1.0.0]
```

## 📄 License

Distributed under the MIT License. See `LICENSE` file for more information.

## 📞 Contact

**Developer**: [Your Name]
- Email: your.email@example.com
- GitHub: [@orangdeso](https://github.com/orangdeso)
- LinkedIn: [Your LinkedIn Profile]

**Project Link**: [https://github.com/orangdeso/e_porter](https://github.com/orangdeso/e_porter)

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - Amazing cross-platform framework
- [GetX](https://pub.dev/packages/get) - Powerful state management
- [Firebase](https://firebase.google.com/) - Reliable backend services
- Bandara Dhoho Kediri - Research collaboration

---

⭐ Jangan lupa untuk memberikan star jika project ini membantu!
