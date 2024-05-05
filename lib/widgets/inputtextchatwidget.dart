import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InputTextChatWidget extends StatelessWidget {
  const InputTextChatWidget(
      {super.key,
      required this.mensagemTextController,
      required this.handleSubmit,
      required this.imageGallery,
      required this.imageCam,
      this.image,
      required this.imageRemove});

  final TextEditingController mensagemTextController;
  final File? image;
  final Function(String mensagem) handleSubmit;
  final Function(ImageSource source) imageGallery;
  final Function(ImageSource source) imageCam;
  final Function() imageRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),

        child: Column(
          children: [
            if (image != null)
              Container(
                alignment: Alignment.centerLeft,
                height: 120,
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(image!),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red,
                      ),
                      child: IconButton(
                        onPressed: imageRemove,
                        iconSize: 15,

                        color: Colors.white,
                        icon: const Icon(
                            Icons.close_outlined,

                        ),
                      ),
                    )
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: Row(
                children: [
                  Flexible(
                      child: TextField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    controller: mensagemTextController,
                    cursorColor: Colors.green,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: EdgeInsets.all(20.0),
                        filled: true,
                        fillColor: Color(0xff2f3136),
                        labelText: 'Message',
                        hintStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 0),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              bottomLeft: Radius.circular(60)),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 0),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              bottomLeft: Radius.circular(60)),
                          gapPadding: 8.0,
                        )),
                    onSubmitted: (text) => handleSubmit(text),
                  )),
                  Container(
                    margin: const EdgeInsets.only(right: 4),
                    decoration: const BoxDecoration(
                      color: Color(0xff2f3136),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(60),
                          bottomRight: Radius.circular(60)),
                    ),
                    child: Center(
                        child: IconButton(
                      padding: const EdgeInsets.all(20),
                      onPressed: () => {_showOpcoesBottomSheet(context)},
                      icon: const Icon(Icons.camera_alt_outlined),
                      color: Colors.white,
                    )),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      onPressed: () =>
                          handleSubmit(mensagemTextController.text),
                      icon: const Icon(Icons.send_rounded),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void _showOpcoesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.folder_open,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  imageGallery(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  imageCam(ImageSource.camera);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
