import 'package:flutter/material.dart';
import 'package:crm/pages/detail_page.dart';

class DetailsBottomSheet {
  static void openBottomSheet(context, status, customerName, address,
      contactNumber, cid, email, addressline2, pgCnf, typ) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return DetailPage(status, customerName, address, contactNumber, cid,
              email, addressline2, pgCnf, typ);
        });
  }
}
