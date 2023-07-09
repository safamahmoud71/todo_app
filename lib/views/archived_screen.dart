
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../compoment/comman.dart';
import '../controller/bottom_nav_bar_cubit/change_app_cubit.dart';
import '../controller/bottom_nav_bar_cubit/change_app_state.dart';
class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<ChangeAppCubit, ChangeAppState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        List tasks = ChangeAppCubit.get(context).archivedTasks;
        if (tasks.isNotEmpty) {
          return Center(
            child: ListView.separated(
                itemBuilder: (context, index) => NewTask(tasks[index], context),
                separatorBuilder: (context, index) => Container(),
                itemCount: tasks.length),
          );
        } else {
          return const NoTasks() ;
        }
      },

    );
  }
}
