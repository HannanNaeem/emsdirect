'use strict';
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

// using sleep
function sleep(milliseconds) {
    var start = new Date().getTime();
    for (var i = 0; i < 1e30; i++) {
      if ((new Date().getTime() - start) > milliseconds){
        break;
      }
    }
  }


//firestore trigger for pending emergency ignored
exports.trackIgnored = functions.firestore.document('/PendingEmergencies/{id}').onCreate((snap, context) => {

    console.log("emergency added");
    const patientId = context.params.id;
    const docRef = admin.firestore().collection('PendingEmergencies').doc(patientId);


    //sleep for 40 seconds
    sleep(30000);

    docRef.get().then((emergency) => {
        
        if(!emergency.exists){
            console.log("Emergency was accepted before time limit");
        } else {
            console.log("incrementing declines");
            //set data
            return docRef.update({declines : 4});
        }
        return null;
    }).catch(error => {console.log(error)});



    return null;
});


exports.notifyPendingToMfrs = functions.firestore.document('/PendingEmergencies/{id}').onCreate(async (snap, context) => {

  console.log("Notifying available Mfrs");
  //getting the patient id for payload/notification content
  const patientId = context.params.id;
 
  //querying all the mfrs that are available and adding their roll no -> doc id to this list
  var availableMfrsList = [];
  const availableMfrsQuery =  await admin.firestore().collection('Mfr').where('isActive', "==", true).where('isOccupied', "==", false).get();
  availableMfrsQuery.forEach(mfrDoc => availableMfrsList.push(mfrDoc.id));
  console.log(availableMfrsList);
  
  //if there is no availble mfr abort
  if(availableMfrsList.length === 0){
    console.log("No available mfrs... aborting");
    return false;
  }
  //now get the user data for these roll no
  const userDataQuery = await admin.firestore().collection('UserData').where('rollNo', 'in', availableMfrsList).get();

  //We have the tokens in this this userDataQuery documents. We will now make a list of all tokens in these docs
  var targetTokens = []; // send the notifications to tokens in this list
  userDataQuery.forEach(userDoc => targetTokens.push(userDoc.data().token))
  console.log(targetTokens);

  //setting up notification payload
  const payload = {
    notification: {title: "New emergency!", body: "There is a new emergency from ${patientId}", sound: "enabled"},
    priority: "high",
  }
  
  //send messages
  try{
    const response = await admin.messaging().sendToDevice(targetTokens,payload);
    console.log("Notifications sent successfully to ", targetTokens);
  } catch(e) {
    console.log(e);
  }

  return true;

});