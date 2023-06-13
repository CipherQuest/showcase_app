// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:zeerac_flutter/modules/users/controllers/dash_board_controller.dart';
// import 'package:zeerac_flutter/modules/users/models/user_model.dart';
// import 'package:zeerac_flutter/utils/user_defaults.dart';
// import 'package:dio/dio.dart' as dio;

// class UpdateUserTypeController extends GetxController {
//   RxBool checkBoxValue = false.obs;
//   DashBoardController dashBoardController = Get.find();
//   RxBool isLoading = false.obs;
//   var formKey = GlobalKey<FormState>();

//   //user info
//   TextEditingController emailController = TextEditingController();
//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();

//   TextEditingController fullNameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();

//   //additional info
//   TextEditingController briefController = TextEditingController();
//   TextEditingController cnicController = TextEditingController();
//   TextEditingController cityController = TextEditingController();
//   TextEditingController areaController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController dobController = TextEditingController();

//   //company info
//   TextEditingController companyNameController = TextEditingController();
//   TextEditingController companyFaxController = TextEditingController();
//   TextEditingController companyMailController = TextEditingController();
//   TextEditingController companyPhoneController = TextEditingController();
//   TextEditingController companyNoOfEmployees = TextEditingController();
//   TextEditingController companyDescription = TextEditingController();
//   TextEditingController companyCityController = TextEditingController();
//   TextEditingController companyAreaController = TextEditingController();
//   TextEditingController companyAddressDescription = TextEditingController();

//   Rxn<File?> agencyLogo = Rxn<File>();

//   double agentAreaLat = 0.0;
//   double agentAreaLng = 0.0;

//   double companyAreaLat = 0.0;
//   double companyAreaLng = 0.0;

//   prefillData(int type) {
//     UserModel? user = UserDefaults.getUserSession();
//     emailController.text = user!.email ?? '';
//     firstNameController.text = user!.firstName ?? '';
//     lastNameController.text = user!.lastName ?? '';
//     fullNameController.text = user!.fullName ?? '';
//     phoneController.text = user!.phoneNumber ?? '';
//     if (type == 2) {
//       briefController.text = user.personalDescription ?? '';
//       cnicController.text = user.cnic ?? '';
//       cityController.text = user.city ?? '';
//       areaController.text = user.area ?? '';
//       addressController.text = user.address ?? '';
//       dobController.text = user.dateOfBirth ?? '';
//       agencyLogo.value = File(user.photo ?? '');
//     }

//     print('User data is ');
//     print(
//         '${emailController.text} ${firstNameController.text} ${lastNameController.text} ${fullNameController.text} ${phoneController.text} ${briefController.text} ${cnicController.text} ${cityController.text} ${areaController.text} ${addressController.text} ${dobController.text}');
//   }

//   updateUserType(type) async {
//     Get.back();
//     Map<String, dynamic> dataMap;
//     if (type == 1) {
//       dataMap = {
//         "email": emailController.text.trim(),
//         "first_name": firstNameController.text.trim(),
//         "last_name": lastNameController.text.trim(),
//         "personal_description": briefController.text,
//         "phone_number": phoneController.text.trim(),
//         "user_type": type,
//         "is_company": checkBoxValue.value == true ? true : false,
//         "cnic": cnicController.text.trim(),
//         "city": cityController.text.trim(),
//         "area": areaController.text.trim(),
//         "address": addressController.text.trim(),
//         "date_of_birth":
//             DateFormat('yyyy-MM-dd').format(DateTime.parse(dobController.text)),
//         "lat": agentAreaLat,
//         "lng": agentAreaLng,
//         // "company_name": companyNameController.text.trim(),
//         // "company_description": companyDescription.text.trim(),
//         // "company_email": companyMailController.text.trim(),
//         // "company_phone": companyPhoneController.text.trim(),
//         // "company_fax": companyFaxController.text.trim(),
//         // "company_city": companyCityController.text.trim(),
//         // "company_areas": companyAreaController.text.trim(),
//         // "company_address": companyAreaController.text.trim(),
//         // "no_of_employees": companyNoOfEmployees.text.trim(),
//       };

//       if (agencyLogo.value != null) {
//         dataMap["photo"] = await dio.MultipartFile.fromFile(
//             agencyLogo.value!.path,
//             filename: "${firstNameController.text}.png");
//       }

//       // if (checkBoxValue.value == true) {
//       //   dashBoardController.updateUserType(2, myCompany: 'New Compa');
//       // } else {
//       //   dashBoardController.updateUserType(2);
//       // }
//     }

//     becomeCompany() {
//       Get.back();
//       //dashBoardController.updateUserType(2, myCompany: 'New Comp');
//     }
//   }
// }
