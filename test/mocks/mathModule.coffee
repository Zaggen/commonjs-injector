injector.set (@dependencies)->
  math =
    square: (x)->  x * x

  return math

module.exports = injector.get()