import 'package:flutter/material.dart';
import 'package:gerente_loja/widgets/add_size_dialog.dart';

class ProductSizesField extends FormField<List> {
  ProductSizesField({
    Key? key,
    required BuildContext context,
    required List initialValue,
    required FormFieldSetter<List> onSaved,
    required FormFieldValidator<List> validator,
  }) : super(
            key: key,
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (state) {
              return SizedBox(
                height: 34,
                child: GridView(
                    padding: EdgeInsets.symmetric(
                      vertical: 4,
                    ),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5,
                    ),
                    children: state.value!.map((size) {
                      return GestureDetector(
                        onLongPress: () {
                          state.didChange(state.value!..remove(size));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: Colors.pinkAccent,
                              width: 3,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            size,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList()
                      ..add(
                        GestureDetector(
                          onTap: () async {
                            String newSize = await showDialog(
                                context: context,
                                builder: (context) => AddSizeDialod());
                            if (newSize != "") {
                              state.didChange(state.value!..add(newSize));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                color: state.hasError
                                    ? Colors.red
                                    : Colors.pinkAccent,
                                width: 3,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "+",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )),
              );
            });
}
