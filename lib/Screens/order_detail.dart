import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highrich/Network/remote_data_source.dart';
import 'package:highrich/Network/result.dart';
import 'package:highrich/Screens/my_orders.dart';
import 'package:highrich/Screens/product_detail_page.dart';
import 'package:highrich/Screens/progress_hud.dart';
import 'package:highrich/Screens/search.dart';
import 'package:highrich/general/constants.dart';
import 'package:highrich/model/MyOrders/orders_model.dart';
import 'package:highrich/model/MyReturns/reason_for_return_model.dart';
import 'package:highrich/model/cancel_order_reason.dart';
import 'package:highrich/model/default_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:highrich/model/invoice_customer.dart';
import 'package:highrich/model/invoice_seller.dart';
import 'package:highrich/model/invoice_company.dart';
import 'package:highrich/model/invoice_company_contact.dart';
import 'package:highrich/model/invoice.dart';
import 'package:highrich/APICredentials/pdf_api.dart';
import 'package:highrich/APICredentials/pdf_invoice_api.dart';
/*
 *  2021 Highrich.in
 */

class OrderDetail extends StatefulWidget {
  String tabIndex;
  String orderGroupId;
  Orders ordersModelNew = new Orders();
  List<ProcessedOrderedItems> processedOrderedItemsList = new List();

