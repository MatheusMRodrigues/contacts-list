import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:technical/shared/functions.dart';
import 'package:technical/utils/palette.dart';

class DeviceContactsList extends StatefulWidget {
  final BoxConstraints constraints;
  final Function onClickContact;
  const DeviceContactsList(
      {super.key, required this.constraints, required this.onClickContact});

  @override
  DeviceContactsListState createState() => DeviceContactsListState();
}

class DeviceContactsListState extends State<DeviceContactsList> {
  final List deviceContacts = [];

  checkDeviceContactsList() async {
    var contactsPermission = await getAccessContactPermission();
    if (contactsPermission == PermissionStatus.granted) {
      final contactsFromDevice = await FastContacts.allContacts;
      contactsFromDevice.forEach((element) {
        deviceContacts
            .add({"name": element.displayName, "phones": element.phones});
      });
    }
  }

  modalStateHandler() async {
    await checkDeviceContactsList();
    print(deviceContacts);
    setState(() {});
  }

  @override
  void initState() {
    modalStateHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.constraints.maxHeight * 0.62,
      padding: const EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Palette.white,
        boxShadow: [
          BoxShadow(
            color: Palette.black,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 10,
              width: widget.constraints.maxWidth * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Palette.lightGrey,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Importar contato',
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                fontSize: widget.constraints.maxWidth * 0.05,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: deviceContacts.length,
              separatorBuilder: (context, index) => const Divider(
                height: 20,
                thickness: 1.5,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                   widget.onClickContact(deviceContacts[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    // ignore: sized_box_for_whitespace
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: Text(
                              deviceContacts[index]['name'][0].toUpperCase()),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          deviceContacts[index]['name'],
                          style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                              fontSize: widget.constraints.maxWidth * 0.05,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
