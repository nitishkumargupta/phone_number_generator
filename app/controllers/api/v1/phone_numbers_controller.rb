# frozen_string_literal: true

module Api
	# This controller is to perform all the action for a phone number
	module V1
		class PhoneNumbersController < Api::ApplicationController
	  	skip_before_action :verify_authenticity_token
	  	before_action :check_request_format

			def create
				number = generate_number
				@phone = PhoneNumber.new(phone_number: number)
				if @phone.save
					render json: { number: @phone.phone_number, status: 'Created' }, status: 200
				else
					render json: { status: 'error', message: 'Please try later' }, status: 400
				end
			end

			def check_number_availability
				unless params[:number].match(/^[1-9]{3}-[1-9]{3}-[1-9]{4}$/)
					render json: {status: false , message: 'Invalid Format'}, status: 400
					return
				end
				status = number_available? params[:number]
				if status.present?
					number = params[:number] 
				else
					number = generate_number
				end
				@phone = PhoneNumber.new(phone_number: number)
				if @phone.save
					message = set_message status, number
					render json: {status: true , message: message}, status: 200
				else
					render json: {status: 'error' , message: 'Please try later'}, status: 400
				end
			end

			private
			def number_available? number
				@phone_number = PhoneNumber.find_by_phone_number(number)
				@phone_number.blank?
			end

			def set_message status, number
				status.present? ? "Number is Available. #{number} is allotted to you" : "Number is not Available. Allotting #{number} to you."
			end

			def check_request_format
				if request.content_type == 'json' || request.content_type == 'application/json'
					return true
				else
					render json: {message: 'Invalid Request'}, status: 400
				end
			end

			def generate_number
				status = false
				until status
					number = 10.times.map{rand(1..9)}
					number.insert(3,'-')
					number.insert(7,'-')
					status = number_available? number
				end
				number.join()
			end
		end
	end
end
