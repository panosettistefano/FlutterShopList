# Lista della spesa — App Flutter

Piccola applicazione didattica realizzata in Flutter per mettere in pratica i concetti dei manuali
**Dart (Parti I–IV)** e **Flutter (Parti I–II)**.

L'app è volutamente semplice ma con un design curato in stile Apple:
**202 righe totali**, di cui **159 di codice effettivo** (esclusi spazi e commenti).
Tutto sta in `lib/main.dart`, senza package esterni, senza database e senza emulatore.
Serve a dimostrare widget, layout, gestione dello stato, eventi e collezioni.

---

## 1. Cosa fa l'app

- Permette di inserire un articolo nel campo di testo e aggiungerlo con il pulsante **+**
  oppure premendo **Invio**.
- Dopo l'aggiunta il campo si **svuota automaticamente** e la lista **scorre** se cresce.
- Mostra quanti articoli restano **da comprare** e quanti sono già **comprati**.
- Toccando una card la si segna come comprata: la card diventa verde, il testo viene
  barrato e l'icona diventa una spunta.
- Un secondo tocco riporta l'articolo a "da comprare".
- Il cestino elimina l'articolo.
- Se la lista è vuota compare un'icona con il messaggio:
  *"La lista è vuota — Aggiungi il primo articolo"*.

I dati restano **solo in memoria**: chiudendo l'app la lista si azzera.

---

## 2. Come è organizzato il codice

Tutto il codice dell'app è in **`lib/main.dart`**:

```
main.dart
│
├── main()                     → avvia MaterialApp con tema e colori
├── class Articolo             → modello dati (nome + comprato)
├── class ListaSpesaPage       → widget con stato
└── class _ListaSpesaPageState → stato, logica e interfaccia
```

### 2.1 `main()`

```dart
void main() {
  // Avvia l'app. Lo Scaffold della schermata è dentro ListaSpesaPage.
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF2F2F7)),
    home: const ListaSpesaPage(),
  ));
}
```

`runApp` avvia l'app; `MaterialApp` è il contenitore principale e `home` indica la prima
schermata, cioè `ListaSpesaPage`.

- `theme` imposta lo sfondo chiaro (`#F2F2F7`);
- `debugShowCheckedModeBanner: false` nasconde il nastro rosso "DEBUG";
- **lo `Scaffold` non è nel `main`**: è dentro `build()` di `ListaSpesaPage`, come negli
  esempi dei manuali (`main` → `MaterialApp` → pagina → `Scaffold`).

### 2.2 `Articolo`

```dart
class Articolo {
  String nome;
  bool comprato;

  Articolo(this.nome, this.comprato);
}
```

È una piccola classe Dart con due proprietà:

| Proprietà | Tipo | Significato |
|---|---|---|
| `nome` | `String` | il nome dell'articolo |
| `comprato` | `bool` | `false` = da comprare, `true` = comprato |

Il costruttore `Articolo(this.nome, this.comprato)` assegna i due valori quando si crea
un nuovo oggetto.

### 2.3 `ListaSpesaPage` e lo stato

```dart
class ListaSpesaPage extends StatefulWidget {
  const ListaSpesaPage({super.key});

  @override
  State<ListaSpesaPage> createState() => _ListaSpesaPageState();
}
```

È uno `StatefulWidget`: possiede uno stato che cambia nel tempo. Lo stato vero e proprio
è dentro `_ListaSpesaPageState`:

```dart
final TextEditingController _controller = TextEditingController();
final List<Articolo> _articoli = [];
```

- `_controller` legge e gestisce il testo scritto nel `TextField`.
- `_articoli` è la lista degli articoli presenti.

`dispose()` libera il controller quando la schermata viene distrutta:

