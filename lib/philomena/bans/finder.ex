defmodule Philomena.Bans.Finder do
  @moduledoc """
  Helper to find a bans associated with a set of request attributes.
  """

  import Ecto.Query, warn: false
  alias Philomena.Repo

  alias Philomena.Bans.Fingerprint
  alias Philomena.Bans.Subnet
  alias Philomena.Bans.User

  @fingerprint "Fingerprint"
  @subnet "Subnet"
  @user "User"

  @doc """
  Returns the first ban, if any, that matches the specified request attributes.
  """
  def find(user, ip, fingerprint) do
    bans =
      generate_valid_queries([
        {ip, &subnet_query/2},
        {fingerprint, &fingerprint_query/2},
        {user, &user_query/2}
      ])
      |> union_all_queries()
      |> Repo.all()
      |> attach_permitted_actions()

    # Don't return a fingerprint or subnet ban if the user is currently signed in.
    if is_nil(user) do
      Enum.at(bans, 0)
    else
      user_ban(bans)
    end
  end

  defp query_base(schema, name, now) do
    from b in schema,
      where: b.enabled and b.valid_until > ^now,
      select: %{
        id: b.id,
        reason: b.reason,
        valid_until: b.valid_until,
        generated_ban_id: b.generated_ban_id,
        type: type(^name, :string)
      }
  end

  defp attach_permitted_actions(bans) when bans == [], do: []

  defp attach_permitted_actions(bans) do
    user_ban_ids = for %{type: @user, id: id} <- bans, do: id
    subnet_ban_ids = for %{type: @subnet, id: id} <- bans, do: id
    fingerprint_ban_ids = for %{type: @fingerprint, id: id} <- bans, do: id

    user_permitted =
      if user_ban_ids != [],
        do:
          Repo.all(
            from pa in Philomena.Bans.PermittedAction, where: pa.user_ban_id in ^user_ban_ids
          ),
        else: []

    subnet_permitted =
      if subnet_ban_ids != [],
        do:
          Repo.all(
            from pa in Philomena.Bans.PermittedAction, where: pa.subnet_ban_id in ^subnet_ban_ids
          ),
        else: []

    fingerprint_permitted =
      if fingerprint_ban_ids != [],
        do:
          Repo.all(
            from pa in Philomena.Bans.PermittedAction,
              where: pa.fingerprint_ban_id in ^fingerprint_ban_ids
          ),
        else: []

    user_permitted_map = Enum.group_by(user_permitted, & &1.user_ban_id)
    subnet_permitted_map = Enum.group_by(subnet_permitted, & &1.subnet_ban_id)
    fingerprint_permitted_map = Enum.group_by(fingerprint_permitted, & &1.fingerprint_ban_id)

    Enum.map(bans, fn ban ->
      actions =
        case ban.type do
          @user -> Map.get(user_permitted_map, ban.id, [])
          @subnet -> Map.get(subnet_permitted_map, ban.id, [])
          @fingerprint -> Map.get(fingerprint_permitted_map, ban.id, [])
        end

      Map.put(ban, :permitted_actions, actions)
    end)
  end

  defp fingerprint_query(fingerprint, now) do
    Fingerprint
    |> query_base(@fingerprint, now)
    |> where([f], f.fingerprint == ^fingerprint)
  end

  defp subnet_query(ip, now) do
    {:ok, inet} = EctoNetwork.INET.cast(ip)

    Subnet
    |> query_base(@subnet, now)
    |> where(fragment("specification >>= ?", ^inet))
  end

  defp user_query(user, now) do
    User
    |> query_base(@user, now)
    |> where([u], u.user_id == ^user.id)
  end

  defp generate_valid_queries(sources) do
    now = DateTime.utc_now()

    Enum.flat_map(sources, fn
      {nil, _cb} -> []
      {source, cb} -> [cb.(source, now)]
    end)
  end

  defp union_all_queries([query | rest]) do
    Enum.reduce(rest, query, fn q, acc -> union_all(acc, ^q) end)
  end

  defp user_ban(bans) do
    bans
    |> Enum.filter(&(&1.type == @user))
    |> Enum.at(0)
  end
end
