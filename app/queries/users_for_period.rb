class RecordsForPeriod
  def initialize(relation, starts, ends)
    @relation = relation
    @period = period
  end

  def user_logins
    @relation.where('login_count > 0 AND remember_created_at between ? and ?', starts, ends)
  end

  def user_active_for_month
    @relation.joins(:uploads).where('uploads.date is not null and uploads.date between ? and ?', starts, ends)
  end
end
