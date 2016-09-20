Parse.Cloud.define("email", function(request, response) {
var Mandrill = require('mandrill');
Mandrill.initialize('g6fHKSFERBja0XRxIRyS3g');
Mandrill.sendEmail({
    message: {
    	html:request.params.htmlCode,
        text:request.params.text,
        subject: request.params.username,
        from_email: "mike@myally.tech",
        from_name: "Ally App",
        to: [
            {
                email:request.params.email,
                name: "Ally needs you help!"
            }
        ]
    },
    async: true
},{
    success: function(httpResponse) {
        response.success("email sent");
    },
    error: function(httpResponse) {
        response.error("Something went wrong");
    }
}
);
});



//add match relation
Parse.Cloud.define("addMatchToMatchRelation", function(request, response) {
  
    Parse.Cloud.useMasterKey();
  
    var matchRequestId = request.params.matchRequest;
    var query = new Parse.Query("MatchRequest");
    console.log("step 1")
    //get the friend request object
    query.get(matchRequestId, {
  
        success: function(matchRequest) {
  
            //get the user the request was from
            //something else
            var fromUser = matchRequest.get("fromUser");
            //get the user the request is to
            var toUser = matchRequest.get("toUser");
  
            var relation = fromUser.relation("match");
            //add the user the request was to (the accepting user) to the fromUsers friends
            relation.add(toUser);
  
            //save the fromUser
            fromUser.save(null, {
  
                success: function() {
  
                    //saved the user, now edit the request status and save it
                    //matchRequest.set("status", "pending");
                    matchRequest.save(null, {
  
                        success: function() {
  
                            response.success("saved relation and updated matchRequest");
                        }, 
  
                        error: function(error) {
  
                            response.error("Error 1");
                        }
  
                    });
  
                },
  
                error: function(error) {
  
                 response.error("Error 2");
  
                }
  
            });
  
        },
  
        error: function(error) {
  
            response.error("error 3");
  
        }
  
    });
  
});