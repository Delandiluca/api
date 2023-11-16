import 'package:book_app_api/dao/dao.dart';
import 'package:book_app_api/model/book.dart';

class BookDaoMemory implements Dao<Book> {
  List<Book> listBooks = [
    Book(
      code: 1,
      title: 'TituloTest',
      author: 'AutorTest',
      gender: 'GeneroTest',
      datePublished: 'DataTest',
      imageUrl: 'ImagemTest',
      sinopse: 'SinopseTest',
      linkReference: 'LinkTest',
      codeUser: '1',
    ),
    Book(
      code: 2,
      title: 'TituloTest2',
      author: 'AutorTest2',
      gender: 'GeneroTest2',
      datePublished: 'DataTest2',
      imageUrl: 'ImagemTest2',
      sinopse: 'SinopseTest2',
      linkReference: 'LinkTest2',
      codeUser: '1',
    ),
    Book(
      code: 2,
      title: 'TituloTest3',
      author: 'AutorTest3',
      gender: 'GeneroTest3',
      datePublished: 'DataTest3',
      imageUrl: 'ImagemTest3',
      sinopse: 'SinopseTest3',
      linkReference: 'LinkTest3',
      codeUser: '1',
    ),
  ];

  @override
  Future<List<Book>> findAll() async {
    return listBooks;
  }

  @override
  Future<Book?> findById(int id) async {
    for (int i = 0; i < listBooks.length; i++) {
      if (listBooks[i].code == id) {
        return listBooks[i];
      }
    }
    return null;
  }

  @override
  Future<bool> save(Book entity) async {
    listBooks.add(entity);
    return true;
  }

  @override
  Future<bool> update(Book entity) async {
    for (int i = 0; i < listBooks.length; i++) {
      if (listBooks[i].code == entity.code) {
        listBooks[i] = entity;
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> delete(Book entity) async {
    for (int i = 0; i < listBooks.length; i++) {
      if (listBooks[i].code == entity.code) {
        listBooks.removeAt(i);
        return true;
      }
    }
    return false;
  }
}