```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

### 2.4 I metodi principali

**`_aggiungi()`**

```dart
void _aggiungi() {
  var testo = _controller.text.trim();
  if (testo == "") {
    return;
  }
  setState(() {
    _articoli.add(Articolo(testo, false));
    _controller.clear();
  });
}
```

1. legge il testo e rimuove gli spazi iniziali/finali con `trim()`;
2. se è vuoto non fa nulla;
3. aggiunge un nuovo `Articolo` con `comprato = false`;
4. svuota il campo con `_controller.clear()`;
5. `setState()` dice a Flutter di ridisegnare l'interfaccia.

**`_toggle()`** inverte lo stato "comprato":

```dart
void _toggle(Articolo articolo) {
  setState(() {
    articolo.comprato = !articolo.comprato;
  });
}
```

**`_elimina()`** rimuove l'articolo dalla lista:

```dart
void _elimina(Articolo articolo) {
  setState(() {
    _articoli.remove(articolo);
  });
}
```

**`_pillola()`** costruisce le due pillole con i conteggi:

```dart
Widget _pillola(String testo, Color colore, Color sfondo) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(color: sfondo, borderRadius: BorderRadius.circular(100)),
    child: Text(testo,
        style: TextStyle(color: colore, fontSize: 13, fontWeight: FontWeight.w600)),
  );
}
```

**`_vuota()`** mostra l'icona della borsa e il messaggio centrale quando la lista
non contiene articoli.

**`_card()`** costruisce la card di un singolo articolo:

```dart
Widget _card(Articolo articolo) {
  var comprato = articolo.comprato;
  return Card(
    elevation: 1,
    margin: const EdgeInsets.only(bottom: 10),
    color: comprato ? const Color(0xFFEAF9EE) : Colors.white,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: ListTile(
      onTap: () => _toggle(articolo),
      leading: Icon(comprato ? Icons.check_circle_rounded : Icons.circle_outlined,
          color: comprato ? const Color(0xFF34C759) : const Color(0xFFC7C7CC)),
      title: Text(articolo.nome,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: comprato ? const Color(0xFF8E8E93) : const Color(0xFF1C1C1E),
              decoration: comprato ? TextDecoration.lineThrough : TextDecoration.none)),
      trailing: IconButton(
        onPressed: () => _elimina(articolo),
        icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFFF3B30)),
      ),
    ),
  );
}
```

In breve:

- `Card` crea la card bianca (o verde) con angoli arrotondati e ombra;
- `ListTile` dispone icona, testo e cestino;
- `onTap` cambia lo stato; il testo diventa grigio e barrato se comprato.

### 2.5 `build()`

`build()` calcola prima i conteggi con `where`:

```dart
var daComprare = _articoli.where((a) => !a.comprato).toList().length;
var comprati = _articoli.where((a) => a.comprato).toList().length;
```

Poi restituisce uno `Scaffold` composto da:

1. **AppBar** trasparente con il titolo grande (28 px, grassetto);
2. **Row** con `Expanded(TextField)` e un pulsante blu quadrato con l'icona `+`;
3. **Row** con le due pillole `_pillola(...)`;
4. **Expanded** che mostra `_vuota()` oppure la lista scorrevole.

La parte chiave della lista è:

```dart
Expanded(
  child: _articoli.isEmpty
      ? _vuota()
      : ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: _articoli.map((a) => _card(a)).toList(),
        ),
),
```

`ListView` è il widget che permette di **scorrere** la lista anche con molti articoli;
`map` trasforma ogni `Articolo` nella sua card.

### 2.6 Flusso dello stato

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

Lo stesso schema vale per `_toggle()` e `_elimina()`.

### 2.7 Scelte di design

- Sfondo grigio chiaro `#F2F2F7`, card bianche e accenti blu `#0A84FF` / verde `#34C759`.
- Angoli arrotondati (16 px) e ombra leggera per le card.
- Titolo grande, campo di testo riempito di bianco, pulsante `+` blu.
- `Card` + `ListTile` per card semplici e ordinate.
- `ListView` per lo scorrimento.
- Nessun package esterno: solo widget standard di Flutter.

---

## 3. Concetti dei manuali usati

