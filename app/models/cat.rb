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
  
  validates :birth_date, :color, :name, :sex, :description, presence: true
  validates_date :birth_date, timeliness: { on_or_before: lambda { Date.current } }
  validates :color, inclusion: { in: COLORS, message: "Not a valid color" }
  validates :sex, inclusion: { in: ["M", "F"], message: "Must be M or F" }
  
  def age
    "#{((Date.current - birth_date).to_i) / 365} years"
  end
  
  def all_colors
    COLORS
  end
end
