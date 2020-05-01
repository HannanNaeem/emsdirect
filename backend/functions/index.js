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

