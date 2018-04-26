# == Schema Information
#
# Table name: users
#
#  admin                  :boolean
#  approved               :boolean
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default(0)
#  sign_in_count          :integer          default(0), not null
#  super_user             :boolean
#  time_zone              :string
#  unconfirmed_email      :string
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # after_create :send_admin_mail
  # def send_admin_mail
  #  DeviseMailer.new_user_waiting_for_approval(self).deliver
  # end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  def role_coin_count
    return 30 if current_user.role == USER_FREE_ROLE
    return 100 if current_user.role == USER_STANDARD_ROLE
    return 10_000 if current_user.role == USER_PREMIUM_ROLE
  end

  def admin?
    admin
  end

  def approved_string
    approved ? "Approved" : "Not approved"
  end

  def admin_string
    admin ? "Admin" : ""
  end

  def display_name
    name.presence || "Anonymous"
  end

  def initial
    display_name[0, 1]
  end
end
