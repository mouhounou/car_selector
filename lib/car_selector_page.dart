import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class CarSelectorPage extends StatefulWidget{

  const CarSelectorPage ({super.key});

  @override
  State<CarSelectorPage> createState() {
    return _CarSelectorPage();
  }
}


class _CarSelectorPage extends State<CarSelectorPage>{
  String _result ="";
  String _firstname = "";
  double _kms = 0;
  bool _electric = true;
  List <int> _places = [2, 4, 5 ,7 ];
  int _placesSelected = 2;
  String? _image;


  final Map<String, bool> _options = {
    "GPS": false,
    "Caméra de recul": false,
    "Clim par zone": false,
    "Régulateur de vitesse": false,
    "Toit ouvrant": false,
    'Siège chauffant': false,
    "Roue de secours": false,
    "Jantes alu": false
  };

  final List<Car> _cars= [
    Car(name: "MG cyberster", url: "MG", places: 2, isElectric: true),
    Car(name: "R5 électrique", url: "R5", places: 4, isElectric: true),
    Car(name: "Tesla", url: "tesla", places: 5, isElectric: true),
    Car(name: "Van VW", url: "Van", places: 7, isElectric: true),
    Car(name: "Alpine", url: "Alpine", places: 2, isElectric: false),
    Car(name: "Fiat 500", url: "Fiat 500", places: 4, isElectric: false),
    Car(name: "Peugeot 3008", url: "P3008", places: 5, isElectric: false),
    Car(name: "Dacia Jogger", url: "Jogger", places: 7, isElectric: false),
  ];
  Car? _carSelected;

  Padding _interactiveWidget({required List<Widget> children, bool isRow = false}){
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          (isRow)?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: children,
              ): Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
           Divider()
        ],
      ),
    );
  }

  void updateFirstName(String newValue){
    setState(() {
      _firstname = newValue;
    });
  }

  void _updateKms(double newValue){
    setState(() {
      _kms = newValue;
    });
  }

void _updateEngine (bool newValue){
    setState(() {
      _electric = newValue;
    });
}



void _updatePlaces (int? newValue){
    _placesSelected = newValue?? 2;
}

void _updateOptions (bool? newBool, String key){
    setState(() {
      _options[key] = newBool ?? false;
    });
}

void _handeleResult(){
  setState(() {
    _result = isGoodChoice();
    _carSelected = _cars.firstWhere((car) => car.isElectric == _electric && car.places == _placesSelected);
  });
}

String isGoodChoice (){
    if (_kms > 15000 && _electric){
      return  "Vous devriez pensez a un moteur thermique";
    } else if( _kms < 15000 && !_electric){
      return "Vous faites peu de kilmetre, pensez a regarder les voitures electric";
    } else{
      return "Voici la voiture faites pour vous ";
    }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurateur de voiture"),
        actions: [
          ElevatedButton(
              onPressed: _handeleResult ,
              child: const Text('Valider')
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
                "Bienvenu : $_firstname",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.blue
              ),
            ),

            Card(
              margin: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(_result),
                    (_carSelected == null)
                    ? const  SizedBox(height: 0)
                        :
                        Image.asset(_carSelected!.urlString! , fit: BoxFit.contain,),
                    Text(_carSelected?.name ?? "nom de la voiture")
                  ],
                ),
              ),
            ),

            _interactiveWidget(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border:  InputBorder.none,
                      hintText: "Entrez votre nom"
                    ),
                    onSubmitted: updateFirstName,
                  )
                ]
            ),
            _interactiveWidget(
                children: [
                  Text('Nombre de kilometre annuel : ${_kms.toInt()}'),
                  Slider(
                      value: _kms,
                      min: 0,
                      max: 25000,
                      onChanged: _updateKms
                  )
                ]
            ),

            _interactiveWidget(
              isRow: true,
                children: [
                  Text(_electric? "Moteur thermique" : "moteurthermique"),
                  Switch(
                      value: _electric,
                      onChanged: _updateEngine
                  )
                ]
            ),

            _interactiveWidget(
                children: [
                  Text('Nombre de placesm : $_placesSelected'),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:_places.map((place){
                      return Column (
                        children: [
                          Radio(
                              value: place,
                              groupValue: _placesSelected,
                              onChanged: _updatePlaces)
                        ],
                      );
                    }).toList(),
                  )
                ]
            ),

            _interactiveWidget(
                children: [
                  const Text('Options du vehicules'),
                  Column(
                    children: _options.keys.map((key){
                      return CheckboxListTile(
                        title: Text(key),
                          value: _options[key],
                          onChanged: ((b) => _updateOptions(b, key))
                      );
                    }).toList()
                  )
                ],
            )
          ],
        ),
      ),
    );
  }
}

class Car {
  String name;
  String url;
  int places;
  bool isElectric;

  Car({required this.name, required this.url, required this.places, required this.isElectric});

  String get urlString => "assets/images/$url.jpg";
}

//La logique de choix de voiture:
// _carSelected = _cars.firstWhere((car) => car.isElectric == _electric && car.places == _placesSelected);