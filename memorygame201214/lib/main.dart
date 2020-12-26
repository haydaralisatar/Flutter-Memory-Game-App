import 'package:flutter/material.dart';
import 'dart:async'; //Kütüphanemizi uygulamamıza dahil ettik.

void main() => runApp(MemoryGame()); //Programızı MemoryGame Widget'ından çalıştırdık.
String selectedTile = ""; //Üstüne tıkladığımız resmi almak için değişken tanımladık
int selectedIndex = 0; //Indexini almak için
bool selected = true; //Seçili olan resim var mı kontrol amaçlı
int points = 0; //Puan hesaplanması ve gösterilmesi için
int wrongChoicesCount = 5; //Yanlış seçim hakkını 5 olarak ayarladık.
List<TileModel> myPairs = new List<TileModel>(); //resimlerimizin listesini myPairs listesine attık.

class MemoryGame extends StatelessWidget { //Statik sınıf oldugu için StatelessWidget kullandık.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game', // başlığını girdik.
      debugShowCheckedModeBanner: false, //sağ üstte çıkan yazıyı kaldırdık.
      theme: ThemeData(  //tema
        primarySwatch: Colors.blue, //rengi mavi yaptık.
      ),
      home: Home(), //Home classına yönlendirdi.
    );
  }
}

class Home extends StatefulWidget { //Ekranda statik olmadığı için StateFulWidget kullandık.
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TileModel> gridViewTiles = new List<TileModel>();  // Gridview için liste oluşturduk.
  List<TileModel> questionPairs = new List<TileModel>(); //Çiftler için liste oluşturduk.
  @override
  void initState() {
    super.initState();
    restart();
  }

