exports.dispatchCustomEvent = function (type) {
  return function (obj) {
    return function () {
      return document.dispatchEvent(
        new CustomEvent(type, { bubles: false, cancelable: false, detail: obj })
      )
    }
  }
}

exports.detail = function (evt) {
  return evt.detail
}

exports.logAny = function (obj) {
  return function () {
    return console.log(obj)
  }
}
