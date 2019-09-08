# frozen_string_literal: true

module Api
	# This controller is to perform all the action for a phone number
	class PhoneNumbersController < Api::ApplicationController
  	skip_before_action :verify_authenticity_token

		def create
			status = false
			until status
				number = 10.times.map{rand(1..9)}
				number.insert(3,'-')
				number.insert(7,'-')
				status = number_available? number
			end
			@phone = PhoneNumber.new(phone_number: number.join())
			if @phone.save
				render json: { number: @phone.phone_number, status: 'Created' }, status: 200
			else
				render json: { status: 'error', message: 'Please retry later' }, status: 400
			end
		end

		def check_number_availability
			unless params[:number].match(/[1-9]{3}-[1-9]{3}-[1-9]{4}/)
				render json: {status: false , message: 'Invalid Format'}, status: 400
				return
			end
			status = number_available? params[:number]
			message = set_message status
			render json: {status: status , message: message}, status: 200
		end

		private
		def number_available? number
			@phone_number = PhoneNumber.find_by_phone_number(number)
			@phone_number.blank?
		end

		def set_message status
			status.present? ? 'Number is Available' : 'Number is not Available'
		end
	end
end
