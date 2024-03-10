import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

final supabase = Supabase.instance.client;

Stream<List> readRecords(pTable){
  final data = supabase.from(pTable).stream(primaryKey: ['id']).order('id', ascending: true);
  return data;
}

PostgrestFilterBuilder filterRecords(pTable,pQuery){
  final data = supabase.from(pTable)
      .select('first_name')
      .textSearch('first_name',pQuery);
  return data;
}

int getUniqueID(){
  int uniqueID = 0;
  var now = DateTime.now();
  uniqueID = int.parse('${DateFormat('yyMMdd').format(now)}${DateFormat('HHmmssS').format(now)}');
  return uniqueID;
}

String notesJson(){
  final noteValues = notesBox.values.toList();
  var finalVerse = '';
  for( var items in noteValues){
    finalVerse += items['book'].replaceAll('[','').replaceAll(']','');
  }
  return finalVerse;
}

Future<List> filterNotes(pQuery) async{
    final noteValues = notesBox.values.toList();
    final listWhere = noteValues.where((e) => e['notes'].contains(pQuery) || e['book'].replaceAll('[','').replaceAll(']','').contains(pQuery)).toList();
    return pQuery.isNotEmpty ? listWhere : noteValues ;
}

Future createRecords(pTable,p1,p2,p3,p4,p5,p6) async{
  await supabase
    .from(pTable)
    .insert({
      'position': p1,
      'title': p2,
      'first_name': p3,
      'middle_name': p4,
      'last_name': p5,
      'phonenumber': p6,
    });
}

Future<void> deleteRecords(pCollection,pID) async {
  await supabase
      .from(pCollection)
      .delete()
      .match({ 'id': pID});
}