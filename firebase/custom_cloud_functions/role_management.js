 const { onCall } = require("firebase-functions/v2/https");
const { logger } = require("firebase-functions");
const admin = require("firebase-admin");
const { 
  validateFirebaseUID, 
  validateEmail, 
  validateDisplayName,
  checkRateLimit, 
  sanitizeError, 
  validateRoleManagementInput,
  executeTransaction 
} = require("./security_utils");

// Role constants
const ROLES = {
  OWNER: 'owner',
  ADMIN: 'admin', 
  MANAGER: 'manager',
  USER: 'user'
};

// Role hierarchy (higher number = more permissions)
const ROLE_HIERARCHY = {
  [ROLES.OWNER]: 4,
  [ROLES.ADMIN]: 3,
  [ROLES.MANAGER]: 2,
  [ROLES.USER]: 1
};

/**
 * Helper function to check if user has required role level
 */
function hasRoleLevel(userRole, requiredRole) {
  return ROLE_HIERARCHY[userRole] >= ROLE_HIERARCHY[requiredRole];
}

/**
 * Helper function to get user role from Firestore
 */
async function getUserRole(userId) {
  const db = admin.firestore();
  const userDoc = await db.collection('users').doc(userId).get();
  
  if (!userDoc.exists) {
    return ROLES.USER; // Default role
  }
  
  return userDoc.data().role || ROLES.USER;
}

/**
 * Helper function to set user role in Firestore
 */
async function setUserRole(userId, role, setBy) {
  const db = admin.firestore();
  await db.collection('users').doc(userId).update({
    role: role,
    roleUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
    roleUpdatedBy: setBy
  });
}

/**
 * Assign manager role to a user
 * Requires: Admin or Owner role
 */
exports.assignManager = onCall(
  {
    region: "us-central1",
  },
  async (request) => {
    logger.info("Assign manager function called", {
      targetUserId: request.data?.userId,
      callerId: request.auth?.uid,
    });

    try {
      // Rate limiting check
      if (!await checkRateLimit(request.auth?.uid, 'assignManager')) {
        throw new Error("Rate limit exceeded. Please try again later.");
      }

      // Input validation
      const validationErrors = validateRoleManagementInput(request.data, request.auth);
      if (validationErrors.length > 0) {
        throw new Error(`Validation failed: ${validationErrors.join(', ')}`);
      }

      if (!request.auth) {
        throw new Error("The function must be called while authenticated.");
      }

      const callerId = request.auth.uid;
      const targetUserId = request.data?.userId;

      if (!targetUserId) {
        throw new Error("User ID is required.");
      }

      if (callerId === targetUserId) {
        throw new Error("You cannot assign roles to yourself.");
      }

      // Check caller's role
      const callerRole = await getUserRole(callerId);
      
      if (!hasRoleLevel(callerRole, ROLES.ADMIN)) {
        throw new Error("Insufficient permissions. Admin or Owner role required.");
      }

      // Check if target user exists
      const db = admin.firestore();
      const targetUserDoc = await db.collection('users').doc(targetUserId).get();
      
      if (!targetUserDoc.exists) {
        throw new Error("User not found or insufficient permissions.");
      }

      // Set manager role
      await setUserRole(targetUserId, ROLES.MANAGER, callerId);

      logger.info(`User ${targetUserId} assigned manager role by ${callerId}`);

      return {
        success: true,
        message: `User has been assigned manager role successfully.`,
        userId: targetUserId,
        role: ROLES.MANAGER,
        assignedBy: callerId,
        assignedAt: new Date().toISOString(),
      };

    } catch (error) {
      logger.error("Error assigning manager role:", error);
      throw new Error(sanitizeError(error, 'assignManager'));
    }
  }
);

/**
 * Assign admin role to a user
 * Requires: Owner role only
 */
