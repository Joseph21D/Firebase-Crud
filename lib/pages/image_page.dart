import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crud/services/select_multi_images.dart';
import 'package:crud/services/upload_image.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key,});
  
  @override
  State<ImagePage> createState() => _ImagePage();
}

class _ImagePage extends State<ImagePage> {
  List<File?> imagesToUpload = [];

  void _clearImage(int index) {
    setState(() {
      imagesToUpload[index] = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<File?> filteredImages = imagesToUpload.where((image) => image != null).toList();

    // Verificar si todas las imágenes están limpias para desactivar el botón "Subir Imágenes a Firebase"
    bool allImagesCleared = imagesToUpload.every((image) => image == null);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Agregar Imágenes',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: filteredImages.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 100, // Ancho fijo para cada imagen
                  height: 100, // Altura fija para cada imagen
                  margin: const EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          filteredImages[index]!,
                          fit: BoxFit.cover, // Ajustar imagen para cubrir el contenedor
                          width: double.infinity, // Utilizar todo el ancho disponible
                          height: double.infinity, // Utilizar toda la altura disponible
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () {
                            _clearImage(imagesToUpload.indexOf(filteredImages[index]));
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              size: 15,
                              Icons.close,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final List<XFile> selectedImages = await getImages();
                    setState(() {
                      imagesToUpload.addAll(selectedImages.map((image) => File(image.path)));
                    });
                  },
                  child: const Text("Seleccionar Imágenes"),
                ),
                ElevatedButton(
                  onPressed: !allImagesCleared && imagesToUpload.isNotEmpty ? () async {
                    bool uploaded = false;
                    for (int i = 0; i < imagesToUpload.length; i++) {
                      if (imagesToUpload[i] != null) {
                        uploaded = await uploadImage(imagesToUpload[i]!);
                        if (uploaded) {
                          setState(() {
                            imagesToUpload[i] = null;
                          });
                        }
                      }
                    }
                    if (uploaded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Imágenes subidas correctamente"),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Error al subir las imágenes"),
                        ),
                      );
                    }
                  } : null,
                  child: const Text("Subir Imágenes a Firebase"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}