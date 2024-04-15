import "package:flutter/material.dart";
import "package:login_alternativo/componentes/my_list_tile.dart";

class MyDrawer extends StatelessWidget{
  final void Function()? onPerfil;
  final void Function()? onCerrar;
  const MyDrawer({
    super.key,
    required this.onPerfil,
    required this.onCerrar,
    });

  @override
  Widget build(BuildContext context){
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          //Header
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 64,
              ),
            ),


            //Home
            MyListTile(
              icon: Icons.home,
              text: 'Hogar',
              onTap: () => Navigator.pop(context),
            ),

            //Perfil
            MyListTile(
              icon: Icons.person,
              text: 'Perfil',
              onTap: onPerfil,
            ),

            //Divisor
            Divider(color: Colors.white),

            //Cerrar sesion
            MyListTile(
              icon: Icons.logout,
              text: 'Cerrar sesión',
              onTap: onCerrar,
            ),
        ],
      ),
    );
  }
}