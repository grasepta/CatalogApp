# Catatan Submission — Capstone iOS Developer Expert

CatalogApp adalah katalog game iOS berbasis API RAWG. Aplikasi ini menerapkan **Clean Architecture**, **Dependency Injection (manual)**, dan **Reactive Programming (Combine)** sesuai kriteria kelas Menjadi iOS Developer Expert.

Navigasi utama memakai `TabView` dengan tiga tab: Games, Favorit, dan About.

## Link wajib untuk reviewer

- **Continuous Integration (GitHub Actions):** https://github.com/grasepta/CatalogApp/actions
- **Modul Core (Swift Package Manager):** https://github.com/grasepta/CatalogApp-Core
- **Repository aplikasi:** https://github.com/grasepta/CatalogApp

## Modularization

Project memakai Swift Package Manager:

- `Core` di-publish ke GitHub (`grasepta/CatalogApp-Core`) dan dikonsumsi sebagai remote package. Tidak ada salinan Core di lokal aplikasi.
- Modul fitur local package: `Home`, `Detail`, `Favorite`, `About`, dan `Common`.
- Diagram hubungan modul: `lo-fi/07-modularization.png`.

`Core` menerapkan **generic protocol**:

- `UseCase`
- `Repository`
- `DataSource`
- `Mapper`

Interactor tiap fitur menyesuaikan protocol tersebut, contoh `HomeInteractor.execute(request: GamesQuery)`.

## Arsitektur

- **Presentation** (modul fitur): View, Presenter, Router. Tidak mengakses Data Layer, Response, Entity, Alamofire, atau Core Data.
- **Domain** (`Core`): `GameModel` / `GameDetailModel` / `GamesPage`, UseCase, dan protocol repository.
- **Data** (`Core`): RemoteDataSource (Alamofire + Combine), LocaleDataSource (Core Data + Combine), Repository, Mapper.

Dependency Injection dilakukan di luar class pemakai:

- `Injection` menyediakan UseCase.
- `CatalogApp` / Router membuat Presenter sebelum View ditampilkan.
- View hanya menerima Presenter yang sudah di-inject.

Pengujian Domain memakai **XCTest** (`HomeInteractor`, `DetailInteractor`, `FavoriteInteractor`) dengan `MockGameRepository` berbasis `GameRepositoryProtocol`, tanpa jaringan atau Core Data.

## Daftar Fitur

### 1. Daftar Game (tab Games)

- Menampilkan daftar game dari endpoint RAWG `/games` (20 item per halaman) dengan **load-more / infinite scroll**.
- Thumbnail, judul, tanggal rilis, dan peringkat.
- Gambar dimuat dengan Kingfisher.
- Pencarian `.searchable()` ke RAWG, debounce **400 ms** (Combine).
- Loading, error + **Coba lagi**, empty state “Tidak ada hasil”.

### 2. Detail Game

- Endpoint RAWG `/games/{id}`.
- Cover, judul, rilis, peringkat, deskripsi, chip genre/platform.
- Tombol favorit di toolbar (`heart` / `heart.fill`) ke Core Data.

### 3. Favorit (tab Favorit)

- Daftar favorit lokal (Core Data, offline).
- Swipe-to-delete / Edit, empty state “Belum ada game favorit”.

### 4. Profil (tab About)

- Nama default: Aldino Risqi Grasepta.
- Edit nama dan foto (PhotosPicker), persist UserDefaults + Documents.

## Improvisasi / saran yang diterapkan

1. Tampilan mengikuti **Human Interface Guidelines**: spacing konsisten, loading, error + retry, empty state, komponen sesuai fungsi.
2. Fitur tambahan: pencarian, favorit offline, edit profil, chip genre/platform, infinite scroll, accessibility.
3. **Generic protocol** pada modularization (`UseCase`, `Repository`, `DataSource`, `Mapper`).
4. Pengujian **XCTest** pada business logic Domain dengan pendekatan TDD.
5. **SwiftLint** (plugin + CI) tanpa mematikan banyak rule.
6. **GitHub Actions** dengan SwiftLint (code style), `xcodebuild test`, dan **code coverage**.
7. Diagram hubungan modul (`lo-fi/07-modularization.png`).

## Lo-fi yang dilampirkan

- `01-home.png` — daftar game + search + tab bar
- `02-detail.png` — cover, deskripsi, chip genre/platform, tombol heart
- `03-favorite.png` — daftar game favorit
- `04-favorite-empty.png` — empty state favorit
- `05-about.png` — foto asli + nama + tombol Edit
- `06-edit-profile.png` — form edit profil
- `07-modularization.png` — hubungan modul aplikasi
