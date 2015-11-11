Differences between Alpha and Beta: In Alpha: the main functionality that we provided was integration with Facebook and Parse and providing the wireframes for all of our views.

How To Test Pikkl: iPhone 6s
- First log out of your Facebook account on your computer
- Open Pikkl and login with these Facebook credentials: 
User: bobbysightsinger@gmail.com
Pass: bobbyisthebest
[This account is now are in our FB Developer list]
- Click the '+' button in the top right corner to Create A Battle
- Give the battle a title! Something you want the picture competition to be about like: "Worst Gift Ever". Tap Create battle.
- Your new battle should appear in the Battles Table View (Home)
* The game is a photo taking game played in 3 phases: Submit your photo, Vote on your friend's photos, and the Final phase after the votes are in and scores are announced. The length of these phases will usually last a few hours but for the purpose of this test, each phase will last 2 MINUTES.
- Your battle is in the first phase, Submit. Click your battle to go the Submit screen. Tap the camera to add a photo from your library. Click the Submit button and the photo will be added to parse.
- Wait in the 'Battles' Table View and refresh until the VOTE phase is available (green 'Current Phase:' Vote). Tap your battle and tap on an entry to vote for it. Tap the entry to view and rate it with the slider (1-5 scale). Then tap 'Cast Vote'!
- Wait in the 'Battles' Table View and refresh until the FINAL phase is available (green 'Current Phase:' Final). Tap your battle and see the final average scores. Tap a score to view the photo entry.
That's Pikkl Beta!

Note: For some simulators the TableViewCell Separators may dissappear in this version. We also tested this on a basic table view cell and it had the same behavior. The Views behaved well on Morgan's 15in Retina but not on Jeffrey's 13in Macbook Air so we think it may be a resolution problem.


In Beta: 
-The biggest difference is providing the user with the ability to Log in with Facebook and create a username. The username then gets stored in the Parse database. 
-We added the ability for users to create Battles/Competitions of their own, which is then synced up with parse and displayed in the Battle Table View Controller. 
-Users are able to enter any of these battles and start submitting pictures of their own to the Battle.
-Battle objects and Battle entry objects have been created and populated with data
-Users can submit photos (which are stored in parse) to be voted on in battles
-User can vote on battle entries
-Users can see a final screen, where all of the average scores per photo are showed
-The game is now fully playable, the phases of the battle change based on time


Julio (33.333333%)
- did front-end (storyboard) and back-end programming for 'vote' and 'final' view controllers
- designed and created battle entry object in parse for keeping track of entries (created in submit view controller)
- implemented conditional segue for various stages in BattleTableViewController
- updated battle object to keep track of it's entries
- implemented the different phases of the battle along with their associated views within the story board
- implemented the logic for uploading, submitting and storing photos into Parse
- created voting system and updating of votes and average scores for final view

Jeffrey (33.333333%)
- implemented all of the infrastructure and code for time based change of phases
- implemented core data for saving all of the battles, used in displaying the initial battle table view
- added alert dialog in battle table view for additional confirmation of battle creation 
- added segue to return back to battle's list after battle creation
- implemented core logic for querying Parse for all Facebook friends (this is currently unimplemented in beta due to the time constraints)
- added refreshing capabilities on the battle table view for possible inconsistent states (multiple external users creating battles at the same time)
- allowed users to login with Facebook and create a username, which is stored in the Parse database.

Morgan (33.333333%)
- front end design changes: constraints, icons, typography, color
    - final hi-fidelity design will be implemented for Final Version
- UI/UX game redesign: 3 phase game system
- implemented slider for voting
- upload and image selector camera for submit - front end