| Manuale | Concetti usati nell'app |
|---|---|
| Dart Parte I | `var`, `final`, tipi `String`/`bool`, `if`/`else`, operatori `==` e `!`, interpolazione di stringhe |
| Dart Parte II | classe `Articolo`, costruttore, proprietà, metodo `this` |
| Dart Parte III | `List`, `add`, `remove`, `where`, `toList`, `map`, `length`, `isEmpty` |
| Flutter Parte I | `MaterialApp`, `Scaffold`, `AppBar`, `Text`, `Icon`, `Container`, `Padding`, `SizedBox`, `Row`, `Column`, `ElevatedButton`, `IconButton`, `TextField`, `InputDecoration`, `TextStyle`, `Colors`, `Icons` |
| Flutter Parte II | `StatefulWidget`, `setState`, `TextEditingController`, `controller.text`, `dispose` |

> La logica principale usa i concetti dei manuali. Per il design richiesto sono state
> aggiunte alcune API standard di Flutter non presenti nei manuali (tra cui):
> `ThemeData`, `ListView`, `Expanded`, `Card`, `ListTile`, `BoxDecoration`,
> `BorderRadius`, `TextDecoration.lineThrough`, `OutlineInputBorder`,
> `RoundedRectangleBorder`, `trim` e `clear`.

---

## 4. Eseguire l'app sul PC (Linux)

### Prerequisiti

- Flutter installato e funzionante;
- toolchain Linux per Flutter (clang, cmake, ninja, pkg-config, GTK 3).

Controllo rapido:

```bash
flutter --version
flutter doctor
flutter devices
```

### Avvio

```bash
cd /home/stefano/Desktop/flutter/progetto_its
flutter pub get
flutter run -d linux
```

La finestra dell'app si apre sul desktop. Nel terminale:

- `r` → hot reload (ricarica le modifiche senza perdere lo stato);
- `R` → hot restart;
- `q` → chiude l'app.

---

## 5. Vedere l'app sul telefono via USB (senza emulatore)

Non serve un emulatore: Flutter può installare e avviare l'app direttamente su un telefono
Android collegato via USB. L'emulatore occupa diversi GB, il telefono no.

### 5.1 Prerequisiti sul PC: Android SDK senza emulatore

Per compilare per Android serve l'**Android SDK**, ma **non serve l'emulatore** e non è
obbligatorio installare Android Studio. Bastano i **command-line tools** e le
**platform-tools** (che contengono `adb`).

> **Stato su questo PC: configurazione già completata.**
> Sono installati:
>
> - `cmdline-tools` 22.0 in `~/Android/Sdk/cmdline-tools/latest`;
> - `platform-tools` 37.0.1 (con `adb`);
> - `platforms;android-36` e `build-tools;36.0.0`;
> - `ndk;28.2.13676358` (Flutter 3.47.7 lo richiede anche senza codice nativo);
> - Java 21 configurato in Flutter (`flutter config --jdk-dir=/usr/lib/jvm/java-21-openjdk-amd64`);
> - licenze Android accettate;
> - `ANDROID_HOME` e `PATH` aggiunti a `~/.bashrc`.
>
> I passi seguenti servono se si riparte da zero o per un altro PC.

Controlla la situazione:

```bash
flutter doctor
```

La voce **Android toolchain** deve avere la spunta verde. Se manca `cmdline-tools`,
completa così:

1. **JDK**: serve Java 17 o superiore. Su questo PC Java 21 è già installato e Flutter
   è configurato per usarlo:

   ```bash
   /usr/lib/jvm/java-21-openjdk-amd64/bin/java -version
   flutter config --jdk-dir /usr/lib/jvm/java-21-openjdk-amd64
   ```

   Su un altro PC, se Gradle segnala una versione non supportata:

   ```bash
   sudo apt install openjdk-21-jdk
   ```

2. **Scarica i command-line tools** dalla pagina
   <https://developer.android.com/studio#command-line-tools-only>
   (sezione "Command line tools only", versione Linux).

3. **Estrai** lo zip nella cartella dell'SDK:

   ```bash
   mkdir -p ~/Android/Sdk/cmdline-tools
   cd ~/Downloads
   unzip commandlinetools-linux-*.zip -d ~/Android/Sdk/cmdline-tools
   mv ~/Android/Sdk/cmdline-tools/cmdline-tools ~/Android/Sdk/cmdline-tools/latest
   ```

   Lo zip crea una cartella `cmdline-tools`; va rinominata in `latest`.

