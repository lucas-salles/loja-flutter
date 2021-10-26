import 'package:flutter/material.dart';
import 'package:gerente_loja/widgets/image_source_sheet.dart';

class ImagesFieldWidget extends FormField<List> {
  ImagesFieldWidget(
      {Key? key,
      required BuildContext context,
      required FormFieldSetter<List> onSaved,
      required FormFieldValidator<List> validator,
      required List initialValue})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 124,
                    padding: EdgeInsets.only(
                      top: 16,
                      bottom: 8,
                    ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: state.value!.map<Widget>((image) {
                        return Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(
                            right: 8,
                          ),
                          child: GestureDetector(
                            child: image is String
                                ? Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    image,
                                    fit: BoxFit.cover,
                                  ),
                            onLongPress: () {
                              state.didChange(state.value!..remove(image));
                            },
                          ),
                        );
                      }).toList()
                        ..add(
                          GestureDetector(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Icon(
                                Icons.camera_enhance,
                                color: Colors.white,
                              ),
                              color: Colors.white.withAlpha(50),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => ImageSourceSheet(
                                        onImageSelected: (image) {
                                          state.didChange(
                                              state.value!..add(image));
                                          Navigator.of(context).pop();
                                        },
                                      ));
                            },
                          ),
                        ),
                    ),
                  ),
                  state.hasError
                      ? Text(
                          state.errorText!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      : Container(),
                ],
              );
            });
}
