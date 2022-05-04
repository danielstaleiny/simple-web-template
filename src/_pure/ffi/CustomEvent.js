export function dispatchCustomEvent(type) {
  return function (obj) {
    return function () {
      return document.dispatchEvent(
        new CustomEvent(type, { bubles: false, cancelable: false, detail: obj })
      )
    }
  }
}

export function detail(evt) {
  return evt.detail
}

export function logAny(obj) {
  return function () {
    return console.log(obj)
  }
}
