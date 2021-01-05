import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:playground/Invoice.dart';

class InvoiceFilterForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InvoiceFilterFormState();
}

class _InvoiceFilterFormState extends State<InvoiceFilterForm> {
  final _filterParams = InvoiceFilter();
  TextEditingController _dateFromCtl = TextEditingController();
  TextEditingController _dateToCtl = TextEditingController();
  String numberErrorText;
  String minAmountErrorText;
  String maxAmountErrorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: "Invoice number", errorText: numberErrorText),
            onChanged: (value) {
              String validString = validateNumber(value);
              if (validString == null) {
                _filterParams.number = value == null || value.isEmpty ? null : int.parse(value);
              }
              setState(() {
                numberErrorText = validString;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: "Company name"),
            onChanged: (value) {
              _filterParams.companyNameLike = value == null || value.isEmpty ? null : value;
            },
          ),
          MultiSelectDialogField(
              title: Text("Status"),
              buttonText: Text("Status"),
              initialValue: _filterParams.statuses,
              items: InvoiceStatus.toList().map((e) => MultiSelectItem(e, e.value)).toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                setState(() {
                  _filterParams.statuses = values;
                });
              }
          ),
          TextField(
            // initialValue: _filterParams.minDate.toString(),
            decoration: InputDecoration(labelText: "Date from"),
            controller: _dateFromCtl,
            onTap: () async {
              FocusScope.of(context).requestFocus(new FocusNode());
              DateTime date = await showDatePicker(
                  context: context,
                  initialDate: _filterParams.minDate == null
                      ? DateTime.now().subtract(Duration(days: 365))
                      : _filterParams.minDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now());
              if (date != null) {
                _filterParams.minDate = date;
              }
              _dateFromCtl.text =
                  _filterParams.minDate == null ? null : DateFormat("yyyy-MM-dd").format(_filterParams.minDate);
            },
          ),
          TextField(
            // initialValue: _filterParams.minDate.toString(),
            decoration: InputDecoration(labelText: "Date to"),
            controller: _dateToCtl,
            onTap: () async {
              FocusScope.of(context).requestFocus(new FocusNode());
              DateTime date = await showDatePicker(
                  context: context,
                  initialDate: _filterParams.maxDate == null ? DateTime.now() : _filterParams.maxDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now());
              if (date != null) {
                _filterParams.maxDate = date;
              }
              _dateToCtl.text =
                  _filterParams.maxDate == null ? null : DateFormat("yyyy-MM-dd").format(_filterParams.maxDate);
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: "Min amount", errorText: minAmountErrorText),
            onChanged: (value) {
              String validString = validateAmount(value);
              if (validString == null) {
                _filterParams.minAmount = value == null || value.isEmpty ? null : double.parse(value);
              }
              setState(() {
                minAmountErrorText = validString;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: "Max amount", errorText: maxAmountErrorText),
            onChanged: (value) {
              String validString = validateAmount(value);
              if (validString == null) {
                _filterParams.maxAmount = value == null || value.isEmpty ? null : double.parse(value);
              }
              setState(() {
                maxAmountErrorText = validString;
              });
            },
          ),
          CheckboxListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              tristate: true,
              value: _filterParams.hasVat,
              title: Text("VAT applicable"),
              onChanged: (value) {
                setState(() {
                  _filterParams.hasVat = value;
                });
              }),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                  child: Text('Search'),
                  onPressed: () {
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing data')));
                  }))
        ],
      ),
    );
  }

  String validateNumber(String value) {
    var res = value == null || value.isEmpty || int.tryParse(value) != null;
    return res ? null : "Enter a valid int number";
  }

  String validateAmount(String value) {
    var res = value == null || value.isEmpty || double.tryParse(value) != null;
    return res ? null : "Enter a valid decimal number";
  }
}
