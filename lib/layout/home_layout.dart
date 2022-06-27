import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


class HomeLayout extends StatelessWidget
{

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state)
        {
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (context, state)
        {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
          key: scaffoldKey,

          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
          ),
          body: state is AppGetDatabaseLoadingState ? const Center(child: CircularProgressIndicator()) :
          cubit.screens[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: ()
            {
              if (cubit.isBottomSheetShown)
              {
                if(formKey.currentState!.validate())
                {
                  cubit.insertToDatabase(
                    title: titleController.text,
                    time: timeController.text,
                    date: dateController.text,
                  );
                  titleController.clear();
                  timeController.clear();
                  dateController.clear();
                }
              } else
                {
                scaffoldKey.currentState?.showBottomSheet(
                      (context) => Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                        [
                          defaultFormField(
                            controller: titleController,
                            type: TextInputType.text,
                            validate: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'title must not be empty';
                              } else
                              {
                                return null;
                              }
                            },
                            label: 'Task title',
                            prefix: Icons.title,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                            controller: timeController,
                            type: TextInputType.datetime,
                            onTap: ()
                            {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                timeController.text = value!.format(context).toString();
                              });
                            },
                            validate: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'you must enter time';
                              } else
                              {
                                return null;
                              }
                            },
                            label: 'Task Time',
                            prefix: Icons.watch_later_outlined,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                            controller: dateController,
                            type: TextInputType.datetime,
                            onTap: ()
                            {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2050-02-15'),
                              ).then((value)
                              {
                                dateController.text = DateFormat.yMMMd().format(value!);
                              });
                            },
                            validate: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'you must enter date';
                              } else
                              {
                                return null;
                              }
                            },
                            label: 'Task Date',
                            prefix: Icons.calendar_today,
                          ),
                        ],
                      ),
                    ),
                  ),
                  elevation: 20.0,
                ).closed.then((value) {
                  cubit.changeBottomSheetState(
                    isShow: false,
                    icon: Icons.edit,
                  );
                });
                cubit.changeBottomSheetState(
                  isShow: true,
                  icon: Icons.add,
                );
                }
              },
            child: Icon(
              cubit.fabIcon,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 15.0,
            currentIndex: cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeIndex(index);
            },
            items:
            const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                ),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_circle_outlined,
                ),
                label: 'Done',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive_outlined,
                ),
                label: 'Archived',
              ),
            ],
          ),
          );
          },
      ),
    );
  }

}