4. **Imposta le variabili d'ambiente**. Aggiungi queste righe in fondo a `~/.bashrc`:

   ```bash
   export ANDROID_HOME="$HOME/Android/Sdk"
   export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
   ```

   Poi ricarica la shell:

   ```bash
   source ~/.bashrc
   ```

5. **Installa platform-tools e accetta le licenze**:

   ```bash
   sdkmanager --install "platform-tools"
   flutter doctor --android-licenses
   flutter doctor
   ```

   Al primo build Gradle scarica automaticamente la piattaforma Android e le build-tools
   richieste. Se preferisci installarle subito:

   ```bash
   sdkmanager --install "platforms;android-36" "build-tools;36.0.0"
   ```

   (Se la tua versione di Flutter richiede un'API diversa, Gradle la scarica da sola.)

   Al primo build Android, Flutter 3.47.7 scarica **anche l'NDK 28.2** (~2,2 GB):
   è obbligatorio anche per le app senza codice nativo. Su questo PC è già installato.

6. Quando `flutter doctor` mostra **Android toolchain ✓** puoi collegare il telefono.

> Le cartelle `~/Android/Sdk/emulator` (~863 MB) e `~/Android/Sdk/system-images`,
> se presenti, **non servono** per il telefono: puoi rimuoverle dal SDK Manager per
> liberare spazio. Su questo PC sono ancora presenti ma non vengono usate.

### 5.2 Preparare il telefono

1. Apri **Impostazioni → Informazioni sul telefono**.
2. Tocca **7 volte** la voce **Numero build** (o "Versione build").
   Comparirà il messaggio "Ora sei uno sviluppatore".
3. Torna in **Impostazioni → Sistema → Opzioni sviluppatore**
   (su alcuni telefoni è direttamente in Impostazioni).
4. Attiva **Debug USB**.
5. Se presente, attiva anche:
   - **Installa tramite USB**;
   - **Debug USB (impostazioni di sicurezza)** — tipico di Xiaomi/Redmi/POCO.
6. Collega il telefono al PC con un **cavo USB di dati** (non un cavo solo-ricarica).
7. Sul telefono, se compare la richiesta **"Consentire il debug USB?"**, tocca
   **Consenti** (e spunta "Ricorda sempre"). La prima volta viene mostrata un'impronta RSA.

> Se non compare nulla: cambia cavo/porta USB, riprova, oppure revoca le autorizzazioni
> da Opzioni sviluppatore → "Revoca autorizzazioni debug USB" e ricollega.

### 5.3 Controllare che il PC veda il telefono

Servono `adb` (Android Debug Bridge) e i driver/regole USB.

> **Su questo PC `adb` è già installato nell'SDK** (`~/Android/Sdk/platform-tools/adb`)
> e il PATH in `~/.bashrc` lo mette per primo. Apri un nuovo terminale (o esegui
> `source ~/.bashrc`) e verifica con `which adb`: deve uscire
> `$HOME/Android/Sdk/platform-tools/adb`.
>
> Non installare `android-tools-adb` da apt: crea un secondo `adb` e `flutter doctor`
> segnala "Multiple adb binaries found". Su questo PC le regole udev ci sono già e
> l'utente è nel gruppo `plugdev`: non serve altro.

Verifica:

```bash
which adb
adb version
adb devices
```

Output atteso (con telefono collegato e autorizzato):

```
List of devices attached
R58M123ABC      device
```

- Se compare `unauthorized`: sblocca il telefono e accetta la finestra "Consentire il debug USB?".
- Su un **altro PC** senza `adb`, puoi installarlo da apt (poi evita di avere due `adb` nel PATH):

```bash
sudo apt update
sudo apt install android-tools-adb android-tools-fastboot
```

- Se compare `no permissions`: mancano le regole udev. Su Ubuntu/Mint:

```bash
sudo apt install android-sdk-platform-tools-common
sudo usermod -aG plugdev $USER
```

Poi esci e rientra nella sessione (o riavvia), quindi:

```bash
adb kill-server
adb start-server
adb devices
```

Su **Windows** serve il driver USB del produttore del telefono (Samsung, Xiaomi, ecc.);
su **macOS** di solito non serve nulla.

### 5.4 Avviare l'app sul telefono

> Su questo PC la toolchain Android è già pronta. Apri un nuovo terminale (o esegui
> `source ~/.bashrc`) e, se usi VS Code, riavvialo per fargli leggere `ANDROID_HOME`
> e il JDK configurato.

```bash
cd /home/stefano/Desktop/flutter/progetto_its
flutter devices
```

Ora il telefono deve comparire nella lista, ad esempio:

```
SM G991B (mobile) • R58M123ABC • android-arm64 • Android 14 (API 34)
```

Copiare l'ID del dispositivo (nell'esempio `R58M123ABC`) e lanciare:

