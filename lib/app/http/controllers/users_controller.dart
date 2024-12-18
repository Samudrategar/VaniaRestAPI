import 'package:vania/vania.dart';
import 'package:vania_api/app/models/users.dart';

class UsersController extends Controller {
  Future<Response> index() async {
    Map? user = Auth().user();

    if (user != null) {
      user.remove('password');
      return Response.json({
        'status': 'success',
        'message': 'Data pengguna berhasil diambil',
        'data': user,
      });
    } else {
      return Response.json({
        'status': 'error',
        'message': 'Pengguna tidak terautentikasi',
      }, 401);
    }
  }

  Future<Response> updatePassword(Request request) async {
    request.validate({
      'current_password': 'required',
      'password': 'required|min_length:6|confirmed'
    }, {
      'current_password.required': 'Password saat ini wajib diisi',
      'password.required': 'Password baru wajib diisi',
      'password.min_length': 'Password baru harus memiliki minimal 6 karakter',
      'password.confirmed': 'Konfirmasi password tidak cocok',
    });

    String currentPassword = request.string('current_password');

    Map<String, dynamic>? user = Auth().user();

    if (user != null) {
      if (Hash().verify(currentPassword, user['password'])) {
        await Users().query().where ('id', '=', Auth().id()).update({
          'password': Hash().make(request.string('password')),
        });
        return Response.json({
          'status': 'success',
          'message': 'Password berhasil diperbarui',
        });
      } else {
        return Response.json({
          'status': 'error',
          'message': 'Password saat ini tidak cocok',
        }, 401);
      }
    } else {
      return Response.json({
        'status': 'error',
        'message': 'Pengguna tidak ditemukan',
      }, 404);
    }
  }
}

final UsersController usersController = UsersController();