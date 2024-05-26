library(shiny)
devtools::load_all()
ui <- fluidPage(
  useDTExtend(),
  shinyjs::useShinyjs(),
  tags$style(
    ".flex {
      display: flex;
    }
    .flex-row {
      flex-direction: row;
    }
    .justify-between {
      justify-content: space-between;
    }
    --black-olive: #2e382eff;
    --robin-egg-blue: #50c9ceff;
    --vista-blue: #72a1e5ff;
    --tropical-indigo: #9883e5ff;
    --mimi-pink: #fcd3deff;
    "


  ),
  div(
    class = "flex flex-row justify-between",
    div(
      textInput(
        "retain_color_class",
        "Class on which color should be retained?",
        value = "color_class"
      )
    ),
    div(
      span("Page Length: ", textOutput("page_length", inline = TRUE))
    ),
    div(
      span("Page Number: ", textOutput("page_num", inline = TRUE))
    )
  ),
  div(
    DT::DTOutput("DT")
  )

)

server <- function(input, output, session) {

  colors <- rep_len(c("#2e382eff", "#50c9ceff", "#72a1e5ff", "#9883e5ff", "#fcd3deff"), nrow(mtcars))



  output$DT <- DT::renderDT({
    out <- DT::datatable(
      mtcars,
      callback = DT_callback(
        retain_color_class = input$retain_color_class
      ),
      selection = list(mode = 'single', target = 'row'),
      options = list(
        columnDefs = list(
          list(
            className = input$retain_color_class,
            # Uses JS indexing
            targets = 0
          )
        ),
        lengthMenu = c(5, 10),
        pageLength = isolate(input$DT_pageLength) %||% 5
      )
    )
    if (UU::is_legit(styled_rows())) {
      debugonce(DT_style_row)
      out <- DT_style_row(out, columns = 0, backgroundColor =  colors[seq_along(styled_rows())], rows = styled_rows())
    }

    render_ran_input("DT")
    out
  })

  observeEvent(input$DT_ran, {
    p <- input$DT_page
    req(p)
    # Retain the page number
    DT::dataTableProxy("DT") |>
      DT::selectPage(p)
  })

  styled_rows <- reactiveVal()
  observeEvent(input$DT_row_last_clicked, {
    styled_rows(c(styled_rows(), input$DT_row_last_clicked))
  })
  output$page_length <- renderText(input$DT_pageLength)
  output$page_num <- renderText(input$DT_page)
}

shinyApp(ui, server)
