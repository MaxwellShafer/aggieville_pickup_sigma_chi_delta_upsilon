const admin = require("firebase-admin");
const { logger } = require("firebase-functions");

// Rate limiting configuration
const RATE_LIMITS = {
  assignManager: { maxCalls: 10, windowMs: 60000 }, // 10 calls per minute
  assignAdmin: { maxCalls: 5, windowMs: 60000 },    // 5 calls per minute
  removeManager: { maxCalls: 10, windowMs: 60000 }, // 10 calls per minute
  getUserRole: { maxCalls: 30, windowMs: 60000 },   // 30 calls per minute
  transferAdmin: { maxCalls: 3, windowMs: 60000 },  // 3 calls per minute
  verifyUser: { maxCalls: 20, windowMs: 60000 },    // 20 calls per minute
  createUserRequest: { maxCalls: 5, windowMs: 60000 } // 5 calls per minute
};

// Firebase UID validation regex
const FIREBASE_UID_REGEX = /^[a-zA-Z0-9_-]{28}$/;

// Email validation regex
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

/**
 * Validate Firebase UID format
 */
function validateFirebaseUID(uid) {
  if (!uid || typeof uid !== 'string') {
    return false;
  }
  return FIREBASE_UID_REGEX.test(uid);
}

/**
 * Validate email format
 */
function validateEmail(email) {
  if (!email || typeof email !== 'string') {
    return false;
  }
  return EMAIL_REGEX.test(email);
}

/**
 * Validate display name format
 */
function validateDisplayName(displayName) {
  if (!displayName || typeof displayName !== 'string') {
    return false;
  }
  // Allow alphanumeric, spaces, hyphens, underscores, and common punctuation
  const DISPLAY_NAME_REGEX = /^[a-zA-Z0-9\s\-_.,!?()]{1,100}$/;
  return DISPLAY_NAME_REGEX.test(displayName);
}

/**
 * Rate limiting implementation using Firestore
 */
async function checkRateLimit(userId, functionName) {
  const db = admin.firestore();
  const rateLimitDoc = db.collection('rate_limits').doc(`${userId}_${functionName}`);
  
  const now = Date.now();
  const windowMs = RATE_LIMITS[functionName].windowMs;
  const maxCalls = RATE_LIMITS[functionName].maxCalls;
  
  try {
    const doc = await rateLimitDoc.get();
    
    if (!doc.exists) {
      // First call - create rate limit document
      await rateLimitDoc.set({
        calls: 1,
        windowStart: now,
        lastCall: now
      });
      return true;
    }
    
    const data = doc.data();
    const windowStart = data.windowStart || now;
    
    // Check if we're in a new time window
    if (now - windowStart > windowMs) {
      // Reset the window
      await rateLimitDoc.update({
        calls: 1,
        windowStart: now,
        lastCall: now
      });
      return true;
    }
    
    // Check if user has exceeded rate limit
    if (data.calls >= maxCalls) {
      logger.warn(`Rate limit exceeded for user ${userId} on function ${functionName}`, {
        userId,
        functionName,
        calls: data.calls,
        maxCalls,
        windowStart,
        now
      });
      return false;
    }
    
    // Increment call count
    await rateLimitDoc.update({
      calls: admin.firestore.FieldValue.increment(1),
      lastCall: now
    });
    
    return true;
  } catch (error) {
    logger.error('Rate limiting error:', error);
    // Fail open - allow the request if rate limiting fails
    return true;
  }
}

/**
 * Sanitize error messages to prevent information disclosure
 */
function sanitizeError(error, context = '') {
  // Log the full error for debugging
  logger.error(`Error in ${context}:`, error);
  
  // Return generic error messages
  if (error.message.includes('not found')) {
    return 'User not found or insufficient permissions.';
  }
  if (error.message.includes('permission') || error.message.includes('role')) {
    return 'Insufficient permissions for this operation.';
  }
  if (error.message.includes('validation') || error.message.includes('format')) {
    return 'Invalid input provided.';
  }
  
  return 'An error occurred while processing your request.';
}

/**
 * Comprehensive input validation for role management functions
 */
function validateRoleManagementInput(data, auth) {
  const errors = [];
  
  // Validate authentication
  if (!auth || !auth.uid) {
    errors.push('Authentication required');
  } else if (!validateFirebaseUID(auth.uid)) {
    errors.push('Invalid authentication token');
  }
  
  // Validate userId if provided
  if (data.userId !== undefined) {
    if (!data.userId || typeof data.userId !== 'string') {
      errors.push('User ID is required and must be a string');
    } else if (!validateFirebaseUID(data.userId)) {
      errors.push('Invalid user ID format');
    }
  }
  
  // Validate email if provided
  if (data.email !== undefined && data.email !== null) {
    if (!validateEmail(data.email)) {
      errors.push('Invalid email format');
    }
  }
  
  // Validate display name if provided
  if (data.displayName !== undefined && data.displayName !== null) {
    if (!validateDisplayName(data.displayName)) {
      errors.push('Invalid display name format');
    }
  }
  
  return errors;
}

/**
 * Execute Firestore transaction with retry logic
 */
async function executeTransaction(transactionFunction, maxRetries = 3) {
  const db = admin.firestore();
  
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await db.runTransaction(transactionFunction);
    } catch (error) {
      if (error.code === 'failed-precondition' && attempt < maxRetries) {
        // Retry on transaction conflicts
        logger.warn(`Transaction attempt ${attempt} failed, retrying...`, error);
        await new Promise(resolve => setTimeout(resolve, Math.random() * 1000));
        continue;
      }
      throw error;
    }
  }
}

module.exports = {
  validateFirebaseUID,
  validateEmail,
  validateDisplayName,
  checkRateLimit,
  sanitizeError,
  validateRoleManagementInput,
  executeTransaction,
  RATE_LIMITS
};
