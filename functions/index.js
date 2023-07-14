const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();

exports.myFunction = functions.firestore
  .document("chat/{chatId}/messages/{messagesId}")
  .onCreate(async (snapshot, context) => {
    const messageData = snapshot.data();
    const emailId = messageData.sendTo; // Accessing "sendTo" directly from messageData
    allDeviceTokens = [];

    try {
      const tokenDocs = await db
        .collection("users")
        .doc(emailId)
        .collection("tokens")
        .get();

      if (tokenDocs.empty) {
        console.log("No Devices");
      } else {
        for (const doc of tokenDocs.docs) {
          allDeviceTokens.push(doc.data().DeviceToken);
          //console.log(doc.data().DeviceToken); // Logging each DeviceToken
        }
        // Debug printing
        //console.log(allDeviceTokens.length);
      }

      const message = {
        notification: {
          title: `New Message From ${messageData.userName}`,
          body: messageData.text,
        },
        tokens: allDeviceTokens, 
      };

      return admin
        .messaging()
        .sendEachForMulticast(message)
        .then((response) => {
          console.log("Successfully sent message:", response);
          return null;
        })
        .catch((error) => {
          console.log("Error sending message:", error);
          return null;
        });
    } catch (error) {
      console.log("Error retrieving tokens:", error);
      return null;
    }
  });
