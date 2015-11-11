Differences between Alpha and Beta: In Alpha: the main functionality that we provided was integration with Facebook and Parse and providing the wireframes for all of our views.

In Beta: 
-The biggest difference is providing the user with the ability to Log in with Facebook and create a username. The username then gets stored in the Parse database. 
-We added the ability for users to create Battles/Competitions of their own, which is then synced up with parse and displayed in the Battle Table View Controller. 
-Users are able to enter any of these battles and start submitting pictures of their own to the Battle.
-Battle objects and Battle entry objects have been created and populated with data
-Users can submit photos (which are stored in parse) to be voted on in battles
-User can vote on battle entries
-Users can see a final screen, where all of the average scores per photo are showed
-The game is now fully playable, the phases of the battle change based on time


Julio
- did front-end (storyboard) and back-end programming for 'vote' and 'final' view controllers
- designed and created battle entry object in parse for keeping track of entries (created in submit view controller)
- implemented conditional segue for various stages in BattleTableViewController
- updated battle object to keep track of it's entries
- implemented the different phases of the battle along with their associated views within the story board
- implemented the logic for uploading, submitting and storing photos into Parse
- created voting system and updating of votes and average scores for final view

Jeffrey
- implemented all of the infrastructure and code for time based change of phases
- implemented core data for saving all of the battles, used in displaying the initial battle table view
- added alert dialog in battle table view for additional confirmation of battle creation 
- added segue to return back to battle's list after battle creation
- implemented core logic for querying Parse for all Facebook friends (this is currently unimplemented in beta due to the time constraints)
- added refreshing capabilities on the battle table view for possible inconsistent states (multiple external users creating battles at the same time)
- allowed users to login with Facebook and create a username, which is stored in the Parse database.

Morgan
- front end design changes: constraints, icons, typography, color
- UI/UX game redesign: 3 phase game system
- implemented slider for voting
- upload and image selector camera for submit - front end