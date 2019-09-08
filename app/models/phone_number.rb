class PhoneNumber < ApplicationRecord
	validates :phone_number, uniqueness: true 
end
