DOOR_LOCK_PIN = if process.env.SPACELOCK_GPIO_PIN then parseInt process.env.SPACELOCK_GPIO_PIN else 12
DOOR_OPEN_PIN = if process.env.DOOR_OPEN_PIN then parseInt process.env.DOOR_OPEN_PIN else 16

# TODO split up into gpio, gpio-door and gpio-sensor

@SpaceLock = @SpaceLock || {}

# TODO implement an observer to do this?

# include gpio npm module
try
  gpio = Meteor.npmRequire 'pi-gpio'
catch err
  # in dev mode
  console.log 'No GPIO detected. Dummy output only.'

if gpio
  console.log 'GPIO detected.'
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
    if gpio
      gpio.write DOOR_LOCK_PIN, 0
    console.log "#{if gpio then "[dummy] " else "" }Door unlocked"

  lockDoor : ->
    if gpio
      gpio.write DOOR_LOCK_PIN, 1
    console.log "#{if gpio then "[gpio #{DOOR_LOCK_PIN}] " else "[dummy] " }Door locked"



