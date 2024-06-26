import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zip_codes/models/zip_code.dart';

class ZipCodes extends StatefulWidget {
  const ZipCodes({super.key});

  @override
  State<ZipCodes> createState() => _ZipCodesState();
}

class _ZipCodesState extends State<ZipCodes> {
  TextEditingController controller = TextEditingController();
  ZipCode? results;
  String? error;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ZipCodes"),
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: controller,
                  style: const TextStyle(fontSize: 48),
                  decoration: const InputDecoration(
                    label: Text("Introduce un código postal"),
                    hintText: "Son 5 números",
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: fetchData,
                child: const Text("Busca"),
              ),
              const SizedBox(height: 24),
              if (error != null)
                Text(
                  error!,
                  style: const TextStyle(color: Colors.red),
                ),
              const Text(
                "Resultados",
                style: TextStyle(fontSize: 24),
              ),
              if (results != null)
                for (var place in results!.places)
                  Column(
                    children: [
                      Text(place.placeName),
                      Text(place.state),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.place),
                          Text("(${place.longitude},${place.latitude})"),
                        ],
                      ),
                      const SizedBox(height: 24)
                    ],
                  ),
              if (loading) const CircularProgressIndicator(),
            ],
          ),
        ));
  }

  Future<void> fetchData() async {
    loading = true;
    results = null;
    setState(() {});
    try {
      var zipData = controller.text;
      var data =
          await http.get(Uri.parse("https://api.zippopotam.us/es/$zipData"));
      results = zipCodeFromJson(data.body);
      error = null;
      setState(() {});
    } on Error catch (e) {
      error = "Error leyendo datos";
      setState(() {});
    }
    loading = false;
    setState(() {});
  }
}
