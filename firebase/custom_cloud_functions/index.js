const admin = require("firebase-admin/app");
admin.initializeApp();

const createUserRequest = require("./create_user_request.js");
const verifyUser = require("./test_function.js");
const roleManagement = require("./role_management.js");

// User management functions
exports.createUserRequest = createUserRequest.createUserRequest;
exports.verifyUser = verifyUser.verifyUser;

// Role management functions
exports.assignManager = roleManagement.assignManager;
exports.assignAdmin = roleManagement.assignAdmin;
exports.removeManager = roleManagement.removeManager;
exports.getUserRole = roleManagement.getUserRole;
exports.transferAdmin = roleManagement.transferAdmin;
