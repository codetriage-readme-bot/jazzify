class UserApplication < ActiveRecord::Base
	belongs_to :user, class_name: User, foreign_key: "user_id"
  belongs_to :volunteer_position, class_name: VolunteerPosition, foreign_key: "fist_choice_volunteer_position_id"
  belongs_to :volunteer_position, class_name: VolunteerPosition, foreign_key: "second_choice_volunteer_position_id"
	belongs_to :volunteer_position, class_name: VolunteerPosition, foreign_key: "third_choice_volunteer_position_id"
	belongs_to :user_application_status, class_name: UserApplicationStatus, foreign_key: "user_application_status_id"
	before_create :set_default_status

	validates_uniqueness_of :volunteer_position, :scope => [:user_id]

  private
	def set_default_status
    if !UserApplicationStatus.where({status: ['Incomplete', "Pending"]}).include?(self.user_application_status)
      self.user_application_status = UserApplicationStatus.find_by({status: 'Incomplete'})
    end
	end
end
