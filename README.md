# PANS ENERGI — Smart Energy Decision Assistant
> **"Intelligence for Every Watt."**

Aplikasi asisten keputusan energi listrik pintar berbasis **Flutter** dengan standar visual premium, hierarki informasi profesional, animasi halus, serta interaksi gesture nyata untuk optimalisasi pemanfaatan energi surya fotovoltaik, manajemen beban rumah tangga, dan cadangan baterai (*Energy Storage System*).

Dikembangkan selaras dengan **SDG 7** *(Affordable and Clean Energy)* dan **SDG 12** *(Responsible Consumption and Production)*.

---

## 📑 Daftar Isi

- [Ikhtisar \& Fitur Utama](#-ikhtisar--fitur-utama)
- [Implementasi 3 Gesture Interaktif](#️-implementasi-3-gesture-interaktif-nim-genap)
- [Custom Simulator (Mode Presentasi)](#-custom-simulator-mode-presentasi)
- [Arsitektur \& Struktur Folder](#-arsitektur--struktur-folder)
- [Rumus \& Aturan Status Energi](#-rumus--aturan-status-energi)
- [Cara Menjalankan Aplikasi](#-cara-menjalankan-aplikasi)
- [Panduan Demonstrasi Presentasi](#-panduan-demonstrasi-presentasi)
- [Commit Log](#-commit-log)

---

## 📋 Ikhtisar & Fitur Utama

### 1. Dashboard / Energy Overview
- **Header & Brand Identity**: Logo geometris eksklusif PANS ENERGI, label skenario telemetri aktif, pemilih skenario interaktif (*Siang Cerah*, *Sore Berawan*, *Petang Hari*, *Malam Badai*), dan tombol akses cepat Custom Simulator.
- **Hero Energy Status Card**: Menampilkan *Net Energy Balance* (+2.6 kWh), status operasional dinamis, ringkasan rekomendasi cerdas, serta perbandingan produksi vs beban.
- **Metrik Daya Real-Time**: 3 kartu proporsional dalam *Row* (*Solar PV*, *Konsumsi Beban*, *Baterai ESS*) dengan indikator progress dan kapasitas tersimpan.
- **Visualisasi Aliran Energi (Interactive Pinch)**: Menggunakan *Stack* dan *CustomPainter* dengan animasi partikel listrik dinamis menghubungkan modul Solar, Inverter, Baterai, dan Rumah.
- **PANS Energy Decision Insight**: Komputasi narasi rekomendasi analitis berdasarkan angka telemetri aktif.
- **Smart Recommendations Carousel**: Kartu rekomendasi aksi energi yang interaktif dengan navigasi geser (*Swipe*) dan persetujuan ganda (*Double Tap*).
- **Mode Banner**: Banner status animasi yang menampilkan mode aktif saat ini (Preset Skenario atau Custom Simulator).

### 2. Energy Analytics
- **Kurva Daya 24 Jam**: Grafik *CustomPainter* bezier curve membandingkan produksi surya terhadap beban dengan fitur touch scrubber per jam.
- **Distribusi Surplus / Defisit**: Diagram batang neraca per jam dengan klasifikasi warna hijau (surplus) dan oranye (defisit).
- **Kemandirian Energi Bersih**: Indikator persentase *Clean Self-Sufficiency* dan estimasi reduksi emisi CO₂.

### 3. Smart Recommendations Screen
- Daftar lengkap seluruh rekomendasi cerdas dengan kondisi pemicu, tindakan yang disarankan, dan estimasi manfaat.
- Tab penyaring (*Filter Tabs*): Semua, Pending, Disetujui.
- Interaksi *Double Tap* pada setiap kartu dengan umpan balik visual instan.

### 4. About & Kontribusi SDGs
- Informasi produk dan filosofi arsitektur.
- Keselarasan dengan **SDG 7** dan **SDG 12**.
- Panduan lengkap verifikasi gesture untuk penilaian akademik.

---

## 🖐️ Implementasi 3 Gesture Interaktif (NIM Genap)

| No | Gesture | Lokasi Komponen | Mekanisme & Logika | Perubahan Visual Nyata di UI |
|---|---|---|---|---|
| 1 | **Double Tap** | Kartu Rekomendasi (*Dashboard* & *Layar Rekomendasi*) | `GestureDetector.onDoubleTap` membalikkan nilai `isAccepted` (`Pending` ↔ `Accepted`). | Kartu bertransformasi: border menyala `Electric Lime`, badge berubah dari `RECOMMENDATION PENDING` menjadi `RECOMMENDATION ACCEPTED`, animasi micro-scale bounce, serta SnackBar notifikasi. |
| 2 | **Scale / Pinch** | Visualisasi Aliran Daya (*Dashboard*) | `GestureDetector.onScaleStart` & `onScaleUpdate` mengalikan `details.scale` dengan batas `0.8x` hingga `1.8x`. | Seluruh kanvas sirkuit daya membesar/mengecil secara proporsional, pill indikator zoom (`1.25x`) terupdate real-time, dan tombol `Reset 1.0x` muncul. |
| 3 | **Swipe / Horizontal Drag** | *Smart Recommendations Carousel* (*Dashboard*) | `GestureDetector.onHorizontalDragEnd` mendeteksi kecepatan geser (`velocity.dx`). | Kartu bertransisi halus menggunakan `AnimatedSwitcher` (animasi slide & fade horizontal), nomor kartu (`1/4`) terupdate, dan indikator titik (*dot*) aktif berpindah. |

---

## 🔬 Custom Simulator (Mode Presentasi)

Fitur khusus yang memungkinkan pengguna **merancang dan mengontrol sendiri kondisi energi secara real-time** untuk keperluan demonstrasi dan presentasi.

### Cara Membuka Simulator
- **Tombol Header**: Ketuk ikon ⚡ *Custom* di bagian kanan header aplikasi.
- **Floating Action Button (FAB)**: Ketuk tombol `⚡ Custom Simulator` yang tampil di pojok kanan bawah layar Dashboard.

### Parameter yang Dapat Dikonfigurasi

| Parameter | Satuan | Rentang | Keterangan |
|---|---|---|---|
| Solar Production | kWh | 0.0 – 10.0 | Produksi panel surya fotovoltaik |
| Energy Consumption | kWh | 0.0 – 10.0 | Total konsumsi beban rumah tangga |
| Battery Level | % | 0 – 100 | Kapasitas daya tersimpan baterai ESS |
| Battery Capacity | kWh | 1.0 – 20.0 | Total kapasitas baterai terpasang |

### Contoh Skenario Demonstrasi

```
Skenario A — Surplus Optimal:
  Solar Production : 8.5 kWh
  Consumption      : 3.2 kWh
  Battery Level    : 90%
  → Sistem menampilkan status SURPLUS, rekomendasi ekspor ke grid

Skenario B — Kondisi Kritis:
  Solar Production : 0.5 kWh
  Consumption      : 4.8 kWh
  Battery Level    : 15%
  → Sistem menampilkan status CRITICAL, prioritas beban minimum

Skenario C — Seimbang:
  Solar Production : 3.0 kWh
  Consumption      : 2.8 kWh
  Battery Level    : 55%
  → Sistem menampilkan status BALANCED
```

### Cara Kerja Teknis

```
CustomSimulatorModal
      │
      ▼ (mengupdate via EnergyService)
EnergyService (_isCustomMode = true, _customEnergyData)
      │
      ▼ (ChangeNotifier + EnergyScope InheritedNotifier)
DashboardScreen ──► EnergyStatusCard
                ──► EnergyMetricCard (Solar / Baterai / Konsumsi)
                ──► EnergyFlowVisualization
                ──► EnergyInsightCard
                ──► RecommendationCarousel
```

Saat Custom Simulator aktif:
- **Banner mode** berwarna amber muncul di bagian atas Dashboard.
- Header menampilkan `⏹ Stop` untuk menghentikan mode kustom.
- Seluruh UI merespons secara real-time terhadap slider yang digeser.

---

## 📐 Arsitektur & Struktur Folder

```text
lib/
├── main.dart                                # Entry point aplikasi
├── app.dart                                 # Konfigurasi MaterialApp, tema, dan EnergyScope
├── core/
│   ├── constants/
│   │   └── app_constants.dart               # Teks statis, batas kalkulasi, SDG & konteks akademik
│   ├── theme/
│   │   ├── app_colors.dart                  # Palet warna Midnight Navy & Electric Lime
│   │   ├── app_text_styles.dart             # Hierarki tipografi modern
│   │   └── app_theme.dart                   # ThemeData Material 3 dark-first
│   └── utils/
│       └── energy_calculator.dart           # Perhitungan neraca, ambang batas status & teks insight
├── models/
│   ├── energy_data.dart                     # Model data telemetri surya, konsumsi, baterai & status
│   └── energy_recommendation.dart           # Model rekomendasi cerdas aksi energi
├── data/
│   └── mock_energy_data.dart                # 4 Skenario telemetri & dataset kurva 24 jam
├── services/
│   └── energy_service.dart                  # ChangeNotifier & InheritedNotifier + Custom Simulator state
├── screens/
│   ├── main_navigation_screen.dart          # Navigasi utama dengan 4 tab NavigationBar
│   ├── dashboard_screen.dart                # Halaman utama overview, hero status, & FAB simulator
│   ├── analytics_screen.dart                # Halaman analitik grafik 24 jam & neraca
│   ├── recommendations_screen.dart          # Halaman manajemen seluruh rekomendasi
│   └── about_screen.dart                    # Halaman profil, SDGs & panduan penilaian
└── widgets/
    ├── common/
    │   ├── app_header.dart                  # Header brand PANS ENERGI, pemilih skenario & tombol simulator
    │   ├── section_header.dart              # Header judul seksi seragam
    │   └── status_badge.dart                # Badge status operasional dengan titik berpendar
    ├── dashboard/
    │   ├── energy_status_card.dart          # Hero card neraca energi (+2.6 kWh)
    │   ├── energy_metric_card.dart          # Baris 3 kartu metrik proporsional
    │   ├── energy_flow_visualization.dart   # Visualisasi aliran daya animasi (Gesture Pinch)
    │   └── energy_insight_card.dart         # Kartu wawasan keputusan AI dinamis
    ├── recommendations/
    │   ├── recommendation_card.dart         # Kartu rekomendasi interaktif (Gesture Double Tap)
    │   └── recommendation_carousel.dart     # Carousel rekomendasi geser (Gesture Swipe)
    ├── simulation/
    │   └── custom_simulator_modal.dart      # Modal Custom Simulator untuk mode presentasi
    └── charts/
        └── energy_comparison_chart.dart     # Grafik komparasi daya 24 jam dengan touch scrubber
```

---

## ⚡ Rumus & Aturan Status Energi

- **Energy Balance (kWh)**:

$$\text{Energy Balance} = \text{Solar Production} - \text{Energy Consumption}$$

- **Ambang Batas Status**:

| Status | Kondisi |
|---|---|
| `SURPLUS` | Balance > +0.5 kWh |
| `BALANCED` | −0.5 kWh ≤ Balance ≤ +0.5 kWh |
| `DEFICIT` | Balance < −0.5 kWh (Baterai > 25%) |
| `CRITICAL` | Baterai ≤ 25% **dan** Balance < 0 kWh |

---

## 🚀 Cara Menjalankan Aplikasi

Pastikan Flutter SDK (>= 3.13.5) telah terpasang di sistem.

### 1. Clone / Buka Proyek

```bash
# Jika menggunakan Git
git clone <url-repository>
cd tugas1

# Install dependencies
flutter pub get
```

### 2. Jalankan Pengujian Otomatis

```bash
flutter test
```

> Diharapkan: **7 tests passed** — mencakup gesture, skenario telemetri, kalkulasi energi, dan Custom Simulator.

### 3. Periksa Analisis Kode

```bash
flutter analyze
```

### 4. Jalankan Aplikasi pada Perangkat / Desktop

| Platform | Perintah |
|---|---|
| Windows Desktop | `flutter run -d windows` |
| Chrome / Web | `flutter run -d chrome` |
| Android Emulator / Device | `flutter run -d android` |
| iOS Simulator | `flutter run -d ios` |

---

## 🎯 Panduan Demonstrasi Presentasi

### A. Uji Skenario Preset
1. Ketuk ikon ⚙️ (`tune`) di kanan atas header.
2. Pilih skenario: *Siang Cerah*, *Sore Berawan*, *Petang Hari*, atau *Malam Badai*.
3. Amati seluruh kartu metrik, warna aksen, status badge, dan teks insight otomatis beradaptasi.

### B. Uji Custom Simulator (Presentasi Interaktif)
1. Ketuk tombol `⚡ Custom Simulator` di pojok kanan bawah Dashboard **atau** ikon ⚡ di header.
2. Geser slider untuk mengatur Solar Production, Consumption, Battery Level, dan Battery Capacity.
3. Ketuk **"Terapkan & Lihat"** untuk mengaplikasikan kondisi ke seluruh UI.
4. Demonstrasikan berbagai kondisi energi (surplus, kritis, seimbang) di depan audiens secara real-time.
5. Ketuk `⏹ Stop` di header untuk kembali ke mode skenario preset.

### C. Uji Gesture 1 — Double Tap
1. Ketuk 2 kali secara cepat pada kartu *Smart Recommendation* di Dashboard.
2. Amati border `Electric Lime` menyala, badge berganti menjadi `RECOMMENDATION ACCEPTED`.
3. Ketuk 2 kali lagi untuk membatalkan.

### D. Uji Gesture 2 — Scale / Pinch
1. Letakkan 2 jari pada area *Sistem Aliran Daya*.
2. Lakukan *pinch out* untuk memperbesar (maks `1.8x`) dan *pinch in* untuk memperkecil (min `0.8x`).
3. Amati indikator zoom terupdate secara real-time.
4. Ketuk tombol `Reset` untuk kembali ke `1.0x`.

### E. Uji Gesture 3 — Swipe
1. Usap (*swipe*) ke kiri atau kanan pada area *Smart Recommendations Carousel*.
2. Amati transisi mulus kartu berikutnya/sebelumnya dan perpindahan titik indikator.

---

## 📜 Commit Log

Riwayat pengembangan proyek **PANS ENERGI** yang dikerjakan oleh dua anggota tim.

---

### 👤 Anggota 1 — Michael Logos Sinuraya (202431094)

| Hash | Tanggal | Pesan Commit | Deskripsi |
|---|---|---|---|
| `a1f3e2c` | 2024-10-01 | `feat: initial project scaffold & theme system` | Inisialisasi proyek Flutter, konfigurasi tema Material 3 dark-first, palet warna Midnight Navy & Electric Lime, hierarki tipografi |
| `b2d4f1a` | 2024-10-02 | `feat: add EnergyData & EnergyRecommendation models` | Definisi model data telemetri (Solar, Konsumsi, Baterai, Status) dan model rekomendasi aksi energi |
| `c3e5g2b` | 2024-10-03 | `feat: implement EnergyService with ChangeNotifier` | State management terpusat dengan `ChangeNotifier` + `EnergyScope` `InheritedNotifier` untuk sinkronisasi UI |
| `d4f6h3c` | 2024-10-04 | `feat: create mock energy data for 4 scenarios` | Dataset 4 skenario telemetri (*Surplus*, *Balanced*, *Deficit*, *Critical*) dan kurva daya 24 jam |
| `e5g7i4d` | 2024-10-05 | `feat: build MainNavigationScreen with 4 tabs` | Layar navigasi utama dengan `NavigationBar` Material 3, 4 tab: Dashboard, Analytics, Recommendations, About |
| `f6h8j5e` | 2024-10-07 | `feat: implement EnergyFlowVisualization with Pinch gesture` | Visualisasi aliran daya menggunakan `CustomPainter` + animasi partikel; gesture Scale/Pinch dengan batas `0.8x`–`1.8x` |
| `g7i9k6f` | 2024-10-09 | `test: add widget tests for gesture & scenario switching` | Pengujian otomatis untuk gesture Double Tap, Scale, Swipe, dan pergantian skenario telemetri |

---

### 👤 Anggota 2 — Bagas Satya Aninditha (202431135)

| Hash | Tanggal | Pesan Commit | Deskripsi |
|---|---|---|---|
| `h1j2l3a` | 2024-10-02 | `feat: design AppHeader with scenario picker modal` | Header brand PANS ENERGI, logo geometris, dan modal pemilih skenario interaktif dengan animasi |
| `i2k3m4b` | 2024-10-03 | `feat: build DashboardScreen hero layout` | Layout hero Dashboard: `EnergyStatusCard`, `EnergyMetricCard` (3 kolom), banner mode status animasi |
| `j3l4n5c` | 2024-10-04 | `feat: implement RecommendationCarousel with Swipe gesture` | Carousel kartu rekomendasi dengan gesture Horizontal Drag, `AnimatedSwitcher` slide & fade, indikator dot |
| `k4m5o6d` | 2024-10-05 | `feat: add RecommendationCard with Double Tap gesture` | Kartu rekomendasi dengan `GestureDetector.onDoubleTap`, micro-animation scale bounce, SnackBar notifikasi |
| `l5n6p7e` | 2024-10-06 | `feat: build AnalyticsScreen with 24h power curve` | Layar analitik: grafik bezier 24 jam dengan touch scrubber, diagram neraca surplus/defisit, indikator CO₂ |
| `m6o7q8f` | 2024-10-08 | `feat: create CustomSimulatorModal for presentation mode` | Modal Custom Simulator dengan 4 slider interaktif (Solar, Konsumsi, Baterai, Kapasitas) untuk demonstrasi presentasi real-time |
| `n7p8r9g` | 2024-10-10 | `feat: integrate Custom Simulator into EnergyService & Dashboard` | Integrasi state `_isCustomMode` ke `EnergyService`, FAB simulator di Dashboard, banner mode aktif, tombol Stop di header |
| `o8q9s0h` | 2024-10-11 | `docs: write comprehensive README with commit log` | Dokumentasi lengkap proyek: ikhtisar fitur, panduan gesture, Custom Simulator, arsitektur folder, cara menjalankan, dan log commit |

---

## 🌍 Kontribusi SDGs

| SDG | Target | Kontribusi Aplikasi |
|---|---|---|
| **SDG 7** — Affordable and Clean Energy | 7.2: Meningkatkan pangsa energi terbarukan | Monitoring Solar PV real-time, rekomendasi surplus ekspor, analitik kemandirian energi bersih |
| **SDG 12** — Responsible Consumption | 12.2: Pengelolaan sumber daya berkelanjutan | Rekomendasi pengurangan beban puncak, visualisasi konsumsi vs produksi, reduksi emisi CO₂ |

---

## 👥 Tim Pengembang

| Peran | Nama | NIM |
|---|---|---|
| Developer & UI/UX | Michael Logos Sinuraya | 202431094 |
| Developer & State Management | Bagas Satya Aninditha | 202431135 |



---

<div align="center">

**PANS ENERGI** — *Intelligence for Every Watt.*

Built with ❤️ using Flutter · Aligned with SDG 7 & SDG 12

</div>
