import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../methods/methods.dart';
import '../widgets/widgets.dart';

var contactSearch = TextEditingController();
var searchQueries = ''.obs;

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  ContactPageState createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage> {

  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder (
      stream: readRecords('users_tbl'),
      builder: (context, snapshot) {
        Object data = [];
        if(snapshot.hasData){
          data = snapshot.data!;
        }
        Future.delayed(Duration.zero, () async => {

        });

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if(snapshot.hasError){
              return const Center(child: Text('No Records available...'));
            } else {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Stack(
                  fit: StackFit.loose,
                  children: [
                    buildListViewRow(data),
                  ],
                )
              );
            }
        }
      },
    ),
  );
}

Widget buildListViewRow(data) =>
  ListView.builder(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    itemCount: data.length,
    itemBuilder: (context, i) {
      return Card(
        child: ListTile(
            leading:
            ElevatedButton(
              onPressed: () {
                membersContactDetails(context,data[i]);
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
                backgroundColor: themeColors[colorSliderIdx.value]  ,
                foregroundColor: globalTextColors[textColorIdx.value],
              ),
              child: const Icon(
                Icons.person,
                size: 25,
                color: Colors.white,
              ),
            ),
            title: Text.rich(
              TextSpan(
                // text: 'Test',
                // style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: '${data[i]['title']} \n',
                      style: GoogleFonts.getFont('Roboto', fontSize: 13,
                          color: globalTextColors[textColorIdx.value] ,
                          fontWeight: FontWeight.w300, fontStyle: FontStyle.italic
                      ),
                    ),
                    TextSpan(
                      text: '${data[i]['first_name']} ${data[i]['last_name']} \n',
                      style: GoogleFonts.getFont('Raleway', fontSize: 18,
                        color: globalTextColors[textColorIdx.value] ,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '${data[i]['position']}',
                      style: GoogleFonts.getFont('Open Sans', fontSize: 14,
                        color: globalTextColors[textColorIdx.value] ,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ]
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  // iconSize: 72,
                  icon: const Icon(Icons.library_books_sharp),
                  onPressed: () {
                    membersContactDetails(context,data[i]);
                  },
                ),
              ],
            )
        ),
      );
    },
  );
// );


