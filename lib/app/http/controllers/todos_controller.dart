import 'package:vania/vania.dart';
import 'package:vania_api/app/models/todos.dart';

class TodosController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> store(Request request) async {
    request.validate({
      'title': 'required',
      'description': 'required',
    }, {
      'title.required': 'Judul To do wajib diisi',
      'description.required': 'Deskripsi To do wajib diisi',
    });

    Map<String, dynamic> data = request.all();

    Map<String, dynamic>? user = Auth().user();

    if (user != null) {
      var todos = await Todos().query().create({
        'user_id': Auth().id(),
        'title': data['title'],
        'description': data['description'],
      });

      return Response.json({
        'status': 'success',
        'message': 'To do berhasil dibuat',
        'data': todos,
      }, 201);
    } else {
      return Response.json({
        'status': 'error',
        'message': 'Pengguna tidak terautentikasi',
      }, 401);
    }
  }
  Future<Response> update(Request request, int id) async {
    request.validate({
      'title': 'required',
      'description': 'required',
    }, {
      'title.required': 'Judul To do wajib diisi',
      'description.required': 'Deskripsi To do wajib diisi',
    });

    Map<String, dynamic> data = request.all();

    Map<String, dynamic>? user = Auth().user();

    if (user != null) {
      var todo = await Todos()
          .query()
          .where('id', '=', id)
          .where('user_id', '=', Auth().id())
          .first();

      if (todo != null) {
        await Todos().query().where('id', '=', id).update({
          'title': data['title'],
          'description': data['description'],
        });

        return Response.json({
          'status': 'success',
          'message': 'To do berhasil diperbarui',
        });
      } else {
        return Response.json({
          'status': 'error',
          'message': 'To do tidak ditemukan atau bukan milik Anda',
        }, 404);
      }
    } else {
      return Response.json({
        'status': 'error',
        'message': 'Pengguna tidak terautentikasi',
      }, 401);
    }
  }

  Future<Response> destroy(Request request, int id) async {
    Map<String, dynamic>? user = Auth().user();

    if (user != null) {
      var todo = await Todos()
          .query()
          .where('id', '=', id)
          .where('user_id', '=', Auth().id())
          .first();

      if (todo != null) {
        await Todos().query().where('id', '=', id).delete();

        return Response.json({
          'status': 'success',
          'message': 'To do berhasil dihapus',
        });
      } else {
        return Response.json({
          'status': 'error',
          'message': 'To do tidak ditemukan atau bukan milik Anda',
        }, 404);
      }
    } else {
      return Response.json({
        'status': 'error',
        'message': 'Pengguna tidak terautentikasi',
      }, 401);
    }
  }
}

final TodosController todosController = TodosController();