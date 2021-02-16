import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import '../models/friend.dart';
import '../pages/favors_page.dart';
import '../widgets/verification_code_input_widget.dart';

class LoginPage extends StatefulWidget {
  final List<Friend> friends;

  LoginPage({Key key, this.friends}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _phoneNumber = "";
  String _smsCode = "";
  String _verificationId = "";
  int _currentStep = 0;
  List<StepState> _stepsState = [
    StepState.editing,
    StepState.indexed,
    StepState.indexed
  ];
  bool _showProgress = false;
  String _displayName = '';
  File _imageFile;
  bool _labeling = false;
  List<ImageLabel> _labels = [];

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FavorsPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Login",
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
            Stepper(
              type: StepperType.vertical,
              steps: <Step>[
                Step(
                  state: _stepsState[0],
                  isActive: _enteringPhoneNumber(),
                  title: Text("Enter your Phone Number"),
                  content: TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9+]")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _phoneNumber = value;
                      });
                    },
                  ),
                ),
                Step(
                  state: _stepsState[1],
                  isActive: _enteringVerificationCode(),
                  title: Text("Verification code"),
                  content: VerificationCodeInput(
                    onChanged: (value) {
                      setState(() {
                        _smsCode = value;
                      });
                    },
                  ),
                ),
                Step(
                  state: _stepsState[2],
                  isActive: _editingProfile(),
                  title: Text("Profile"),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        child: CircleAvatar(
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile)
                              : AssetImage('assets/images/default_avatar.png'),
                        ),
                        onTap: () => _importImage(),
                      ),
                      Container(
                        height: 16,
                      ),
                      Text(
                        _labeling
                            ? "Labeling the captured image ..."
                            : "Capture a image to start labeling",
                      ),
                      Container(
                        height: 32.0,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: min(_labels.length, 5),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) => Text(
                          "${_labels[index].text}, confidence: ${_labels[index].confidence}",
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "Display name"),
                        onChanged: (value) {
                          setState(() {
                            _displayName = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
              currentStep: _currentStep,
              controlsBuilder: _stepControlsBuilder,
              onStepContinue: () {
                if (_currentStep == 0) {
                  _sendVerificationCode();
                } else if (_currentStep == 1) {
                  _executeLogin();
                } else {
                  _saveProfile();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _stepControlsBuilder(BuildContext context,
      {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    if (_showProgress) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          onPressed: onStepContinue,
          child: Text("CONTINUE"),
        ),
      ],
    );
  }

  bool _enteringPhoneNumber() =>
      _currentStep == 0 && _stepsState[0] == StepState.editing;

  _enteringVerificationCode() =>
      _currentStep == 1 && _stepsState[1] == StepState.editing;

  _editingProfile() => _currentStep == 2 && _stepsState[2] == StepState.editing;

  void _sendVerificationCode() async {
    final PhoneCodeSent codeSent = (String verId, [int forceCodeResend]) {
      _verificationId = verId;
      _goToVerificationStep();
    };
    //FirebaseUser user
    final PhoneVerificationCompleted verificationSuccess = (_) {
      _loggedIn();
    };
    // AuthException exception
    final PhoneVerificationFailed verificationFail = (_) {
      goBackToFirstStep();
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this._verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneNumber,
      codeSent: codeSent,
      verificationCompleted: verificationSuccess,
      verificationFailed: verificationFail,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
      timeout: Duration(seconds: 0),
    );
  }

  void _executeLogin() async {
    setState(() => _showProgress = true);

    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _smsCode,
    ));

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) goToProfileStep();
  }

  void _loggedIn() {
    setState(() {
      _showProgress = false;
      _stepsState[1] = StepState.complete;
    });
  }

  void goBackToFirstStep() {
    setState(() {
      _showProgress = false;
      _stepsState[0] = StepState.editing;
      _stepsState[1] = StepState.indexed;
      _currentStep = 0;
    });
  }

  void _goToVerificationStep() {
    setState(() {
      _stepsState[0] = StepState.complete;
      _stepsState[1] = StepState.editing;
      _currentStep = 1;
    });
  }

  void _saveProfile() async {
    setState(() => _showProgress = true);

    final user = FirebaseAuth.instance.currentUser;

    if (user != null && _imageFile != null)
      await user.updateProfile(
          displayName: _displayName, photoURL: await uploadPicture(user.uid));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FavorsPage(),
      ),
    );
  }

  void goToProfileStep() {
    setState(() {
      _showProgress = false;
      _stepsState[1] = StepState.complete;
      _stepsState[2] = StepState.editing;
      _currentStep = 2;
    });
  }

  void _importImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    _labelImage();
  }

  Future<String> uploadPicture(String userUid) async {
    /*
        1 We create a reference to a new object on Storage. We chain child
        calls, created a folder called 'Profiles' and a file with the user
        ID in its name
     */
    final ref = FirebaseStorage.instance
        .ref()
        .child('profiles')
        .child('profile_$userUid');

    // 2 We create a storage upload task that will initialize the
    // upload to Firebase
    await ref.putFile(_imageFile);

    // 3 We get the file URL, this is a download URL of the Firebase
    // file so that we can access the file from Storage
    return await ref.getDownloadURL();
  }

  _labelImage() async {
    if (_imageFile == null) return;

    setState(() => _labeling = true);

    // 1 We instantiate FireBaseVisionImage from the captured image
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(_imageFile);

    // 2 Then we instantiate a FireBase ImageLabeler
    final imageLabeler = FirebaseVision.instance.imageLabeler();
    // 3 We process the image. This will return a collection of ImageLabel
    // objects that are displayed later
    List<ImageLabel> labels = await imageLabeler.processImage(visionImage);

    setState(() {
      _labels = labels;
      _labeling = false;
    });
  }
}
