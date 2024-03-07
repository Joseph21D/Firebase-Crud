import 'dart:io';

import 'package:flutter/material.dart';
import 'package:crud/services/select_image.dart';
import 'package:crud/services/upload_image.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({
    super.key,
  });

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  File? imageToUpload;

  void _clearImage() {
    setState(() {
      imageToUpload = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
          child: Text(
            'Add Image',
            style: TextStyle(color: Colors.white),
          ),
        ) 
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
                child: imageToUpload != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      imageToUpload!,
                      fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
                      alignment: Alignment.center,
                    ),
                  ) : const SizedBox(),
              ),
              if (imageToUpload != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: _clearImage,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close, 
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              final image = await getImage();
              if(image != null){
                setState(() {
                  imageToUpload = File(image.path);
                });
              }
            }, 
            child: const Text("Seleccionar Imagen")
          ),
          ElevatedButton(
            onPressed: () async {
              if(imageToUpload == null){
                return;
              }

              final uploaded = await uploadImage(imageToUpload!);

              if(uploaded){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Imagen subida correctamente"))
                );
                setState(() {
                  imageToUpload = null;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Error al subir la imagen"))
                );
              }
            }, 
            child: const Text("Subir Imagen")
          )
        ],
      )
    );
  }
}