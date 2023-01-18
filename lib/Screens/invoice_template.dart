// import 'package:pdf/pdf.dart';
// import 'package:flutter/material.dart';
// import 'package:highrich/model/invoice_customer.dart';
// import 'package:highrich/model/invoice_seller.dart';
// import 'package:highrich/model/invoice_company.dart';
// import 'package:highrich/model/invoice_company_contact.dart';
// import 'package:highrich/model/invoice.dart';
// import 'package:highrich/APICredentials/pdf_api.dart';
// import 'package:highrich/APICredentials/pdf_invoice_api.dart';
// import 'package:highrich/model/MyOrders/orders_model.dart';

// class ButtonWidget extends StatelessWidget {
//   final String text;
//   final VoidCallback onClicked;

//   const ButtonWidget({
//     // Key? key,
//     this.text,
//     this.onClicked,
//   }) 
//   // : super(key: key)
//   ;

//   @override
//   Widget build(BuildContext context) => ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           minimumSize: Size.fromHeight(40),
//         ),
//         child: FittedBox(
//           child: Text(
//             text,
//             style: TextStyle(fontSize: 20, color: Colors.white),
//           ),
//         ),
//         onPressed: onClicked,
//       );
// }

// //title widget
// class TitleWidget extends StatelessWidget {
//   final IconData icon;
//   final String text;

//   const TitleWidget({
//     // Key? key,
//     this.icon,
//     this.text,
//   }) 
//   // : super(key: key)
//   ;

//   @override
//   Widget build(BuildContext context) => Column(
//         children: [
//           Icon(icon, size: 100, color: Colors.white),
//           const SizedBox(height: 16),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 42,
//               fontWeight: FontWeight.w400,
//               color: Colors.white,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       );
// }
// //invoice template
// class PdfPage extends StatefulWidget {
//   @override
//   _PdfPageState createState() => _PdfPageState();
// }

// class _PdfPageState extends State<PdfPage> {
//   List<Orders> ordersList = new List();
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           title: Text(" HR Invoice"),
//           centerTitle: true,
//         ),
//         body: Container(
//           padding: EdgeInsets.all(32),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 TitleWidget(
//                   icon: Icons.picture_as_pdf,
//                   text: 'Generate Invoice',
//                 ),
//                 const SizedBox(height: 88),
//                 ButtonWidget(
//                   text: 'Invoice PDF',
//                   onClicked: () async {
//                     final date = DateTime.now();
//                     final dueDate = date.add(Duration(days: 7));

//                     final invoice = Invoice(
//                       companycontact: Companycontact(
//                                                             title: 'Conatact',
//                                                             gstin: '32AAFCH0823E1Z8',
//                                                             phone: '+91 9744338134',
//                                                             mail: 'info@highrich.in',
//                                                           ),
//                       company: Company(
//                         title: 'Address',
//                         name: 'Highrich Online Shoppe Pvt. Ltd.',
//                         firstaddr: '2nd Floor, Kanimangalam Tower',
//                         secondaddr: 'Valiyalukkal,Thrissur',
//                       ),
//                       supplier: Seller(
//                         title: 'Billed From',
//                         name: 'Nadathara-680751',
//                         address: 'Nadathara-680751,Urakam,Thrissur',
//                         gstin: 'GSTIN : 3ZAbi484sd545fsd4f',
//                         paymentInfo: 'https://paypal.me/sarahfieldzz',
//                       ),
//                       customer: Customer(
//                         title:'Billed To',
//                         name: 'testuser-01',
//                         address: 'Test Street, TEstttt, 680122',
//                       ),
//                       info: InvoiceInfo(
//                         date: date,
//                         // dueDate: dueDate,
//                         description: 'My description...',
//                         number: '${DateTime.now().year}-9999',
//                       ),
//                       items: [
//                         InvoiceItem(
//                           // slno: 1,
//                           // description: 'Sugar',
//                           // quantity: 3,
//                           // vat: 0.19,
//                           // unitPrice: 205.99,
//                         ),
                        
//                       ],
//                     );

//                     final pdfFile = await PdfInvoiceApi.generate(invoice);

//                     PdfApi.openFile(pdfFile);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
// }