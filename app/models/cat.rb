# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :date             not null
#  color       :string(255)      not null
#  name        :string(255)      not null
#  sex         :string(255)      not null
#  description :text             not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Cat < ActiveRecord::Base
  COLORS = [
    "black",
    "white",
    "gray",
    "orange"
  ]
  
  validates :name, :description, presence: true
  validates_date :birth_date, on_or_before: Date.current # write your own if you have time
  validates :color, inclusion: { in: COLORS }
  validates :sex, inclusion: { in: ["M", "F"], message: "Must be M or F" }

  has_many(
    :rental_requests,
    class_name: "CatRentalRequest",
    foreign_key: :cat_id,
    primary_key: :id,
    dependent: :destroy
  )
  
  belongs_to(
    :user,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )
  
  def age
    "#{((Date.current - birth_date).to_i) / 365} years"
  end
  
  # def all_colors
  #   COLORS
  # end
  
  # def rental_requests
  #   CatRentalRequest.where("cat_id = ?", self.id)
  #                   .order(:start_date)
  # end
end
