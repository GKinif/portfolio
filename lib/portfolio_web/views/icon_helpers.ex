defmodule PortfolioWeb.IconHelpers do
  def render_icon(name, class) do
    Phoenix.View.render(PortfolioWeb.IconView, "#{name}.html", class: class)
  end
end
