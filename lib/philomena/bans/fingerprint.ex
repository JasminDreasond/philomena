defmodule Philomena.Bans.Fingerprint do
  use Ecto.Schema
  import Ecto.Changeset
  import Philomena.Bans.IdGenerator

  alias Philomena.Users.User

  schema "fingerprint_bans" do
    belongs_to :banning_user, User

    field :reason, :string
    field :note, :string, default: ""
    field :enabled, :boolean, default: true
    field :valid_until, PhilomenaQuery.Ecto.RelativeDate
    field :fingerprint, :string
    field :generated_ban_id, :string

    # Granular bans
    field :ban_upload_image, :boolean, default: false
    field :ban_downvote_image, :boolean, default: false
    field :ban_upvote_image, :boolean, default: false
    field :ban_comment_images, :boolean, default: false
    field :ban_post_forum, :boolean, default: false
    field :ban_reply_forum, :boolean, default: false
    field :ban_send_pm, :boolean, default: false
    field :ban_api_key, :boolean, default: false
    field :ban_create_filters, :boolean, default: false
    field :ban_galleries, :boolean, default: false
    field :ban_manage_tags, :boolean, default: false
    field :ban_commissions, :boolean, default: false

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  @doc false
  def changeset(fingerprint_ban, attrs) do
    fingerprint_ban
    |> cast(attrs, [
      :reason,
      :note,
      :enabled,
      :fingerprint,
      :valid_until,
      :ban_upload_image,
      :ban_downvote_image,
      :ban_upvote_image,
      :ban_comment_images,
      :ban_post_forum,
      :ban_reply_forum,
      :ban_send_pm,
      :ban_api_key,
      :ban_create_filters,
      :ban_galleries,
      :ban_manage_tags,
      :ban_commissions
    ])
    |> put_ban_id("F")
    |> validate_required([:reason, :enabled, :fingerprint, :valid_until])
    |> check_constraint(:valid_until, name: :fingerprint_ban_duration_must_be_valid)
  end
end
