defmodule Philomena.Bans.Fingerprint do
  use Ecto.Schema
  import Ecto.Changeset
  import Philomena.Bans.IdGenerator

  alias Philomena.Users.User

  @type t :: %__MODULE__{}

  schema "fingerprint_bans" do
    belongs_to :banning_user, User

    field :reason, :string
    field :note, :string, default: ""
    field :enabled, :boolean, default: true
    field :valid_until, PhilomenaQuery.Ecto.RelativeDate
    field :fingerprint, :string
    field :generated_ban_id, :string

    has_many :permitted_actions, Philomena.Bans.PermittedAction,
      foreign_key: :fingerprint_ban_id,
      on_replace: :delete

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  @doc false
  def changeset(fingerprint_ban, attrs \\ %{}) do
    fingerprint_ban
    |> cast(attrs, [
      :reason,
      :note,
      :enabled,
      :fingerprint,
      :valid_until
    ])
    |> cast_assoc(:permitted_actions)
    |> put_ban_id("F")
    |> validate_required([:reason, :enabled, :fingerprint, :valid_until])
    |> check_constraint(:valid_until, name: :fingerprint_ban_duration_must_be_valid)
  end
end
