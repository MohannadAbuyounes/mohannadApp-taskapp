import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskapp/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:taskapp/modules/done_tasks/done_tasks_screen.dart';
import 'package:taskapp/modules/new_tasks/new_tasks_screen.dart';
import 'package:taskapp/shared/cubit/states.dart';
import 'package:taskapp/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates>
{


  AppCubit(): super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
// variables for todo app
  int currentIndex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex (int index)
  {
    currentIndex =index;
    emit(AppChangeBottomNavBarState());
  }

  // Database for (Todo app)
  List<Map> new_tasks =[];
  List<Map> done_tasks =[];
  List<Map> archived_tasks =[];
  late Database database;

  void createDatabase(){
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        // id integer
        // title String
        // date String
        // time String
        // status String

        print('database created');
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value)
    {
      database =value;
      emit(AppCreateDatabaseStates());
    });
  }

   insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
     await database.transaction((txn) => txn
        .rawInsert(
      'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
    )
        .then((value) {
      print('$value inserted successfully');
      emit(AppInsertDatabaseStates());
      getDataFromDatabase(database);

    }).catchError((error) {
      print('Error When Inserting New Record ${error.toString()}');
    }));
  }

 void getDataFromDatabase(database)  {

    new_tasks =[];
    done_tasks=[];
    archived_tasks=[];

      database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element){
      if(element['status'] == 'new'){
        new_tasks.add(element);
      }else if(element['status'] == 'done'){
        done_tasks.add(element);
      }else archived_tasks.add(element);
      });

      emit(AppGetDatabaseStates());
    });
  }

  void updateData({
  required String status,
    required int id,
}) async
  {
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status',id]).then((value)
     {
       getDataFromDatabase(database);
       emit(AppUpdateDatabaseStates());
     });
  }

  void deleteData({
    required int id,
  }) async
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseStates());
    });
  }

//logic for todo app
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState (
  {
    required bool isShow,
    required IconData icon,
  })
  {
    isBottomSheetShown =isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  //for Theme mode app (dark & light)
  bool isDark=false;
    ThemeMode appMode =ThemeMode.dark;
  void changeAppMode({bool ?fromShared})
  {
    if(fromShared!=null)
      isDark = fromShared;
    else
    isDark = !isDark;
    CacheHelper.putData(key: 'isDark', value: isDark).then((value)
    {
      emit(AppChangeModeStates());
    });
}
}