defmodule Philomena.Bans.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Philomena.Bans.IdGenerator

  alias Philomena.Users.User

  @type t :: %__MODULE__{}

  schema "user_bans" do
    belongs_to :user, User
    belongs_to :banning_user, User

    field :reason, :string
    field :note, :string, default: ""
    field :enabled, :boolean, default: true
    field :valid_until, PhilomenaQuery.Ecto.RelativeDate
    field :generated_ban_id, :string
    field :override_ip_ban, :boolean, default: false

    has_many :permitted_actions, Philomena.Bans.PermittedAction,
      foreign_key: :user_ban_id,
      on_replace: :delete

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  @doc false
  def changeset(user_ban, attrs \\ %{}) do
    user_ban
    |> cast(attrs, [
      :reason,
      :note,
      :enabled,
      :override_ip_ban,
      :user_id,
      :valid_until
    ])
    |> cast_assoc(:permitted_actions)
    |> put_ban_id("U")
    |> validate_required([:reason, :enabled, :valid_until])
    |> check_constraint(:valid_until, name: :user_ban_duration_must_be_valid)
  end
end
