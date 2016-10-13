injector.set ()->
  pi = @importGlobal('PI')
  def = @import('def-type')
  math = def.Object(
    square: (x)->  x * x
    pi: pi
  )
  return math

module.exports = injector.get()