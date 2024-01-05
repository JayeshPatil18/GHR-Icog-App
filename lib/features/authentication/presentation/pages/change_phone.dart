import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../../constants/boarder.dart';
import '../../../../constants/color.dart';
import '../../../../constants/cursor.dart';
import '../../../../constants/elevation.dart';
import '../../../../utils/fonts.dart';
import '../../../reviews/domain/entities/verify_phoneno_argument.dart';
import '../../../reviews/domain/entities/verify_arguments.dart';
import '../../../reviews/presentation/widgets/shadow.dart';
import '../../../reviews/presentation/widgets/snackbar.dart';
import '../bloc/signup_bloc/signup_bloc.dart';

class ChangePhoneNo extends StatefulWidget {
  const ChangePhoneNo({super.key});

  @override
  State<ChangePhoneNo> createState() => _ChangePhoneNoState();
}

class _ChangePhoneNoState extends State<ChangePhoneNo> {
  final FocusNode _focusPhoneNoNode = FocusNode();
  bool _hasPhoneNoFocus = false;

  TextEditingController phoneNoController = TextEditingController();

  String countryCode = '+91';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateInput(String? input, int index) {
    switch (index) {
      case 0:
        if (input == null || input.isEmpty) {
          return 'Field empty';
        } else if (!isNumeric(input) || input.length != 10) {
          return 'Invalid phone number';
        }
        break;

      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _focusPhoneNoNode.addListener(() {
      setState(() {
        _hasPhoneNoFocus = _focusPhoneNoNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor60,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: SafeArea(
              child: Container(
                alignment: Alignment.centerLeft,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios,
                          color: AppColors.textColor, size: 26),
                    ),
                    SizedBox(width: 10),
                    Text('Change Phone no', style: MainFonts.pageTitleText()),
                  ],
                ),
              ),
            )),
        body: SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(
                boxShadow: ContainerShadow.boxShadow,
                color: AppColors.primaryColor30,
                borderRadius:
                    BorderRadius.circular(AppBoarderRadius.reviewUploadRadius),
              ),
              width: double.infinity,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 5),
                        child: Text('New Phone Number',
                            style: MainFonts.lableText()),
                      ),
                      Container(
                        child: TextFormField(
                          maxLength: 10,
                          controller: phoneNoController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: ((value) {
                            return _validateInput(value, 0);
                          }),
                          style: MainFonts.textFieldText(),
                          keyboardType: TextInputType.number,
                          focusNode: _focusPhoneNoNode,
                          cursorHeight: TextCursorHeight.cursorHeight,
                          decoration: InputDecoration(
                            prefixIcon: CountryCodePicker(
                              textStyle: MainFonts.textFieldText(),
                              onChanged: ((value) {
                                countryCode = value.dialCode.toString();
                              }),
                              initialSelection: '+91',
                              favorite: ['+91', 'IND'],
                              showFlagDialog: true,
                              showFlagMain: false,
                              alignLeft: false,
                            ),
                            contentPadding: EdgeInsets.only(
                                top: 16, bottom: 16, left: 20, right: 20),
                            fillColor: AppColors.primaryColor30,
                            filled: true,
                            hintText:
                                _hasPhoneNoFocus ? 'Enter phone number' : null,
                            hintStyle: MainFonts.hintFieldText(),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppBoarderRadius.reviewUploadRadius),
                                borderSide: BorderSide(
                                    width: AppBoarderWidth.reviewUploadWidth,
                                    color: AppBoarderColor.searchBarColor)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppBoarderRadius.reviewUploadRadius),
                                borderSide: BorderSide(
                                    width: AppBoarderWidth.reviewUploadWidth,
                                    color: AppBoarderColor.searchBarColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppBoarderRadius.reviewUploadRadius),
                                borderSide: BorderSide(
                                    width: AppBoarderWidth.searchBarWidth,
                                    color: AppBoarderColor.searchBarColor)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppBoarderRadius.reviewUploadRadius),
                                borderSide: BorderSide(
                                    width: AppBoarderWidth.searchBarWidth,
                                    color: AppBoarderColor.errorColor)),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        height: 55,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryColor10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppBoarderRadius.buttonRadius)),
                              elevation: AppElevations.buttonElev,
                            ),
                            onPressed: () async {
                              bool isValid = _formKey.currentState!.validate();
                              if(isValid){
                                SignupBloc signupBlocObj = SignupBloc();
                                bool isOtpSent = await signupBlocObj
                                    .sendOtpToEmail(countryCode +
                                    phoneNoController.text.toString().trim());
                                if (isOtpSent) {
                                  FocusScope.of(context).unfocus();
                                  Future.delayed(
                                      const Duration(milliseconds: 300), () {
                                    Navigator.of(context).pushNamed(
                                        'verifynewphone',
                                        arguments: VerifyPhoneNoArg(countryCode +
                                            phoneNoController.text
                                                .toString()
                                                .trim(), "phoneno"));
                                  });
                                } else {
                                  mySnackBarShow(context,
                                      'Something went wrong! Try again.');
                                }
                              }
                            },
                            child: Text('Send Verification Code',
                                style: AuthFonts.authButtonText())),
                      ),
                    ]),
              )),
        ));
  }
}
