import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';


Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 10.0,
  required String text,
  required VoidCallback function,
}) =>
    Container(
    width: width,
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(
          radius,
      ),
    ),
    child: MaterialButton(
      onPressed: function,
       child: Text(
         isUpperCase? text.toUpperCase() : text,
         style: const TextStyle(
           color: Colors.white,
         ),
       ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  ValueChanged? onSubmit,
  ValueChanged? onChanged,
  GestureTapCallback? onTap,
  required FormFieldValidator<String>? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isPassword = false,
  double radius = 10.0,
  bool isClickable = true,
}) => TextFormField(
  controller: controller,
  obscureText: isPassword,
  keyboardType: type,
  enabled: isClickable,
  onFieldSubmitted: onSubmit,
  onChanged: onChanged,
  validator: validate,
  onTap: onTap,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: suffix != null ? IconButton(
      onPressed: suffixPressed,
      icon: Icon(
        suffix
      ),
    ) : null,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          radius,
        )
    ),
  ),
);

Widget buildTaskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children:
        [
          CircleAvatar(
            radius: 40.0,
            child: Text(
              '${model['time']}',
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children:
              [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          IconButton(
            onPressed: ()
            {
              AppCubit.get(context).updateData(
                status: 'done',
                id: model['id'],
              );
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: ()
            {
              AppCubit.get(context).updateData(
                status: 'archive',
                id: model['id'],
              );
            },
            icon: Icon(
              Icons.archive,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    ),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteData(
      id: model['id'],
     );
  },
);

Widget taskBuilder({
  required List<Map> tasks,
}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
    separatorBuilder: (context, index) => myDivider(),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
);

Widget myDivider() => Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);

