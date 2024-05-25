/**
 * Create a sequence
 *
 * @param {Number} start Starting number of sequence
 * @param {Number} end Ending number of sequence
 * @return {Array} with numeric values from start to end 
 */
function seq(start, stop, step = 1) {
    return Array.from(
    { length: (stop - start) / step + 1 },
    (value, index) => start + index * step
    );
}



/**
 * Sum an array
 * @param {Array} arr of numeric
 * @returns {Numeric} sum
 */
function sum(arr) {
  return arr.reduce((p, v) => {
    return p + v;
  });
}
 /**
    * @param  {Object} jq - A jQuery DOM object
    * @returns {Array} stripped of jQuery methods
    */
 function jqueryObjsOnly(jq) {
    var out = [];
    for (i = 0; i < jq.length; i++) {
      out.push(jq[[i]]);
    }
    return out;
  }
/**
 * Subset an array in R fashion
 *
 * @param {Array} arr to subset
 * @param {*} [rc=[1,1]] row, column indices to subset. Set to null or undefined to omit an index
 * @return {*} Array or value depending on the subset  
 */
function arr_subset(arr, rc = [1,1]) {
  out = [];

  if (rc[0] && rc[1]) {
    out = arr[rc[0]][rc[1]];
  } else if (rc[1]) {
    for (let r = 0; r < arr.length; r++) {
      out.push(arr[r][rc[1]]);
    }
  } else if (rc[0]) {
    out = arr[rc[0]];
  }
  return out;
}
/**
 * Retrieve indices of TRUE values in R fashion
 *
 * @param {Array} array of Boolean values
 * @return {Array/Number} of indices of true values 
 */
function which(array) {
  let out = [];
  for (let index = 0; index < array.length; index++) {
    if (array[index]) {
      out.push(index);
    }
  }
  return out;
}
/** Return true when element is ready
* @param {String} selector Element to wait for
* @usage waitForEl('.some-class').then((elm) => {
  console.log('Element is ready');
  console.log(elm.textContent);
});
* @credit https://stackoverflow.com/a/61511955
*/
function waitForEl(selector) {
    return new Promise(resolve => {
      if (document.querySelector(selector)) {
        return resolve(document.querySelector(selector));
      }
      
      const observer = new MutationObserver(mutations => {
        if (document.querySelector(selector)) {
          resolve(document.querySelector(selector));
          observer.disconnect();
        }
      });
      
      observer.observe(document.body, {
        childList: true,
        subtree: true
      });
    });
  }

/**
 * Ensure a string is an ID (#id), or remove the hash from and ID string.
* @param  {String} id An id to check for the hash (#) symbol
* @param {Boolean} rm_hash whether to remove the hash symbol if it has it
* @returns  {String} Returns an id String with or without the hash based on the `rm_hash` argument
* @example
id_check('blah')
id_check('#blah', rm_hash = true)
*/
function id_check(id, rm_hash = false) {
    let reg = new RegExp("^#");
    if (!reg.test(id) && !rm_hash) {
      id = "#" + id;
    } else if (rm_hash) {
      if (reg.test(id)) {
        id = id.substring(1);
      }
    }
    return id;
  }
  
/**
* Map for objects
* @param obj {String} Object to map
* @param fn {Function} callback to map with
* @returns  {Logical}
* @example
* objectMap([0, "#", null], (x) => {return typeof x == "string";});
*/

function objectMap (obj, fn) {
return Object.fromEntries(
  Object.entries(obj).map(
    ([k, v], i) => [k, fn(v, k, i)]
    )
    );
}

 /**
    * Return an array of all matching indices
    *
    * @param {Array} arr to be matched against
    * @param {Function} fn of function that returns {Logical}
    * @return {Array} of matching indexes
    */
 function tagMatch(arr, fn) {
    let idx = [];
    if (arr instanceof jQuery) {
        idx = arr.map((i, e) => {
            let out = null;
            if (fn(e)) {
                out = i;
            }
            return out; 
        });
        idx = Array.from(jqueryObjsOnly(idx));
    } else {
        idx = arr.reduce(function(a, e, i) {
            if (fn(e))
            a.push(i);
            return a;
        }, []);
    }
    return idx;
}
  
/** Is an element visible
* @param  {String} selector to determine the visibility of
* @returns  {Logical} whether the element is visible
*/
function isVisible(selector) {
    return $(selector).is(":visible");
}
