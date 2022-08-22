class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock

    stocks.where(id: stock.id).exists?
  end

  def stock_not_tracked?(ticker_symbol)
    !stock_already_tracked?(ticker_symbol)
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && stock_not_tracked?(ticker_symbol)
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name

    email
  end

  def stock_list
    return 'Not tracking any stocks' if stocks.empty?

    stocks.map { |stock| stock.ticker }.join(', ')
  end

  def not_self?(user_id)
    id != user_id
  end

  def not_friend?(user_id)
    !friend?(user_id)
  end

  def friend?(user_id)
    friends.where(id: user_id).exists?
  end

  def can_add_friend?(user_id)
    not_self?(user_id) && not_friend?(user_id)    
  end
  
  def search(param)
    User.search(param).select {|result| can_add_friend?(result.id)}
  end

  def self.search(param)
    param.strip!
    (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
  end

  def self.first_name_matches(param)
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    matches('last_name', param)
  end

  def self.email_matches(param)
    matches('email', param)
  end

  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end
end
