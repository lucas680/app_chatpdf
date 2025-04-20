import 'package:app_chatpdf/ui/_core/listPdfs_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPdfScreen extends StatelessWidget {
  const AddPdfScreen({super.key});

  void _pickPdfFiles(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      Provider.of<ListpdfsProvider>(
        context,
        listen: false,
      ).addAllPdfs(result.files);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listpdfsProvider = Provider.of<ListpdfsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Adicionar PDFs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 42,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _pickPdfFiles(context),
                icon: const Icon(Icons.upload_file, color: Colors.white),
                label: const Text(
                  'Selecionar PDFs',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  listpdfsProvider.listPdfFiles.isEmpty
                      ? const Center(child: Text('Nenhum PDF adicionado.'))
                      : ListView.builder(
                        itemCount: listpdfsProvider.listPdfFiles.length,
                        itemBuilder: (context, index) {
                          final file = listpdfsProvider.listPdfFiles[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.red,
                              ),
                              title: Text(file.name),
                              subtitle: Text(
                                '${(file.size / 1024).toStringAsFixed(1)} KB',
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  listpdfsProvider.removePdf(index);
                                },
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
