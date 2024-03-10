

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../main.dart';
import '../methods/methods.dart';

final position = ['CEO','Senior VP','VP','Regional Director','Deputy Regional Director','Provincial Director','Correspondent'];
final title = ['Mr','Miss','Mrs','Pastor'];
var vposition = 'Correspondent';
var vtitle = 'Pastor';
var vfirstname = TextEditingController();
var vmiddlename = TextEditingController();
var vlastname = TextEditingController();
var vphonenumber = TextEditingController();

Future<void> showBottomSheetCreate(context){
  String uniqueID = '';
  vfirstname.text = '';
  vmiddlename.text = '';
  vlastname.text = '';
  vphonenumber.text = '';
  var now = DateTime.now();
  uniqueID = '${DateFormat('yyMMdd').format(now)}${DateFormat('HHmmssS').format(now)}';
  return showCupertinoModalBottomSheet(
    context: context,
    builder: (context) => Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Flexible(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: const Text('Add Details.'),
                      trailing: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close)
                      ) ,
                    ),
                    Row(
                      children: [
                        DropdownMenu<String>(
                          initialSelection: vposition,
                          onSelected: (String? value) {
                            vposition = value!;
                          },
                          dropdownMenuEntries: position.map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(value: value, label: value);
                          }).toList(),
                        ),
                        const SizedBox(width: 5),
                        DropdownMenu<String>(
                          initialSelection: vtitle,
                          onSelected: (String? value) {
                            vtitle = value!;
                          },
                          dropdownMenuEntries: title.map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(value: value, label: value);
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: vfirstname,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'First Name',
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: vmiddlename,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Middle Name',
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: vlastname,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Last Name',
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: vphonenumber,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Contact Number',
                      ),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                            onPressed: (){
                                createRecords('users_tbl',vposition,vtitle,vfirstname.text,vmiddlename.text,vlastname.text,vphonenumber.text);
                                Navigator.pop(context);
                              },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColors[colorSliderIdx.value],
                            ),
                            child: const Text('Save')
                          ),
                        const SizedBox(width: 20),
                      ],
                    )
                  ],
                ),
              )
        ]
      ),
    )
  );
}

Future<void> membersContactDetails(context,data){
  return showCupertinoModalBottomSheet(
    expand: false,
    context: context,
    builder: (context) => Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Flexible(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: const Text('Contact Details'),
                  trailing: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close)
                  ) ,
                ),
                ListTile(
                  leading: const Icon(Icons.phone_android_outlined),
                  title: Text('${data['phonenumber']}'),
                ),
              ],
            ),
          )
        ]
      ),
    )
  );
}


