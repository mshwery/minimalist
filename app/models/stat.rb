class Stat < ActiveRecord::Base

  default_scope order('created_at ASC')

  def self.increment_count_of(counter_name)
    s = Stat.any? ? 
      Stat.first() :
      Stat.new({:lists_count => List.count, :tasks_count => Task.count })

    if !s.new_record?
      s.increment(counter_name)
    end

    s.save
  end
end