```bash
flutter run -d R58M123ABC
```

La prima compilazione può richiedere qualche minuto (Gradle scarica le dipendenze; su
questo PC sono già in cache). Alla fine l'app si apre automaticamente sul telefono.
Tieni il telefono sbloccato durante l'installazione.

Se `flutter devices` non mostra il telefono, controlla prima `adb devices`: se lì non
compare, il problema è USB/autorizzazione, non Flutter.

Comandi utili nel terminale:

| Tasto | Effetto |
|---|---|
| `r` | hot reload |
| `R` | hot restart |
| `q` | chiude l'app e il comando |

### 5.5 Alternativa: generare un APK e installarlo

```bash
flutter build apk --debug
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

Oppure, con Flutter:

```bash
flutter install -d R58M123ABC
```

### 5.6 Se il telefono non viene rilevato

Controlla in quest'ordine:

1. **Cavo**: usa un cavo di dati, non uno solo di ricarica. Prova un'altra porta USB.
2. **Debug USB** attivo: disattivalo e riattivalo.
3. **Autorizzazione**: sul telefono deve comparire la richiesta RSA; se non compare,
   revoca le autorizzazioni e ricollega.
4. **Modalità USB**: nella notifica "Utilizzo USB" scegli **Trasferimento file** (MTP).
5. **adb**: esegui `adb kill-server` e poi `adb devices`.
6. **Linux**: regole udev e gruppo `plugdev` come sopra.
7. **Flutter**: esegui `flutter doctor -v` e accetta le licenze Android con
   `flutter doctor --android-licenses`.
8. **Xiaomi/Redmi/POCO**: oltre al Debug USB, attiva "Installa tramite USB" e
   "Debug USB (impostazioni di sicurezza)"; a volte serve un account Xiaomi attivo
   per la prima autorizzazione.

> Nota: il debug USB descritto qui vale per Android. Un iPhone non può essere collegato
> a un PC Linux per eseguire app Flutter: serve un Mac con Xcode.

---

## 6. Analisi e test

```bash
flutter analyze
flutter test
```

Risultati attesi:

- `flutter analyze` → **No issues found**;
- `flutter test` → **2 test passati**:
  - la lista parte vuota;
  - aggiunta, svuotamento del campo, segna come comprato ed eliminazione funzionano.

Il file `test/widget_test.dart` è solo di verifica: l'app vera resta interamente in
`lib/main.dart`.

---

## 7. Scelte di design e limiti

- **Niente persistenza**: i dati restano in memoria e si perdono alla chiusura.
- **Design in stile Apple**: sfondo chiaro, card bianche arrotondate con ombra leggera,
  titolo grande, pillole per i conteggi e accenti blu/verdi.
- **Card semplici**: `Card` + `ListTile` con angoli arrotondati e ombra leggera.
- **Lista scorrevole**: `ListView` gestisce anche molti articoli.
- **Campo che si svuota**: `_controller.clear()` dopo l'aggiunta.
- **Testo barrato**: `TextDecoration.lineThrough` per gli articoli comprati.
- La logica principale usa i concetti dei manuali; le API di design elencate nella
  sezione 3 sono state aggiunte su richiesta per rendere l'app più curata.

---

## 8. Possibili estensioni (facoltative)

- salvare la lista con `shared_preferences` o un file;
- aggiungere categorie, prezzi o quantità;
- tema scuro automatico;
- ricerca o filtro degli articoli;
- conferma prima dell'eliminazione.
