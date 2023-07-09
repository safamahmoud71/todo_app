import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/bottom_nav_bar_cubit/change_app_state.dart';
import 'package:todo_app/controller/bottom_nav_bar_cubit/change_app_cubit.dart';



class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangeAppCubit()..createDatabase(),
      child: BlocConsumer<ChangeAppCubit, ChangeAppState>(
        listener: (context, state) {
          if(state is InsertDatabase)
            {
               Navigator.pop(context);
            }
        },
        builder: (context, state) {
          ChangeAppCubit cubit = ChangeAppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: state is LoadingData
                ? const Center(child: CircularProgressIndicator())
                : cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: ChangeAppCubit.get(context).currentIndex,
              onTap: (index) {
                cubit.ChangeBottomNav(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: 'Archive'),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheet) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDatabase(title: titleController.text,
                        time:timeController.text,
                        date: dateController.text);
                    // insertDatabase(
                    //   title: titleController.text,
                    //   date: dateController.text,
                    //   time: timeController.text,
                    // ).then((value) {
                    //   getDatebase(database).then((value) {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   tasksToDo = value;
                    //     //   print(tasksToDo);
                    //     //   isBottomSheet = false;
                    //     //   iconBottom = Icons.edit;
                    //     // });
                    //   });
                    // });
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet((context) => Padding(
                            padding: const EdgeInsets.all(25),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blueGrey[200],
                              ),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: titleController,
                                      decoration: const InputDecoration(
                                        label: Text('Task title'),
                                        prefix: Icon(Icons.title),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ' you must enter title';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: timeController,
                                      decoration: const InputDecoration(
                                        label: Text('Time'),
                                        prefix:
                                            Icon(Icons.watch_later_outlined),
                                      ),
                                      onTap: () {
                                        showTimePicker(
                                          initialTime: TimeOfDay.now(),
                                          context: context,
                                        ).then((value) {
                                          timeController.text =
                                              value!.format(context);
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ' you must enter time';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    TextFormField(
                                      controller: dateController,
                                      decoration: const InputDecoration(
                                        label: Text('Date'),
                                        prefix: Icon(Icons.date_range),
                                      ),
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2050))
                                            .then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value!);
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ' you must enter date';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.ChangeBottomSheet(show: false, iconB: Icons.edit);
                  });
                  cubit.ChangeBottomSheet(show: true, iconB: Icons.add);
                }
              },
              child: Icon(cubit.iconBottom),
            ),
          );
        },
      ),
    );
  }


}
