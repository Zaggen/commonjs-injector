injector.set ->
  pi = @import(__dirname, './PiModule')
  math =
    square: (x)->  x * x
    pi: pi

  return math

module.exports = injector.get()