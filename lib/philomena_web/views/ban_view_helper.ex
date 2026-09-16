defmodule PhilomenaWeb.BanViewHelper do
  @moduledoc """
  Utility functions to check bans directly in views/templates.
  """
  alias PhilomenaWeb.BanReasonHelper

  # =======================================================================
  # 1. Detect ONLY Universal Ban
  # =======================================================================
  def universal_banned?(conn) do
    current_ban = conn.assigns[:current_ban]
    check_universal_ban(current_ban)
  end

  defp check_universal_ban(nil), do: false

  defp check_universal_ban(bans) when is_list(bans) do
    # Returns true if ANY of the bans in the list is universal
    Enum.any?(bans, fn ban -> not BanReasonHelper.any_granular_ban?(ban) end)
  end

  defp check_universal_ban(ban) do
    # If there are no granular flags, it is a universal ban
    not BanReasonHelper.any_granular_ban?(ban)
  end


  # =======================================================================
  # 2. Detect Universal Ban OR Specific Granular Ban
  # =======================================================================
  def banned_from?(conn, reason) do
    current_ban = conn.assigns[:current_ban]
    check_banned_from(current_ban, reason)
  end

  defp check_banned_from(nil, _reason), do: false

  defp check_banned_from(bans, reason) when is_list(bans) do
    Enum.any?(bans, &matches_ban_or_universal?(&1, reason))
  end

  defp check_banned_from(ban, reason) do
    matches_ban_or_universal?(ban, reason)
  end

  defp matches_ban_or_universal?(ban, reason) do
    # It is universal (no granular flag) OR has the granular flag we are testing
    not BanReasonHelper.any_granular_ban?(ban) or Map.get(ban, reason) == true
  end
end
