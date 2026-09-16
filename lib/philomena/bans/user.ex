defmodule Philomena.Bans.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Philomena.Bans.IdGenerator

  alias Philomena.Users.User

  schema "user_bans" do
    belongs_to :user, User
    belongs_to :banning_user, User

    field :reason, :string
    field :note, :string, default: ""
    field :enabled, :boolean, default: true
    field :valid_until, PhilomenaQuery.Ecto.RelativeDate
    field :generated_ban_id, :string
    field :override_ip_ban, :boolean, default: false

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
  def changeset(user_ban, attrs) do
    user_ban
    |> cast(attrs, [
      :reason,
      :note,
      :enabled,
      :override_ip_ban,
      :user_id,
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
    |> put_ban_id("U")
    |> validate_required([:reason, :enabled, :user_id, :valid_until])
    |> check_constraint(:valid_until, name: :user_ban_duration_must_be_valid)
  end
end
