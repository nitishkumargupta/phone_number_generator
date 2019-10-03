class PhoneNumber < ApplicationRecord
	validates :phone_number, uniqueness: true, format: { with: /[1-9]{3}-[1-9]{3}-[1-9]{4}/,
    message: "Invalid Format" } 
end
