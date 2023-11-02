class RatingsQuery
  def initialize(relation)
    @relation = relation
  end

  def subs_with_users_recent_upload_infos
     relation = @relation.where(id: users.pluck(:subscription_ids).flatten.compact)
     relation
  end

  def users
    user_ids = ActiveRecord::Base.connection.exec_query(
      "SELECT user_id FROM uploads WHERE updated_at is null OR updated_at::date > '#{Time.now.prev_month.strftime("%Y-%d-%m")}'")

    User.where(id: user_ids.rows.flatten.uniq)
  end

  def selected_uploads
    Upload.where(id: upload_ids)
  end

  def upload_ids
    upload_ids = ActiveRecord::Base.connection.exec_query(
      "SELECT id FROM uploads WHERE updated_at is null OR updated_at::date > '#{Time.now.prev_month.strftime("%Y-%d-%m")}'")
      .rows
      .flatten
  end

  def infos_for_subscriptions_update
    UploadsInfo.where(upload_id: upload_ids)
  end
end
