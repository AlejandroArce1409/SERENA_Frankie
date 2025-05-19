import 'package:flutter/material.dart';
import 'Hito_matito.dart';
import 'calendariomamalon.dart';
import 'contadoramsiedad.dart';
import 'notitascoloridas.dart';
import 'calculadorashida.dart';
import 'Geolocalizador.dart';


class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({Key? key}) : super(key: key);

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;

    switch (_selectedIndex) {
      case 0:
        currentPage = Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffac0f2d), Color(0xff592c78)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15), // fondo semitransparente
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // se ajusta al contenido
                  children: [
                    const Text(
                      '🦝❤️Amamos tenerte con nosotros ❤️🦝',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/brale.png',
                      width: 180,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
        break;
      case 1:
        currentPage = const TeVeo();
        break;
      case 2:
        currentPage = const CalculadoraShida();
        break;
      case 3:
        currentPage = const TengoAmsiedad();
        break;
      case 4:
        currentPage =  CalendarioMamalon();
        break;
      case 5:
        currentPage =  NotitasColoridas();
        break;
      case 6:
        currentPage =  HitoMatito();
        break;
      default:
        currentPage = const Center(child: Text('Página no encontrada'));
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffac0f2d), Color(0xff592c78)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(child: currentPage),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xffB81736),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Geolocalizacion',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculadora',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Contador',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ad_units_outlined),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.abc_rounded),
            label: 'Notitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarms_sharp),
            label: 'Hitomatito',
          ),
        ],
      ),
    );
  }
}
