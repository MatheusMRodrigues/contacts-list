import 'dart:convert';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:technical/controllers/contact_controller.dart';
import 'package:technical/models/contact_model.dart' as contact_model;
import 'package:technical/models/phone_model.dart';
import 'package:technical/shared/functions.dart';
import 'package:technical/utils/palette.dart';
import 'package:technical/utils/viacep.dart';
import 'package:technical/widgets/app_bar.dart';
import 'package:technical/widgets/contact_form_avatar.dart';
import 'package:technical/widgets/contact_form_input.dart';
import 'package:technical/widgets/device_contacts_list.dart';

class NewContactView extends StatefulWidget {
  const NewContactView({Key? key}) : super(key: key);

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  String? contactImage;
  String? lastText;
  bool showAddresForm = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController complementController = TextEditingController();

  final List<TextEditingController> _phoneControllersList = [];

  final List<ContactFormInput> _phonesInputList = [];

  final ContactController contactController = Get.find<ContactController>();

  submitFormData() async {
    try {
      var saveContactResult = await contactController.saveContact(
          contact_model.Contact(
            avatar: contactImage,
            name: nameController.text,
            zipCode: zipCodeController.text,
            city: cityController.text,
            state: stateController.text,
            address: addressController.text,
            number: numberController.text,
            complement: complementController.text,
          ),
          _phoneControllersList
              .map<Phone>((element) => Phone(phone: element.text))
              .toList());
      Logger().wtf(saveContactResult);
      await contactController.loadAllContactsWithPagination(1, true);
      Get.back();
    } catch (e) {
      Logger().e(e);
    }
  }

  addressFormHandler() {
    if (showAddresForm) {
      return [
        ContactFormInput(
          label: 'Cidade',
          centeredLabel: false,
          controller: cityController,
          textInputType: TextInputType.text,
        ),
        const SizedBox(
          height: 10,
        ),
        ContactFormInput(
          label: 'UF',
          centeredLabel: false,
          controller: stateController,
          textInputType: TextInputType.text,
        ),
        const SizedBox(
          height: 10,
        ),
        ContactFormInput(
          label: 'Logradouro',
          centeredLabel: false,
          controller: addressController,
          textInputType: TextInputType.text,
        ),
        const SizedBox(
          height: 10,
        ),
        ContactFormInput(
          label: 'Número',
          centeredLabel: false,
          controller: numberController,
          textInputType: TextInputType.number,
        ),
        const SizedBox(
          height: 10,
        ),
        ContactFormInput(
          label: 'Complemento',
          centeredLabel: false,
          controller: complementController,
          textInputType: TextInputType.text,
        ),
      ];
    }
    return [const SizedBox()];
  }

  zipCodeHandler() async {
    try {
      if (zipCodeController.text != lastText) {
        if (zipCodeController.text.length > 8) {
          ViaCep result = await getAddressFromZipCode(zipCodeController.text);
          setState(() {
            cityController.text = result.localidade!;
            stateController.text = result.uf!;
            addressController.text = result.logradouro!;
            complementController.text = result.complemento!;
          });
          if (!mounted) return;
          FocusScope.of(context).unfocus();
          setState(() {
            showAddresForm = true;
          });
        }
      }
      lastText = zipCodeController.text;
    } catch (e) {
      Logger().e(e);
    }
  }

