class RecordsForPeriod
  def initialize(relation, period)
    @relation = relation
    @period = period
  end

  def user_logins
    @relation.where('login_count > 0 AND remember_created_at IN ?', @period)
  end
end
