# CatalogApp

[![CI](https://github.com/grasepta/CatalogApp/actions/workflows/ci.yml/badge.svg)](https://github.com/grasepta/CatalogApp/actions)

Katalog game iOS berbasis API [RAWG](https://rawg.io/) untuk submission **Menjadi iOS Developer Expert** (Dicoding).

## Arsitektur

- Clean Architecture (Presentation / Domain / Data)
- Dependency Injection manual
- Reactive Programming dengan Combine
- Modularization: `Home`, `Detail`, `Favorite`, `About`, `Common` (local SPM) + **Core** (remote SPM)

Modul Core yang di-publish:

https://github.com/grasepta/CatalogApp-Core

## Continuous Integration

GitHub Actions menjalankan SwiftLint, build, test, dan code coverage pada setiap push/PR.

https://github.com/grasepta/CatalogApp/actions
