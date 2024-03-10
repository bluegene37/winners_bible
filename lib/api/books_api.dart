import 'dart:convert';
import 'package:flutter/material.dart';
import '../main.dart';
import '../model/books.dart';

class BooksApi {
  static Future<List<Book>> getBooksLocally(BuildContext context, jsonName, bookTitle, bookChapter) async{
    if(mainBooks.isEmpty) {
      final assetBundle = DefaultAssetBundle.of(context);
      mainBooks = await assetBundle.loadString('assets/$bibleVersions.json');
    }
    final body = json.decode(mainBooks);
    final bookList = body.map<Book>(Book.fromJson).toList();
    final resultText = bookList.where((val) => val.book == bookTitle && val.chapter == bookChapter).toList();
    final chapters = bookList.where((x) => x.book == bookTitle).toList();
    final unique = <String>{};
    final uniqueList = chapters.where((x) => unique.add(x.chapter.toString())).toList();
    lastChapter = uniqueList.length;
    bibleScreen = resultText;
    return resultText;
  }
}

class BooksTitleApi {
  static Future<List<BookTitle>> getBooksLocally(BuildContext context, testament) async{
    if(mainBooksMenu == '') {
      final assetBundle = DefaultAssetBundle.of(context);
      mainBooksMenu = await assetBundle.loadString('assets/$testament.json');
    }
    final body = json.decode(mainBooksMenu);
    final bookNames = body.map<BookTitle>(BookTitle.fromJson).toList();

    return bookNames;
  }
}

class BooksChapterApi {
  static Future<List<Book>> getBooksLocally(BuildContext context, jsonName,bookTitle) async{
    if(mainBooks.isEmpty) {
      final assetBundle = DefaultAssetBundle.of(context);
      mainBooks = await assetBundle.loadString('assets/$bibleVersions.json');
    }
    final body = json.decode(mainBooks);
    final allChapter = body.map<Book>((json) => Book.fromJson(json)).toList();
    final bookChapter = allChapter.where((x) => x.book == bookTitle).toList();
    final unique = <String>{};
    final uniqueList = bookChapter.where((x) => unique.add(x.chapter.toString())).toList();
    chaptersScreen = uniqueList;
    return uniqueList;
  }
}

class SearchApi {
  static Future<List<Book>> getBooksLocally(BuildContext context, jsonName, searchQuery) async{
    if(mainBooks.isEmpty) {
      final assetBundle = DefaultAssetBundle.of(context);
      mainBooks = await assetBundle.loadString('assets/$bibleVersions.json');
    }
    final body = json.decode(mainBooks);
    final bookList = body.map<Book>(Book.fromJson).toList();
    final resultText = bookList.where((val) =>
      (val.text.toLowerCase().contains(searchQuery.toLowerCase().trim()) == true)
      || (val.book.toLowerCase().contains(searchQuery.toLowerCase().trim()) == true && val.chapter == 1 && val.verse == 1)
      // || (val.book.toLowerCase().contains(searchQuery.replaceAll(RegExp(r"\d"), "").toLowerCase().trim()) == true && val.chapter == int.parse(searchQuery.replaceAll(RegExp(r"\D"), "")) && val.verse == 1)
    ).toList();
    searchScreen = resultText;
    return resultText;
  }
}
