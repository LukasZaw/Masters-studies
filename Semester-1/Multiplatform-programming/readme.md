# Aplikacja do zarządzania firmą (Qt / C++)

## Opis projektu

Desktopowa aplikacja napisana w C++ z wykorzystaniem frameworka Qt, służąca do kompleksowego zarządzania firmą. System umożliwia zarządzanie pracownikami, produktami oraz magazynem, a także generowanie raportów i zestawień.

# Główne funkcjonalności

## 1. Zarządzanie pracownikami

### Funkcje

- Dodawanie pracownika
- Edytowanie danych pracownika
- Usuwanie pracownika
- Przeglądanie listy pracowników
- Wyszukiwanie pracowników
- Filtrowanie pracowników
- Przypisywanie pracowników do działów
- Przypisywanie pracowników do zadań

### Dane pracownika

- ID
- Imię
- Nazwisko
- Email
- Telefon
- Stanowisko
- Dział
- Data zatrudnienia
- Status (aktywny / nieaktywny)
- Notatki

## 2. Zarządzanie produktami

### Funkcje

- Dodawanie produktu
- Edytowanie produktu
- Usuwanie produktu
- Lista produktów
- Wyszukiwanie produktów
- Filtrowanie produktów
- Przypisywanie produktu do lokalizacji
- Śledzenie stanu magazynowego

### Dane produktu

- ID
- Nazwa produktu
- Kod produktu (SKU)
- Kategoria
- Cena
- Ilość
- Jednostka
- Lokalizacja
- Opis

## 3. Zarządzanie magazynem

### Funkcje

- Rejestrowanie przyjęć produktów
- Rejestrowanie wydań produktów
- Historia operacji magazynowych
- Aktualizacja stanów magazynowych
- Przenoszenie produktów między lokalizacjami

### Operacje magazynowe

- Przyjęcie towaru
- Wydanie towaru
- Przesunięcie międzymagazynowe
- Korekta stanu

### Dane operacji

- ID operacji
- Typ operacji
- Produkt
- Ilość
- Data
- Pracownik
- Lokalizacja źródłowa
- Lokalizacja docelowa
- Uwagi

## 4. Raporty i zestawienia

### Raporty magazynowe

- Aktualny stan magazynu
- Lista produktów poniżej minimalnego stanu
- Historia przyjęć
- Historia wydań
- Ruch magazynowy

### Raporty pracowników

- Lista pracowników
- Pracownicy według działów
- Przypisanie do zadań
- Aktywność pracowników

### Możliwości eksportu

- Export do CSV
- Export do PDF
- Export do JSON

# Architektura aplikacji

Aplikacja oparta o architekturę MVC:

- Model — dane (pracownicy, produkty, magazyn)
- View — interfejs Qt (QWidget / QMainWindow)
- Controller — logika aplikacji

## Struktura katalogów

```
project/
│
├── main.cpp
├── ui/
├── models/
├── database/
├── services/
└── ui/

```

# Baza danych

SQLite (Qt SQL)

## Tabela employees

```
employees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone TEXT,
    position TEXT,
    department TEXT,
    hire_date TEXT,
    status TEXT,
    notes TEXT
)
```

## Tabela products

```
products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    sku TEXT,
    category TEXT,
    price REAL,
    quantity INTEGER,
    unit TEXT,
    location TEXT,
    description TEXT
)
```

## Tabela warehouse_operations

```
warehouse_operations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER,
    type TEXT,
    quantity INTEGER,
    employee_id INTEGER,
    source_location TEXT,
    target_location TEXT,
    created_at TEXT,
    notes TEXT
)
```

# Interfejs użytkownika

## Główne okno

- Menu górne
- Pasek nawigacji
- Obszar roboczy
- Status bar

## Zakładki

- Pracownicy
- Produkty
- Magazyn
- Raporty

# Technologie

- C++
- Qt 5
- Qt Widgets
- Qt Designer
- Qt SQL
- SQLite
- Model/View (QTableView)

# Przyszłe rozszerzenia

- Logowanie użytkowników
- Role użytkowników
- Uprawnienia
- Wiele magazynów
- Wykresy statystyk
- Dashboard
- Powiadomienia

# Wymagania

- Qt 5.15+
- Kompilator C++17
- CMake lub qmake

# Budowanie projektu (CMake)

```
mkdir build
cd build
cmake ..
make
```

---

# Autor

Projekt edukacyjny – github.com/lukaszaw
