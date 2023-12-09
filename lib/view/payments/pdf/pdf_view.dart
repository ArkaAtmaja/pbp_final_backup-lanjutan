import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:news_c_kelompok4/view/payments/pdf/invoice/get_total_invoice.dart';
import 'package:news_c_kelompok4/view/payments/pdf/invoice/model/custom_row_invoice.dart';
import 'package:news_c_kelompok4/view/payments/pdf/invoice/model/product.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:news_c_kelompok4/view/payments/pdf/preview_screen.dart';
import 'package:news_c_kelompok4/view/payments/pdf/invoice/item_doc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PDFView extends StatefulWidget {
  @override
  _PDFViewState createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  final formKey = GlobalKey<FormState>();
  late String username = "";
  late String email = "";
  late String id = const Uuid().v1();

  late List<Product> products = [
    Product("Membership", 10000),
  ];

  int number = 0;
  getTotal() => products
      .fold(0.0,
          (double prev, element) => prev + (element.price * element.amount))
      .toStringAsFixed(2);

  getPPN() => products
      .fold(
          0.0,
          (double prev, element) =>
              prev +
              (element.price / 100 * element.ppnInPercent * element.amount))
      .toStringAsFixed(2);

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await createPdf(id, context, products);
          },
          child: Text('Create PDF'),
        ),
      ),
    );
  }
}

Future<void> createPdf(
    String id, BuildContext context, List<Product> soldProducts) async {
  final doc = pw.Document();
  final now = DateTime.now();
  final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

  final imageLogo =
      (await rootBundle.load("lib/images/logo.png")).buffer.asUint8List();
  final imageInvoice = pw.MemoryImage(imageLogo);

  //Memberi border pada dokumen pdf
  final pdfTheme = pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    buildBackground: (pw.Context context) {
      return pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: PdfColor.fromHex('#ffffff'),
            width: 1.w,
          ),
        ),
      );
    },
  );

  //peletakan urutan hasil isi atau value baris invoicenya sesuai yang telah diinputkan
  // menggunakan list
  //bentuk widgetnya diatur pada file item_doc.dart
  final List<CustomRow> elements = [
    CustomRow("INFO PRODUK", "HARGA SATUAN", "JUMLAH", "TOTAL"),
    for (var product in soldProducts)
      CustomRow(product.name, product.price.toStringAsFixed(2), "1 Month",
          "Rp. 10.000.00"),
    CustomRow(
      "PPN Total(10%)",
      "",
      "",
      "Rp 1000.00", //Memanggil fungsi yang ada pada file
      // get_total_invoice.dart
    ),
    CustomRow(
      "Total",
      "",
      "",
      "Rp 11.000.00", //Memanggil fungsi yang ada pada file
      // get_total_invoice.dart
    )
  ];
  pw.Widget table = itemColumn(elements);

  //Pengaturan tampilan dokumen PDFnya
  //Di sini meggunakan Multi Page agar dapat menampilkan lebih dari 1 halaman
  //kemudian menggunakan header untuk header dokumen PDF, build untuk isi dokumen PDFnya,
  //dan footer untuk footer dokumen PDF

  doc.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
        buildBackground: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColor.fromHex('#ffffff'),
                width: 16,
              ),
            ),
          );
        },
      ),
      header: (pw.Context context) {
        return headerPDF();
      },
      build: (pw.Context context) {
        return [
          pw.Center(
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                pw.Container(
                    margin: pw.EdgeInsets.symmetric(
                  horizontal: 2.h,
                  vertical: 2.h,
                )),
                //Bagian menampilkan gambar yang telah diinput

                //Bagian halaman PDF yang menampilkan data personal berupa sebuah
                // tabel yang sudah diinputkan pada halaman input
                //white space untuk jeda

                // Bagian PDF yang mmenampilkan invoice
                topLogo(imageInvoice),
                topOfInvoice(formattedDate),

                contentOfInvoice(table),

                //barcode di dalam dokumen PDF

                pw.SizedBox(height: 16.h),
              ])),
        ];
      },
      footer: (pw.Context context) {
        return footerPDF(formattedDate);
      },
    ),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PreviewScreen(doc: doc),
    ),
  );
}

pw.Header headerPDF() {
  return pw.Header(
    margin: pw.EdgeInsets.zero,
    outlineColor: PdfColors.amber50,
    outlineStyle: PdfOutlineStyle.normal,
    level: 5,
    decoration: pw.BoxDecoration(
      shape: pw.BoxShape.rectangle,
      gradient: pw.LinearGradient(
        colors: [
          PdfColor.fromHex('#FCDF8A'),
          PdfColor.fromHex('#F38381'),
        ],
        begin: pw.Alignment.topLeft,
        end: pw.Alignment.bottomRight,
      ),
    ),
    child: pw.Center(
      child: pw.Text(
        'PBP NEWS Invoice',
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 12.sp,
        ),
      ),
    ),
  );
}

