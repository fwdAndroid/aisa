const functions = require("firebase-functions");
const admin = require('firebase-admin');
const { Change } = require('firebase-functions');
const { storage } = require("firebase-admin");
admin.initializeApp(
 
);
const db = admin.firestore();

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions
exports.likefunction = functions.firestore
  .document('posts/{docId}')
  .onWrite(async(change, context) => { 
   const userid=change.after.data()["userid"];
   const likes=change.before.data()["likes"];
   const dislike=change.before.data()["likes"];
   const afterlike=change.after.data()["likes"];
   const postid=change.before.data()["postid"];
   const id=change.after.data()["notification"];
   let name=change.after.data()[postid+"name"];
   if( userid==id){
     console.log("myid");
   }else{
   if(likes+1==afterlike){
    console.log(userid);
    console.log(postid);
 

   
    const querySnapshot= await db.collection("user").doc(userid).get();
    console.log("hello");
    
 
     if(querySnapshot.exists){

         const token=querySnapshot.data()["token"];
         const username=querySnapshot.data()["firstname"]
         console.log(token)
         const payload = {
           data:{
            
              "type":"likes",
              "postid":postid
            
           },
           notification: {
           title: username,
           
          body: name+" likes your post",
          
           }
         };
         admin.messaging().sendToDevice(
           token,payload
 
 
 
 
    );
         }
   }else if(likes-1==afterlike){
    console.log(userid);
   
    const querySnapshot= await db.collection("user").doc(userid).get();
    console.log("hello");
    
 
     if(querySnapshot.exists){
         const token=querySnapshot.data()["token"];
         const username=querySnapshot.data()["firstname"]
         console.log(token)
         const payload = {
          data:{
            
            "type":"likes",
            "postid":postid
          
         },
           notification: {
           title: username,
          
           body:name+" dislikes your post",
           
           }
         };
         admin.messaging().sendToDevice(
           token,payload
 
 
 
 
    );
         }
   }
  }
   
      
      });


        exports.commentfunction = functions.firestore
  .document('comments/{docId}')
  .onWrite(async(change, context) => { 
   const postid=change.after.data()["postid"];
   const commentby=change.after.data()["username"];
   const notificationuserid=change.after.data()["userid"];
   const getpost=await db.collection("posts").doc(postid).get();
   if(getpost.exists){
    const userId= getpost.data()["userid"];
    if(userId==notificationuserid){
      console.log("my id");
    }else{
    const querySnapshot= await db.collection("user").doc(userId).get();
    console.log("hello");
    
 
     if(querySnapshot.exists){
         const token=querySnapshot.data()["token"];
         const username=querySnapshot.data()["firstname"]
         console.log(token)
         const payload = {
          data:{
            
            "type":"comment",
            "postid":postid
          
         },
           notification: {
           title: username,
           body: commentby +"  commented on your post",
           
           }
         };
         admin.messaging().sendToDevice(
           token,payload
 
 
 
 
    );
         }

   }
  }
}
      );
      exports.chatfunction=functions.firestore.document("/groups/{groupId}/messages/{messageId}").onWrite(async(change,context)=>{
        const userid=change.after.data()["sendto"];
        const sms=change.after.data()["sms"];
        const name=change.after.data()["name"];
        const groupname=change.after.data()["groupname"];
        const members=change.after.data()["members"];
        const groupid=change.after.data()["groupid"];
const grouptype=change.after.data()["grouptype"];
if(grouptype=="user"){
  
  const querySnapshot= await db.collection("user").doc(userid).get();
  
  console.log("hello");
  

   if(querySnapshot.exists){
       const token=querySnapshot.data()["token"];
       const username=querySnapshot.data()["firstname"]
       console.log(token)
       console.log("members")
       console.log(members)
       var mem=[];
       for(var data in members){
         mem.push(data);
       }
       var payload = {
        data:{
          "groupname":groupname,
          "members":JSON.stringify(members),
          "groupid":groupid,
          "gtype":grouptype,
          "type":"chat"
         },
         notification: {
         title: name,
         body: sms
         }
       };
       admin.messaging().sendToDevice(
         token,payload
);
       }


}else{
  console.log("group chat");
  // const userid=change.after.data()["sendto"];
  // const sms=change.after.data()["sms"];
  // const groupName=change.after.data()["groupname"];
  // const meMbers=change.after.data()["members"];
  // const grouPid=change.after.data()["groupid"];
 
  const name=change.after.data()["name"];
  for(let i=0;i<userid.length;i++){
    console.log("loop started");
    const querySnapshot= await db.collection("user").doc(userid[i]).get();
    console.log("hello");
     if(querySnapshot.exists){
         const token=querySnapshot.data()["token"];
         const username=querySnapshot.data()["firstname"]
         console.log(token)
         console.log(groupid)
         var mem=[];
         for(var data in members){
           mem.push(data);
         }
         console.log(members)
         var payload = {
           data:{
            "groupname":groupname,
            "members":JSON.stringify(members),
            "groupid":groupid,
            "gtype":grouptype,
            "type":"chat"
           },
           notification: {
           title: name,
           body: sms
          
           }
         };
         admin.messaging().sendToDevice(
           token,payload
  
  
  
  
    );
         }
  }
}

      });
      exports.businessrequest=functions.firestore.document("posts/{postsId}").onWrite(async(change,context)=>{
        const potype=change.after.data()["posttype"];
        const approval=change.after.data()["approved"];
        if(potype=="business"&&approval==false){
          const bname=change.after.data()["businessname"];
         await db.collection("admin").get().then(snapshot=>{
           snapshot.docs.forEach(admindata=>{
             console.log(admindata.data()["token"]);
             console.log("admin notification");
            const token=admindata.data()["token"];
            console.log(token);
            const payload = {
              notification: {
              title:bname ,
              body: "send you add request"
              }
            };
            admin.messaging().sendToDevice(
              token,payload
     
     
     
     
       );
           })
         });
 
  


        }else {
          const buserid=change.after.data()["userid"];
          const businessSnapshot= await db.collection("businessuser").doc(buserid).get();
          console.log("hello");
          
        
           if(businessSnapshot.exists){
            
               const btoken=businessSnapshot.data()["token"];
               const busername=businessSnapshot.data()["businessname"]
               
               console.log(btoken);
     console.log("notification send to businessuser");
               const payload = {
                 notification: {
                 title: busername,
                 body:"Admin Approved Your add"
                 }
               };
               admin.messaging().sendToDevice(
                 btoken,payload
        
        
        
        
          );
               }

        }

      });
      exports.deletedata = functions.pubsub.schedule('every 1 minutes').onRun(async(context) => {
        var myCurrentDate=new Date();
        var myPastDate=new Date(myCurrentDate.getTime()- (1000*60*60*24*3));
            // myPastDate.setDate(myCurrentDate.getTime()- (1000*60*60));
            console.log(myPastDate);
            
            await db.collection("posts").where("timestamp",'<=', myPastDate).get().then(snapshot=>{
              snapshot.docs.forEach(async data=>{
                console.log("document getted");
                const imagelink=data.data()["postimage"];
                const postid=data.data()["postid"]
                if(imagelink!=null){
                //   console.log("started deleted");
                // await admin.storage().bucket().refFromURL(imagelink).delete();
              
                  // console.log("image deleted");
                  const deledata=await db.collection("posts").doc(postid).delete().then(dele=>{
                    console.log("successfully deleted");
                  });
                  // await db.collection("posts").delete().where("timestamp","<=",myPastDate).then(newarray=>{
                  //   console.log("data deleted in post");
                  // });
               
                //   var nowdelete=storage.refFromURL(fileUrl);
                //   nowdelete.delete();
                //  const docid= data.id;
                //  await db.collection("posts").doc(docid).delete();

                  
                }
              }
              )
            });



      
      });
      exports.reportuser=functions.firestore.document("reportuser/{reportId}").onWrite(async(change,context)=>{
       
      
         
         await db.collection("admin").get().then(snapshot=>{
           const username =snapshot.data()["username"];
           snapshot.docs.forEach(admindata=>{
             console.log(admindata.data()["token"]);
             console.log("admin notification");
            const token=admindata.data()["token"];
            console.log(token);
            const payload = {
              notification: {
              title:"Reported User" ,
              body: "Some One Reported ${username}"
              }
            };
            admin.messaging().sendToDevice(
              token,payload
     
     
     
     
       );
           })
         });
 
  


       

      });
      exports.reportpost=functions.firestore.document("reportpost/{reportpostId}").onWrite(async(change,context)=>{
       
      
         
        await db.collection("admin").get().then(snapshot=>{
         
          snapshot.docs.forEach(admindata=>{
            console.log(admindata.data()["token"]);
            console.log("admin notification");
           const token=admindata.data()["token"];
           console.log(token);
           const payload = {
             notification: {
             title:"Post Removed Request" ,
             body: "User Request To Remove This Post"
             }
           };
           admin.messaging().sendToDevice(
             token,payload
    
    
    
    
      );
          })
        });

 


      

     });



      


