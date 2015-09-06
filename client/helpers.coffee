@SpaceLock = @SpaceLock || {}

SpaceLock.helpers =
  currentRouteName : -> Router.current().route.getName()
  mainConfig : -> SpaceLock.cols.Settings.findOne('main') || {}
  appContent : -> SpaceLock.helpers.mainConfig().content
  JSONify : (str) -> JSON.stringify(str)
  formatDate : (date) -> if date then new Date(date).toLocaleDateString() else '?'
  formatTime : (date) -> if date then new Date(date).toLocaleTimeString() else '?'
  formatDateTime : (date) -> "#{SpaceLock.helpers.formatDate(date)} - #{SpaceLock.helpers.formatTime(date)}"
  formatDuration : (time) -> if time then moment.duration(time).humanize() else '?'
  humanDate : (date) -> if date then moment(date).fromNow() else '?'
  getFileUrl : (fileId) -> SpaceLock.cols.Images.findOne(fileId)?.url()

for key, val of SpaceLock.helpers
  UI.registerHelper key, val