pw.Padding topLogo(pw.MemoryImage imageInvoice) {
  return pw.Padding(
    padding: pw.EdgeInsets.only(top: 0, bottom: 10),
    child: pw.Row(
      children: [
        pw.Image(imageInvoice,
            height: 150, width: 150, alignment: pw.Alignment.centerLeft),
      ],
    ),
  );
}

pw.Padding topOfInvoice(String formattedDate) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8.0),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          child: pw.Container(
            height: 80, // Set a specific height value
            decoration: const pw.BoxDecoration(
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                color: PdfColors.white),
            padding: const pw.EdgeInsets.only(
                left: 10, top: 10, bottom: 10, right: 0),
            alignment: pw.Alignment.centerLeft,
            child: pw.DefaultTextStyle(
              style: const pw.TextStyle(color: PdfColors.white, fontSize: 12),
              child: pw.GridView(
                crossAxisCount: 2,
                children: [
                  // Kolom 1 (rata kiri)
                  pw.Align(
                    alignment: pw.Alignment.topLeft,
                    child: pw.Text(
                      'PRO-ACCOUNT',
                      style: pw.TextStyle(
                        fontSize: 15.sp,
                        color: PdfColors.black,
                      ),
                    ),
                  ),
                  // Spasi antar baris
                  pw.SizedBox(height: 20), // Set a specific height value
                ],
              ),
            ),
          ),
        ),
        // Kolom 2 (rata kanan)
        pw.Expanded(
          child: pw.Container(
            height: 80, // Set a specific height value
            decoration: const pw.BoxDecoration(
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                color: PdfColors.white),
            padding: const pw.EdgeInsets.only(
                left: 15, top: 10, bottom: 10, right: 15),
            alignment: pw.Alignment.centerRight,
            child: pw.DefaultTextStyle(
              style: const pw.TextStyle(color: PdfColors.white, fontSize: 12),
              child: pw.GridView(
                crossAxisCount: 1,
                mainAxisSpacing: 10, // Spasi antar kolom
                crossAxisSpacing: 8, // Spasi antar baris
                children: [
                  // Teks Pembeli
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.RichText(
                      text: pw.TextSpan(
                        text: 'Pembeli',
                        style: pw.TextStyle(
                          fontSize: 10.sp,
                          color: PdfColors.black,
                        ),
                        children: [
                          pw.WidgetSpan(
                            child: pw.SizedBox(
                                width: 58
                                  ..w), // Tambahkan spasi sebanyak 4 unit sebelum ":"
                          ),
                          pw.TextSpan(
                            text: ': Charlie Palangan',
                            style: pw.TextStyle(
                              fontSize: 10.sp,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.RichText(
                      text: pw.TextSpan(
                        text: 'Tanggal Pembelian: $formattedDate',
                        style: pw.TextStyle(
                          fontSize: 10.sp,
                          color: PdfColors.black,
                        ),
                        children: [
                          pw.WidgetSpan(
                            child: pw.SizedBox(
                                width:
                                    30), // Tambahkan spasi sebanyak 4 unit sebelum ":"
                          ),
                          pw.TextSpan(
                            text: ': 1 Agustus 2023',
                            style: pw.TextStyle(
                              fontSize: 10.sp,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.RichText(
                      text: pw.TextSpan(
                        text: 'Metode Pembayaran',
                        style: pw.TextStyle(
                          fontSize: 10.sp,
                          color: PdfColors.black,
                        ),
                        children: [
                          pw.WidgetSpan(
                            child: pw.SizedBox(
                                width:
                                    25), // Tambahkan spasi sebanyak 4 unit sebelum ":"
                          ),
                          pw.TextSpan(
                            text: ': GOPAY',
                            style: pw.TextStyle(
                              fontSize: 10.sp,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.WidgetSpan(
                            child: pw.SizedBox(
                                width: 25
                                    .w), // Tambahkan spasi sebanyak 4 unit sebelum ":"
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

pw.Padding contentOfInvoice(pw.Widget table) {
  return pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
      child: pw.Column(children: [
        pw.Text(
            "Dear Customer, thank you for buying our product, we hope the product can make your day."),
        pw.SizedBox(height: 20.h), // Set a specific height value
        /// buatkanlah tabel yang berisi 4 kolom dan dua baris
        table,
        pw.Text("Thanks for your trust, and till the next time."),
        pw.SizedBox(height: 20.h), // Set a specific height value
        pw.Text("Kind regards,"),
        pw.SizedBox(height: 20.h), // Set a specific height value
        pw.Text("PBP NEWS"),
      ]));
}

pw.Center footerPDF(String formattedDate) {
  return pw.Center(
    child: pw.Text(
      'Created At $formattedDate',
      style: pw.TextStyle(fontSize: 10.sp, color: PdfColors.blue),
    ),
  );
}
