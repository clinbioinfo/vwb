import { Meteor } from 'meteor/meteor';
import { Template } from 'meteor/templating';
import { ReactiveDict } from 'meteor/reactive-dict';
 
import { Assets } from '../api/assets.js';
 
import './asset.js';
import './asset_details.js';
import './body.html';

Template.body.onCreated(function bodyOnCreated() {
    this.state = new ReactiveDict();
    Meteor.subscribe('assets');
});

Template.body.helpers({
  assets() {

    const instance = Template.instance();

    return Assets.find({}, { sort: { date_modified: -1 } });
  },
  fileCount() {
    return Assets.find().count();
  },
});

Template.body.events({
  'click .hide-details'() {

    $("#main-table").removeAttr('style').show();

    $("#details-view").html('').css('display', 'none').hide();

    console.log("In the body - should have hidden the details view")
  },
});
