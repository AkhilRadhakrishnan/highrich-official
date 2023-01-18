import 'dart:io';
import 'package:flutter/services.dart';
import 'package:highrich/APICredentials/pdf_api.dart';
import 'package:highrich/model/invoice_customer.dart';
import 'package:highrich/model/invoice.dart';
import 'package:highrich/model/invoice_seller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:intl/intl.dart';
// import 'package:pdf/widgets/container.dart';
// import 'package:pdf/widgets/text.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:pdf/src/image.dart';
import 'package:highrich/model/invoice_company.dart';
import 'package:highrich/model/invoice_company_contact.dart';
import 'package:highrich/Screens/my_orders.dart';
import 'package:highrich/model/MyOrders/orders_model.dart';
// import 'package:printing/printing.dart';

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();
    final imageSvg = await rootBundle.loadString('images/logo_highrich.svg');

    pdf.addPage(MultiPage(
      build: (context) => [
        Row(children: [
          Text('TAX INVOICE', style: TextStyle(fontWeight: FontWeight.bold)),
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 300, 0)),
          SvgImage(svg: imageSvg),
        ]),
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        // SvgImage(svg: imageSvg),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: invoice.info.number + '.pdf', pdf: pdf);
  }

  List<Orders> ordersList = new List();

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    // final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';

    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Place of Supply:',
      'Payment Mode:',
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      // paymentTerms,
      // Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 1 * PdfPageFormat.cm),
          // Row(
          //   children: [
          //     Text(
          //       'TAX INVOICE',
          //     ),
          //     SvgImage(svg: imageSvg ),
          //   ]
          // ),
          Divider(
            color: PdfColors.red,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Padding(padding: EdgeInsets.all(50) ),
              // Text(
              //   'GST IN: 32AAFCH0823E1Z8\n'
              //   'HIGHRICH ONLINE SHOPPE Pvt. Ltd.\n'
              //   '2nd Floor, Kanimangalam Tower,\nMain Road, Valiyalukkal\n'
              //   'Thrissur, Kerala, 680027\n'
              //   'Ph: +91 9744338134\n'
              //   'info@highrich.in \n'
              // ),
              buildCompanyContact(invoice.companycontact),
              buildCompanyAddress(invoice.company)
              // buildInvoiceInfo(invoice.info),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Highrich ID: ' + invoice.info.hrid),
            ],
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),
              buildCustomerAddress(invoice.customer),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: 'https://highrich.in/',
                ),
              ),
            ],
          ),
          // Divider(),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('Highrich ID: ' + invoice.info.hrid),
          //   ],
          // ),
          Divider(),
          // SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // buildCustomerAddress(invoice.customer),
              Text('Invoice No: ' + invoice.info.number),
              Text('Invoice Date: ' + invoice.info.indate),
              Text(invoice.info.paymode,
                  style: TextStyle(color: PdfColors.green)),
            ],
          ),
          Divider(),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer?.title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer?.name),
          Text(customer?.building),
          Text(customer?.address),
          Text(customer?.address2),
          Text(customer?.state),
          Text(customer?.dist),
          Text(customer?.pin),
          Text("Phone: " + customer?.cusno)
        ],
      );
  static Widget buildCompanyContact(Companycontact companycontact) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(companycontact.gstin),
          Text(companycontact.title,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(companycontact.phone),
          Text(companycontact.mail),
        ],
      );

  static Widget buildSupplierAddress(Seller supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier?.title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(supplier?.gstin),
          Text(supplier?.name),
          Text(supplier?.building),
          // SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier?.address != null ? supplier.address : ""),
          Text(supplier?.address2),
          Text(supplier?.state),
          Text(supplier?.dist),
          Text(supplier?.pin),
          Text("Phone: " + supplier?.phno),
          Text(supplier.email != null ? supplier.email : ""),
        ],
      );
  static Widget buildCompanyAddress(Company company) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(company?.title, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(company?.name),
        Text(company?.firstaddr),
        Text(company?.secondaddr),
      ]);
  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // children: [
        //   Text(
        //     'INVOICE',
        //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        //   ),
        //   SizedBox(height: 0.8 * PdfPageFormat.cm),
        //   // Text(invoice.info.description),
        //   SizedBox(height: 0.8 * PdfPageFormat.cm),
        // ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'S.No',
      'Item',
      // 'HSN Code',
      'Unit',
      'MRP',
      'SP',
      'Qty',
      'Tax %',
      'SI',
      // 'Dis Amt.',
      // 'Taxable Amt.',
      // 'CGST Rate',
      // 'CGST Amnt',
      // 'SGST Rate',
      // 'SGST Amnt',
      // 'SI',
      'Amount',
    ];

    final data = invoice.items.map((item) {
      // final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        '${item.count}',
        item.description,
        // Utils.formatDate(item.date),
        ' ${item.unit}',
        ' ${item.mrp}',
        ' ${item.sellingprice}',
        '${item.quantity}',
        ' ${item.tax}',
        ' ${item.si == null ? "0.00" : item.si}',
        // '₹ 201.56'
        ' ${item.unitPrice}',
        // '₹ 50'
        // '${item.vat} %',
        // '\$ ${total.toStringAsFixed(2)}',
        // item.description,
        // Utils.formatDate(item.date),
        // '${item.quantity}',
        // '\$ ${item.unitPrice}',
        // '${item.vat} %',
        // item.description,
        // Utils.formatDate(item.date),
        // '${item.quantity}',
        // '\$ ${item.unitPrice}',
        // '${item.vat} %',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
        7: Alignment.centerRight,
        8: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    // final netTotal = invoice.items
    //     .map((item) => item.unitPrice * item.quantity)
    //     .reduce((item1, item2) => item1 + item2);
    // final vatPercent = invoice.items.first.vat;
    // final vat = netTotal * vatPercent;
    // final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: 'Rs. ' + invoice.totalPrice.netTotal.toString(),
                  unite: true,
                ),
                buildText(
                  title: 'Total Discount',
                  value: 'Rs. ' + invoice.totalPrice.totalDiscount.toString(),
                  unite: true,
                ),
                buildText(
                  title: 'Delivery Charge',
                  value: 'Rs. ' + invoice.totalPrice.deliveryCharge.toString(),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total Amount',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: 'Rs. ' + invoice.totalPrice.totalAmount.toString(),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Highrich Online Shoppe Private Limited '),
          // SizedBox(height: 1 * PdfPageFormat.mm),
          // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
        ],
      );

  static buildSimpleText({
    String title,
    String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.normal, fontSize: 10);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        // Text('value'),
      ],
    );
  }

  static buildText({
    String title,
    String value,
    double width = double.infinity,
    TextStyle titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
