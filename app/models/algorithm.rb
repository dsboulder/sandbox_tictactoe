class Algorithm < ActiveRecord::Base

  acts_as_runnable_code :classes => [Board, Move]
  
  attr_reader :valid_password
  
  validates_each :password do |record, attr, value|
    record.errors.add attr, 'must match the original' if !record.valid_password
  end
  
  def password=(newpass)
    if self["password"].blank?
      self["password"] = MD5.md5(newpass).to_s
      @valid_password = true
    else
      @valid_password = (self["password"] == MD5.md5(newpass).to_s)
    end
  end
  
  def display_name
    "#{name} (by #{author})"
  end
end
