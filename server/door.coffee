@SpaceLock = @SpaceLock || {}

# TODO implement an observer to do this!

SpaceLock.door =
  unlock : (unlockTime) ->
    unlockTime?= SpaceLock.cols.Settings.findOne('main')?.door?.openTime || 5000
    console.log "unlocking door for #{unlockTime}ms"
    SpaceLock.gpio.unlockDoor()
    Meteor.setTimeout ->
      SpaceLock.gpio.lockDoor()
    , unlockTime

  lock : (options) ->
    console.log 'locking door ...'
    SpaceLock.gpio.lockDoor()

Meteor.startup ->
  # lock door on bootup
  Meteor.setTimeout ->
    SpaceLock.door.lock()
  , 1000