  OrderDetail(
      {@required this.ordersModelNew,
      this.processedOrderedItemsList,
      this.orderGroupId,
      this.tabIndex});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetail> {
  int count = 0;
  String tabIndex;
  int orderSize = 0;
  DateTime currentDate;
  bool _enabled = true;
  bool isActive = true;
  bool isLoading = false;
  String paymentMode = "COD";
  Orders ordersModel = new Orders();
  Orders ordersModelNew = new Orders();
  String orderGroupId, orderId, quantity;
  var returnedDate = null;
  List<String> returnReasonList = new List();
  List<String> cancelReasonsList = new List();
  RemoteDataSource _apiResponse = RemoteDataSource();
  List<ProcessedOrderedItems> processedOrderedItemsList = new List();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    ordersModelNew = widget.ordersModelNew;
    processedOrderedItemsList = widget.processedOrderedItemsList;
    orderGroupId = widget.orderGroupId;
    tabIndex = widget.tabIndex;
    currentDate = new DateTime.now();

    for (int i = 0; i < processedOrderedItemsList.length; i++) {
      for (int j = 0;
          j < processedOrderedItemsList[i].orderedItemsOfVendor.length;
          j++) {
        int returnPeriod = processedOrderedItemsList[i]
                    .orderedItemsOfVendor[j]
                    .returnPeriod ==
                null
            ? 0
            : processedOrderedItemsList[i].orderedItemsOfVendor[j].returnPeriod;
        if (processedOrderedItemsList[i]
                .orderedItemsOfVendor[j]
                .itemOrderStatus
                .deliveredDate !=
            null) {
          String formattedDate = "";
          var date = DateTime.fromMillisecondsSinceEpoch(
              processedOrderedItemsList[i]
                  .orderedItemsOfVendor[j]
                  .itemOrderStatus
                  .deliveredDate);
          formattedDate = DateFormat('yyyy-MM-dd').format(date);
          var dateTemp = DateTime.parse(formattedDate);
          var returnDate = new DateTime(
              dateTemp.year, dateTemp.month, (dateTemp.day) + returnPeriod);
          returnedDate = DateFormat('MMM dd yyyy').format(returnDate);
          bool valDate = currentDate.isBefore(returnDate);
          processedOrderedItemsList[i].orderedItemsOfVendor[j].Expired =
              valDate;
        }
      }
    }

    if (tabIndex == "1" || tabIndex == "0") {
      for (int i = 0; i < processedOrderedItemsList.length; i++) {
        count = 0;
        orderSize = 0;
        for (int j = 0;
            j < processedOrderedItemsList[i].orderedItemsOfVendor.length;
            j++) {
          if (processedOrderedItemsList[i]
                  .orderedItemsOfVendor[j]
                  .itemOrderStatus
                  .currentStatus ==
              "CANCELLED") {
            orderSize =
                processedOrderedItemsList[i].orderedItemsOfVendor.length;
            setState(() {
              count++;
              if (count == orderSize) {
                processedOrderedItemsList[i].invoice = false;
              }
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      SystemNavigator.pop();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text("My Orders",
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 60,
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: processedOrderedItemsList?.length,
                    itemBuilder: (context, index) {
                      print(
                          "Seller: " + processedOrderedItemsList[index].vendor);
                      return new ExpansionTile(
                        initiallyExpanded: true,
                        title: RichText(
                          text: TextSpan(
                            text: 'Sold by  ',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      processedOrderedItemsList[index]?.vendor,
                                  style: new TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        children: <Widget>[
                          Visibility(
                            visible: processedOrderedItemsList[index].invoice,
                            child: Container(
                              margin: EdgeInsets.only(right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FlatButton(
                                    color: Colors.white,
                                    textColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    splashColor: Colors.deepOrange,
                                    onPressed: () async {
                                      final date = DateTime.now();
                                      final dueDate =
                                          date.add(Duration(days: 7));
                                      List<InvoiceItem> invoiceList =
                                          new List();
                                      int count = 1;
                                      // print("hrid:   " + loginModel[index].accountType.toString());
                                      processedOrderedItemsList[index]
                                          ?.orderedItemsOfVendor
                                          ?.forEach((element) {
                                        if (element.itemOrderStatus
                                                .currentStatus !=
                                            "CANCELLED") {
                                          invoiceList.add(
                                            InvoiceItem(
                                              count: count,
                                              description: element
                                                          .productName.length <=
                                                      10
                                                  ? element.productName
                                                  : element.productName
                                                          .substring(0, 10) +
                                                      '...',
                                              unit: element.itemCurrentPrice
                                                      .quantity +
                                                  " " +
                                                  element.itemCurrentPrice.unit,
                                              mrp: element
                                                  .itemCurrentPrice.price
                                                  .toStringAsFixed(2)
                                                  .toString(),
                                              sellingprice: element
                                                  .itemCurrentPrice.sellingPrice
                                                  .toStringAsFixed(2)
                                                  .toString(),
                                              quantity: element.quantity,
                                              tax: element.taxPerCent + "%",
                                              si: element?.itemCurrentPrice
                                                  ?.salesIncentive
                                                  ?.toStringAsFixed(2)
                                                  .toString(),
                                              // vat: 0.19,
                                              unitPrice: element.totalAmount
                                                  .toStringAsFixed(2)
                                                  .toString(),
                                            ),
                                          );
                                          count = count + 1;
                                        }
                                      });

                                      final invoice = Invoice(
                                          companycontact: Companycontact(
                                            title: 'Contact',
                                            gstin: processedOrderedItemsList[
                                                            index]
                                                        ?.windowType ==
                                                    "singleWindow"
                                                ? "GSTIN: 32AAFCH0823E1Z8"
                                                : "GSTIN: " +
                                                    processedOrderedItemsList[
                                                            index]
                                                        ?.vendorGstNumber,
                                            phone: processedOrderedItemsList[
                                                            index]
                                                        ?.windowType ==
                                                    "singleWindow"
                                                ? '+91 9744338134'
                                                : "Ph: " +
                                                    processedOrderedItemsList[
                                                            index]
                                                        ?.vendorAddress
                                                        ?.phoneNo,
                                            mail:
                                                processedOrderedItemsList[index]
                                                            ?.windowType ==
                                                        "singleWindow"
                                                    ? 'info@highrich.in'
                                                    : "",
                                          ),
                                          company: Company(
                                            title:
                                                processedOrderedItemsList[index]
                                                            ?.vendorType ==
                                                        "SELLER"
                                                    ? 'Seller Address'
                                                    : 'Company Address',
                                            name: processedOrderedItemsList[
                                                            index]
                                                        ?.vendorType ==
                                                    "SELLER"
                                                ? processedOrderedItemsList[
                                                        index]
                                                    ?.vendor
                                                : 'Highrich Online Shoppe Pvt. Ltd.',
                                            firstaddr: processedOrderedItemsList[
                                                            index]
                                                        ?.vendorType ==
                                                    "SELLER"
                                                ? processedOrderedItemsList[
                                                        index]
                                                    ?.vendorAddress
                                                    ?.addressLine1
                                                : '2nd Floor, Kanimangalam Tower',
                                            secondaddr: processedOrderedItemsList[
                                                            index]
                                                        ?.vendorType ==
                                                    "SELLER"
                                                ? processedOrderedItemsList[
                                                        index]
                                                    ?.vendorAddress
                                                    ?.addressLine2
                                                : 'Valiyalukkal,Thrissur,Kerala, 680027',
                                          ),
                                          supplier: Seller(
                                            title:
                                                processedOrderedItemsList[index]
                                                            ?.vendorType ==
                                                        "SELLER"
                                                    ? 'Shipped To '
                                                    : 'Shipped From',
                                            gstin: processedOrderedItemsList[
                                                            index]
                                                        ?.windowType ==
                                                    "singleWindow"
                                                ? "GSTIN: 32AAFCH0823E1Z8"
                                                : "GSTIN: " +
                                                    processedOrderedItemsList[
                                                            index]
                                                        ?.vendorGstNumber,
                                            name:
                                                processedOrderedItemsList[index]
                                                            ?.vendorType ==
                                                        "SELLER"
                                                    ? ordersModelNew
                                                        ?.source?.customerName
                                                    : processedOrderedItemsList[
                                                            index]
                                                        ?.vendor,
                                            building:
                                                processedOrderedItemsList[index]
                                                    ?.vendorAddress
                                                    ?.buildingName,
                                            address:
                                                processedOrderedItemsList[index]
                                                    ?.vendorAddress
                                                    ?.addressLine1,
                                            address2:
                                                processedOrderedItemsList[index]
                                                            ?.vendorAddress
                                                            ?.addressLine2 !=
                                                        null
                                                    ? processedOrderedItemsList[
                                                            index]
                                                        ?.vendorAddress
                                                        ?.addressLine2
                                                    : "",
                                            state:
                                                processedOrderedItemsList[index]
                                                    ?.vendorAddress
                                                    ?.state,
                                            dist:
                                                processedOrderedItemsList[index]
                                                    ?.vendorAddress
                                                    ?.district,
                                            pin:
                                                processedOrderedItemsList[index]
                                                    ?.vendorAddress
                                                    ?.pinCode,
                                            phno:
                                                processedOrderedItemsList[index]
                                                    ?.vendorAddress
                                                    ?.phoneNo,
                                            email:
                                                processedOrderedItemsList[index]
                                                    ?.vendorAddress
                                                    ?.emailId,

                                            // paymentInfo: 'https://paypal.me/sarahfieldzz',
                                          ),
                                          customer: Customer(
                                            title: 'Billed To',
                                            name: ordersModelNew
                                                ?.source?.customerName,
                                            building: ordersModelNew?.source
                                                ?.shippingAddress?.buildingName,
                                            address: ordersModelNew?.source
                                                ?.shippingAddress?.addressLine1,
                                            address2: ordersModelNew
                                                        ?.source
                                                        ?.shippingAddress
                                                        ?.addressLine2
                                                        .length !=
                                                    null
                                                ? ordersModelNew
                                                    ?.source
                                                    ?.shippingAddress
                                                    ?.addressLine2
                                                : "",
                                            state: ordersModelNew?.source
                                                ?.shippingAddress?.state,
                                            dist: ordersModelNew?.source
                                                ?.shippingAddress?.district,
                                            pin: ordersModelNew?.source
                                                ?.shippingAddress?.pinCode,
                                            cusno: ordersModelNew?.source
                                                ?.shippingAddress?.phoneNo,
                                          ),
                                          info: InvoiceInfo(
                                            hrid: ordersModelNew
                                                ?.source?.referralId,
                                            indate: getFormatedDate(
                                                ordersModelNew
                                                    ?.source?.orderedDate),
                                            paymode: ordersModelNew
                                                ?.source?.paymentMode,
                                            // description: 'sugar',
                                            number: ordersModelNew
                                                ?.source?.orderGroupId,
                                          ),
                                          items: invoiceList,
                                          totalPrice: InvoicePrice(
                                            // rs: '\₹',
                                            deliveryCharge:
                                                processedOrderedItemsList[index]
                                                    ?.vendorOrderSummary
                                                    ?.deliveryCharge
                                                    ?.toStringAsFixed(2)
                                                    .toString(),
                                            totalDiscount:
                                                processedOrderedItemsList[index]
                                                    ?.vendorOrderSummary
                                                    ?.totalDiscount
                                                    ?.toStringAsFixed(2)
                                                    .toString(),
                                            netTotal:
                                                processedOrderedItemsList[index]
                                                    ?.vendorOrderSummary
                                                    ?.subTotal
                                                    ?.toStringAsFixed(2)
                                                    .toString(),
                                            totalAmount:
                                                processedOrderedItemsList[index]
                                                    ?.vendorOrderSummary
                                                    ?.totalPrice
                                                    ?.toStringAsFixed(2)
                                                    .toString(),
                                          ));

                                      final pdfFile =
                                          await PdfInvoiceApi.generate(invoice);

                                      PdfApi.openFile(pdfFile);
                                      // BottomSheetViewInvoice mbs =
                                      // new BottomSheetViewInvoice(
                                      //     processedOrderedItemsList:
                                      //     processedOrderedItemsList[index],
                                      //     ordersModel: ordersModelNew,
                                      //     tabIndex: tabIndex);
                                      // Future(() =>
                                      //     showModalBottomSheet(
                                      //         isScrollControlled: true,
                                      //         context: context,
                                      //         builder: (context) {
                                      //           return mbs;
                                      //         }));
                                    },
                                    child: Text(
                                      "View Invoice",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          new Column(
                              children: _buildExpandableContent(
                                  processedOrderedItemsList[index])),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
        key: _scaffoldkey);
  }

  _buildExpandableContent(ProcessedOrderedItems processedOrderedItems) {
    List<Widget> columnContent = [];

    for (OrderedItemsOfVendor content
        in processedOrderedItems?.orderedItemsOfVendor)
      columnContent.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Product_Detail_Page(
                    product_id: content?.productId,
                  ),
                ));
          },
          child: new Container(
            margin: EdgeInsets.only(left: 4, right: 4),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // ClipRRect(borderRadius: BorderRadius.circular(25),child:Image.network("https://homepages.cae.wisc.edu/~ece533/images/airplane.png",height: 50,width: 50,),),
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: gray_bg,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage:
                              NetworkImage(imageBaseURL + content?.image),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Text(
                                    content?.orderId,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ]),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    content?.productName,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "₹ " +
                                      content?.itemCurrentPrice?.sellingPrice
                                          ?.toStringAsFixed(2)
                                          ?.toString(),
                                  style: TextStyle(
                                      color: colorButtonOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "₹ " +
                                      content?.itemCurrentPrice?.price
                                          ?.toStringAsFixed(2)
                                          ?.toString(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  content?.itemCurrentPrice?.quantity
                                          ?.toString() +
                                      " " +
                                      content?.itemCurrentPrice?.unit
                                          ?.toString(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Qty: " + content?.quantity.toString(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                returnedDate != null
                                    ? Text(
                                        "Return Available till " +
                                            returnedDate.toString(),
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      )
                                    : Text(""),
                                SizedBox(
                                  width: 8,
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: content
                                            ?.itemOrderStatus?.currentStatus ==
                                        "CANCELLED"
                                    ? Colors.red
                                    : content?.itemOrderStatus?.currentStatus ==
                                            "ORDERED"
                                        ? Colors.blueAccent
                                        : colorCyan,
                                border: Border.all(
                                  color:
                                      content?.itemOrderStatus?.currentStatus ==
                                              "CANCELLED"
                                          ? Colors.red
                                          : content?.itemOrderStatus
                                                      ?.currentStatus ==
                                                  "ORDERED"
                                              ? Colors.blueAccent
                                              : colorCyan,
                                ),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(12.0),
                                    bottomLeft: Radius.circular(0.0),
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(0.0))),
                            child: Center(
                                child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  content?.itemOrderStatus?.currentStatus ==
                                          "RETURN_REQUESTED"
                                      ? "RETURN REQUESTED"
                                      : content?.itemOrderStatus
                                                  ?.currentStatus ==
                                              "RETURN_REQUEST_ACCEPTED"
                                          ? "REQUEST ACCEPTED"
                                          : content?.itemOrderStatus
                                                      ?.currentStatus ==
                                                  "RETURN_REQUEST_REJECTED"
                                              ? "REQUEST REJECTED"
                                              : content?.itemOrderStatus
                                                  ?.currentStatus,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          content?.itemOrderStatus?.currentStatus == "SHIPPED"
                              ? FlatButton(
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  onPressed: () {},
                                  child: Text(
                                    "Track Order",
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                )
                              : content?.itemOrderStatus?.currentStatus ==
                                          "ORDERED" ||
                                      content?.itemOrderStatus?.currentStatus ==
                                          "PICKED" ||
                                      content?.itemOrderStatus?.currentStatus ==
                                          "CONFIRMED"
                                  ? OutlineButton(
                                      child: Text(
                                        "Cancel Item",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        cancelOrderReason(content?.orderId);
                                      },
                                    )
                                  : content?.itemOrderStatus?.currentStatus ==
                                              "RETURN_REQUESTED" ||
                                          content?.itemOrderStatus
                                                  ?.currentStatus ==
                                              "RETURN_REQUEST_ACCEPTED" ||
                                          content?.itemOrderStatus
                                                  ?.currentStatus ==
                                              "RETURN_REQUEST_REJECTED"
                                      ? Container(
                                          child: Text(
                                            "Requested for return",
                                            style: TextStyle(
                                                color: Colors.deepOrange),
                                          ),
                                        )
                                      : content?.Expired == false
                                          ? Container(
                                              child: Text(
                                                "Return Period Expired",
                                                style: TextStyle(
                                                    color: Colors.deepOrange),
                                              ),
                                            )
                                          : content?.itemOrderStatus
                                                      ?.currentStatus ==
                                                  "CANCELLED"
                                              ? Container(
                                                  child: Text(
                                                    "Item canceled",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepOrange),
                                                  ),
                                                )
                                              : FlatButton(
                                                  child: Text(
                                                    "Return Request",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  color: Colors.deepOrange,
                                                  onPressed: () {
                                                    returnReasons(
                                                        content?.quantity,
                                                        content?.orderId);
                                                  },
                                                )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

    return columnContent;
  }

  //Cancel order reason listing api call
  Future<CancelOrderReasonModel> cancelOrderReason(String orderId) async {
    setState(() {
      isLoading = true;
    });
    Result result = await _apiResponse.cancelOrderReason();
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      CancelOrderReasonModel response = (result).value;
      if (response.status == "success") {
        print("000000" + response.status + "000000");
        setState(() {
          cancelReasonsList = response.cancelReasons;
        });

        CancelRequestBottomSheet mbs = new CancelRequestBottomSheet(
            ordersModel: ordersModel,
            cancelReasonsList: cancelReasonsList,
            orderGroupId: orderGroupId,
            orderId: orderId);

        Future(() => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return mbs;
            }));
      } else {
        // showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      CancelOrderReasonModel unAuthoedUser = (result).value;
      // showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      //showSnackBar("Failed, please try agian later");
    }
  }

  //Return reason listing api call
  Future<ReasonForReturnModel> returnReasons(int qty, String orderId) async {
    setState(() {
      isLoading = true;
    });

    Result result = await _apiResponse.returnReasons();
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      ReasonForReturnModel response = (result).value;
      if (response.status == "success") {
        returnReasonList = response.returnReasons;
        ReturnRequestBottomSheet mbs = new ReturnRequestBottomSheet(
            ordersModel: ordersModel,
            returnReasonsList: returnReasonList,
            orderGroupId: orderGroupId,
            orderId: orderId,
            quantity: qty);

        Future(() => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return mbs;
            }));
      } else {
        Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_SHORT,
        );

        // showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      ReasonForReturnModel unAuthoedUser = (result).value;
      // showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      //showSnackBar("Failed, please try agian later");
    }
  }
}

class CancelRequestBottomSheet extends StatefulWidget {
  Orders ordersModel = new Orders();
  List<String> cancelReasonsList;
  String orderGroupId;
  String orderId;

  CancelRequestBottomSheet(
      {@required this.ordersModel,
      this.cancelReasonsList,
      this.orderGroupId,
      this.orderId});

  _CancelRequestBottomSheetState createState() =>
      _CancelRequestBottomSheetState();
}

class _CancelRequestBottomSheetState extends State<CancelRequestBottomSheet>
    with SingleTickerProviderStateMixin {
  Orders ordersModel = new Orders();
  List<String> cancelReasonsList;
  String selectedReason;
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  bool flag = false;
  bool isLoading;
  String orderGroupId, orderId;

  RemoteDataSource _apiResponse = RemoteDataSource();

  @override
  void initState() {
    ordersModel = widget.ordersModel;
    cancelReasonsList = widget.cancelReasonsList;
    orderGroupId = widget.orderGroupId;
    orderId = widget.orderId;
    if (cancelReasonsList.length > 0) {
      flag == true;
      selectedReason = cancelReasonsList[0];
    }
  }

  Widget build(BuildContext context) {
    _dropdownMenuItems = buildDropDownMenuItems(cancelReasonsList);
    return Container(
      color: Colors.white,
      height: 300,
      child: new Wrap(
        children: <Widget>[
          new ListTile(
              title: new Text(
                "Cancel Order",
              ),
              onTap: () => {}),
          Divider(),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Cancel Reason",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(children: [
                  Expanded(
                      child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: dropdown(),
                    ),
                  ))
                ]),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      width: 130,
                      child: OutlineButton(
                          child: new Text(
                            "Cancel",
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          borderSide: BorderSide(color: Colors.deepOrange),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(0.0),
                          )),
                    ),
                    Spacer(),
                    Container(
                      width: 130,
                      child: FlatButton(
                          color: Colors.deepOrange,
                          child: new Text(
                            "Cancel Order",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            cancelOrders(orderGroupId, orderId, selectedReason);
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(0.0))),
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem,
            style: TextStyle(
                color: Colors.black, fontFamily: 'Poppins', fontSize: 14),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  DropdownButtonHideUnderline dropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
          value: selectedReason,
          items: _dropdownMenuItems,
          onChanged: (value) {
            setState(() {
              print(value);
              selectedReason = value;
            });
          }),
    );
  }

  Future<OrdersModel> cancelOrders(
      String orderGroupId, String orderId, String reason) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("userId");
    setState(() {
      isLoading = true;
    });
    var cancelOrdersReqBody = Map<String, dynamic>();
    cancelOrdersReqBody.addAll({
      "orderGroupId": orderGroupId,
      "orderId": orderId,
      "reasonOfCancellation": reason,
    });

    Result result = await _apiResponse.cancelOrders(cancelOrdersReqBody);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      DefaultModel response = (result).value;
      if (response.status == "success") {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyOrders(
                      tabIndex: 0,
                    )));
        print(response.message);
      } else {
        Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_SHORT,
        );

        // showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      OrdersModel unAuthoedUser = (result).value;
      // showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      //showSnackBar("Failed, please try agian later");
    }
  }
}

class ReturnRequestBottomSheet extends StatefulWidget {
  Orders ordersModel = new Orders();
  List<String> returnReasonsList;
  String orderGroupId;
  String orderId;
  int quantity;

  ReturnRequestBottomSheet(
      {@required this.ordersModel,
      this.returnReasonsList,
      this.orderGroupId,
      this.orderId,
      this.quantity});

  _ReturnRequestBottomSheetState createState() =>
      _ReturnRequestBottomSheetState();
}

class _ReturnRequestBottomSheetState extends State<ReturnRequestBottomSheet>
    with SingleTickerProviderStateMixin {
  Orders ordersModel = new Orders();
  List<String> returnReasonsList;
  String selectedReason;
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  bool flag = false;
  bool isLoading;
  String orderGroupId, orderId;
  int quantity;

  RemoteDataSource _apiResponse = RemoteDataSource();

  @override
  void initState() {
    ordersModel = widget.ordersModel;
    returnReasonsList = widget.returnReasonsList;
    orderGroupId = widget.orderGroupId;
    orderId = widget.orderId;
    quantity = widget.quantity;
    if (returnReasonsList.length > 0) {
      flag == true;
      selectedReason = returnReasonsList[0];
    }
  }

  Widget build(BuildContext context) {
    _dropdownMenuItems = buildDropDownMenuItems(returnReasonsList);
    return Container(
      color: Colors.white,
      height: 300,
      child: new Wrap(
        children: <Widget>[
          new ListTile(
              title: new Text(
                "Return Request",
              ),
              onTap: () => {}),
          Divider(),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Return Reason",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(children: [
                  Expanded(
                      child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: dropdown(),
                    ),
                  ))
                ]),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      width: 130,
                      child: OutlineButton(
                          child: new Text(
                            "Cancel",
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          borderSide: BorderSide(color: Colors.deepOrange),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(0.0),
                          )),
                    ),
                    Spacer(),
                    Container(
                      width: 130,
                      child: FlatButton(
                          color: Colors.deepOrange,
                          child: new Text(
                            "Return Order",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            returnOrderRequest(orderGroupId, orderId,
                                selectedReason, quantity);
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(0.0))),
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat-Black',
                fontSize: 14),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  DropdownButtonHideUnderline dropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
          value: selectedReason,
          items: _dropdownMenuItems,
          onChanged: (value) {
            setState(() {
              print(value);
              selectedReason = value;
            });
          }),
    );
  }

  Future<OrdersModel> returnOrderRequest(
      String orderGroupId, String orderId, String reason, int quantity) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString("userId");
    setState(() {
      isLoading = true;
    });
    var returnOrdersReqBody = Map<String, dynamic>();
    returnOrdersReqBody.addAll({
      "orderGroupId": orderGroupId,
      "orderId": orderId,
      "reasonOfCancellation": reason,
      "quantity": quantity,
    });

    Result result = await _apiResponse.returnOrderRequest(returnOrdersReqBody);
    setState(() {
      isLoading = false;
    });
    if (result is SuccessState) {
      DefaultModel response = (result).value;
      if (response.status == "success") {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyOrders(
                      tabIndex: 0,
                    )));
        print(response.message);
      } else {
        Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_SHORT,
        );