  importContactHandler(BuildContext context, BoxConstraints constraints) async {
    MagicMask phoneMask = MagicMask.buildMask('(99) 99999-9999');
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => DeviceContactsList(
              constraints: constraints,
              onClickContact: (contact) {
                setState(() {
                  nameController.text = contact['name'];
                  _phoneControllersList.clear();
                  _phonesInputList.clear();
                  contact['phones'].forEach((element) {
                    TextEditingController phoneController =
                        TextEditingController();
                    phoneController.text = phoneMask.getMaskedString(element);
                    _phoneControllersList.add(phoneController);
                    ContactFormInput contactFormInput = ContactFormInput(
                      label: 'TELEFONE',
                      centeredLabel: false,
                      controller: phoneController,
                      textInputType: TextInputType.number,
                      textInputMask: TextInputMask(mask: '(99) 99999-9999'),
                    );
                    _phonesInputList.add(contactFormInput);
                  });
                });
                Get.back();
              },
            ));
  }

  @override
  void initState() {
    TextEditingController phoneController = TextEditingController();
    zipCodeController.addListener(zipCodeHandler);
    _phoneControllersList.add(phoneController);
    ContactFormInput contactFormInput = ContactFormInput(
      label: 'TELEFONE',
      centeredLabel: false,
      controller: _phoneControllersList[0],
      textInputType: TextInputType.number,
      textInputMask: TextInputMask(mask: '(99) 99999-9999'),
    );
    _phonesInputList.add(contactFormInput);
    super.initState();
  }

  @override
  void dispose() {
    zipCodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    addressController.dispose();
    complementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                  child: CustomAppBar(
                    title: 'NOVO CONTATO',
                    action: true,
                    actionFunction: () {
                      importContactHandler(context, constraints);
                    },
                    actionIcon: const Icon(Icons.download_outlined),
                  ),
                ),
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (Rect rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.white
                        ],
                        stops: [
                          0.0,
                          0.07,
                          0.9,
                          1.0
                        ], // 10% white, 80% transparent, 10% white
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstOut,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 35.0, right: 35.0, bottom: 35.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            ContactFormAvatar(
                              onImageSelected: (XFile file) async {
                                List<int> imageBytes = await file.readAsBytes();
                                contactImage = base64Encode(imageBytes);
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Form(
                              child: Column(
                                children: [
                                  ContactFormInput(
                                    label: 'NOME',
                                    centeredLabel: true,
                                    controller: nameController,
                                    textInputType: TextInputType.text,
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    'TELEFONES',
                                    style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                        fontSize: constraints.maxWidth * 0.04,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _phonesInputList.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Flexible(
                                              child: _phonesInputList[index],
                                            ),
                                            _phonesInputList.length > 1
                                                ? IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _phoneControllersList
                                                            .removeAt(index);
                                                        _phonesInputList
                                                            .removeAt(index);
                                                      });
                                                    },
                                                    iconSize:
                                                        constraints.maxWidth *
                                                            0.06,
                                                    splashRadius:
                                                        constraints.maxWidth *
                                                            0.06,
                                                    icon: const Icon(
                                                      Icons.close,
                                                    ),
                                                  )
                                                : const SizedBox()
                                          ],
                                        );
                                      }),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: constraints.maxWidth,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        final phoneController =
                                            TextEditingController();
                                        final phoneInput = ContactFormInput(
                                          label: 'TELEFONE',
                                          centeredLabel: false,
                                          controller: phoneController,
                                          textInputType: TextInputType.number,
                                          textInputMask: TextInputMask(
                                              mask: '(99) 99999-9999'),
                                        );
                                        setState(() {
                                          _phoneControllersList
                                              .add(phoneController);
                                          _phonesInputList.add(phoneInput);
                                        });
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                          Palette.pink,
                                        ),
                                        side: MaterialStateProperty.all(
                                          BorderSide(
                                            color: Palette.pink,
                                          ),
                                        ),
                                      ),
                                      child: const Icon(Icons.add),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    'ENDEREÇO',
                                    style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                        fontSize: constraints.maxWidth * 0.04,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                  ContactFormInput(
                                    label: 'CEP',
                                    centeredLabel: false,
                                    controller: zipCodeController,
                                    textInputType: TextInputType.text,
                                    textInputMask:
                                        TextInputMask(mask: ['99999-999']),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ...addressFormHandler(),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: constraints.maxWidth,
                                    height: 50,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        submitFormData();
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                          Palette.white,
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Palette.pink,
                                        ),
                                        side: MaterialStateProperty.all(
                                          BorderSide(
                                            color: Palette.pink,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'SALVAR',
                                        style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                            fontSize:
                                                constraints.maxWidth * 0.04,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
