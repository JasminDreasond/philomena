defmodule PhilomenaWeb.ApiTokenPlug do
  alias Philomena.Users
  alias Plug.Conn
  alias Philomena.Bans
  alias Phoenix.Controller

  def init([]), do: []

  def call(conn, _opts) do
    conn
    |> maybe_find_user(conn.params["key"])
    |> assign_user()
    |> check_api_ban()
  end

  defp maybe_find_user(conn, nil), do: {conn, nil}

  defp maybe_find_user(conn, token) do
    user = Users.get_user_by_authentication_token(token)

    {conn, user}
  end

  defp assign_user({conn, user}) do
    Conn.assign(conn, :current_user, user)
  end

  defp check_api_ban(conn) do
    if user = conn.assigns.current_user do
      if Bans.is_banned?(user, :api_key) do
        conn
        |> Conn.put_status(:forbidden)
        |> Controller.text("")
        |> Conn.halt()
      else
        conn
      end
    else
      conn
    end
  end
end
