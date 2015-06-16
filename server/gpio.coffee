DOOR_LOCK_PIN = 12

@SpaceLock = @SpaceLock || {}

# TODO implement an observer to do this?

# include gpio npm module
try
  gpio = Meteor.npmRequire 'pi-gpio'
catch err
  # in dev mode
  console.log 'No GPIO detected. Dummy output only.'
  SpaceLock.gpio =
    unlockDoor : -> console.log '[dummy] Door unlocked'
    lockDoor : -> console.log '[dummy] Door locked'


unless SpaceLock.gpio?
  console.log 'GPIO detected. Door locking by default...'
  # always open io pin on app start

  gpio.open DOOR_LOCK_PIN, "output"

  # exit handler for script on exit
  exitHandler = (options, err) ->
    gpio.close DOOR_LOCK_PIN
    if err
      console.log err.stack
    if options.exit
      process.exit()

  process.stdin.resume()
  process.on 'exit', exitHandler.bind(null, cleanup: true)
  process.on 'SIGINT', exitHandler.bind(null, exit: true)
  process.on 'uncaughtException', exitHandler.bind(null, exit: true)


  SpaceLock.gpio =
    unlockDoor : ->
      gpio.write DOOR_LOCK_PIN, 0
      console.log 'Door unlocked'
    lockDoor : ->
      gpio.write DOOR_LOCK_PIN, 1
      console.log 'Door locked'



