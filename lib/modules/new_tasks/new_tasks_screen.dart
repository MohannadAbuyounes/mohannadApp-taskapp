import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/shared/component/components.dart';
import 'package:taskapp/shared/cubit/cubit.dart';
import 'package:taskapp/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var tasks =AppCubit.get(context).new_tasks;
        return tasksBuilder(
            tasks: tasks
        );
      },
    );
  }
}
