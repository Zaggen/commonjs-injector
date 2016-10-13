injector.set ->
  pi = @import(__dirname, './injectorPiModule')

  #[Exportable Module]
  math =
    square: (x)->  x * x
    pi: pi

  return math

module.exports = injector.get()