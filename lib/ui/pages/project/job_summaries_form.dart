part of '../pages.dart';

typedef IsDelete();

class JobSummariesForm extends StatefulWidget {
  final Jobs? job;
  final state = _JobSummariesFormState();
  final IsDelete? isDelete;

  JobSummariesForm({Key? key, this.job, this.isDelete}) : super(key: key);
  @override
  _JobSummariesFormState createState() => state;

  bool isValid() => state.validate();
}

class _JobSummariesFormState extends State<JobSummariesForm> {
  final form = GlobalKey<FormState>();
  UnitPrice? unitPrice;
  bool onUpload = false;
  List<ImageX> imageBase64 = [];
  List<File> _image = [];
  final picker = ImagePicker();

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
          ImageX()
            ..image = baseimage
            ..name = pickedFile.path.split("/").last,
        );
      });
    }

    setState(() {
      onUpload = false;
    });
  }

  removeImage(int index) {
    setState(() {
      _image.removeAt(index);
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
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: widget.isDelete,
              ),
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
                              Image.file(
                                _image[index],
                                fit: BoxFit.cover,
                              ),
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
                                  final imgSource = await imgSourceDialog();
                                  if (imgSource != null) {
                                    await getImage(imgSource);
                                    setState(() {
                                      widget.job!.image = imageBase64;
                                    });
                                  }
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
              initialValue: widget.job!.kasus,
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
              initialValue: widget.job!.saran,
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
                  (unitPrice == null) ? 'Pilih' : unitPrice!.text ?? '',
                  style: TextStyle(
                      color: (unitPrice == null) ? Colors.grey : Colors.black),
                ),
                onTap: () {
                  Get.to(() => UnitPicker())!.then((value) {
                    if (value != null && value is UnitPrice) {
                      unitPrice = value;
                      widget.job!.ahs = unitPrice!.id.toString();

                      setState(() {});
                    }
                  });
                },
              ),
            ),
            labelText('Harga Jual'),
            TextFormField(
              //controller: budgetCT,
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
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: unitPrice == null || unitPrice!.totalPrice == null
                      ? 'Harga Jual'
                      : NumberFormat.currency(
                              locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                          .format(unitPrice!.totalPrice)),
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
  String kasus;
  String saran;
  String ahs;
  String harga;
  List<ImageX>? image;

  Jobs(
      {this.kasus = '',
      this.saran = '',
      this.ahs = '',
      this.harga = '0',
      this.image});
}