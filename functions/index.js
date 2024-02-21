const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();

exports.sendChatNotification = functions.firestore
  .document("chat/{chatId}/messages/{messagesId}")
  .onCreate(async (snapshot, context) => {
    const chatID = context.params.chatId;
    const messageData = snapshot.data();
    const emailId = messageData.sendTo; // Accessing "sendTo" directly from messageData
    const chatPartnerId = messageData.userId;
    const ListingId = messageData.ListingId;
    const chatPartnerName = messageData.userName;
    const messageContent = messageData.text;
    allDeviceTokens = [];

    try {
      const tokenDocs = await db
        .collection("users")
        .doc(emailId)
        .collection("tokens")
        .get();

      const listingInfo = await db
        .collection('Listings')
        .doc(ListingId)
        .get();

      const listingPicture = listingInfo.data().image;

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
        data: {
          type: 'chat',
          chatId: chatID,
          chatPartnerId: chatPartnerId,
          chatPartnerName: chatPartnerName,
          ListingId: ListingId,
          messageContent: messageContent,
          listingPicture: listingPicture,
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

exports.listingNotifications = functions.firestore
  .document("users/{emailID}/likes/{listingID}")
  .onUpdate(async (snapshot, context) => {
    const isExpired = snapshot.after.data()?.isExpired; // Optional chaining to safely access the field
    if (isExpired === true) {
      const emailID = context.params.emailID;
      const listingID = context.params.listingID;
      console.log("emailID:", emailID);
      console.log("listingID:", listingID);

      const expiryDate = new Date(snapshot.after.data()?.expiryDate?.toDate()); // Convert Firestore Timestamp to JavaScript Date
      const itemExpiryDate = expiryDate.toLocaleString(); // Format the expiry date

      console.log("Expiry Date:", itemExpiryDate);

      allDeviceTokens = [];

      try {
        const tokenDocs = await db.collection("users").doc(emailID).collection("tokens").get();
        const itemName = (await db.collection("Listings").doc(listingID).get()).data()?.itemName.toString(); // Use get() to access the document data
        
        const listingInfo = await db
        .collection('Listings')
        .doc(listingID)
        .get();

        const listingPicture = listingInfo.data().image;

        if (tokenDocs.empty) {
          console.log("No Devices");
        } else {
          tokenDocs.forEach((doc) => {
            allDeviceTokens.push(doc.data().DeviceToken);
          });
        }

        const message = {
          notification: {
            title: "An Item You Liked Has Expired!",
            body: `${itemName} has expired on ${itemExpiryDate}`,
          },
          data: {
            type: 'expiredItem',
            ListingId: listingID,
            userId: emailID,
            itemName: itemName,
            itemExpiryDate: itemExpiryDate, 
            listingPicture: listingPicture,
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
    }
});

exports.scheduledFunctionCrontab = functions.pubsub.schedule('0 0 * * *')
  .timeZone('America/New_York') // Users can choose timezone - default is America/Los_Angeles
  .onRun((context) => {
  console.log('This will be run every day at 11:05 AM Eastern!');
  return null;
});