exports.innerHTML = function (node) {
  return function () {
    return node.innerHTML
  }
}

exports.setInnerHTML = function (innerHTML) {
  return function (node) {
    return function () {
      node.innerHTML = innerHTML
    }
  }
}

exports.innerText = function (node) {
  return function () {
    return node.innerText
  }
}

exports.setInnerText = function (innerText) {
  return function (node) {
    return function () {
      node.innerText = innerText
    }
  }
}
