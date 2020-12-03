import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

//const db = admin.firestore();
const fcm = admin.messaging();
export const sendToTopic = functions.firestore
  .document('chatRoom/{roomId}/chats/{chatId}')
  .onCreate(async snapshot => {
    const chat = snapshot.data();

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New DM!',
        body: `${chat.sendBy} sent a message`,
        
        click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
      }
    };

    return fcm.sendToTopic(chat.chatRoom, payload);
    
  });
  
  
export const sendToNewTopic = functions.firestore
  .document('team/{teamId}/chats/{chatId}')
  .onCreate(async snapshot => {
    const chats = snapshot.data();

    const payload_new: admin.messaging.MessagingPayload = {
      notification: {
        title: `New Message in the team:${chats.team.split("_")[0]} `,
        body: `${chats.sendBy} sent a message`,
        
        click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
      }
    };

    return fcm.sendToTopic(chats.team, payload_new);
  });

export const sendToVideoCall = functions.firestore
  .document('team/{teamId}/VideoCall/{VideoCallId}')
  .onCreate(async snapshot => {
    const call = snapshot.data();

    const payload_new: admin.messaging.MessagingPayload = {
      notification: {
        title: `Meeting in team: ${call.team.split("_")[0]} `,
        body: `${call.user} joined meeting in the team: ${call.team.split("_")[0]}`,
        
        click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
      }
    };

    return fcm.sendToTopic(call.team.split("@")[0]+"videoCall", payload_new);
  });
  