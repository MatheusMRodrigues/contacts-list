import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstore/localstore.dart';
import 'package:technical/controllers/phone_controller.dart';
import 'package:technical/utils/notification_helper.dart';
import 'package:technical/utils/palette.dart';
import 'package:technical/widgets/app_bar.dart';
import 'package:technical/widgets/contact_header.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactView extends StatefulWidget {
  final int id;
  final ImageProvider? avatar;
  final String name;
  final String zipCode;
  final String city;
  final String state;
  final String address;
  final String number;
  final String complement;

  const ContactView(
      {Key? key,
      required this.id,
      required this.avatar,
      required this.name,
      required this.zipCode,
      required this.city,
      required this.state,
      required this.address,
      required this.number,
      required this.complement})
      : super(key: key);

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  final PhoneController phoneController = Get.find<PhoneController>();

  bool haveReminder = false;
  Map<String, dynamic>? reminder;

  checkReminder() async {
    final db = Localstore.instance;
    final data =
        await db.collection('reminders').doc(widget.id.toString()).get();
    if (data != null) {
      if (DateTime.now().isBefore(DateTime.parse(data['date']))) {
        setState(() {
          haveReminder = true;
          reminder = data;
        });
      }
      return;
    }
    setState(() {
      haveReminder = false;
      reminder = null;
    });
  }

  setReminder(BoxConstraints constraints) {
    DatePicker.showDateTimePicker(
      context,
      theme: DatePickerTheme(
        containerHeight: constraints.maxHeight * 0.2,
        cancelStyle: GoogleFonts.nunitoSans(
          textStyle: TextStyle(
            fontSize: constraints.maxWidth * 0.04,
            fontWeight: FontWeight.w700,
            color: Palette.lightGrey,
            letterSpacing: 1.0,
          ),
        ),
        doneStyle: GoogleFonts.nunitoSans(
          textStyle: TextStyle(
            fontSize: constraints.maxWidth * 0.04,
            fontWeight: FontWeight.w700,
            color: Palette.pink,
            letterSpacing: 1.0,
          ),
        ),
      ),
      showTitleActions: true,
      minTime: DateTime.now(),
      onChanged: (date) {},
      onConfirm: (date) {
        NotificationApi.setScheduledNotification(
          id: widget.id,
          title: 'Lembrete para entrar em contato!',
          body: 'Entre em contanto com ${widget.name}',
          scheduledDate: date,
        );
        final db = Localstore.instance;

        db
            .collection('reminders')
            .doc(widget.id.toString())
            .set({'date': date.toString()});

        checkReminder();
      },
      currentTime: DateTime.now(),
      locale: LocaleType.pt,
    );
  }

  removeReminder() {
    Get.defaultDialog(
      title: 'Remover lembrete',
      middleText:
          'Deseja remover o lembrete para entrar em contato com ${widget.name}?',
      textConfirm: 'Sim',
      textCancel: 'Não',
      confirmTextColor: Palette.white,
      onConfirm: () async {
        final db = Localstore.instance;
        db.collection('reminders').doc(widget.id.toString()).delete();
        await NotificationApi.cancel(widget.id);
        checkReminder();
        Get.back();
      },
    );
  }

  @override
  void initState() {
    phoneController.loadAllPhonesFromContact(widget.id);
    checkReminder();
    super.initState();
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
                    title: 'CONTATO',
                    action: true,
                    actionFunction: () {
                      if (!haveReminder) {
                        setReminder(constraints);
                        return;
                      }
                      removeReminder();
                    },
                    actionIcon: haveReminder
                        ? const Icon(Icons.notifications_off_outlined)
                        : const Icon(Icons.notification_add_outlined),
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
                            Hero(
                              tag: 'contactCard${widget.id}',
                              transitionOnUserGestures: true,
                              child: Material(
                                type: MaterialType.transparency,
                                child: ContactHeader(
                                  name: widget.name,
                                  avatar: widget.avatar,
                                  haveReminder: haveReminder,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Obx(
                              () {
                                MagicMask phoneMask =
                                    MagicMask.buildMask('(99) 99999-9999');

                                return phoneController.phones[0].phone!.isEmpty
                                    ? Row(
                                        children: [
                                          const Icon(Icons.phone_outlined),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'SEM TELEFONE',
                                            style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                fontSize: constraints.maxWidth *
                                                    0.032,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                          height: 8,
                                        ),
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            phoneController.phones.length,
                                        itemBuilder: (context, index) =>
                                            phoneController.phones[index].phone!
                                                    .isNotEmpty
                                                ? InkWell(
                                                    onTap: () {
                                                      launchUrl(Uri.parse(
                                                          'tel:${phoneController.phones[index].phone!}'));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              Palette.lightGrey,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons
                                                              .phone_outlined),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            phoneMask.getMaskedString(
                                                                phoneController
                                                                    .phones[
                                                                        index]
                                                                    .phone!),
                                                            style: GoogleFonts
                                                                .nunitoSans(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize:
                                                                    constraints
                                                                            .maxWidth *
                                                                        0.040,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                letterSpacing:
                                                                    1.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                      );
                              },
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: widget.zipCode.isNotEmpty
                                      ? Text(
                                          '${widget.address}, ${widget.number}, ${widget.city} - ${widget.state}',
                                          style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                              fontSize:
                                                  constraints.maxWidth * 0.032,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          'SEM ENDEREÇO',
                                          style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                              fontSize:
                                                  constraints.maxWidth * 0.032,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
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
