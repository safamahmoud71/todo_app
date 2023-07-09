import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../views/archived_screen.dart';
import '../../views/done_screen.dart';
import '../../views/tasks_screen.dart';
import 'change_app_state.dart';

class ChangeAppCubit extends Cubit<ChangeAppState> {
  ChangeAppCubit() : super(InitialChangeAppState()) {
    // TODO: implement BottomNavBarCubit
  }
  static ChangeAppCubit get(context) => BlocProvider.of(context);
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  int currentIndex = 0;
  List<Widget> screens = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  List<String> titles = ['Tasks', 'Done Tasks', 'archived Tasks'];

  void ChangeBottomNav(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBar());
  }

  late Database database;

  createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database is created');
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, time TEXT,date TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error while creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDatebase(database);

        print('database opened');
        emit(DataBaseCreated());
      },
    );
  }

   insertDatabase(
      {@required title, @required time, @required date}) async {
    return await database.transaction((txn) async {
      txn.rawInsert(
              'INSERT INTO tasks(title , time ,date ,  status) VALUES("$title" ,"$time","$date" ,"new")')
          .then((value) {
        print('$value is inserted');
        emit(InsertDatabase());
        getDatebase(database);
      }).catchError((onError) {
        print('there is error in inserting data : $onError');
      });
    });
  }

  void getDatebase(database)  {
    newTasks =[];
    doneTasks= [];
    archivedTasks= [];

    emit(LoadingData());
      database.rawQuery('SELECT * FROM tasks').then((value) {
        value.forEach((element)
            {
              if(element['status']=='done')
               {
                doneTasks.add(element);
               }
              else if (element['status']=='new')
                {
                  newTasks.add(element);
                }
              else
                archivedTasks.add(element);

            }


        );
        emit(GetDatabase());
      });;
  }

  void updateDatabase({
    required String status ,
    required int id,
}) {

      database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          getDatebase(database);
          emit(UpdateDatabase());
      });

  }
  void deleteDatabase({required int id}) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
    getDatebase(database);
    emit(DeleteDatabase());
  }

  bool isBottomSheet = false;
  IconData iconBottom = Icons.edit;

  void ChangeBottomSheet({
    required bool show,
    required IconData iconB,
  }) {
    isBottomSheet = show;
    iconBottom = iconB;
    emit(ChangeBottomsheet());
  }
}
