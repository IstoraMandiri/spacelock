# Priority

- GPI O for door -> LED
- Timed unlock for admins
- NFC Cards
  - Add cards collection, add 'newCard' method, modify unlock door method
  - Implement accessToken generation on unlock


# All Todos

- EZModal + Materialize
  - Confirm Logout

~ Pub/Sub
  x User fields
  - Paginated Subscriptions
  - Config fields

x Allow/Deny

- Users
  x Users list
  x Fuzzy search
  - Sorting
  - User Editor
    x Image upload
    x Edit Name
    x Create / Revoke Card (random ID)
    - User stats
    - Remove user
    x User Roles
      x Admin
      x cardOpen
      x phoneOpen

- Logs
  x Logs list + fuzzy search
  x Clear logss
  - Export list

- Open Door Method
  - GPIO: Open door for x seoncds
  - Create card
  - Scan card
  - Card Scanner -- How does that work?


Rev. 2 Requirements

- Ability for admins to create a timed door open (eg for events)
- Restructrure CARD system to cater for NFC cards
- Schedule opening hours
- Card reading/writing (with USB)
- Card security

  Each time a user uses a card, a new random access token is written to the card which must match next time the card is used. This way, only one physical card will work at any given time, which reduces the risk from cloning.

  The following things are checked when card is tapped:
    - user id
    - card id
    - access token

  A new cards collection with the following schema needs to be created.
    _id: MeteorId
    _cardId: cardId (actual physical id)
    _userId: userId
    accessToken: Meteor.random()

  For pub/sub
    _id: this user + admin
    _userId: this user + amdin
    _cardId: not published
    accessToken: not published

  This way knowledge of cards exiting for a given user, but card details are not published.




# Upcoming Ideas

- Doorbell option
- Recording 'long open' events
- Admin Dashboard
  - How many people are here
- User-editable profiles
- Part time
- Open/Close Schedule
- Timekeeping
- Message system
- Signage frontend
- Access period groups
- Multiple door concept
- Push email to people who have not logged out


Access type
- Member access
- Guest pass printing w/ qr code
- Event mode


- Add 'superAdmin' role (can designate other admins)
- Modularize 'requestAccess' method on server for different login types (card, acc, qr, etc)


User types
- Admins
- Managers
  - Event Creation
  - Member Registration
- Members
  - Pass generation ()
    - How many, how long



# Membership Details
- Expiry date ( future: hours topup )
- Full access
- Open hours
- Weekend/Weekday
- Number of guest passes to issue
  - Full day pass (e.g. 4 per month)
  - 2 hours pass (e.g. 10 per month)


Events

# Acceess Types
- Grant access for X amount of time
- Full membership access
- 'Currently bleeped in' list
- 'Open hours' for different groups

