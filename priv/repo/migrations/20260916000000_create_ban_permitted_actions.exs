defmodule Philomena.Repo.Migrations.CreateBanPermittedActions do
  use Ecto.Migration

  def up do
    create table(:ban_permitted_actions) do
      add :user_ban_id, references(:user_bans, on_delete: :delete_all)
      add :subnet_ban_id, references(:subnet_bans, on_delete: :delete_all)
      add :fingerprint_ban_id, references(:fingerprint_bans, on_delete: :delete_all)
      add :action, :text, null: false

      timestamps()
    end

    create constraint(:ban_permitted_actions, :num_nonnulls,
             check: "num_nonnulls(user_ban_id, subnet_ban_id, fingerprint_ban_id) = 1"
           )
  end

  def down do
    drop table(:ban_permitted_actions)
  end
end
