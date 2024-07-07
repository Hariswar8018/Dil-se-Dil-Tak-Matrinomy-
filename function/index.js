const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Initialize Firebase Admin with your service account
const serviceAccount = require("./path-to-service-account-file.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

exports.generateCustomToken = functions.https.onRequest(async (req, res) => {
  const { uid } = req.body;

  if (!uid) {
    return res.status(400).send("UID is required.");
  }

  try {
    // Generate the custom token
    const customToken = await admin.auth().createCustomToken(uid);
    return res.status(200).send({ customToken });
  } catch (error) {
    console.error("Error generating custom token:", error);
    return res.status(500).send({ error: "Internal Server Error" });
  }
});
