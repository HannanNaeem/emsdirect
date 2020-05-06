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


//firestore trigger for pending emergency ignored and notify ops
exports.trackIgnored = functions.firestore.document('/PendingEmergencies/{id}').onCreate(async (snap, context) => {

    console.log("emergency added");
    const patientId = context.params.id;
    const docRef = admin.firestore().collection('PendingEmergencies').doc(patientId);
    const userData = admin.firestore().collection('UserData');


    //sleep for 40 seconds
    sleep(30000);

    var emergency = await docRef.get();
        
    if(!emergency.exists){

        console.log("Emergency was accepted before time limit");

    } else if(emergency.data().severity === "low" || emergency.data().severity === "medium") {

        console.log("incrementing declines");
        //set data
        docRef.update({declines : 4});

        //Before ending notify ops about the emergency
        //We simply need to query the userData docs that have loggedInAs : "ops" and send them a message
        const opsQuerySnapshot = await userData.where('loggedInAs', '==','ops').get();

        var targetTokens = [];
        //filter out the tokens from the fetched userData docs
        opsQuerySnapshot.forEach(userDoc => targetTokens.push(userDoc.data().token));
        console.log(targetTokens);

        //setting up notification payload
        const payload = {
        notification: {title: "Ignored emergency!", body: `There is a new Ignored Emergency!`, sound: "default"},
        }

        //send messages
        try{
          const response = await admin.messaging().sendToDevice(targetTokens,payload);
          console.log("Notifications sent successfully to ", targetTokens);
        } catch(e) {
          console.log(e);
        }
    }
     
 



    return null;
});

exports.notifyEmergency = functions.firestore.document('/PendingEmergencies/{id}').onCreate(async (snap,context) => {

  console.log("Notifying ops for severe emergency");
  const patientId = context.params.id;
  var targetTokens = [];
  var payload;

  //if the emergency is severe == high or critical
  if(snap.data().severity === "high" || snap.data().severity === "critical") { //! Notify ops

    //get ops that are logged in
    const opsQuerySnapshot = await admin.firestore().collection('UserData').where('loggedInAs', '==','ops').get();

    targetTokens = [];
    //filter out the tokens from the fetched userData docs
    opsQuerySnapshot.forEach(userDoc => targetTokens.push(userDoc.data().token));
    console.log(targetTokens);

    //setting up notification payload
    payload = {
    notification: {title: "Severe emergency!", body: `There is a new Severe Emergency!\nSeverity: ${snap.data().severity}`, sound: "default"},
    }

    //send messages
    try{
      const response = await admin.messaging().sendToDevice(targetTokens,payload);
      console.log("Notifications sent successfully to ", targetTokens);
    } catch(e) {
      console.log(e);
    }

  } else if(snap.data().severity === "low" || snap.data().severity === "medium") { //! we need to notify MFRS instead
 
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
    targetTokens = []; // send the notifications to tokens in this list
    userDataQuery.forEach(userDoc => targetTokens.push(userDoc.data().token));
    console.log(targetTokens);

    //setting up notification payload
    payload = {
      notification: {title: "New emergency!", body: `There is a new emergency from ${patientId}`, sound: "default"},
    }
    
    //send messages
    try{
      const response = await admin.messaging().sendToDevice(targetTokens,payload);
      console.log("Notifications sent successfully to ", targetTokens);
    } catch(e) {
      console.log(e);
    }
  }

  return true;

});

exports.setIsOccupied = functions.firestore.document('/OngoingEmergencies/{id}').onCreate(async (snap,context) => {

  //setting the MFR's isOccupied who accepted the emergecny to true
  const patientId = context.params.id;
  // first set reference to mfr
  const mfrRef = admin.firestore().collection('Mfr').doc(snap.data().mfr);

  try{
    //this is the mfr that has been assigned/has accepted the emergency. Set there isOccupied to true and force isActive on
    mfrRef.update({
      isOccupied : true,
      isActive : true,
    });

  } catch(e) {
    console.log(e);
    return false;
  }

  return true;

});

// trigger to decrement equipment on emergency reported
exports.decrementEquipment = functions.firestore.document('/ReportedEmergencies/{id}').onCreate(async (snap,context) =>{

  //get the name of bag used
  var bagUsed = snap.data().bagUsed;
  
  //if no bag was used ==> no equipment was used  we can abort rightaway
  if(bagUsed === "None" || bagUsed === null){
    console.log("No equipment was used");
    return false;
  }
  //otherwise we need to get the contents of this bag
  
  //get the equipment used map from the document created first
  var equipmentInfo = snap.data().equipmentUsed;
  var equipmentNameList = Object.keys(equipmentInfo);

  //proceed to get the bag used from firestore
  const bagRef = admin.firestore().collection('EquipmentBags').doc(bagUsed);
 

  const bagState = await bagRef.get();
  console.log(`got ${bagState.data()}`);

  //Now decrement each field
  try{
    equipmentNameList.forEach(equipment => {
      bagRef.update({
        equipment : bagState[equipment] - equipmentInfo[equipmentInfo] < 0 ?  0 : bagState[equipment] - equipmentInfo[equipmentInfo],
      })
    });
  } catch(e){
    console.log(e);
    console.log("Bag Update failed")
  }

  return true

});



// Function to notify MFRS for pending emergency
// exports.notifyPendingToMfrs = functions.firestore.document('/PendingEmergencies/{id}').onCreate(async (snap, context) => {

//   console.log("Notifying available Mfrs");
//   //getting the patient id for payload/notification content
//   const patientId = context.params.id;

//   //check if the severity is low /medium then notify
//   if(snap.data().severity === "low" || snap.data().severity === "medium") {
 
//     //querying all the mfrs that are available and adding their roll no -> doc id to this list
//     var availableMfrsList = [];
//     const availableMfrsQuery =  await admin.firestore().collection('Mfr').where('isActive', "==", true).where('isOccupied', "==", false).get();
//     availableMfrsQuery.forEach(mfrDoc => availableMfrsList.push(mfrDoc.id));
//     console.log(availableMfrsList);
    
//     //if there is no availble mfr abort
//     if(availableMfrsList.length === 0){
//       console.log("No available mfrs... aborting");
//       return false;
//     }
//     //now get the user data for these roll no
//     const userDataQuery = await admin.firestore().collection('UserData').where('rollNo', 'in', availableMfrsList).get();

//     //We have the tokens in this this userDataQuery documents. We will now make a list of all tokens in these docs
//     var targetTokens = []; // send the notifications to tokens in this list
//     userDataQuery.forEach(userDoc => targetTokens.push(userDoc.data().token));
//     console.log(targetTokens);

//     //setting up notification payload
//     const payload = {
//       notification: {title: "New emergency!", body: `There is a new emergency from ${patientId}`, sound: "default"},
//     }
    
//     //send messages
//     try{
//       const response = await admin.messaging().sendToDevice(targetTokens,payload);
//       console.log("Notifications sent successfully to ", targetTokens);
//     } catch(e) {
//       console.log(e);
//     }
//   }

//   return true;

// });