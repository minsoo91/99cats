# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string(255)      default("PENDING")
#  created_at :datetime
#  updated_at :datetime
#

class CatRentalRequest < ActiveRecord::Base
  STATUSES = [
    "PENDING",
    "APPROVED",
    "DENIED"
  ]
  
  validates :cat_id, :start_date, :end_date, presence: true
  validates :status, inclusion: { in: STATUSES }
  validate :does_not_overlap_with_approved_request
  
  belongs_to(
    :cat,
    class_name: "Cat",
    foreign_key: :cat_id,
    primary_key: :id
  )
  
  def approve!
    self.status = "APPROVED"
    if self.save
      overlapping_pending_requests.update_all(status: "DENIED")
    end
  end
  
  def overlapping_pending_requests
    overlapping_requests.where("status = 'PENDING'")
  end
  
  def overlapping_requests
    CatRentalRequest
      .where("cat_id = ?", self.cat_id)
      .where("start_date BETWEEN ? AND ? OR end_date BETWEEN ? AND ?", 
             self.start_date, self.end_date, self.start_date, self.end_date)
      .where(
        "(:id IS NULL) OR (id != :id)", 
        id: self.id
      )
  end
  
  def deny!
    self.status = "DENIED"
    self.save
  end
  
  def overlapping_approved_requests
    overlapping_requests.any? { |request| request.status == "APPROVED" }
  end
  
  def pending?
    self.status == "PENDING"
  end
  
  private
  def does_not_overlap_with_approved_request
    if overlapping_approved_requests
      errors[:request] << "can not overlap with another request"
    end
  end
end