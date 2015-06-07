@SpaceLock = @SpaceLock || {}

SpaceLock.helpers =
  currentRouteName : -> Router.current().route.getName()
  mainConfig : -> SpaceLock.cols.Settings.findOne('main') || {}
  appContent : -> SpaceLock.helpers.mainConfig().content
  JSONify : (str) -> JSON.stringify(str)
  formatDate : (date) -> new Date(date).toLocaleDateString()
  formatTime : (date) -> new Date(date).toLocaleTimeString()
  formatDateTime : (date) -> "#{SpaceLock.helpers.formatDate(date)} - #{SpaceLock.helpers.formatTime(date)}"

for key, val of SpaceLock.helpers
  UI.registerHelper key, val
