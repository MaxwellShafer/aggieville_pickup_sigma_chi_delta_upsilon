const { onCall } = require('firebase-functions/v2/https');
const { logger } = require('firebase-functions');
const admin = require('firebase-admin');
const { 
  validateFirebaseUID, 
  validateEmail, 
  validateDisplayName,
  checkRateLimit, 
  sanitizeError 
} = require('./security_utils');
// To avoid deployment errors, do not call admin.initializeApp() in your code

exports.createUserRequest = onCall(
  {
    region: "us-central1", // Set the region
  },
  async (request) => {
    try {
      // Rate limiting check
      if (!await checkRateLimit(request.auth?.uid, 'createUserRequest')) {
        throw new Error("Rate limit exceeded. Please try again later.");
      }

      if (!request.auth) {
        throw new Error('The function must be called while authenticated.');
      }

      const userId = request.auth.uid;
      const email = request.auth.token.email || request.data?.email;
      const displayName = request.auth.token.name || request.data?.displayName;

      // Input validation
      if (!validateFirebaseUID(userId)) {
        throw new Error('Invalid user ID format.');
      }

      if (!email || !validateEmail(email)) {
        throw new Error('Valid email is required.');
      }

      if (!displayName || !validateDisplayName(displayName)) {
        throw new Error('Valid display name is required.');
      }

      const db = admin.firestore();
      const userDocRef = db.collection('user_requests').doc(userId);

      const doc = await userDocRef.get();

      if (!doc.exists) {
        // Create the document if it doesn't exist
        await userDocRef.set({
          userId: userId,
          email: email,
          displayName: displayName,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        logger.info(`User request created for ${userId}`);
        return { created: true, message: 'User request document created.' };
      } else {
        return { created: false, message: 'User request document already exists.' };
      }
    } catch (error) {
      logger.error('Error checking/creating user request:', error);
      throw new Error(sanitizeError(error, 'createUserRequest'));
    }
  }
);