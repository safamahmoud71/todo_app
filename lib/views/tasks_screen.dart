import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/controller/bottom_nav_bar_cubit/change_app_cubit.dart';
import 'package:todo_app/controller/bottom_nav_bar_cubit/change_app_state.dart';

import '../compoment/comman.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangeAppCubit, ChangeAppState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        List tasks = ChangeAppCubit.get(context).newTasks;
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




