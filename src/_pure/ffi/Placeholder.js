export const placeholderArr = (template) => (arr) => {
  return arr.map((it) => {
    return placeholder(template)(it)
  })
}
export const placeholder = (template) => (data) => {
  // Originally:
  // (c) 2018 Chris Ferdinandi, MIT License, https://gomakethings.com
  var get = function (obj, path) {
    /**
     * If the path is a string, convert it to an array
     * @param  {String|Array} path The path
     * @return {Array}             The path array
     */
    var stringToPath = function (path) {
      // If the path isn't a string, return it
      if (typeof path !== 'string') return path

      // Create new array
      let output = []

      // Split to an array with dot notation
      path.split('.').forEach(function (item) {
        // Split to an array with bracket notation
        item.split(/\[([^}]+)\]/g).forEach(function (key) {
          // Push to the new array
          if (key.length > 0) {
            output.push(key)
          }
        })
      })

      return output
    }

    // Get the path as an array
    path = stringToPath(path)

    // Cache the current object
    let current = obj

    // For each item in the path, dig into the object
    for (let i = 0; i < path.length; i++) {
      // If the item isn't found, return the default (or null)
      if (!current[path[i]]) return null

      // Otherwise, update the current  value
      current = current[path[i]]
    }

    return current
  }
  return template.replace(/\[\[([^\]]+)\]\]/g, function (match) {
    const match_path = match.slice(2, -2) // Removes wrapping [[]]
    const val = get(data, match_path.trim())
    if (!val) return match
    return val
  })
}