        // showSnackBar("Failed, please try agian later");
      }
    } else if (result is UnAuthoredState) {
      OrdersModel unAuthoedUser = (result).value;
      // showSnackBar("Failed, please try agian later");
    } else if (result is ErrorState) {
      String errorMessage = (result).msg;
      //showSnackBar("Failed, please try agian later");
    }
  }
}

class BottomSheetViewInvoice extends StatefulWidget {
  // List<ProcessedOrderedItems> processedOrderedItemsList = new List();
  ProcessedOrderedItems processedOrderedItemsList = new ProcessedOrderedItems();
  Orders ordersModel = new Orders();
  String tabIndex;

  BottomSheetViewInvoice(
      {@required this.processedOrderedItemsList,
      this.ordersModel,
      this.tabIndex});

  _BottomSheetViewInvoiceState createState() => _BottomSheetViewInvoiceState();
}

class _BottomSheetViewInvoiceState extends State<BottomSheetViewInvoice>
    with SingleTickerProviderStateMixin {
  Orders ordersModel = new Orders();
  ProcessedOrderedItems processedOrderedItemsList = new ProcessedOrderedItems();
  List<OrderedItemsOfVendor> allOrderList;
  String phone = "";
  String tabIndex;

  Widget build(BuildContext context) {
    ordersModel = widget.ordersModel;
    tabIndex = widget.tabIndex;
    print("TABINDEX");
    print(tabIndex);
    processedOrderedItemsList = widget.processedOrderedItemsList;

    if (ordersModel.source.shippingAddress != null) {
      if (ordersModel.source.shippingAddress.phoneNo == null) {
        phone = "";
      } else {
        phone = ordersModel.source.shippingAddress.phoneNo;
      }
    }

    // for (int i = 0; i <  processedOrderedItemsList.orderedItemsOfVendor.length; i++) {
    allOrderList = processedOrderedItemsList.orderedItemsOfVendor;
    // }
    return Container(
        height: 550,
        child: ListView(
          children: [
            new Wrap(
              children: <Widget>[
                new ListTile(
                    title: new Text(
                      "Order Details",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    onTap: () => {}),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  // height: (MediaQuery
                  //     .of(context)
                  //     .size
                  //     .height)+ 500 ,
                  margin: EdgeInsets.only(left: 14.0, right: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Sold By :",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            processedOrderedItemsList.vendor,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Text(
                            "Order By :",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            ordersModel.source.customerName,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Text(
                            "Contact :",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            phone,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Row(
                        children: [
                          Text(
                            "Order Date:",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            getFormatedDate(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Text(
                            "Invoice ID:",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              ordersModel?.source?.orderGroupId,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Text(
                            "Payment:",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            ordersModel.source.paymentMode,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Billed From",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        billingFromAddress(
                            processedOrderedItemsList.vendorAddress),
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Billed To",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        addressDetails(ordersModel.source.shippingAddress),
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: allOrderList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return myOrderItems(allOrderList[index]);
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Sub Total"),
                          ),
                          Text(
                            "₹ " +
                                processedOrderedItemsList
                                    .vendorOrderSummary.subTotal
                                    .toStringAsFixed(2),
                            style: TextStyle(
                                color: colorButtonOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Delivey Charges"),
                          ),
                          Text(
                            "₹ " +
                                processedOrderedItemsList
                                    .vendorOrderSummary.deliveryCharge
                                    .toStringAsFixed(2),
                            style: TextStyle(
                                color: colorButtonOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Total"),
                          ),
                          Text(
                            "₹ " +
                                processedOrderedItemsList
                                    .vendorOrderSummary.totalPrice
                                    .toStringAsFixed(2),
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ));
  }

  Widget myOrderItems(OrderedItemsOfVendor allOrder) {
    return tabIndex == "1" || tabIndex == "0"
        ? Visibility(
            visible: allOrder.itemOrderStatus.currentStatus != "CANCELLED",
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    allOrder?.productName,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Text(
                                  "₹ " +
                                      allOrder?.itemCurrentPrice.sellingPrice
                                          ?.toStringAsFixed(2)
                                          .toString(),
                                  style: TextStyle(
                                      color: colorButtonOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Varient: " +
                                    allOrder?.itemCurrentPrice?.quantity +
                                    " " +
                                    allOrder?.itemCurrentPrice?.unit),
                                Text("  Qty: " + allOrder?.quantity.toString()),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ))
        : Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  allOrder?.productName,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              Text(
                                "₹ " +
                                    allOrder?.itemCurrentPrice.sellingPrice
                                        .toString(),
                                style: TextStyle(
                                    color: colorButtonOrange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Qty: " +
                                  allOrder?.itemCurrentPrice?.quantity +
                                  " " +
                                  allOrder?.itemCurrentPrice?.unit),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
  }

  String addressDetails(ShippingAddress shippingAddressModel) {
    String key = "";

    String ownerName = shippingAddressModel?.ownerName;
    String buildingName = shippingAddressModel?.buildingName;
    String addressLine1 = shippingAddressModel?.addressLine1;
    String addressLine2 = shippingAddressModel?.addressLine2;
    String district = shippingAddressModel?.district;
    String state = shippingAddressModel?.state;
    String pinCode = shippingAddressModel?.pinCode;

    if (ownerName != null && ownerName != "") {
      key = key + ownerName;
    }
    if (buildingName != null && buildingName != "") {
      if (key.length > 0) {
        key = key + "," + buildingName;
      } else {
        key = key + buildingName;
      }
    }
    if (addressLine1 != null && addressLine1 != "") {
      if (key.length > 0) {
        key = key + "," + addressLine1;
      } else {
        key = key + addressLine1;
      }
    }
    if (addressLine2 != null && addressLine2 != "") {
      if (key.length > 0) {
        key = key + "," + addressLine2;
      } else {
        key = key + addressLine2;
      }
    }
    if (district != null && district != "") {
      if (key.length > 0) {
        key = key + "," + district;
      } else {
        key = key + district;
      }
    }
    if (state != null && state != "") {
      if (key.length > 0) {
        key = key + "," + state;
      } else {
        key = key + state;
      }
    }
    if (pinCode != null && pinCode != "") {
      if (key.length > 0) {
        key = key + "," + pinCode;
      } else {
        key = key + pinCode;
      }
    }
    return key;
  }

  String billingFromAddress(VendorAddress vendorAddress) {
    String key = "";

    String ownerName = vendorAddress?.ownerName;
    String buildingName = vendorAddress?.buildingName;
    String addressLine1 = vendorAddress?.addressLine1;
    String addressLine2 = vendorAddress?.addressLine2;
    String district = vendorAddress?.district;
    String state = vendorAddress?.state;
    String pinCode = vendorAddress?.pinCode;

    if (ownerName != null && ownerName != "") {
      key = key + ownerName;
    }
    if (buildingName != null && buildingName != "") {
      if (key.length > 0) {
        key = key + "," + buildingName;
      } else {
        key = key + buildingName;
      }
    }
    if (addressLine1 != null && addressLine1 != "") {
      if (key.length > 0) {
        key = key + "," + addressLine1;
      } else {
        key = key + addressLine1;
      }
    }
    if (addressLine2 != null && addressLine2 != "") {
      if (key.length > 0) {
        key = key + "," + addressLine2;
      } else {
        key = key + addressLine2;
      }
    }
    if (district != null && district != "") {
      if (key.length > 0) {
        key = key + "," + district;
      } else {
        key = key + district;
      }
    }
    if (state != null && state != "") {
      if (key.length > 0) {
        key = key + "," + state;
      } else {
        key = key + state;
      }
    }
    if (pinCode != null && pinCode != "") {
      if (key.length > 0) {
        key = key + "," + pinCode;
      } else {
        key = key + pinCode;
      }
    }
    return key;
  }

  String getFormatedDate() {
    String formattedDate = "";
    if (ordersModel.source?.orderedDate != null) {
      var date =
          DateTime.fromMillisecondsSinceEpoch(ordersModel.source.orderedDate);
      formattedDate = DateFormat('MMM dd , hh:mm a').format(date);
      print(formattedDate);
    } else {
      formattedDate = "";
    }

    return formattedDate;
  }
}

String getFormatedDate(var timeStamp) {
  String formattedDate = "";
  var date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  formattedDate = DateFormat('MMM dd , hh:mm a').format(date);

  return formattedDate;
}
