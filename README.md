> **Disclaimer:** This README is for a series of educational projects for CS378: iOS Mobile Computing at the University of Texas at Austin with Bob Seitsinger in semester Fall 2015. Our goal was to create an iOS application, a spin-off variation of the popular SnapChat application. 

# Getting Started
* Log out of your Facebook account on your computer or mobile device.
* Open Pikkl and login with the following Facebook credentials [This account is part of our FB Developer List]:
```
User: bobbysightsinger@gmail.com
Pass: bobbyisthebest
```
* Click the '+' button in the top right corner to "Create" a Battle.
* Give the battle a title or select from a pre-select set of randomly generated battle titles, then tap "Create". Your new battle should appear in the Battles Table View on the Home screen.

# The Game
The game is a photo taking competition played in 3 phases: Submit, Vote (Join), Final (Scores). The length of each of these phases fall under to possible categories, short and long, each with a pre-determined length.
*Submit: Your battle is in the first phase, Submit. Click your battle to go the Submit screen. Tap the camera to add a photo from your library. Click the Submit button and the photo will be added to parse.
*Vote: Wait in the 'Battles' Table View and refresh until the VOTE phase is available (green 'Current Phase:' Vote). Tap your battle and tap on an entry to vote for it. Tap the entry to view and rate it with the slider (1-5 scale). Then tap 'Cast Vote'!
*Final: Wait in the 'Battles' Table View and refresh until the FINAL phase is available (green 'Current Phase:' Final). Tap your battle and see the final average scores. Tap a score to view the photo entry.

#Beta
*The biggest difference is providing the user with the ability to Log in with Facebook and create a username. The username then gets stored in the Parse database. 
*We added the ability for users to create Battles/Competitions of their own, which is then synced up with parse and displayed in the Battle Table View Controller. 
*Users are able to enter any of these battles and start submitting pictures of their own to the Battle.
*Battle objects and Battle entry objects have been created and populated with data
*Users can submit photos (which are stored in parse) to be voted on in battles
*User can vote on battle entries
*Users can see a final screen, where all of the average scores per photo are showed
*The game is now fully playable, the phases of the battle change based on time

#Final:
*
*


#Contributions
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