exports.assignAdmin = onCall(
  {
    region: "us-central1",
  },
  async (request) => {
    logger.info("Assign admin function called", {
      targetUserId: request.data?.userId,
      callerId: request.auth?.uid,
    });

    try {
      // Rate limiting check
      if (!await checkRateLimit(request.auth?.uid, 'assignAdmin')) {
        throw new Error("Rate limit exceeded. Please try again later.");
      }

      // Input validation
      const validationErrors = validateRoleManagementInput(request.data, request.auth);
      if (validationErrors.length > 0) {
        throw new Error(`Validation failed: ${validationErrors.join(', ')}`);
      }

      if (!request.auth) {
        throw new Error("The function must be called while authenticated.");
      }

      const callerId = request.auth.uid;
      const targetUserId = request.data?.userId;

      if (!targetUserId) {
        throw new Error("User ID is required.");
      }

      if (callerId === targetUserId) {
        throw new Error("You cannot assign roles to yourself.");
      }

      // Check caller's role - only Owner can assign Admin
      const callerRole = await getUserRole(callerId);
      
      if (callerRole !== ROLES.OWNER) {
        throw new Error("Insufficient permissions. Owner role required to assign admin.");
      }

      // Check if target user exists
      const db = admin.firestore();
      const targetUserDoc = await db.collection('users').doc(targetUserId).get();
      
      if (!targetUserDoc.exists) {
        throw new Error("User not found or insufficient permissions.");
      }

      // Set admin role
      await setUserRole(targetUserId, ROLES.ADMIN, callerId);

      logger.info(`User ${targetUserId} assigned admin role by ${callerId}`);

      return {
        success: true,
        message: `User has been assigned admin role successfully.`,
        userId: targetUserId,
        role: ROLES.ADMIN,
        assignedBy: callerId,
        assignedAt: new Date().toISOString(),
      };

    } catch (error) {
      logger.error("Error assigning admin role:", error);
      throw new Error(sanitizeError(error, 'assignAdmin'));
    }
  }
);

/**
 * Remove manager role from a user (downgrade to User)
 * Requires: Admin or Owner role
 */
exports.removeManager = onCall(
  {
    region: "us-central1",
  },
  async (request) => {
    logger.info("Remove manager function called", {
      targetUserId: request.data?.userId,
      callerId: request.auth?.uid,
    });

    try {
      // Rate limiting check
      if (!await checkRateLimit(request.auth?.uid, 'removeManager')) {
        throw new Error("Rate limit exceeded. Please try again later.");
      }

      // Input validation
      const validationErrors = validateRoleManagementInput(request.data, request.auth);
      if (validationErrors.length > 0) {
        throw new Error(`Validation failed: ${validationErrors.join(', ')}`);
      }

      if (!request.auth) {
        throw new Error("The function must be called while authenticated.");
      }

      const callerId = request.auth.uid;
      const targetUserId = request.data?.userId;

      if (!targetUserId) {
        throw new Error("User ID is required.");
      }

      if (callerId === targetUserId) {
        throw new Error("You cannot remove roles from yourself.");
      }

      // Check caller's role
      const callerRole = await getUserRole(callerId);
      
      if (!hasRoleLevel(callerRole, ROLES.ADMIN)) {
        throw new Error("Insufficient permissions. Admin or Owner role required.");
      }

      // Check target user's current role
      const targetUserRole = await getUserRole(targetUserId);
      
      if (targetUserRole !== ROLES.MANAGER) {
        throw new Error("User is not currently a manager or insufficient permissions.");
      }

      // Downgrade to user role
      await setUserRole(targetUserId, ROLES.USER, callerId);

      logger.info(`User ${targetUserId} removed from manager role by ${callerId}`);

      return {
        success: true,
        message: `User has been removed from manager role successfully.`,
        userId: targetUserId,
        previousRole: ROLES.MANAGER,
        newRole: ROLES.USER,
        removedBy: callerId,
        removedAt: new Date().toISOString(),
      };

    } catch (error) {
      logger.error("Error removing manager role:", error);
      throw new Error(sanitizeError(error, 'removeManager'));
    }
  }
);

/**
 * Get user role for UI rendering
 * Returns the current user's role
 */
