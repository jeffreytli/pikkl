
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
/*
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});
*/

Parse.Cloud.afterSave("Average", function(request) {
  query = new Parse.Query("Post");
  query.get(request.object.get("post").id, {
    success: function(post) {
      post.increment("comments");
      post.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});

var Battle = Parse.Object.extend("BattleEntry");
var query = new Parse.Query(Battle);
query.get("xWMyZ4YEGZ", {
  success: function(gameScore) {
    // The object was retrieved successfully.
  },
  error: function(object, error) {
    // The object was not retrieved successfully.
    // error is a Parse.Error with an error code and message.
  }
});



let query = PFQuery(className:"BattleEntry")
        query.whereKey("battle", equalTo:battleId)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count)  jobs from database.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        if(object["avgScore"] == nil) {
                            object["avgScore"] = self.getFinalScore(object)
                            object.saveInBackground()
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
