
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
/*
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});
*/

Parse.Cloud.job("deleteOldEntries", function(request, status) {

var Battle = Parse.Object.extend("Battle");
var query = new Parse.Query(Battle);

var day = new Date();
day.setDate(day.getDate()-3);

query.lessThan("createdAt", day);

    query.find({
            success:function(results) {
              for (var i = 0, len = results.length; i < len; i++) {
                  var result = results[i];
                  result.destroy({});
                  console.log("Destroy: "+result);
              }   
            status.success("Delete successfully.");             
            },
            error: function(error) {
              status.error("Uh oh, something went wrong.");
              console.log("Failed!");         
            }
    })

var BattleEntry = Parse.Object.extend("BattleEntry");
query = new Parse.Query(BattleEntry);

day = new Date();
day.setDate(day.getDate()-3);

query.lessThan("createdAt", day);

    query.find({
            success:function(results) {
              for (var i = 0, len = results.length; i < len; i++) {
                  var result = results[i];
                  result.destroy({});
                  console.log("Destroy: "+result);
              }   
            status.success("Delete successfully.");             
            },
            error: function(error) {
              status.error("Uh oh, something went wrong.");
              console.log("Failed!");         
            }
    })
});