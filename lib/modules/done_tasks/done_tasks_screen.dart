import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/shared/cubit/states.dart';
import '../../../shared/component/components.dart';
import '../../../shared/cubit/cubit.dart';


class DoneTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var tasks =AppCubit.get(context).done_tasks;
        return tasksBuilder(
            tasks: tasks
        );
      },
    );
  }
}