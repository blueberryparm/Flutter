import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import '../models/favor.dart';
import '../models/friend.dart';

class RequestFavorPage extends StatefulWidget {
  final List<Friend> friends;

  RequestFavorPage({Key key, this.friends}) : super(key: key);

  @override
  RequestFavorPageState createState() => RequestFavorPageState();
}

class RequestFavorPageState extends State<RequestFavorPage> {
  final _formKey = GlobalKey<FormState>();
  final ContactPicker _contactPicker = ContactPicker();
  Friend _importedFriend;
  Friend _selectedFriend;
  DateTime _dueDate;
  String _description;
  List<Friend> friends;

  InterstitialAd _interstitialAd;
  BannerAd _bannerAd;

  // sample targeting from https://github.com/flutter/plugins/blob/master/packages/firebase_admob/example/lib/main.dart

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: <String>[],
    //testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  static RequestFavorPageState of(BuildContext context) =>
      context.findAncestorStateOfType();

  @override
  void initState() {
    super.initState();

    Friend newFriend = Friend(name: "New number", uuid: 'new');
    friends = widget.friends..add(newFriend);

    _bannerAd = BannerAd(
      targetingInfo: targetingInfo,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
    )
      ..load()
      ..show();

    _interstitialAd = InterstitialAd(
      targetingInfo: targetingInfo,
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'request_favor',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Requesting a favor'),
          leading: CloseButton(),
          actions: [
            Builder(
              builder: (context) => FlatButton(
                colorBrightness: Brightness.dark,
                child: Text("SAVE"),
                onPressed: () {
                  RequestFavorPageState.of(context).save(context);
                  // we could call save() method directly
                  // as we are in the same class.
                  // intentionally left for exemplification.
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Request a favor to:'),
                  Row(
                    children: [
                      DropdownButtonFormField<Friend>(
                        value: _selectedFriend,
                        onChanged: (friend) {
                          setState(() {
                            _selectedFriend = friend;
                          });
                        },
                        items: friends
                            .map(
                              (f) => DropdownMenuItem<Friend>(
                                value: f,
                                child: Text(
                                  f.name,
                                ),
                              ),
                            )
                            .toList(),
                        validator: (friend) {
                          if (friend == null) {
                            return "You must select a friend to ask the favor";
                          }
                          return null;
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.contact_phone,
                          color: Colors.black,
                        ),
                        onPressed: _importContact,
                      ),
                    ],
                  ),
                  _selectedFriend?.uuid == 'new'
                      ? TextFormField(
                          maxLines: 1,
                          decoration:
                              InputDecoration(hintText: "Friend phone number"),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20)
                          ],
                          validator: (value) {
                            if (value.isEmpty) {
                              return "add the new friend phone number";
                            }
                            return null;
                          },
                          onSaved: (number) {
                            _selectedFriend = Friend(number: number);
                          },
                        )
                      : Container(
                          height: 0,
                        ),
                  Container(
                    height: 16.0,
                  ),
                  Text("Favor description:"),
                  TextFormField(
                    maxLines: 5,
                    inputFormatters: [LengthLimitingTextInputFormatter(200)],
                    validator: (value) {
                      if (value.isEmpty) {
                        return "You must detail the favor";
                      }
                      return null;
                    },
                    onSaved: (description) {
                      _description = description;
                    },
                  ),
                  Container(
                    height: 16.0,
                  ),
                  Text("Due Date:"),
                  DateTimeField(
                    format: DateFormat("EEEE, MMMM, d, yyyy 'at' h:mmma"),
                    decoration: InputDecoration(
                      labelText: 'Date/Time',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now(),
                          ),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                    validator: (dateTime) {
                      if (dateTime == null) {
                        return "You must select a due date time for the favor";
                      }
                      return null;
                    },
                    onSaved: (dateTime) {
                      _dueDate = dateTime;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _bannerAd.dispose();
    _interstitialAd.dispose();
  }

  void save(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      // store the favor request on firebase
      /*
        1 We validate and save the form fields. That is, we store the value of the
        text fields of description, due date, and friend as variables to use later
     */
      _formKey.currentState.save();
      /*
        2 We get the current logged-in user, as we need the current user info to
        populate the favor request, so that the requested friend will know who is
        asking them for a favor
       */
      final currentUser = FirebaseAuth.instance.currentUser;
      /*
         3 We call the utility method that makes the Firebase call, with a new
         Favor instance created with the values coming from Form
       */
      await _saveFavorOnFirebase(
        Favor(
          to: _importedFriend?.number ?? _selectedFriend?.number,
          description: _description,
          dueDate: _dueDate,
          friend: Friend(
            name: currentUser.displayName,
            number: currentUser.phoneNumber,
            photoURL: currentUser.photoURL,
          ),
        ),
      );

      await _interstitialAd.show();

      Navigator.pop(context);
    }
  }

  _saveFavorOnFirebase(Favor favor) async => await FirebaseFirestore.instance
      .collection('favors')
      .doc()
      .set(favor.toJson());

  Future<void> _checkPermissions() async {
    PermissionStatus contactStatus = await Permission.contacts.status;
    if (contactStatus != PermissionStatus.granted) await Permission.contacts.request();
    PermissionStatus cameraStatus = await Permission.contacts.status;
    if (cameraStatus != PermissionStatus.granted) await Permission.camera.status;
  }

  void _importContact() async {
    await _checkPermissions();
    /*
        1 We launch the contact selector
     */
    Contact contact = await _contactPicker.selectContact();
    if (contact != null) {
      // 2 Create a Friend instance based on the selected contact
      setState(() {
        _importedFriend =
            Friend(name: contact.fullName, number: contact.phoneNumber.number);
      });
    }
  }
}
