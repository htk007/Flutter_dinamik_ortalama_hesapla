import 'dart:math';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi;
  int dersKredi = 1;
  double dersHarfDegeri = 4;
  List<Ders> tumDersler;
  double ortalama = 0;
  static int sayac = 0;
  var formKey = GlobalKey<FormState>(); //erişmek istediğim formun state i
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,//klavye açıldığında oluşan overflow hatasını çözer
      appBar: AppBar(
        title: Text("Ortalma Hesapla"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return uygulamaGovdesi();
          } else {
            return uygulamaGovdesiLandscape();
          }
        },
      ),
    );
  }

  Widget uygulamaGovdesiLandscape() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  //  color: Colors.grey,
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: formKey,
                    autovalidate: true,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Ders Adı",
                            hintText: "Ders adı giriniz",
                            border: OutlineInputBorder(),
                          ),
                          validator: (girilenDeger) {
                            if (girilenDeger.length > 0) {
                              return null;
                            } else
                              return "Ders adı boş olamaz!";
                          },
                          onSaved: (kaydedilenDeger) {
                            dersAdi = kaydedilenDeger;
                            setState(() {
                              tumDersler.add(Ders(dersAdi, dersHarfDegeri,
                                  dersKredi, ratgeleRenkOlustur()));
                              ortalama = 0.0;
                              ortalamayiHesapla();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                    items: dersKredileriItems(),
                                    value: dersKredi,
                                    onChanged: (secilenKredi) {
                                      setState(() {
                                        dersKredi = secilenKredi;
                                      });
                                    }),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<double>(
                                  items: dersHarfDegerleriItems(),
                                  value: dersHarfDegeri,
                                  onChanged: (secilenHarf) {
                                    setState(() {
                                      dersHarfDegeri = secilenHarf;
                                    });
                                  },
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purple, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        border: BorderDirectional(
                          top: BorderSide(color: Colors.blue, width: 2),
                          bottom: BorderSide(color: Colors.blue, width: 2),
                        )),
                    child: Center(
                        child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: tumDersler.length == 0
                                ? "Lütfen ders ekle"
                                : "Ortalama: ",
                            style: TextStyle(fontSize: 30, color: Colors.black)),
                        TextSpan(
                            text: tumDersler.length == 0
                                ? ""
                                : "${ortalama.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))
                      ]),
                    )),
                  ),
                )
              ],
            ),
            flex: 1,
          ),
          Expanded(
              child: Container(
                //  color: Colors.blue,
                child: ListView.builder(
                    itemBuilder: _listeElemanlariniOlustur,
                    itemCount: tumDersler.length),
              ))
        ],
      ),
    );
  }

  Widget uygulamaGovdesi() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            //  color: Colors.grey,
            padding: EdgeInsets.all(10),
            child: Form(
              key: formKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Ders Adı",
                      hintText: "Ders adı giriniz",
                      border: OutlineInputBorder(),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.length > 0) {
                        return null;
                      } else
                        return "Ders adı boş olamaz!";
                    },
                    onSaved: (kaydedilenDeger) {
                      dersAdi = kaydedilenDeger;
                      setState(() {
                        tumDersler.add(Ders(dersAdi, dersHarfDegeri, dersKredi,
                            ratgeleRenkOlustur()));
                        ortalama = 0.0;
                        ortalamayiHesapla();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                              items: dersKredileriItems(),
                              value: dersKredi,
                              onChanged: (secilenKredi) {
                                setState(() {
                                  dersKredi = secilenKredi;
                                });
                              }),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            items: dersHarfDegerleriItems(),
                            value: dersHarfDegeri,
                            onChanged: (secilenHarf) {
                              setState(() {
                                dersHarfDegeri = secilenHarf;
                              });
                            },
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 70,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                border: BorderDirectional(
                  top: BorderSide(color: Colors.blue, width: 2),
                  bottom: BorderSide(color: Colors.blue, width: 2),
                )),
            child: Center(
                child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: tumDersler.length == 0
                        ? "Lütfen ders ekle"
                        : "Ortalama: ",
                    style: TextStyle(fontSize: 30, color: Colors.black)),
                TextSpan(
                    text: tumDersler.length == 0
                        ? ""
                        : "${ortalama.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))
              ]),
            )),
          ),
          Expanded(
              child: Container(
            //  color: Colors.blue,
            child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: tumDersler.length),
          )),
        ],
      ),
    );
  }

  dersKredileriItems() {
    List<DropdownMenuItem<int>> krediler = [];
    for (int i = 1; i <= 10; i++) {
      krediler.add(DropdownMenuItem<int>(value: i, child: Text("$i Kredi")));
    }
    return krediler;
  }

  dersHarfDegerleriItems() {
    List<DropdownMenuItem<double>> harfler = [];
    harfler.add(DropdownMenuItem(
      child: Text(
        " AA ",
        style: TextStyle(fontSize: 20),
      ),
      value: 4,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " BA ",
        style: TextStyle(fontSize: 20),
      ),
      value: 3.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " BB ",
        style: TextStyle(fontSize: 20),
      ),
      value: 3,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " CB ",
        style: TextStyle(fontSize: 20),
      ),
      value: 2.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " CC ",
        style: TextStyle(fontSize: 20),
      ),
      value: 2,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " DC ",
        style: TextStyle(fontSize: 20),
      ),
      value: 1.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " DD ",
        style: TextStyle(fontSize: 20),
      ),
      value: 1,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " FF ",
        style: TextStyle(fontSize: 20),
      ),
      value: 0,
    ));
    return harfler;
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    sayac++;

    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          tumDersler.removeAt(index);
          ortalamayiHesapla();
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: tumDersler[index].renk, width: 2),
            borderRadius: BorderRadius.circular(5)),
        margin: EdgeInsets.all(4),
        child: ListTile(
          leading: Icon(Icons.done, size: 36, color: tumDersler[index].renk),
          title: Text(tumDersler[index].ad),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: tumDersler[index].renk,
          ),
          subtitle: Text(tumDersler[index].kredi.toString() +
              " |" +
              tumDersler[index].harfDegeri.toString()),
        ),
      ),
    );
  }

  void ortalamayiHesapla() {
    double toplamNot = 0;
    double toplamKredi = 0;

    for (var oankiders in tumDersler) {
      var kredi = oankiders.kredi;
      var harfDegeri = oankiders.harfDegeri;
      toplamNot = toplamNot + (kredi * harfDegeri);
      toplamKredi += kredi;
    }
    ortalama = toplamNot / toplamKredi;
  }

  Color ratgeleRenkOlustur() {
    return Color.fromARGB(150 + Random().nextInt(105), Random().nextInt(255),
        Random().nextInt(255), Random().nextInt(255));
  }
}

class Ders {
  String ad;
  double harfDegeri;
  int kredi;
  Color renk;

  Ders(this.ad, this.harfDegeri, this.kredi, this.renk);
}
