import 'package:highrich/model/invoice_company.dart';
import 'package:highrich/model/invoice_company_contact.dart';
import 'package:highrich/model/invoice_customer.dart';
import 'package:highrich/model/invoice_seller.dart';
import 'package:highrich/model/invoice_company.dart';

class Invoice {
  final InvoiceInfo info;
  final Seller supplier;
  final Customer customer;
  final Company company;
  final Companycontact companycontact;
  final List<InvoiceItem> items;
  final InvoicePrice totalPrice;

  const Invoice({
    this.info,
    this.supplier,
    this.customer,
    this.company,
    this.companycontact,
    this.items,
    this.totalPrice
  });

}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final String paymode;
  final String hrid;
  final String indate;

  const InvoiceInfo({
    this.description,
    this.number,
    this.date,
    this.hrid,
    this.indate,
    this.paymode,
  });
}

class InvoiceItem {
  final int count;
  final String description;
  final String unit;
  final String mrp;
  final String sellingprice;
  final int quantity;
  final String tax;
  final int slno;
  final String si;
  final String unitPrice;
  final String delivercharge;

  const InvoiceItem({
    this.count,
    this.slno,
    this.description,
    this.mrp,
    this.sellingprice,
    this.unit,
    this.si,
    this.tax,
    this.quantity,
    this.unitPrice,
    this.delivercharge,
  });
}

class InvoicePrice {
  final String netTotal;
  final String deliveryCharge;
  final String totalAmount;
  final String totalDiscount;
  // final String rs ;

  const InvoicePrice({
    this.netTotal,
    this.deliveryCharge,
    this.totalAmount,
    this.totalDiscount,
    // this.rs,
  });
}
