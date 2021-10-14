part of '../pages.dart';

typedef IsDelete();

// ignore: must_be_immutable
class JobSummariesForm extends StatefulWidget {
   final String id;
  final Jobs? job;
  final state = _JobSummariesFormState();
  final IsDelete? isDelete;
  TextEditingController? kasus;
  TextEditingController? saran;
  TextEditingController? hargaJual;

  JobSummariesForm(this.id,
      {Key? key,
      this.job,
      this.isDelete,
      this.kasus,
      this.saran,
      this.hargaJual})
      : super(key: key);
  @override
  _JobSummariesFormState createState() => state;

  bool isValid() => state.validate();
}

class _JobSummariesFormState extends State<JobSummariesForm> {
  final form = GlobalKey<FormState>();
  UnitPrice? unitPrice;
  bool onUpload = false;
  List<ImageSourceX> imageBase64 = [];
  List<File> _image = [];
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getinitialImage();
  }

  getinitialImage() async {
    imageBase64.add(ImageSourceX(
        src: await networkImageToBase64(widget.job!.image?.first.src!),
        fullname: widget.job!.image?.first.fullname ?? ''));

    print(imageBase64);
    setState(() {});
    // widget.kasus!.text = widget.job!.kasus;

    // widget.saran!.text = widget.job!.saran;
    widget.kasus = TextEditingController(text: widget.job!.kasus);
    widget.saran = TextEditingController(text: widget.job!.saran);
    widget.hargaJual = TextEditingController(text: widget.job!.harga);

    print('============+=======');
    print(widget.job!.kasus);
  }

  getTextController() {
    widget.hargaJual!.text = widget.job!.harga;

    print(widget.saran!.text);
  }

  Future<String> networkImageToBase64(String? imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl!));
    final bytes = response.bodyBytes;
    return base64Encode(bytes);
  }

  Future getImage(ImageSource source) async {
    setState(() {
      onUpload = true;
    });
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      List<int> imageBytes = await pickedFile.readAsBytes();
      String baseimage = base64Encode(imageBytes);
      setState(() {
        _image.add(File(pickedFile.path));
        imageBase64.add(
          ImageSourceX()
            ..src = baseimage
            ..fullname = pickedFile.path.split("/").last,
        );
      });
    }

    setState(() {
      onUpload = false;
    });
  }

  removeImage(int index) {
    setState(() {
      //_image.removeAt(index);
      imageBase64.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Form(
        key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              labelText('Gambar'),
              IconButton(icon: Icon(Icons.delete), onPressed: widget.isDelete),
            ]),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 106,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (index < imageBase64.length) {
                      return Container(
                        width: 100,
                        height: 100,
                        child: Card(
                          elevation: 8.0,
                          child: Stack(
                            alignment: Alignment.center,
                            fit: StackFit.expand,
                            children: [
                              _image.length > 0
                                  ? Image.file(
                                      _image[index],
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      widget.job!.image!.first.src!),
                              IconButton(
                                onPressed: () => removeImage(index),
                                icon: Icon(
                                  Icons.close,
                                  color: mainColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }

                    return Container(
                      width: 100,
                      height: 100,
                      child: Card(
                        elevation: 8.0,
                        child: InkWell(
                          onTap: onUpload
                              ? null
                              : () async {
                                  //final imgSource = await imgSourceDialog();
                                  //if (imgSource != null) {
                                  await getImage(ImageSource.gallery);
                                  setState(() {
                                    widget.job!.image = imageBase64;
                                  });
                                  // }
                                },
                          child: Center(
                            child: onUpload
                                ? CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(mainColor),
                                  )
                                : Icon(Icons.add_a_photo),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: imageBase64.length + 1,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            labelText('Kasus'),
            TextFormField(
              minLines: 1,
              maxLines: 10,
              controller: widget.kasus,
              onSaved: (String? val) => widget.job!.kasus = val!,
              style: TextStyle(
                color: Color(0xFF43A8FC),
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(30, 16, 30, 16),
                hintStyle: TextStyle(color: Colors.grey),
                hintText: 'Kasus',
              ),
            ),
            labelText('Saran'),
            TextFormField(
              minLines: 1,
              maxLines: 10,
              controller: widget.saran,
              onSaved: (String? val) => widget.job!.saran = val!,
              style: TextStyle(
                color: Color(0xFF43A8FC),
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(30, 16, 30, 16),
                hintStyle: TextStyle(color: Colors.grey),
                hintText: 'Saran',
              ),
            ),
            labelText('Analisa Harga Satuan'),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35), color: Colors.white),
              child: ListTile(
                title: Text(
                  widget.job?.ahs ?? '-',
                  style: TextStyle(
                      color: (unitPrice == null) ? Colors.grey : Colors.black),
                ),
                onTap: () {
                  Get.to(() => UnitPicker())!.then((value) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (value != null && value is UnitPrice) {
                      unitPrice = value;
                      widget.job!.ahs = unitPrice!.text!;
                      widget.job!.idSummeries = unitPrice!.id!;
                      widget.job!.harga = unitPrice!.totalPrice!.toString();

                      setState(() {});
                    }
                  });
                },
              ),
            ),
            labelText('Harga Jual'),
            TextFormField(
              controller: widget.hargaJual,
              readOnly: true,
              style: TextStyle(
                color: Color(0xFF43A8FC),
              ),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(30, 16, 0, 16),
                  //hintStyle: TextStyle(color: Colors.grey),
                  hintText: widget.job?.harga == ""
                      ? 'Harga Jual'
                      : NumberFormat.currency(
                              locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                          .format(int.parse(widget.job!.harga))),
            ),
          ],
        ),
      ),
    );
  }

  imgSourceDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ambil Gambar Dari"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              IconButton(
                icon: Icon(Icons.photo),
                onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tutup"),
            )
          ],
        );
      },
    );
  }

  ///form validator
  bool validate() {
    var valid = form.currentState!.validate();
    if (valid) form.currentState!.save();
    return valid;
  }
}

class Jobs {
  String id;
  int? idSummeries;
  String kasus;
  String saran;
  String ahs;
  String harga;
  List<ImageSourceX>? image;

  Jobs(this.id,
      {
        this.idSummeries,
        this.kasus = '',
      this.saran = '',
      this.ahs = '',
      this.harga = '0',
      this.image});
}
