@SpaceLock = @SpaceLock || {}

SpaceLock.helpers =
  'currentRouteName' : -> Router.current().route.getName()
  'appContent' : -> SpaceLock.cols.Settings.findOne('main')?.content
  'JSONify' : (str) -> JSON.stringify(str)

for key, val of SpaceLock.helpers
  UI.registerHelper key, val
