part of '../pages.dart';

class DetailReportPage extends StatelessWidget {
  final Datum data;
  final Type type;
  const DetailReportPage(this.data, this.type, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = (type == Type.report) ? 'laporan' : 'jadwal';

    return Scaffold(
      appBar: AppBar(title: Text('Detail $title survey')),
      body: (type == Type.report)
          ? ListView(
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: [
                detailCard('Referensi Jadwal', text: data.subjekJadwal),
                labelText('Pesanan'),
                Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
                      children: data.order!
                          .map((e) => Text('${e.title}, '))
                          .toList()),
                ),
                labelText('Jenis Pekerjaan'),
                Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
                      children: data.workType!
                          .map((e) => Text('${e.name}, '))
                          .toList()),
                ),
                labelText('Material/Chemical yang digunakan'),
                Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
                      children: data.materials!
                          .map((e) => Text('${e.name}, '))
                          .toList()),
                ),
                labelText('Akses Lokasi'),
                Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
                      children: data.locatioanAccesses!
                          .map((e) => Text('${e.name}, '))
                          .toList()),
                ),
                labelText('Akses Jalan'),
                Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
                      children: data.accessRoad!
                          .map((e) => Text('${e.name}, '))
                          .toList()),
                ),
                labelText('Contur Tanah'),
                Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
                      children: data.landContours!
                          .map((e) => Text('${e.name}, '))
                          .toList()),
                ),
                labelText('Keadaan Tapak'),
                Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
                      children:
                          data.foot!.map((e) => Text('${e.name}, ')).toList()),
                ),
                detailCard('Luas Tanah Permintaan', text: data.landArea),
                detailCard('Luas Bangunan Permintaan', text: data.buildingArea),
                detailCard('Luas Tanah Yang Sudah Ada',
                    text: data.existingLandArea),
                detailCard('Luas Bangunan Yang Sudah Ada',
                    text: data.existingBuildingArea),
                detailCard(
                  'Budget',
                  text:
                      NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(
                    int.parse((data.budget == "")
                        ? "0"
                        : data.budget!.replaceAll(".", "")),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Center(child: labelText('Volume Pekerjaan')),
                ),
                Container(
                  child: Column(
                      children: data.uPrice!.map((e) => cardAHS(e)).toList()),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Center(child: labelText('Daftar Ringkasan Pekerjaan')),
                ),
                Container(
                  child: Column(
                      children: data.jobs!.map((e) => cardJob(e)).toList()),
                ),
                detailCard('Catatan', text: data.note),
              ],
            )
          : ListView(padding: EdgeInsets.symmetric(horizontal: 12), children: [
              detailCard('Subjek Jadwal', text: data.subjekJadwal),
              labelText('Pesanan'),
              Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Row(
                    children:
                        data.order!.map((e) => Text('${e.title}, ')).toList()),
              ),
              detailCard('Tanggal Mulai', text: data.dateStart),
              detailCard('Tanggal Selesai', text: data.dateEnd),
              detailCard('Deskripsi', text: data.deskripsi),
            ]),
    );
  }
}

Widget detailCard(String title, {String? text}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    labelText(title),
    TextField(
      readOnly: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(30, 16, 0, 16),
          hintStyle: TextStyle(color: Colors.black),
          hintText: text),
    ),
  ]);
}

Widget cardAHS(Uprice price) {
  return Row(children: [
    Expanded(
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Text('${price.name}'),
      ),
    ),
    Expanded(
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Text(
            NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                .format(price.totalPrice)),
      ),
    ),
  ]);
}

Widget cardJob(JobsX job) {
  print("(===============================);");
  print(job.image!.map((e) => '${e.src}').toList());
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    labelText('Gambar'),
    Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 12),
        scrollDirection: Axis.horizontal,
        child: Row(
            children: job.image!
                .map((e) => Container(
                      width: 200,
                      height: 200,
                      child: Card(
                        elevation: 8.0,
                        child: Image.network(
                          '${e.src}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ))
                .toList()),
      ),
    ),
    detailCard('Kasus', text: '${job.cases}'),
    detailCard('Saran', text: '${job.suggestion}'),
    detailCard('AHS', text: '${job.name}'),
    detailCard('Harga Jual',
        text:
            NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                .format(job.totalPrice ?? 0)),
  ]);
}
