injector.set ->
  math =
    square: (x)->  x * x

  return math

module.exports = injector.get()