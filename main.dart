import 'package:flutter/material.dart';

void main() => runApp(const TripMateApp());

const dark = Color(0xFF142033);
const purple = Color(0xFF7C6CF2);
const paper = Color(0xFFF6F7FB);
const grey = Color(0xFF8994A7);

class TripMateApp extends StatelessWidget {
  const TripMateApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'TripMate', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(seedColor: purple)),
    home: const TravelHome(),
  );
}
class TripPlan {
  TripPlan(this.city, this.days, this.budget, this.vibe, this.emoji);
  final String city, vibe, emoji;
  final int days, budget;
}
class TravelHome extends StatefulWidget {
  const TravelHome({super.key});
  @override
  State<TravelHome> createState() => _TravelHomeState();
}
class _TravelHomeState extends State<TravelHome> {
  final cityController = TextEditingController();
  final budgetController = TextEditingController(text: '25000');
  int days = 3;
  String vibe = 'Culture';
  final trips = <TripPlan>[
    TripPlan('Jaipur', 3, 18000, 'Culture', '🏰'),
    TripPlan('Munnar', 2, 12000, 'Nature', '🌿'),
    TripPlan('Goa', 4, 25000, 'Beach', '🌊'),
  ];
  Future<void> createTrip() async {
    cityController.clear(); budgetController.text = '25000';
    int localDays = days; String localVibe = vibe;
    final key = GlobalKey<FormState>();
    final result = await showDialog<TripPlan>(context: context, builder: (ctx) =>
      StatefulBuilder(builder: (ctx, setDialog) => AlertDialog(
        title: const Text('Plan a getaway'),
        content: Form(key: key, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(controller: cityController, decoration: const InputDecoration(labelText: 'Destination city'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Enter a destination' : null),
          const SizedBox(height: 10),
          TextFormField(controller: budgetController, keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Budget (₹)'),
            validator: (v) { final n = int.tryParse(v ?? ''); return n == null || n <= 0 ? 'Enter a valid budget' : null; }),
          const SizedBox(height: 14), Align(alignment: Alignment.centerLeft, child: Text('Trip length: $localDays days')),
          Slider(value: localDays.toDouble(), min: 1, max: 14, divisions: 13,
            label: '$localDays days', onChanged: (v) => setDialog(() => localDays = v.round())),
          DropdownButtonFormField<String>(value: localVibe, decoration: const InputDecoration(labelText: 'Travel style'),
            items: const ['Culture','Nature','Beach','Food','Adventure'].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
            onChanged: (v) { if (v != null) setDialog(() => localVibe = v); }),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () { if (!key.currentState!.validate()) return;
            Navigator.pop(ctx, TripPlan(cityController.text.trim(), localDays,
              int.parse(budgetController.text.trim()), localVibe, '✈️')); }, child: const Text('Create trip')),
        ],
      )));
    if (result != null && mounted) setState(() { trips.insert(0, result); days = result.days; vibe = result.vibe; });
  }
  @override
  void dispose() { cityController.dispose(); budgetController.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: paper, title: const Row(children: [
      Icon(Icons.explore_rounded, color: purple, size: 29), SizedBox(width: 8),
      Text('tripmate', style: TextStyle(color: dark, fontWeight: FontWeight.w900, letterSpacing: -.6)),
    ]), actions: [IconButton(onPressed: createTrip, icon: const Icon(Icons.add_circle_outline, color: dark)), const SizedBox(width: 8)]),
    floatingActionButton: FloatingActionButton.extended(onPressed: createTrip, backgroundColor: purple, foregroundColor: Colors.white,
      icon: const Icon(Icons.add_rounded), label: const Text('Plan a trip')),
    body: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(18, 8, 18, 100), children: [
      Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6556D9), Color(0xFF9A7AF6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(26)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('YOUR NEXT STORY STARTS HERE', style: TextStyle(color: Color(0xFFE9E4FF), letterSpacing: 1.5, fontSize: 10, fontWeight: FontWeight.w800)),
          const SizedBox(height: 11), const Text('Collect moments,\\nnot just miles.', style: TextStyle(color: Colors.white, fontSize: 29, fontWeight: FontWeight.w900, height: 1.15)),
          const SizedBox(height: 10), const Text('Save your ideas and shape a trip around your budget.', style: TextStyle(color: Colors.white70, height: 1.4)),
          const SizedBox(height: 18), FilledButton.icon(onPressed: createTrip,
            style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: purple),
            icon: const Icon(Icons.auto_awesome_rounded, size: 17), label: const Text('Build my itinerary')),
        ])),
      const SizedBox(height: 22),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Your saved trips', style: TextStyle(color: dark, fontSize: 20, fontWeight: FontWeight.w900)),
        Text('${trips.length} trips', style: const TextStyle(color: grey, fontSize: 12)),
      ]),
      const SizedBox(height: 13),
      ...trips.map((trip) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE9ECF4))),
        child: Row(children: [
          Container(width: 62, height: 70, decoration: BoxDecoration(
            gradient: LinearGradient(colors: [const Color(0xFFEDE9FF), const Color(0xFFF7F4FF)]),
            borderRadius: BorderRadius.circular(15)), child: Center(child: Text(trip.emoji, style: const TextStyle(fontSize: 28)))),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(trip.city, style: const TextStyle(color: dark, fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 5), Text('${trip.days} days · ${trip.vibe}', style: const TextStyle(color: grey, fontSize: 11)),
            const SizedBox(height: 9), Row(children: [
              const Icon(Icons.account_balance_wallet_outlined, size: 14, color: purple), const SizedBox(width: 4),
              Text('₹${trip.budget.toString()}', style: const TextStyle(color: dark, fontSize: 12, fontWeight: FontWeight.w800)),
              const Spacer(), const Icon(Icons.arrow_outward_rounded, size: 16, color: purple),
            ]),
          ])),
        ]))),
      const SizedBox(height: 8),
      const Text('Sample trip ideas · This demo does not fetch live travel prices.', textAlign: TextAlign.center, style: TextStyle(color: grey, fontSize: 10)),
    ])),
  );
}

