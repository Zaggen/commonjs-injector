injector.set (@dependencies)->
  pi = @import(__dirname, './PiModule')
  def = @import('def-inc')
  math = def.Object(
    square: (x)->  x * x
    pi: pi
  )
  return math

module.exports = injector.get()