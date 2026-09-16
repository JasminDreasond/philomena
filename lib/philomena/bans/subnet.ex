defmodule Philomena.Bans.Subnet do
  use Ecto.Schema
  import Ecto.Changeset
  import Philomena.Bans.IdGenerator

  alias Philomena.Users.User

  schema "subnet_bans" do
    belongs_to :banning_user, User

    field :reason, :string
    field :note, :string, default: ""
    field :enabled, :boolean, default: true
    field :valid_until, PhilomenaQuery.Ecto.RelativeDate
    field :specification, EctoNetwork.INET
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
  def changeset(subnet_ban, attrs) do
    subnet_ban
    |> cast(attrs, [
      :reason,
      :note,
      :enabled,
      :specification,
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
    |> put_ban_id("S")
    |> validate_required([:reason, :enabled, :specification, :valid_until])
    |> check_constraint(:valid_until, name: :subnet_ban_duration_must_be_valid)
    |> mask_specification()
  end

  defp mask_specification(changeset) do
    specification =
      changeset
      |> get_field(:specification)
      |> case do
        %Postgrex.INET{address: {h1, h2, h3, h4, _h5, _h6, _h7, _h8}, netmask: 128} ->
          %Postgrex.INET{address: {h1, h2, h3, h4, 0, 0, 0, 0}, netmask: 64}

        val ->
          val
      end

    put_change(changeset, :specification, specification)
  end
end
