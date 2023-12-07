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
 * @param  {String} id An id to check for the hash (#) symbol
 * @param {Boolean} rm_hash whether to remove the hash symbol if it has it
 * @returns {String} Returns an id String with or without the hash based on the rm_hash argument
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
 * @param {String} obj Object to map
 * @param {Function} fn callback to map with
 * @returns  {Logical}
 */
const objectMap = (obj, fn) =>
  Object.fromEntries(
    Object.entries(obj).map(
      ([k, v], i) => [k, fn(v, k, i)]
    )
  )


/**
 * Replaces the Search: on a datatable search widget with a FontAwesome magnifying glass
 * @param  {String} selector The datatable ID
 * @returns  {Logical}
 */
function dt_search_icon(selector) {
    var el = `#${selector}_filter`;
    var f = $(el);
    var a = f.html();
    if (a) {
      a = a.replace(/Search:/g, '<i class="fas fa-magnifying-glass p-2"></i>');
      $(f).html(a);
      f.find('input').attr('placeholder', 'Search');
    }
}

/**
 * Replaces the Filter placeholders on a DT based on the column data-type
 * @param {String} id Datatable ID
 * @param {String} character Filter box placeholder for character type columns
 * @param {String} integer  Filter box placeholder for integer type columns
 * @param {String} number Filter box placeholder for number type columns
 * @returns Changes the filters as a side affect, returns nothing
 */
function dt_filter_placeholders(id = table.table().node().id, character = 'Search', integer = 'Use Slider', number = 'Use Slider') {
   $('#' + id + " td[data-type='character'] input[type='search']").attr('placeholder', character);
   $('#' + id + " td[data-type='integer'] input[type='search']").attr('placeholder', integer);
   $('#' + id + " td[data-type='number'] input[type='search']").attr('placeholder', number);
}

/**
 * Add !important to the background-color on the policy_id column to retain the color style
 * @param {String} id Table ID
 * @param {String} cl Class to retain color for
 * @returns  undefined
 */

function dt_retain_policy_color(id, cl = "dt-policy_id") {
  var pid =  jqueryObjsOnly($("#" + id + " td." + cl))
  if (pid) {
    pid.forEach((e) => {
      let el = $(e)
      var style = el.attr('style');
      if (style && !/important\;$/g.test(style)) {
        debugger;
        el.attr('style', style.split(/\;$/)[0] + ' !important;')
      }
    })
  }
}

/**
 * Add important to the background-color on the policy_id column to retain the color style
 * @param {String} id Table ID
 * @returns  undefined
 */

function dt_api(id) {
  id = id_check(dt_table_id(id));
  //return $.fn.dataTable.Api()
  return $(id).DataTable()
}
/**
 * Get the header names for a DT
 * @param {String} id Table ID
 * @returns  undefined
 */
function dt_names(id) {
  return Object.values(objectMap(jqueryObjsOnly($( `#${id} th` )), (e) => $(e).text()));
}

/**
 * Get the values supplied to filters
 * @param {String} id Table ID
 * @returns  undefined
 */
function dt_filter_inputs(id) {
  return jqueryObjsOnly($(id_check(id) + ' input[type=\"search\"]'));
}

/**
 * Reset the {id}_reset counter DT Input value to 0
 * @param {String} id Table ID
 * @returns  undefined
 */
function dt_filter_reset(id) {
  Shiny.setInputValue(id + '_reset', 0, {priority: 'event'});
}
/**
 * Set the filters on a DT
 * @param {String} id  Table ID
 * @param {Array} filter Array of strings to set as filteres
 * @param {Boolean}reset  Whether to signal shiny to reset the filters by setting the {id}_reset counter DT Input value to 0
 * @returns  undefined, Sets the {id}_search_columns Input value to the actual filter values
 */
function dt_filter_set(id, filters = [], reset = false) {
  var t_id = dt_table_id(id);
  var t_nms = dt_names(id);
  // Table should be initialized before acted on
  if (typeof t_id == 'string') {
    var sc = dt_filter_inputs(id);
    var input_val = Array(sc.length).fill('');
    var d_api = dt_api(t_id);
    var filtered_api = d_api;
    if (reset) {
      dt_filter_reset(id);
    } else if (filters.length) {
      if (Array.isArray(filters)) {
        input_val = filters;
      } else {
        var nms = Object.keys(filters)
        var vals = Object.values(filters)
        // Replace the filter values in the existing array
        for (var i = 0; i < nms.length; i++) {
          input_val[t_nms.indexOf(nms[i])] = vals[i];
        }
      }
      for (var i = 0; i < input_val.length; i++) {
        $(sc[i]).val(input_val[i]);
        d_api.column(i).search(input_val[i]).draw();
      }
    }
    Shiny.setInputValue(id + '_search_columns', input_val, {priority: 'event'});
  }
}

/**
 * Return the ID that can be used to reference the DataTable via the datatable API
 * @param  {String} id Shiny ID
 * @returns  {String} The Datatable ID
 */
function dt_table_id(id) {
  id = id_check(id);
  var out = undefined;
  if (!/^\#?DataTables/g.test(id)) {
    out =  $( `${id_check(id)} table` ).attr('id');
  } else {
    out = id;
  }
  return out;
}

/**
 * Returns whether a DOM element is visible
 * @param  {String} selector
 * @returns  {Logical}
 */
function isVisible(selector) {
  return $(selector).is(":visible");
}