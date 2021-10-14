part of '../pages.dart';

typedef OnDelete();

class AHSform extends StatefulWidget {
  final String id;
  final AHS? user;
  final state = _AHSformState();
  final OnDelete? onDelete;
  final TextEditingController? textEditingController;

  AHSform(this.id,
      {Key? key, this.user, this.onDelete, this.textEditingController})
      : super(key: key);
  @override
  _AHSformState createState() => state;

  bool isValid() => state.validate();
}

class _AHSformState extends State<AHSform> {
  final form = GlobalKey<FormState>();
  UnitPrice? unitPrice;
  // TextEditingController _volume = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTextVolume();
  }

  getTextVolume() {
    widget.textEditingController!.text = widget.user!.volume;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Form(
        key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              labelText('Analisa Harga Satuan'),
              SizedBox(width: Get.width * 0.1),
              labelText('Volume'),
            ]),
            Row(children: [
              //labelText('Volume'),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.white),
                  child: ListTile(
                    title: Text(
                        widget.user!.title == "" ? "Pilih" : widget.user!.title,
                        style: TextStyle(color: Colors.grey)),
                    onTap: () {
                      Get.to(() => UnitPicker())!.then((value) {
                        if (value != null && value is UnitPrice) {
                          unitPrice = value;
                          widget.user!.title = unitPrice!.text.toString();
                          setState(() {});
                        }
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: widget.textEditingController,
                  keyboardType: TextInputType.number,
                  onSaved: (String? val) => widget.user!.volume = val!,
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
                    hintText: 'Volume',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  widget.onDelete!();
                  // _volume.text = widget.user!.volume;
                },
              )
            ]),
          ],
        ),
      ),
    );
  }

  ///form validator
  bool validate() {
    var valid = form.currentState!.validate();
    if (valid) form.currentState!.save();
    return valid;
  }
}

class AHS {
  String id;
  String title;
  String volume;

  AHS(
    this.id, {
    this.title = '',
    this.volume = '',
  });
}
// part of '../pages.dart';

// typedef OnDelete();

// class AHSform extends StatefulWidget {
//   final AHS? user;
//   final state = _AHSformState();
//   final OnDelete? onDelete;
//   final UnitPrice? unitPrice;

//   AHSform({Key? key, this.user, this.onDelete, this.unitPrice}) : super(key: key);
//   @override
//   _AHSformState createState() => state;

//   bool isValid() => state.validate();
// }

// class _AHSformState extends State<AHSform> {
//   final form = GlobalKey<FormState>();
//   UnitPrice? unitPrice;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(2),
//       child: Form(
//         key: form,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(children: [
//               labelText('Analisa Harga Satuan'),
//               SizedBox(width: Get.width * 0.1),
//               labelText('Volume'),
//             ]),
//             Row(children: [
//               //labelText('Volume'),
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(35),
//                       color: Colors.white),
//                   child: ListTile(
//                     title: Text(
//                         (unitPrice == null) ? 'Pilih' : unitPrice!.text ?? '',
//                         style: TextStyle(color: Colors.grey)),
//                     onTap: () {
//                       Get.to(() => UnitPicker())!.then((value) {
//                         if (value != null && value is UnitPrice) {
//                           unitPrice = value;
//                           widget.user!.title = unitPrice!.id.toString();
//                           setState(() {});
//                         }
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: TextFormField(
//                   keyboardType: TextInputType.number,
//                   initialValue: widget.user!.volume,
//                   onSaved: (String? val) => widget.user!.volume = val!,
//                   style: TextStyle(
//                     color: Color(0xFF43A8FC),
//                   ),
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(35),
//                       borderSide: BorderSide.none,
//                     ),
//                     fillColor: Colors.white,
//                     filled: true,
//                     contentPadding: EdgeInsets.fromLTRB(30, 16, 30, 16),
//                     hintStyle: TextStyle(color: Colors.grey),
//                     hintText: 'Volume',
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.delete),
//                 onPressed: widget.onDelete,
//               )
//             ]),
//           ],
//         ),
//       ),
//     );
//   }

//   ///form validator
//   bool validate() {
//     var valid = form.currentState!.validate();
//     if (valid) form.currentState!.save();
//     return valid;
//   }
// }

// class AHS {
//   String title;
//   String volume;

//   AHS({this.title = '', this.volume = ''});
// }
