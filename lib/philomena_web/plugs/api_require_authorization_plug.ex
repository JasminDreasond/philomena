defmodule PhilomenaWeb.ApiRequireAuthorizationPlug do
  @moduledoc """
  This plug will force a 401 Unauthorized if no/invalid
  API key provided and a 403 Forbidden if user is banned.

  ## Example

      plug PhilomenaWeb.ApiRequireAuthorizationPlug
  """
  alias Phoenix.Controller
  alias Plug.Conn
  alias Philomena.Bans

  @doc false
  @spec init(any()) :: any()
  def init(opts), do: opts

  @doc false
  @spec call(Conn.t(), any()) :: Conn.t()
  def call(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> maybe_unauthorized(user)
    |> maybe_forbidden(Bans.find(user, conn.remote_ip, "NOTAPI"))
  end

  defp apply_ban_protocol(conn) do
    conn
    |> Conn.put_status(:forbidden)
    |> Controller.text("")
    |> Conn.halt()
  end

  defp maybe_unauthorized(conn, nil) do
    conn
    |> Conn.put_status(:unauthorized)
    |> Controller.text("")
    |> Conn.halt()
  end

  defp maybe_unauthorized(conn, _user), do: conn

  defp maybe_forbidden(conn, nil), do: conn

  defp maybe_forbidden(conn, bans) when is_list(bans) do
    should_halt =
      Enum.any?(bans, fn current_ban ->
        not PhilomenaWeb.BanReasonHelper.any_granular_ban?(current_ban) or
          matches_granular_ban?(current_ban, conn)
      end)

    if should_halt, do: apply_ban_protocol(conn), else: conn
  end

  defp maybe_forbidden(conn, current_ban) do
    should_halt =
      not PhilomenaWeb.BanReasonHelper.any_granular_ban?(current_ban) or
        matches_granular_ban?(current_ban, conn)

    if should_halt, do: apply_ban_protocol(conn), else: conn
  end

  defp matches_granular_ban?(current_ban, conn) do
    case PhilomenaWeb.BanReasonHelper.get_current_request_reason(conn) do
      nil -> false
      reason -> PhilomenaWeb.BanReasonHelper.has_action?(current_ban, reason)
    end
  end
end
