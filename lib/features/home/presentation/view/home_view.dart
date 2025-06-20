import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/common/snackbar/my_snackbar.dart';
import 'package:student_management/core/storage/hive_storage.dart';
import 'package:student_management/features/auth/presentation/view/login_view.dart';
import 'package:student_management/features/home/presentation/view_model/home_state.dart';
import 'package:student_management/features/home/presentation/view_model/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: _isDarkTheme cannot be updated here because this is StatelessWidget.
    // To add theme toggle, convert this widget to StatefulWidget and manage state.
    final bool isDarkTheme = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Show logout snackbar
              showMySnackBar(
                context: context,
                message: 'Logging out...',
                color: Colors.red,
              );

              // Clear Hive storage and navigate to login
              HiveStorage.logout();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginView()),
                (route) => false,
              );

              // Alternatively, if you want to call bloc logout method:
              // context.read<HomeViewModel>().logout(context);
            },
          ),
          Switch(
            value: isDarkTheme,
            onChanged: (value) {
              // Theme change logic here
              // Since StatelessWidget, you can't update state here.
              // Convert to StatefulWidget if you want to handle this.
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return state.views.elementAt(state.selectedIndex);
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'DASHBOARD',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'OFFERS',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'COMMUNITY',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'PROFILE',
              ),
            ],
            currentIndex: state.selectedIndex,
            selectedItemColor: Colors.white,
            onTap: (index) {
              context.read<HomeViewModel>().onTabTapped(index);
            },
          );
        },
      ),
    );
  }
}
