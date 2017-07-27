import { Meteor } from 'meteor/meteor';
import { Template } from 'meteor/templating';
 
import './asset_details.html';

Template.asset_details.helpers({
  // isOwner() {
  //   return this.owner === Meteor.userId();
  // },
});

Template.asset_details.events({
 
  'click .hide-details'() {

    $("#main-table").removeAttr('style').show();

    $("#details-view").html('').css('display', 'none').hide();

    console.log("Should have hidden the details view")
  },
});
