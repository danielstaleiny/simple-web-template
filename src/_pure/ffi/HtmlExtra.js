export const innerHTML = (node) => () => {
  return node.innerHTML
}

export const setInnerHTML = (innerHTML) => (node) => () =>
  (node.innerHTML = innerHTML)

export const innerText = (node) => () => node.innerText

export const setInnerText = (innerText) => (node) => () =>
  (node.innerText = innerText)

export const ctrlKey = (event) => () => event.ctrlKey || event.metaKey
