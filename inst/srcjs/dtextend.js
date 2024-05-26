/**
 * Return the ID that can be used to reference the DataTable via the DataTable API
 * @param {String} id of the DataTable or the containing shiny DOM element
 * @param {Logical} rm_hash Whether to remove the hash on the ID
 * @returns  {String} The DataTable ID
 */
function dt_table_id(id, rm_hash = false) {
  var out = undefined;
  if (!/^\#?DataTables/g.test(id)) {
    out = $(`${id_check(id)} table`).attr("id");
  } else {
    console.log("dt_table_id: not a valid ID");
    out = id;
  }
  return id_check(out, (rm_hash = rm_hash));
}

/**
 * Return the DT column names
 *
 * @param {String} id of the DataTable or the containing shiny DOM element
 * @return {Array} of the column names of the DataTable
 */
function dt_names(id) {
  return Object.values(
    objectMap(jqueryObjsOnly($(`${dt_table_id(id)} th`)), (e) => $(e).text())
  );
}

/**
 * Get the ID of a table from the `table` object
 * @param {Datatable} table
 * @returns {String} DOM ID of the table
 */
function dt_id_from_table(table) {
  return table.table().node().id;
}

function get_dt_props(table) {
  return window.sessionStorage.getItem(table.table().node().id);
}
class dt_props {
  #id = {
    table: null,
    shiny: null,
    render: null,
    props: null,
    page: null,
    render: null,
  };
  #render_count = 0;
  #table;
  #colClassNames;
  constructor(table) {
    this.#id.table = table.table().node().id;
    debugger;
    this.#id.shiny = dt_shiny_id(this.#id.table, true);
    this.#id.render = this.#id.shiny + "_rendered";
    this.#id.page = this.#id.shiny + "_page";
    this.#id.props = this.#id.table + "_props";
    this.#table = table;
    this.#colClassNames = table
      .settings()[0]
      .oInit.columnDefs.map((e) => e.className);
    this.shinyRender();
    this.shinyPage();
    window.sessionStorage.setItem(this.#id.table, this);
  }
  ShinySet(id, val) {
    Shiny.setInputValue(id, val, {
      priority: "event",
    });
  }
  shinyRender() {
    this.#render_count = this.#render_count + 1;
    this.ShinySet(this.#id.render, this.#render_count);
    return this.#render_count;
  }
  shinyPage() {
    let pn = this.#table.page();
    this.ShinySet(this.page_id, pn + 1);
    return pn;
  }
  shinyPageLength() {
    let len = this.#table.page.len();
    this.ShinySet(this.#id.shiny + "_pageLength", this.#table.page.len());
    return len;
  }
}

/**
 * Return the ID that can be used to reference the Shiny output widget containing the DataTable
 * @param {String} id of the DataTable or the containing shiny DOM element
 * @param {Logical} rm_hash Whether to remove the hash on the ID
 * @returns  {String} The Shiny widget ID (with #)
 */
function dt_shiny_id(id, rm_hash = false) {
  var out = undefined;
  if (/^\#?DataTables/g.test(id)) {
    out = $(id_check(id) + "_wrapper")
      .parent(".datatables")
      .attr("id");
  } else {
    console.log("dt_shiny_id: not a valid Datatables id");
    out = id;
  }
  return id_check(out, (rm_hash = rm_hash));
}

/**
 * Return the DataTable API given a DataTable ID
 *
 * @param {String} id of the DataTable or the containing shiny DOM element
 * @return {Object} DataTable API
 */
function dt_api(id) {
  //return $.fn.dataTable.Api()
  return $(dt_table_id(id)).DataTable();
}

/**
 * Make a DT keyboard accessible by enabling return key to select, populates the `_row_last_clicked` and the `_rows_selected` Shiny inputs
 *
 * @param {String} id of the DataTable or the containing shiny DOM element
 */
function dt_tab_accessible(id) {
  // Get the API
  let table = dt_api(id);
  if (document.debug_mode) {
    console.log("dt_tab_accessible ran");
  }
  // This sets a jquery event listener which doesn't need to be re-established on Draw
  table.on("key", function (e, datatable, key, cell, originalEvent) {
    var table_id = cell.table().node().id;
    var shiny_id = $("#" + table_id)
      .parent()
      .parent()
      .attr("id");
    if (key == 13) {
      // When return is pressed
      // Select the row
      let row_idx = cell.index().row;
      let tr = $(datatable.row(row_idx).node());
      if (tr.hasClass("selected")) {
        tr.removeClass("selected");
      } else {
        tr.addClass("selected");
      }
      let pn = datatable.page();
      let pl = datatable.page.len();
      // TODO how to set class on tr, update crosstalk inputs?
      // Update the Shiny inputs
      // row_last_clicked, account for R indexing
      Shiny.setInputValue(shiny_id + "_row_last_clicked", row_idx + 1, {
        priority: "event",
      });
      // rows_selected
      let trs = tr.parent("tbody").children("tr");
      let sel_idx = tagMatch(trs, (e) => {
        return $(e).hasClass("selected");
      });
      // Account for page and JS/R indexing
      let rows_selected = sel_idx.map((i) => i + 1 + pn * pl);
      Shiny.setInputValue(shiny_id + "_rows_selected", rows_selected, {
        priority: "event",
      });
    }
  });
}

/**
 * Add important to the background-color on a column to retain the color style
 * @param {String} id Table ID
 * @param {String} cl Class of cells on which to retain color
 * @returns  undefined
 */

function dt_retain_color(id, cl) {
  var pid = jqueryObjsOnly($(dt_table_id(id) + " td." + cl));
  if (pid) {
    pid.forEach((e) => {
      let el = $(e);
      var style = el.attr("style");
      if (style && !/important\;$/g.test(style)) {
        el.attr("style", style.split(/\;$/)[0] + " !important;");
      }
    });
  }
}

/**
 * Get DT Column filter values as array
 *
 * @param {String} id of the DataTable or the containing shiny DOM element
 * @return {Array} of the DT filter fields
 */
function dt_filter_inputs(id) {
  return jqueryObjsOnly($(dt_table_id(id) + ' input[type="search"]'));
}

/**
 *
 *
 * @param {String} id of the DataTable or the containing shiny DOM element
 * @returns Called for side-effect of assigning the `input$[DTOutput ID]_reset` a value of 0
 */
function dt_filter_reset(id) {
  Shiny.setInputValue(dt_shiny_id(id, (rm_hash = true)) + "_reset", 0, {
    priority: "event",
  });
}

/**
 * Set DT Column filter values
 * TODO This might not be working properly
 * @param {String} id of the DataTable or the containing shiny DOM element
 * @param {Array} [filters=[]] Filter values to set
 * @param {boolean} [reset=false] Whether to reset the filter values
 */
function dt_filter_set(id, filters = [], reset = false) {
  var t_id = dt_table_id(id);
  var t_nms = dt_names(id);
  // Table should be initialized before acted on
  if (typeof t_id == "string") {
    debugger;
    var sc = dt_filter_inputs(id);
    var input_val = Array(sc.length).fill("");
    var d_api = dt_api(t_id);
    var filtered_api = d_api;
    if (reset) {
      dt_filter_reset(id);
    } else if (filters.length) {
      if (Array.isArray(filters)) {
        input_val = filters;
      } else {
        var nms = Object.keys(filters);
        var vals = Object.values(filters);
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
    Shiny.setInputValue(id + "_search_columns", input_val, {
      priority: "event",
    });
  }
}

/**
 * Replaces the Search: on a DataTable search widget with a FontAwesome magnifying glass
 * @param {String} selector The DataTable ID
 */
function dt_search_icon(id) {
  var el = `${dt_table_id(id)}_filter`;
  var f = $(el);
  var a = f.html();
  if (a) {
    a = a.replace(/Search:/g, '<i class="fas fa-magnifying-glass p-2"></i>');
    $(f).html(a);
    f.find("input").attr("placeholder", "Search");
  }
}

/**
 * Replaces the Filter placeholders on a DT based on the column data-type
 * @param {String} id of the DataTable or the containing shiny DOM element
 * @param {String} character Filter box placeholder for character type columns
 * @param {String} integer Filter box placeholder for integer type columns
 * @param {String} number Filter box placeholder for number type columns
 * @param {String} disabled Filter box placeholder for disabled columns
 * @returns Changes the filters as a side affect, returns nothing
 */
function dt_filter_placeholders(
  id,
  character = "Search",
  integer = "Use Slider",
  number = "Use Slider",
  disabled = "N/A"
) {
  id = dt_table_id(id);
  $(id + " td[data-type='character'] input[type='search']").attr(
    "placeholder",
    character
  );
  $(id + " td[data-type='integer'] input[type='search']").attr(
    "placeholder",
    integer
  );
  $(id + " td[data-type='number'] input[type='search']").attr(
    "placeholder",
    number
  );
  $(id + " td[data-type='number'] input[disabled]").attr(
    "placeholder",
    disabled
  );
}
