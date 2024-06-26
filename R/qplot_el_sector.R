#' Title
#'
#' @param data_el_plot data_el_plot
#'
#' @export
qplot_el_sector <- function(data_el_plot, use_exp_loss_types) {
  data_losses <- data_el_plot %>%
    dplyr::filter(.data$expected_loss_type %in% use_exp_loss_types)

  p_abs <- plot_el_coloured(data_losses, "expected_loss_value") +
    ggplot2::labs(
      title = "Expected loss per sector",
      subtitle = "For baseline and shock scenarios",
      y = "Expected Loss (currency)"
    )

  p_perc <- plot_el_coloured(data_losses, "el_as_perc_exposure", is_percentage = TRUE) +
    ggplot2::labs(
      title = "Expected Loss as percentage of exposure per sector",
      subtitle = "For baseline and shock scenarios",
      y = "Expected Loss (% exposure)"
    )

  gridExtra::grid.arrange(p_perc, p_abs, ncol = 1)
}

#' Title
#'
#' @param data data
#' @param y_val_name y_val_name
#' @param is_percentage is_percentage
#'
plot_el_coloured <- function(data, y_val_name, is_percentage = FALSE) {
  if (is_percentage) {
    labels <- scales::percent
  } else {
    labels <- scales::unit_format(unit = "M", scale = 1e-6)
  }

  p <-
    ggplot2::ggplot(
      data,
      ggplot2::aes_string(x = "expected_loss_type", y = y_val_name, fill = y_val_name)
    ) +
    ggplot2::geom_bar(stat = "identity", color = "grey") +
    ggplot2::scale_x_discrete(position = "bottom", labels = r2dii.plot::to_title) +
    ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(.1, 0)), labels = labels) +
    ggplot2::scale_fill_gradient2(
      low = r2dii.colours::palette_1in1000_plot %>%
        dplyr::filter(.data$label == "red") %>%
        dplyr::pull(.data$hex),
      high = r2dii.colours::palette_1in1000_plot %>%
        dplyr::filter(.data$label == "green") %>%
        dplyr::pull(.data$hex),
      midpoint = 0,
      labels = labels,
      name = "Expected loss"
    ) +
    r2dii.plot::theme_2dii() +
    ggplot2::theme(
      legend.title = ggplot2::element_text(),
      axis.ticks.x = ggplot2::element_blank(),
      axis.title.x = ggplot2::element_blank(),
      strip.placement = "outside",
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1)
    ) +
    ggplot2::facet_wrap(~group_variable, scales = "fixed")


  p
}
