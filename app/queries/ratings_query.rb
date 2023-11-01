class RatingsQuery
  def initialize(relation)
    @relation = relation
  end

  def subs_with_users_recent_upload_infos
    user_ids = Arel.sql(
      "SELECT user_id
      FROM uploads
      WHERE('uploads.created_at > ?, #{Date.today.prev_month})"
     )
     users = User.where(id: user_ids)
     relation = @relation.where('id IN ?', users.pluck(:subscription_ids).flatten)
     relation
  end

  def infos_for_subsriptions_update
    UploadsInfo.where(upload_id: selected_uploads.ids)
  end

  def selected_uploads
    users = User.select('subscription_ids IN ?', subs_with_users_recent_upload_infos.ids)
    uploads_ids = Arel.sql(
    "SELECT upload_id
    FROM uploads_infos
    GROUP_BY user_id IN #{users.ids}")
    relation = @relation.where(id: ids)
    relation
  end
end
