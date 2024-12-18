import 'package:vania/vania.dart';
import 'package:vania_api/app/http/controllers/customers_controller.dart';
import 'package:vania_api/app/http/controllers/orders_controller.dart';
import 'package:vania_api/app/http/controllers/products_controller.dart';
import 'package:vania_api/app/http/controllers/productnotes_controller.dart';
import 'package:vania_api/app/http/controllers/vendors_controller.dart';
import 'package:vania_api/app/http/controllers/users_controller.dart';
import 'package:vania_api/app/http/controllers/todos_controller.dart';
import 'package:vania_api/app/http/controllers/auth_controller.dart';
import 'package:vania_api/app/http/middleware/authenticate.dart';

class ApiRoute implements Route {
  @override
  void register() {
    Router.group((){
      Router.post('/register', authController.register);
      Router.post('/login', authController.login);
    }, prefix: '/auth');

    Router.group(() {
      Router.patch('/update-password', usersController.updatePassword);
      Router.get('/', usersController.index);
    }, prefix: '/user', middleware: [AuthenticateMiddleware()]);

    Router.group(() {
      Router.post('/todo', todosController.store);
      Router.put('/todo', todosController.update);
      Router.delete('/todo', todosController.destroy);
    }, prefix: '/user', middleware: [AuthenticateMiddleware()]);

    Router.group(() { 
      Router.get('/', vendorsController.index); 
      Router.post('/', vendorsController.store); 
      Router.get('/{id}', vendorsController.show); 
      Router.put('/{id}', vendorsController.update); 
      Router.delete('/{id}', vendorsController.destroy); 
    }, prefix: '/vendors'); 

    Router.group(() { 
      Router.get('/', customerController.index); 
      Router.post('/', customerController.store); 
      Router.get('/{id}', customerController.show); 
      Router.put('/{id}', customerController.update); 
      Router.delete('/{id}', customerController.destroy); 
    }, prefix: '/customers'); 
 
    Router.group(() { 
      Router.get('/', productsController.index); 
      Router.post('/', productsController.store); 
      Router.get('/{id}', productsController.show); 
      Router.put('/{id}', productsController.update); 
      Router.delete('/{id}', productsController.destroy); 
    }, prefix: '/products'); 
 
    Router.group(() { 
      Router.get('/', productnotesController.index); 
      Router.post('/', productnotesController.store); 
      Router.get('/{id}', productnotesController.show); 
      Router.put('/{id}', productnotesController.update); 
      Router.delete('/{id}', productnotesController.destroy); 
    }, prefix: '/product-notes'); 
 
    Router.group(() { 
      Router.get('/', ordersController.index); 
      Router.post('/', ordersController.store); 
      Router.get('/{id}', ordersController.show); 
      Router.delete('/{id}', ordersController.destroy); 
    }, prefix: '/orders'); 
  }
}
