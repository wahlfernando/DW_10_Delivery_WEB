import 'package:mobx/mobx.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/ui/helpers/loader.dart';
import '../../../core/ui/helpers/messages.dart';
import '../../../core/ui/helpers/upload_html_helper.dart';
import 'product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/env/env.dart';
import '../../../core/extensions/format_extensions.dart';
import '../../../core/ui/helpers/size_extensions.dart';
import '../../../core/ui/styles/text_styles.dart';

class ProductDetailPage extends StatefulWidget {
  final int? productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with Loader, Messages {
  final controller = Modular.get<ProductDetailController>();
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final priceEC = TextEditingController();
  final descriptionEC = TextEditingController();

  @override
  void dispose() {
    nameEC.dispose();
    priceEC.dispose();
    descriptionEC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      reaction((_) => controller.status, (status) {
        switch (status) {
          case ProductDetailStateStatus.initial:
            break;
          case ProductDetailStateStatus.loading:
            showLoader();
            break;
          case ProductDetailStateStatus.loaded:
            final model = controller.productModel!;
            nameEC.text = model.name;
            priceEC.text = model.price.currencyPTBR;
            descriptionEC.text = model.description;
            hideLoader();
            break;
          case ProductDetailStateStatus.error:
            hideLoader();
            showError(controller.errorMessage ?? '');
            break;
          case ProductDetailStateStatus.errorLoadProduct:
            hideLoader();
            showError('Erro ao carregar o produto para elteração');
            Navigator.of(context).pop();
            break;
          case ProductDetailStateStatus.upload:
            hideLoader();
            break;
          case ProductDetailStateStatus.deleted:
          case ProductDetailStateStatus.saved:
            hideLoader();
            Navigator.pop(context);
            break;
        }
      });
      controller.loadProduct(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final witchButtonAction = context.percentWidth(.5);

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${widget.productId != null ? 'Alterar' : 'Adiconar'} Produto',
                      textAlign: TextAlign.center,
                      style: context.textStyles.textTitle.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Observer(
                        builder: (_) {
                          if (controller.imagePath != null) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                '${Env.instance.get('backend_base_url')}${controller.imagePath}',
                                width: 200,
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: TextButton(
                          onPressed: () {
                            UploadHtmlHelper()
                                .startUpload(controller.uploadImageProduct);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.8),
                          ),
                          child: Observer(
                            builder: (_) {
                              return Text(
                                '${controller.imagePath == null ? 'Adicionar' : 'Alterar'} Foto',
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameEC,
                          validator: Validatorless.required('Nome Obrigatório'),
                          decoration: const InputDecoration(
                            label: Text('Nome'),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: priceEC,
                          validator:
                              Validatorless.required('Preço Obrigatório'),
                          decoration: const InputDecoration(
                            label: Text('Preço'),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(moeda: true),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: descriptionEC,
                validator: Validatorless.required('Descrição Obrigatória'),
                maxLines: null,
                minLines: 10,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  label: Text('Descrição'),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: witchButtonAction,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: witchButtonAction / 3,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancelar',
                            style: context.textStyles.textBold,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.productId != null,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: witchButtonAction / 3,
                          height: 60,
                          child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Confirmar'),
                                    content: Text(
                                      'Confirmar a exclusão do produto ${controller.productModel!.name}?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Cancelar',
                                          style: context.textStyles.textBold
                                              .copyWith(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          controller.deleteProduct();
                                        },
                                        child: Text(
                                          'Confirmar',
                                          style: context.textStyles.textBold,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: Text(
                              'Deletar',
                              style: context.textStyles.textBold
                                  .copyWith(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: witchButtonAction / 3,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            final valid =
                                formKey.currentState?.validate() ?? false;
                            if (valid) {
                              if (controller.imagePath == null) {
                                showWarning(
                                  'Imagem obrigatória! Por favor, cliquem em Adicionar Foto',
                                );
                                return;
                              }

                              controller.save(
                                nameEC.text,
                                UtilBrasilFields.converterMoedaParaDouble(
                                    priceEC.text),
                                descriptionEC.text,
                              );
                            }
                          },
                          child: Text(
                            'Salvar',
                            style: context.textStyles.textBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