exports.getUserRole = onCall(
  {
    region: "us-central1",
  },
  async (request) => {
    logger.info("Get user role function called", {
      userId: request.auth?.uid,
    });

    try {
      // Rate limiting check
      if (!await checkRateLimit(request.auth?.uid, 'getUserRole')) {
        throw new Error("Rate limit exceeded. Please try again later.");
      }

      if (!request.auth) {
        throw new Error("The function must be called while authenticated.");
      }

      const userId = request.auth.uid;

      const userRole = await getUserRole(userId);

      logger.info(`User ${userId} role retrieved: ${userRole}`);

      return {
        success: true,
        userId: userId,
        role: userRole,
        roleLevel: ROLE_HIERARCHY[userRole],
        permissions: {
          canManageUsers: hasRoleLevel(userRole, ROLES.MANAGER),
          canAssignManager: hasRoleLevel(userRole, ROLES.ADMIN),
          canAssignAdmin: userRole === ROLES.OWNER,
          canTransferAdmin: userRole === ROLES.OWNER || userRole === ROLES.ADMIN,
        },
        retrievedAt: new Date().toISOString(),
      };

    } catch (error) {
      logger.error("Error getting user role:", error);
      throw new Error(sanitizeError(error, 'getUserRole'));
    }
  }
);

/**
 * Transfer admin role to another manager
 * Requires: Owner or Admin role
 * If Admin transfers, they lose their admin role and become a user
 */
exports.transferAdmin = onCall(
  {
    region: "us-central1",
  },
  async (request) => {
    logger.info("Transfer admin function called", {
      targetUserId: request.data?.userId,
      callerId: request.auth?.uid,
    });

    try {
      // Rate limiting check
      if (!await checkRateLimit(request.auth?.uid, 'transferAdmin')) {
        throw new Error("Rate limit exceeded. Please try again later.");
      }

      // Input validation
      const validationErrors = validateRoleManagementInput(request.data, request.auth);
      if (validationErrors.length > 0) {
        throw new Error(`Validation failed: ${validationErrors.join(', ')}`);
      }

      if (!request.auth) {
        throw new Error("The function must be called while authenticated.");
      }

      const callerId = request.auth.uid;
      const targetUserId = request.data?.userId;

      if (!targetUserId) {
        throw new Error("User ID is required.");
      }

      if (callerId === targetUserId) {
        throw new Error("You cannot transfer admin role to yourself.");
      }

      // Use transaction to prevent race conditions
      await executeTransaction(async (transaction) => {
        const db = admin.firestore();
        const callerRef = db.collection('users').doc(callerId);
        const targetRef = db.collection('users').doc(targetUserId);

        // Get both user documents in transaction
        const [callerDoc, targetDoc] = await Promise.all([
          transaction.get(callerRef),
          transaction.get(targetRef)
        ]);

        // Validate caller exists and has permission
        if (!callerDoc.exists) {
          throw new Error("Caller user not found.");
        }

        const callerRole = callerDoc.data().role || ROLES.USER;
        if (callerRole !== ROLES.OWNER && callerRole !== ROLES.ADMIN) {
          throw new Error("Insufficient permissions. Owner or Admin role required to transfer admin.");
        }

        // Validate target user exists and is a manager
        if (!targetDoc.exists) {
          throw new Error("Target user not found or insufficient permissions.");
        }

        const targetUserRole = targetDoc.data().role || ROLES.USER;
        if (targetUserRole !== ROLES.MANAGER) {
          throw new Error("Target user must be a manager to receive admin role.");
        }

        // Transfer admin role to target user
        transaction.update(targetRef, {
          role: ROLES.ADMIN,
          roleUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
          roleUpdatedBy: callerId
        });

        // If the caller is an Admin (not Owner), downgrade them to User
        if (callerRole === ROLES.ADMIN) {
          transaction.update(callerRef, {
            role: ROLES.USER,
            roleUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
            roleUpdatedBy: callerId
          });
          logger.info(`Admin role transferred from ${callerId} to ${targetUserId}. Previous admin downgraded to user.`);
        } else {
          logger.info(`Admin role transferred from ${callerId} to ${targetUserId} by Owner.`);
        }
      });

      return {
        success: true,
        message: `Admin role has been transferred successfully.`,
        previousAdmin: callerId,
        newAdmin: targetUserId,
        callerDowngraded: await getUserRole(callerId) === ROLES.USER,
        transferredAt: new Date().toISOString(),
      };

    } catch (error) {
      logger.error("Error transferring admin role:", error);
      throw new Error(sanitizeError(error, 'transferAdmin'));
    }
  }
);
