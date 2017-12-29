class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: { minimum: 5 }

  sluggable_column :username

  def two_factor_auth?
    # having a phone number means two factor auth is on
    !self.phone.blank?
  end

  def generate_pin!
    # generate random 6 digit number
    self.update_column(:pin, rand(10 ** 6))
  end

  def remove_pin!
    self.update_column(:pin, nil)
  end

  def send_pin_to_twilio
    # put your own credentials here
    account_sid = 'AC67532bf8aade61f435d28c29575003fd'
    auth_token = 'b8839d1ddd74406ad60a12688cea23b0'
    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token

    msg = "Hi there! Please enter this pin to login: #{self.pin}"

    @client.account.sms.messages.create({
      :from => '+18596671840',
      :to => "+1#{self.phone}",
      :body => msg
    })
  end

  def admin?
    self.role == 'admin'
  end

  def creator?(obj)
    self == obj.creator
  end
end
