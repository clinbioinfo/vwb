import { Meteor } from 'meteor/meteor';
import { Mongo } from 'meteor/mongo';
import { check } from 'meteor/check';
 
export const Assets = new Mongo.Collection('assets');
 
if (Meteor.isServer) {
    // This code only runs on the server
    // Only publish assets that are public or belong to the current user
    Meteor.publish('assets', function assetsPublication() {
	return Assets.find({
	    $or: [
		{ private: { $ne: true } },
		{ owner: this.userId },
	    ],
	});
    });
}

Meteor.methods({
  // 'assets.insert'(text) {
  //   check(text, String);
 
  //   // Make sure the user is logged in before inserting a asset
  //   if (! Meteor.userId()) {
  //     throw new Meteor.Error('not-authorized');
  //   }
 
  //   Assets.insert({
  //     text,
  //     createdAt: new Date(),
  //     owner: Meteor.userId(),
  //     username: Meteor.user().username,
  //   });
  // },
  // 'assets.remove'(assetId) {
  //   check(assetId, String);

  //     const asset = Assets.findOne(assetId);
  //     if (asset.private && asset.owner !== Meteor.userId()) {
	 //  // If the asset is private, make sure only the owner can delete it
	 //  throw new Meteor.Error('not-authorized');
  //     }
      
  //     Assets.remove(assetId);
  // },
  // 'assets.setChecked'(assetId, setChecked) {
  //     check(assetId, String);
  //     check(setChecked, Boolean);

  //     const asset = Assets.findOne(assetId);
  //     if (asset.private && asset.owner !== Meteor.userId()) {
	 //  // If the asset is private, make sure only the owner can check it off
	 //  throw new Meteor.Error('not-authorized');
  //     }
      
  //     Assets.update(assetId, { $set: { checked: setChecked } });
  // },
  // 'assets.setPrivate'(assetId, setToPrivate) {
  //   check(assetId, String);
  //   check(setToPrivate, Boolean);
 
  //   const asset = Assets.findOne(assetId);
 
  //   // Make sure only the asset owner can make a asset private
  //   if (asset.owner !== Meteor.userId()) {
  //     throw new Meteor.Error('not-authorized');
  //   }
 
  //   Assets.update(assetId, { $set: { private: setToPrivate } });
  // },
});
