export const dispatchCustomEvent = (type) => (obj) => () =>
  document.dispatchEvent(
    new CustomEvent(type, {
      bubles: false,
      cancelable: false,
      composed: false,
      detail: obj,
    })
  )

export const detail = (evt) => {
  return evt.detail
}

export const logAny = (obj) => () => {
  return console.log(obj)
}
