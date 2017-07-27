import { Meteor } from 'meteor/meteor';
import { Template } from 'meteor/templating';
 
import { Assets } from '../api/assets.js';
 
import './asset.html';
// import './asset_details.html';

Template.asset.helpers({
  isOwner() {
    return this.owner === Meteor.userId();
  },
});

Template.asset.events({

  'click .view-details'() {

    $("#main-table").hide();

    let content = _getAssetDetailContent(this);

    $("#details-view").html(content).show();
    // $("#details-view").show();

    console.log(this);
  },
});


function _getAssetDetailContent (asset){


  let content = "<header>"+
    "<h3>Details for file " + asset.basename + "</h3>" +
  "</header>"+
  "<table class='table table-striped table-condensed'>"+
    "<thead>"+
      "<tr>"+
        "<th>Parameter</th>"+
        "<th>Value</th>"+
      "</tr>"+
    "</thead>"+
    "<tbody>"+
      "<tr>"+
        "<td>basename</td>"+
        "<td>" + asset.basename + "</td>"+
      "</tr>"+
      "<tr>"+
        "<td>path</td>"+
        "<td>" + asset.path + "</td>"+
      "</tr>"+
      "<tr>"+
        "<td>date created</td>"+
        "<td>" + asset.date_created + "</td>"+
      "</tr>"+
      "<tr>"+
        "<td>date modified</td>"+
        "<td>" + asset.date_modified + "</td>"+
      "</tr>"+
      "<tr>"+
        "<td>bytes size</td>"+
        "<td>" + asset.bytes_size + "</td>"+
      "</tr>"+
      "<tr>"+
        "<td>owner</td>"+
        "<td>"+ asset.owner + "</td>"+
      "</tr>"+
      "<tr>"+
        "<td>group</td>"+
        "<td>" + asset.group +"</td>"+
      "</tr>"+
    "</tbody>"+
  "</table>"+
  "<button class='hide-details'>Hide</button>";

  return content;
}