  void restart() { //Oyun bittiğinde yapılacak olan işlemler
    myPairs = getPairs(); //çiftleri myPairs listesine attık.
    myPairs.shuffle(); //Listeyi rastgele karıştırdık.
    gridViewTiles = myPairs; //Gridview e çiftleri attık.
    Future.delayed(const Duration(seconds: 2), () { //Açılışta 2 sn beklettik o
      setState(() {                                 //o sıra çiftler gözüktü
        questionPairs = getQuestionPairs();         //sonra soru işareti olarak
        gridViewTiles = questionPairs;              //değiştirdik.
        selected = false; //seçili birşey olmadığı için false değerini verdik.
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50), //Sayfayı simetrik olarak ayarladık.
          child: Column( //Kolon açtık.
            children: <Widget>[
              SizedBox( //yüksekliği 40 olan boş bir alan açtık.
                height: 40,
              ),
              if (points != (myPairs.length / 2) * 100 && wrongChoicesCount > 0) //Eğer puan "tam değil ise"
                //listedeki resimlerin yarısı(çift olduğu için) çarpı 100(her doğru 100 puan) ve Yanlış seçim hakkı
                //0 değilse
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Hak : " + wrongChoicesCount.toString(), // Ekranın üstünde hak sayısını yazdırdık.
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text( //Puanı da onun altına yazdırdık.
                      "Puan : " + (points).toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              else
                Container(),
              SizedBox( //Yüksekliği 20 olan boş bir alan açtık.
                height: 20,
              ),
              points != (myPairs.length / 2) * 100 && wrongChoicesCount > 0//Eğer puan "tam değil ise"
              //listedeki resimlerin yarısı(çift olduğu için) çarpı 100(her doğru 100 puan) ve Yanlış seçim hakkı
              //0 değilse
                  ? GridView( //Gridviewi oluşturduk
                      //daha düzenli olması için resimlerin boyutunu aynı oranda ayarladık.
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisSpacing: 0.0, maxCrossAxisExtent: 100.0),
                      //Yukarıda tanımladığımız listedeki resimleri listview e ekledik.
                      children: List.generate(gridViewTiles.length, (i) {
                        return Tile(
                          image: gridViewTiles[i].getImageAssetPath(), //resim
                          index: i, //kaçıncı index olduğu
                          parent: this,
                        );
                      }),
                    )
                  : Container( //değilse Container döndürdük.
                      child: Column( //Kolon açtık.
                        children: <Widget>[
                          SizedBox( //Yüksekliği 10 olan boş bir alan açtık.
                            height: 10,
                          ),
                          GestureDetector( //Hareketleri algılayan bir widget. Kısaca kapsadığı alanı dokunmaya duyarlı hale getirir.
                          onTap: () { //tıkladığında
                              setState(() {
                                points = 0; //puanı sıfırladı
                                wrongChoicesCount = 5; //hak sayısını sıfırladı
                                restart(); // ve restart fonskiyonu çalıştı.
                              });
                            },
                            child: Column(
                              children: <Widget>[
                                if (points >= 400) //Puan 400 den büyük ve eşitse
                                  Center( //sayfanın ortasına
                                      child: Column(
                                    children: <Widget>[
                                      Text( //Kazandın yazdırdı ve puanını gösterdi.
                                        "Kazandın!!! Puanın : " +
                                            points.toString(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox( //Yüksekliği 15 olan boş bir alan açtık
                                        height: 15,
                                      ),
                                      Image( //Kazandığı için mutlu emoji image ını koyduk.
                                          image:
                                              AssetImage('images/unnamed.jpg'))
                                    ],
                                  ))
                                else //değilse
                                  Center( //sayfanın ortasına
                                    child: Column(
                                      children: <Widget>[
                                        Text( //Kaybettin yazdı ve puanını gösterdi
                                          "Kaybettin. Puanın : " +
                                              points.toString(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox( //Yüksekliği 15 olan boş bir alan açtık
                                          height: 15,
                                        ),
                                        Image( //Kazandığı için üzgün emoji image ını koyduk.
                                            image: AssetImage(
                                                'images/download.jpg'))
                                      ],
                                    ),
                                  ),
                                SizedBox( //Yüksekliği 15 olan boş bir alan açtık
                                  height: 15,
                                ),
                                //Yeniden başlat butonunu tanımladık.
                                Container(
                                  height: 50,
                                  width: 200,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,//rengi mavi
                                      //yumuşak kenar
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Text(
                                    "Restart Game",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget { //Tile class ı
  String image; //Image yolu
  int index; //Indexi
  _HomeState parent;
  Tile({this.image, this.index, this.parent});
  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector( //Hareketleri algılayan bir widget. Kısaca kapsadığı alanı dokunmaya duyarlı hale getirir.
    onTap: () {
        if (!selected) { //eğer seçili değilse
          setState(() {
            myPairs[widget.index].setIsSelected(true); //mevcut index in seçili yaptı.
          });
          if (selectedTile != "") { //seçili Tile boş değilse
            if (selectedTile == myPairs[widget.index].getImageAssetPath()) {  //eğer iki tile de aynı ise
              points += 100; //puanına +100 ekledi.
              TileModel tileModel = new TileModel(); //Yeni bir tileModel açtık.
              selected = true; //seçildi değişkenini true yaptık.
              Future.delayed(const Duration(seconds: 2), () { //2sn bekledi.gösterdi sonra kapattı.
                tileModel.setImageAssetPath("");
                myPairs[widget.index] = tileModel;
                myPairs[selectedIndex] = tileModel;
                this.widget.parent.setState(() {});
                setState(() {
                  selected = false;
                });
                selectedTile = "";
              });
            } else { //yanlış seçim yaptıysa
              wrongChoicesCount -= 1; //hakkını 1 düşürdük
              points -= 50; //puanını 50 azalttık.
              selected = true; //değişkenimizi true yaptık
              Future.delayed(const Duration(seconds: 2), () { //seçili olanı 2 sn gösterdik.ve kapattık.
                this.widget.parent.setState(() {
                  myPairs[widget.index].setIsSelected(false);
                  myPairs[selectedIndex].setIsSelected(false);
                });
                setState(() {
                  selected = false;
                });
              });
              selectedTile = "";
            }
          } else {
            setState(() {
              selectedTile = myPairs[widget.index].getImageAssetPath();
              selectedIndex = widget.index;
            });
          }
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: myPairs[widget.index].getImageAssetPath() != ""
            ? Image.asset(myPairs[widget.index].getIsSelected()
                ? myPairs[widget.index].getImageAssetPath()
                : widget.image)
            : Container(
                color: Colors.white,
                child: Image.asset("images/correct.png"),
              ),
      ),
    );
  }
}

class TileModel { //TileModel classı
  String image; //image yolunu tuttuk.
  bool isSelected; //seçili olup olmadığını tuttuk.

  TileModel({this.image, this.isSelected});

  //getset işlemleri
  void setImageAssetPath(String getImageAssetPath) { //bu fonksiyona gönderdiğimiz seçili olan image yolunu gönderdik
    image = getImageAssetPath; //image değişkenini set yaptık.
  }

  String getImageAssetPath() {
    return image;
  }
//Get set işlemleri
  void setIsSelected(bool getIsSelected) {
    isSelected = getIsSelected;
  }

  bool getIsSelected() {
    return isSelected;
  }
}


List<TileModel> getQuestionPairs() { //program açıldığında veya restart edildiğindede çalışacak olan fonksiyon
  List<TileModel> pairs = new List<TileModel>(); //liste
  for (int i = 0; i < 8; i++) { //8 tane tilemodel oluşturduk
    TileModel tileModel = new TileModel();
    tileModel.setImageAssetPath("images/question.png"); //hepsini soru işareti olan image yaptık
    tileModel.setIsSelected(false); //başta soru işareti olarak gözükmesi için
    pairs.add(tileModel); //2 tane eklettik çift olduğu için
    pairs.add(tileModel);
  }
  return pairs; //listeyi geri döndürdük.
}

List<TileModel> getPairs() { ////program açıldığında veya restart edildiğindede çalışacak olan fonksiyon
  var questionUrl = [ //imageların ismini diziye attık. ve ...
    "fox",
    "hippo",
    "horse",
    "monkey",
    "panda",
    "parrot",
    "rabbit",
    "zoo"
  ];

  List<TileModel> pairs = new List<TileModel>(); //liste oluşturduk
  for (int i = 0; i < questionUrl.length; i++) { //dizinin uzunluğuna kadar gittik ve
    TileModel tileModel = new TileModel();
    tileModel.setImageAssetPath("images/" + questionUrl[i] + ".png"); //image yolunu dizi içindeki değerden aldık
    tileModel.setIsSelected(false);
    pairs.add(tileModel);
    pairs.add(tileModel); // ve 2 tane eklettik çift olduğu için.
  }

  return pairs; //geri dödürdük listeyi.
}
