defmodule PhilomenaWeb.Registration.BanStatusController do
  use PhilomenaWeb, :controller

  alias PhilomenaWeb.BanReasonHelper

  def show(conn, _params) do
    grouped_actions = BanReasonHelper.actions_grouped_by_category()

    render(conn, "show.html",
      page_title: "Account Standing",
      grouped_actions: grouped_actions
    )
  end
end
