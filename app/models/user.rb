# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  project_id             :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  admin                  :boolean          default(FALSE)
#  diploma_year           :integer
#  promotion_id           :integer
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :promotion
  has_and_belongs_to_many :projects
  has_many :features, through: :project

  validates :email, presence: true

  before_create :set_as_admin_if_first

  include Gravtastic
  gravtastic size: 100

  delegate :has_feature?, to: :project

  default_scope { order('last_name, first_name') }

  def project
    projects.order(created_at: :desc).first
  end

  def project_in_workshop(workshop)
    projects.where(workshop: workshop).first
  end

  def to_s
    if first_name.nil? or last_name.nil?
      "#{email}"
    else
      "#{first_name} #{last_name}"
    end
  end

  private

    def set_as_admin_if_first
      self.admin = true unless User.any?
    end
end
