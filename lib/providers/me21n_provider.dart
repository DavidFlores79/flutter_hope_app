import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/helpers/debouncer.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/supplier_provider.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ME21NProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/mi-endpoint';
  String jwtToken = '';
  ServerResponse? serverResponse;
  bool result = false;
  MaterialResponse? materialResponse;
  ME21NResponse? me21nResponse;
  CreateOrderResponse? createOrderResponse;
  List<Centro>? centrosUsuario = [];
  List<PedidoPos>? _posiciones = [];
  List<Materials>? materials = [];
  Materials _materialSelected = Materials();
  String quantity = '';
  String _claseDocumentoSelected = '';
  String _orgComprasSelected = '';
  String _centroDefault = '';
  String gpoCompras = '200';
  String almacen = '1000';
  String numeroProveedor = '';
  List<ClasesDocumento> _clases = [];
  List<OrgCompras> _orgCompras = [];
  List<String> clasesDocumentoProv = ['ZOCM', 'ZDTP', 'ZDCP'];

  final debouncer = Debouncer(duration: const Duration(milliseconds: 700));

  final StreamController<List<Materials>> _materialStreamController =
      StreamController.broadcast();

  Stream<List<Materials>> get materialStream =>
      _materialStreamController.stream;

  final NavigationService _navigationService = locator<NavigationService>();

  final storage = const FlutterSecureStorage();

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  get isLoading => _isLoading;

  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  List<PedidoPos>? get posiciones => _posiciones;

  set posiciones(List<PedidoPos>? value) {
    _posiciones = value;
    notifyListeners();
  }

  String get centroDefault => _centroDefault;

  set centroDefault(String value) {
    _centroDefault = value;
    notifyListeners();
  }

  String get orgComprasSelected => _orgComprasSelected;

  set orgComprasSelected(String value) {
    _orgComprasSelected = value;
    notifyListeners();
  }

  String get claseDocumentoSelected => _claseDocumentoSelected;

  set claseDocumentoSelected(String value) {
    _claseDocumentoSelected = value;
    notifyListeners();
  }

  Materials get materialSelected => _materialSelected;

  set materialSelected(Materials value) {
    _materialSelected = value;
    notifyListeners();
  }

  List<OrgCompras> get orgCompras => _orgCompras;

  set orgCompras(List<OrgCompras> value) {
    _orgCompras = value;
    notifyListeners();
  }

  List<ClasesDocumento> get clases => _clases;

  set clases(List<ClasesDocumento> value) {
    _clases = value;
    notifyListeners();
  }

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }

  ME21NProvider() {
    print('ME21NProvider inicializado');
    getCatalogs();
  }

  //Peticiones API
  Future<bool> getCatalogs() async {
    isLoading = true;
    result = false;
    print('Peticion ME21N - Get Catalogs');
    _endPoint = '/api/v1/me21n';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));
      // claseDocumentoSelected = clases.first.code;
      // orgComprasSelected = orgCompras.first.code;
      // posicionesSelected = [];
      posiciones = [];

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Catalogs ${response.body}');
          me21nResponse = ME21NResponse.fromJson(response.body);
          centrosUsuario = me21nResponse!.centrosUsuario;
          clases = me21nResponse!.clasesDocumento!;
          orgCompras = me21nResponse!.orgCompras!;
          orgComprasSelected = orgCompras.first.code!;
          gpoCompras = me21nResponse!.gpoCompras!;
          claseDocumentoSelected = clases.first.code!;
          centroDefault = centrosUsuario!.first.idcentro!;
          notifyListeners();
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoading = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
            (serverResponse?.message != null || serverResponse?.message != '')
                ? serverResponse!.message!
                : 'Error de Autenticación.',
          );
          break;
        case 404:
          isLoading = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(serverResponse?.message ?? 'Error 404.');
          notifyListeners();
          print('404: ${response.body}');
          break;
        case 422:
          isLoading = false;
          result = false;
          print('422: ${response.body}');
          ValidatorResponse validatorResponse =
              ValidatorResponse.fromJson(response.body);
          final Map<String, dynamic> errors = validatorResponse.errors.toMap();
          String messages = '${validatorResponse.message}\n';

          Iterable<dynamic> values = errors.values;
          for (final error in values) {
            Iterable<dynamic> errorStrings = error;
            for (final errorString in errorStrings) {
              print('error: $errorString');
              messages = '${messages + errorString}\n';
            }
          }

          Notifications.showSnackBar(messages);
          notifyListeners();
          break;
        case 500:
          isLoading = false;
          result = false;
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoading = false;
          result = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isLoading = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }

  Future<List<Materials>> searchMaterials(String query) async {
    print('Peticion API Search');
    _endPoint = '/api/v1/me21n/search';
    String numeroMaterial = '';
    String textoBreve = '';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    if (queryHasNumbers(query)) {
      numeroMaterial = query;
    } else {
      textoBreve = query;
    }

    final Map<String, dynamic> queryParameters = {
      'numero_material': numeroMaterial,
      'texto_breve': textoBreve,
      'centro': centroDefault,
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint', queryParameters);

    try {
      isLoading = true;
      materials = [];

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          isLoading = false;
          print('200: ${response.body}');
          materialResponse = MaterialResponse.fromJson(response.body);
          materials = materialResponse?.materials;
          notifyListeners();
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoading = false;
          materials = [];
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(Preferences.truncateMessage(
              serverResponse?.message ?? 'Error Desconocido.'));
          notifyListeners();
          print('404 ${serverResponse?.message}');
          break;
        case 422:
          isLoading = false;
          result = false;
          print('422: ${response.body}');
          ValidatorResponse validatorResponse =
              ValidatorResponse.fromJson(response.body);
          final Map<String, dynamic> errors = validatorResponse.errors.toMap();
          String messages = '${validatorResponse.message}\n';

          Iterable<dynamic> values = errors.values;
          for (final error in values) {
            Iterable<dynamic> errorStrings = error;
            for (final errorString in errorStrings) {
              print('error: $errorString');
              messages = '${messages + errorString}\n';
            }
          }
          break;
        case 500:
          isLoading = false;
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoading = false;
          materials = [];
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isLoading = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return materials!;
  }

  void getMaterialsByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      print('hay valor a buscar $value');
      final results = await searchMaterials(value);
      _materialStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301)).then(
      (value) => timer.cancel(),
    );
  }

  Future<bool> createOrder() async {
    isLoading = true;
    result = false;
    print('Peticion ME21N - Create');
    _endPoint = '/api/v1/me21n';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    // Modificar la lista antes de enviarla al backend
    List<PosicionZSTT> listaModificada = posiciones!.map((posicion) {
      return PosicionZSTT(
        cantidad: posicion.cantidad,
        numeroMaterial: posicion.numeroMaterial,
        centroReceptor: posicion.centroReceptor,
        unidadMedida: posicion.unidadMedida,
        esDevolucion: posicion.esDevolucion,
        almacen: posicion.almacen,
      );
    }).toList();

    final CreateOrderRequest pedido = CreateOrderRequest(
      pedido: PedidoME21N(
        cabeceraPedido: Cabecera(
          gpoCompras: gpoCompras,
          tipoPedido: claseDocumentoSelected,
          proveedorMercancias: numeroProveedor,
          cuentaProveedor: numeroProveedor,
          orgCompras: orgComprasSelected,
        ),
        posiciones: listaModificada,
      ),
    );

    print(pedido.toJson());

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      final response = await http
          .post(url, headers: headers, body: pedido.toJson())
          .timeout(const Duration(seconds: 20));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Create ME21N ${response.body}');
          createOrderResponse = CreateOrderResponse.fromJson(response.body);
          Notifications.showSnackBar(
            createOrderResponse!.trace ?? 'Creacion Satisfactoria.',
          );
          notifyListeners();
          break;
        case 400:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('400: ${response.body}');
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoading = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('404: ${response.body}');
          break;
        case 422:
          isLoading = false;
          result = false;
          print('422: ${response.body}');
          ValidatorResponse validatorResponse =
              ValidatorResponse.fromJson(response.body);
          final Map<String, dynamic> errors = validatorResponse.errors.toMap();
          String messages = '${validatorResponse.message}\n';

          Iterable<dynamic> values = errors.values;
          for (final error in values) {
            Iterable<dynamic> errorStrings = error;
            for (final errorString in errorStrings) {
              print('error: $errorString');
              messages = '${messages + errorString}\n';
            }
          }

          Notifications.showSnackBar(messages);
          notifyListeners();
          break;
        case 500:
          isLoading = false;
          print('500: ${response.body}');
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoading = false;
          result = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isLoading = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }

  bool queryHasNumbers(String query) {
    // Comprueba si el String solo contiene números
    if (RegExp(r'^[0-9]+$').hasMatch(query)) {
      return true;
    } else {
      return false;
    }
  }

  Supplier getSupplierSelected(BuildContext context) {
    final supplierProvider =
        Provider.of<SupplierProvider>(context, listen: false);
    Supplier supplierSelected = supplierProvider.supplierSelected;
    print('Supplier Selected ${supplierSelected.numeroProveedor}');
    return supplierSelected;
  }

  logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    _navigationService.navigateTo(LoginScreen.routeName);
  }
}
