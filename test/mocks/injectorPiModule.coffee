injector.set (@dependencies)-> return Math.PI

module.exports = injector.get()