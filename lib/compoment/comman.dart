import 'package:flutter/material.dart';

import '../controller/bottom_nav_bar_cubit/change_app_cubit.dart';

Widget NewTask(Map tasks, context) => Dismissible(
  key: Key(tasks['id'].toString()),
  child:   Padding(
    padding: const EdgeInsets.all(25),
    child: Container(

      decoration: BoxDecoration(

          color: Colors.purple, borderRadius: BorderRadius.circular(20)),

      child: Padding(

        padding: const EdgeInsets.all(15.0),

        child: Row(

          children: [

            Column(

              mainAxisSize: MainAxisSize.min,

              children: [

                Text(

                  '${tasks['title']}',

                  style: TextStyle(

                      fontSize: 20,

                      color: Colors.white,

                      fontWeight: FontWeight.bold),

                ),

                Text(

                  '${tasks['time']}',

                  style: TextStyle(

                      fontSize: 15,

                      color: Colors.white,

                      fontWeight: FontWeight.bold),

                ),

              ],

            ),

            SizedBox(

              width: 100,

            ),

            Column(

              children: [

                Text(

                  '${tasks['date']}',

                  style: TextStyle(

                    color: Colors.white,

                    fontSize: 15,

                    fontWeight: FontWeight.bold,

                  ),

                ),

                Row(

                  children: [

                    IconButton(

                        onPressed: () {

                          ChangeAppCubit.get(context).updateDatabase(

                              status: 'done', id: tasks['id']);

                        },

                        icon: Icon(Icons.check_box)),

                    IconButton(

                        onPressed: () {

                          ChangeAppCubit.get(context).updateDatabase(

                              status: 'archive', id: tasks['id']);

                        },

                        icon: Icon(Icons.archive)),

                  ],

                ),

              ],

            ),

          ],

        ),

      ),

    ),

  ),
  onDismissed: (direction)
  {

    ChangeAppCubit.get(context).deleteDatabase(id: tasks['id']);
  },
  background: Container(
    color: Colors.red,
    child: Icon(Icons.delete),
  ),
);

class NoTasks extends StatelessWidget {
  const NoTasks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu, color: Colors.black45,size: 50,),
          Text("No Tasks Yet, Please Add One", style: TextStyle(

              color: Colors.black45,
              fontSize: 20
          ),),
        ],
      ),
    );
  }

}