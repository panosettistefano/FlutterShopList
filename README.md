# 🛒 Lista della Spesa — Flutter

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Test](https://img.shields.io/badge/test-2%20passing-34C759)
![Piattaforme](https://img.shields.io/badge/piattaforme-Android%20%7C%20Linux%20%7C%20Web-0A84FF)

Piccola applicazione **Flutter** realizzata a scopo didattico per mettere in pratica i
fondamenti di Dart e Flutter: widget, layout, gestione dello stato, eventi e collezioni.

L'intera applicazione vive in un solo file, **`lib/main.dart`** (~200 righe), senza
package esterni, database o servizi: solo widget standard di Flutter.

---

## ✨ Funzionalità

- ➕ Aggiunta di un articolo tramite pulsante **+** o tasto **Invio**
- 🧹 Svuotamento automatico del campo di testo dopo l'aggiunta
- 📊 Contatori in tempo reale: articoli **da comprare** e **comprati**
- ✅ Tap su una card per segnarla come comprata (testo barrato, card verde, spunta)
- ↩️ Secondo tap per riportarla tra quelli da comprare
- 🗑️ Eliminazione di un articolo con il cestino
- 📭 Stato vuoto con messaggio dedicato quando la lista non contiene articoli
- 📜 Lista scorrevole con `ListView`

> ⚠️ I dati restano **solo in memoria**: chiudendo l'app la lista si azzera.

---

## 🧱 Tecnologie

| Tecnologia | Utilizzo |
|---|---|
| **Flutter** | UI, widget e gestione dello stato |
| **Dart** | Modello dati e logica applicativa |
| `StatefulWidget` + `setState` | Stato locale della schermata |
| `TextEditingController` | Gestione del campo di testo |
| `flutter_test` | Widget test |

Nessuna dipendenza esterna: il progetto usa esclusivamente l'SDK Flutter.

---

## 📂 Struttura del progetto

```
progetto_its/
├── lib/
│   └── main.dart          # Tutta l'app: modello, schermata e logica
├── test/
│   └── widget_test.dart   # Widget test (lista vuota + flusso completo)
├── android/               # Progetto Android generato da Flutter
├── ios/                   # Progetto iOS generato da Flutter
├── linux/                 # Progetto Linux generato da Flutter
├── web/                   # Progetto Web generato da Flutter
├── windows/               # Progetto Windows generato da Flutter
└── pubspec.yaml           # Dipendenze e configurazione
```

Dentro `lib/main.dart`:

```
main()                     → avvia MaterialApp con tema e colori
class Articolo             → modello dati (nome + comprato)
class ListaSpesaPage       → widget con stato
class _ListaSpesaPageState → stato, logica e interfaccia
```

---

## 🚀 Avvio

### Requisiti

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installato
- Un dispositivo/emulatore oppure la toolchain desktop (Linux, Windows, macOS)

Verifica l'ambiente:

```bash
flutter --version
flutter doctor
flutter devices
```

### Installazione

```bash
git clone https://github.com/panosettistefano/FlutterShopList.git
cd FlutterShopList
flutter pub get
```

### Esecuzione

```bash
# Desktop Linux
flutter run -d linux

# Telefono Android collegato via USB (debug USB attivo)
flutter run -d <device-id>

# Web
flutter run -d chrome
```

Durante l'esecuzione, nel terminale:

| Tasto | Effetto |
|---|---|
| `r` | hot reload |
| `R` | hot restart |
| `q` | chiude l'app |

### Build APK

```bash
flutter build apk --debug
# output: build/app/outputs/flutter-apk/app-debug.apk
```

---

## 🧪 Test

```bash
flutter analyze
flutter test
```

Risultati attesi:

- `flutter analyze` → **No issues found**
- `flutter test` → **2 test passati**
  - la lista parte vuota;
  - aggiunta, svuotamento del campo, segna come comprato ed eliminazione funzionano.

---

## 🎨 Design

Interfaccia ispirata allo stile **Apple** (iOS):

| Elemento | Valore |
|---|---|
| Sfondo | `#F2F2F7` |
| Card | bianche, angoli `16 px`, ombra leggera |
| Card "comprato" | `#EAF9EE` con spunta verde |
| Accento primario | `#0A84FF` |
| Accento verde | `#34C759` |
| Accento eliminazione | `#FF3B30` |
| Testo principale | `#1C1C1E` |
| Testo secondario | `#8E8E93` |

- Titolo grande (28 px, bold) nell'`AppBar` trasparente
- Campo di testo bianco con angoli arrotondati
- Pulsante `+` blu quadrato
- Pillole per i conteggi
- Card con `Card` + `ListTile`

---

## 🔄 Flusso dello stato

```
utente scrive nel TextField
        ↓
preme + oppure Invio
        ↓
_aggiungi() legge _controller.text.trim()
        ↓
setState() aggiunge un Articolo e svuota il campo
        ↓
Flutter riesegue build()
        ↓
la lista e i contatori si aggiornano
```

Lo stesso schema vale per `_toggle()` (comprato / da comprare) e `_elimina()`.

---

## 🛠️ Possibili estensioni

- [ ] Salvare la lista con `shared_preferences` o un file
- [ ] Categorie, prezzi e quantità
- [ ] Tema scuro automatico
- [ ] Ricerca o filtro degli articoli
- [ ] Conferma prima dell'eliminazione

---

## 👤 Autore

**Stefano Panosetti** — [@panosettistefano](https://github.com/panosettistefano)

Progetto realizzato a scopo didattico.
