defmodule Philomena.Bans.PermittedAction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ban_permitted_actions" do
    belongs_to :user_ban, Philomena.Bans.User
    belongs_to :subnet_ban, Philomena.Bans.Subnet
    belongs_to :fingerprint_ban, Philomena.Bans.Fingerprint

    field :action, :string

    timestamps()
  end

  @doc false
  def changeset(permitted_action, attrs) do
    permitted_action
    |> cast(attrs, [:user_ban_id, :subnet_ban_id, :fingerprint_ban_id, :action])
    |> validate_required([:action])
    |> foreign_key_constraint(:user_ban_id)
    |> foreign_key_constraint(:subnet_ban_id)
    |> foreign_key_constraint(:fingerprint_ban_id)
  end
end
