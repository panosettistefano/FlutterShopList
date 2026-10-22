import 'package:flutter/material.dart';

void main() {
  // Avvia l'app. Lo Scaffold della schermata è dentro ListaSpesaPage.
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF2F2F7)),
    home: const ListaSpesaPage(),
  ));
}

// Un articolo della lista.
class Articolo {
  String nome;
  bool comprato;

  Articolo(this.nome, this.comprato);
}

class ListaSpesaPage extends StatefulWidget {
  const ListaSpesaPage({super.key});

  @override
  State<ListaSpesaPage> createState() => _ListaSpesaPageState();
}

class _ListaSpesaPageState extends State<ListaSpesaPage> {
  // Il controller va creato qui e rilasciato in dispose(): tiene risorse native
  // del campo di testo che non vengono liberate da sole.
  final TextEditingController _controller = TextEditingController();
  final List<Articolo> _articoli = [];

  @override
  void dispose() {
    // Prima si libera il controller, poi si chiama super.dispose():
    _controller.dispose();
    super.dispose();
    // in questo modo lo stato non è più utilizzabile.
  }

    
  // Aggiunge il testo scritto e svuota il campo.
  void _aggiungi() {
    // trim() toglie gli spazi ai lati: così un campo con solo spazi non
    // crea un articolo vuoto.
    var testo = _controller.text.trim();
    if (testo == "") {
      return;
    }
    setState(() {
      // clear() sta dentro setState perché nello stesso momento cambiano
      // sia la lista sia il contenuto del campo.
      _articoli.add(Articolo(testo, false));
      _controller.clear();
    });
  }

  // Cambia lo stato comprato / da comprare.
  void _toggle(Articolo articolo) {
    // L'oggetto è mutabile, ma senza setState Flutter non ridisegna la card.
    setState(() {
      articolo.comprato = !articolo.comprato;
    });
  }

  // Elimina un articolo.
  void _elimina(Articolo articolo) {
    // Arriva lo stesso oggetto presente nella lista, quindi remove() lo trova.
    setState(() {
      _articoli.remove(articolo);
    });
  }

  // Pillola colorata per i conteggi.
  Widget _pillola(String testo, Color colore, Color sfondo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: sfondo, borderRadius: BorderRadius.circular(100)),
      child: Text(testo,
          style: TextStyle(color: colore, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  // Messaggio mostrato quando la lista è vuota.
  Widget _vuota() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 56, color: Color(0xFFC7C7CC)),
          SizedBox(height: 12),
          Text("La lista è vuota",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
          SizedBox(height: 4),
          Text("Aggiungi il primo articolo", style: TextStyle(color: Color(0xFF8E8E93))),
        ],
      ),
    );
  }

  // Card di un articolo.
  Widget _card(Articolo articolo) {
    var comprato = articolo.comprato;
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      color: comprato ? const Color(0xFFEAF9EE) : Colors.white,
      // In Material 3 l'elevazione colora la card con una tinta del tema:
      // il trasparente la lascia bianca come da design.
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

  @override
  Widget build(BuildContext context) {
    // where() restituisce un Iterable "pigro": toList() lo fa scorrere
    // davvero, poi length conta i due gruppi.
    var daComprare = _articoli.where((a) => !a.comprato).toList().length;
    var comprati = _articoli.where((a) => a.comprato).toList().length;

    // Struttura della schermata: AppBar + corpo (come nei manuali).
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 70,
        title: const Text("Lista della spesa",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E))),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo di testo e pulsante per aggiungere.
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _aggiungi(),
                  decoration: InputDecoration(
                    hintText: "Aggiungi un articolo",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _aggiungi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A84FF),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(56, 56),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Icon(Icons.add_rounded, size: 28),
              ),
            ]),
            const SizedBox(height: 16),
            // Conteggi.
            Row(children: [
              _pillola("$daComprare da comprare", const Color(0xFF0A84FF), const Color(0x1A0A84FF)),
              const SizedBox(width: 8),
              _pillola("$comprati comprati", const Color(0xFF34C759), const Color(0x1A34C759)),
            ]),
            const SizedBox(height: 16),
            // Lista oppure messaggio di lista vuota.
            // Expanded dà al figlio un'altezza limitata: una ListView dentro
            // una Column deve sapere quanto spazio può occupare.
            Expanded(
              child: _articoli.isEmpty
                  ? _vuota()
                  : ListView(
                      padding: const EdgeInsets.only(bottom: 24),
                      children: _articoli.map((a) => _card(a)).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
