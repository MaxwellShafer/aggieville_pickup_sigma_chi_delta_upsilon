const { onCall } = require("firebase-functions/v2/https");
const { logger } = require("firebase-functions");
const admin = require("firebase-admin");
const { 
  validateFirebaseUID, 
  checkRateLimit, 
  sanitizeError, 
  validateRoleManagementInput 
} = require("./security_utils");

/**
 * A cloud function that verifies a user by setting their verified field to true
 * This function can be called via Firebase callable function
 */
exports.verifyUser = onCall(
  {
    region: "us-central1", // Set the region
  },
  async (request) => {
    // Log the request
    logger.info("Verify user function called", {
      userId: request.data?.userId,
      auth: request.auth?.uid,
    });

    try {
      // Rate limiting check
      if (!await checkRateLimit(request.auth?.uid, 'verifyUser')) {
        throw new Error("Rate limit exceeded. Please try again later.");
      }

      // Input validation
      const validationErrors = validateRoleManagementInput(request.data, request.auth);
      if (validationErrors.length > 0) {
        throw new Error(`Validation failed: ${validationErrors.join(', ')}`);
      }

      // Check if user is authenticated
      if (!request.auth) {
        throw new Error("The function must be called while authenticated.");
      }

      // Get the userId from the request data
      const userId = request.data?.userId;
      
      if (!userId) {
        throw new Error("User ID is required.");
      }

      // Check caller's role - Manager or higher required to verify users
      const db = admin.firestore();
      const callerDoc = await db.collection('users').doc(request.auth.uid).get();
      
      if (!callerDoc.exists) {
        throw new Error("Caller user not found.");
      }

      const callerRole = callerDoc.data().role || 'user';
      const ROLE_HIERARCHY = { 'owner': 4, 'admin': 3, 'manager': 2, 'user': 1 };
      
      if (ROLE_HIERARCHY[callerRole] < ROLE_HIERARCHY['manager']) {
        throw new Error("Insufficient permissions. Manager role or higher required to verify users.");
      }

      const userDocRef = db.collection('users').doc(userId);

      // Check if the user document exists
      const userDoc = await userDocRef.get();
      
      if (!userDoc.exists) {
        throw new Error("User not found or insufficient permissions.");
      }

      // Update the verified field to true
      await userDocRef.update({
        verified: true,
        verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
        verifiedBy: request.auth.uid,
      });

      logger.info(`User ${userId} has been verified successfully by ${request.auth.uid}`);

      return {
        success: true,
        message: `User has been verified successfully.`,
        userId: userId,
        verified: true,
        verifiedAt: new Date().toISOString(),
        verifiedBy: request.auth.uid,
      };

    } catch (error) {
      logger.error("Error verifying user:", error);
      throw new Error(sanitizeError(error, 'verifyUser'));
    }
  }
);
