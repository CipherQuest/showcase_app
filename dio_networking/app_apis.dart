import 'package:zeerac_flutter/utils/user_defaults.dart';

enum APIType {
  loginUser,
  registerUser,
  getAllUsers,
  becomeAgent,
  loadProperties,
  loadProjects,
  loadCompanies,
  loadCompanyPropertiesListing,
  companiesProjects,
  loadAgents,
  loadAgencies,
  agentzPropertyListing,
  loadBlogs,
  loadUserDetails,
  updateUserDetails,
  createProperty,
  updateProperty,
  uploadImages,
  searchForTrends,
  loadTutorials,
  postUserPreference,
  getUserPreferences,
  updateUserPreferences,
  getUserPreferenceListing,
  checkUniqueMail,
  checkUniqueCnic,
  userPropertyFiles,
  createFile,
  updateFile,
  postFileImages,
  loadForums,
  postNewForum,
  replyToForum,
  createSocialGroup,
  updateSocialGroup,
  getAllSocialGroups,
  getOneSocialGroupById,
  socialGroupMemberRequestUpdate,
  requestJoinGroup,
  getSocialPosts,
  createSocialPosts,
  updateSocialPosts,
  postSocialPostComment,
  propertyPostCommentLikes,
  propertyPostCommentLikesPut,

  ///bids
  getPropertyFilesBid,

  ///same is used for accepting bid
  placeYourPropertyBid,
  loadBidsOfAuction,
  placeBid,
  acceptBid,

  ///notifications from api
  getNotifications,
  patchNotifications,
  deleteNotification,
  editProperty,
  postNotification,
}

class WebSocketsConstants {
  static String getUrl() {
    String? token = UserDefaults.getUserSession()?.token;
    return "$wsNotifications?token=$token";
  }

  static const String wsNotifications = "${_baseWebSocketUrl}";
}
