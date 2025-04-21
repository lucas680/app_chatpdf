import 'dart:io';
import 'package:app_chatpdf/ui/_core/app_requesters.dart';
import 'package:app_chatpdf/ui/_core/listPdfs_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPdfScreen extends StatefulWidget {
  const AddPdfScreen({super.key});

  @override
  State<AddPdfScreen> createState() => _AddPdfScreenState();
}

class _AddPdfScreenState extends State<AddPdfScreen> {
  bool loading = false;

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

  void _enviarArquivos(List<File> arquivos) async {
    setState(() => loading = true);
    try {
      await AppRequesters().enviarPdfs(arquivos);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'PDFs enviados com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blueAccent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao enviar: $e')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 42,
              child:
                  listpdfsProvider.listPdfFiles.isEmpty
                      ? const Icon(Icons.upload_file_rounded)
                      : IconButton(
                        onPressed:
                            loading
                                ? null
                                : () {
                                  if (listpdfsProvider
                                      .listPdfFiles
                                      .isNotEmpty) {
                                    final arquivos =
                                        listpdfsProvider.listPdfFiles
                                            .where((pf) => pf.path != null)
                                            .map((pf) => File(pf.path!))
                                            .toList();

                                    _enviarArquivos(arquivos);
                                  }
                                },
                        icon: const Icon(Icons.upload_file_rounded),
                      ),
            ),
          ),
        ],
        title: const Text('Adicionar PDFs'),
      ),
      body:
          loading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 42,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _pickPdfFiles(context),
                        icon: const Icon(
                          Icons.upload_file,
                          color: Colors.white,
                        ),
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
                              ? const Center(
                                child: Text('Nenhum PDF adicionado.'),
                              )
                              : ListView.builder(
                                itemCount: listpdfsProvider.listPdfFiles.length,
                                itemBuilder: (context, index) {
                                  final file =
                                      listpdfsProvider.listPdfFiles[index];
                                  return Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
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
