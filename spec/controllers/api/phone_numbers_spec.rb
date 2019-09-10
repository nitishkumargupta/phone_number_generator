require 'rails_helper'

RSpec.describe Api::PhoneNumbersController do
	
  describe 'POST #create' do
    it 'should return true' do
      post :create
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(parsed_response['status']).to eql('Created')
    end
  end

  describe '#number_available?' do
    describe 'when number is valid' do
      let(:valid_avail_number) do
        { number: '123-123-1234' }
      end
      let(:valid_unavail_number) do
        { number: '123-123-1235' }
      end
      describe 'when number is available' do
        it 'should return true' do
          get :check_number_availability, params: valid_avail_number
          parsed_response = JSON.parse(response.body)
          expect(response).to have_http_status(:success)
          expect(parsed_response['status']).to eql(true)
          expect(parsed_response['message']).to eql('Number is Available')
        end
      end
      describe 'when number is not available' do
        @phone = PhoneNumber.create(phone_number: '123-123-1235')
        it 'should return false' do
          get :check_number_availability, params: valid_unavail_number
          parsed_response = JSON.parse(response.body)
          expect(response).to have_http_status(:success)
          expect(parsed_response['status']).to eql(false)
          expect(parsed_response['message']).to eql('Number is not Available')
        end
      end
    end

    describe 'when number is invalid' do
      
      let(:invalid_number_1) do
        { number: '123-120-1234' }
      end
      
      let(:invalid_number_2) do
        { number: '123-123-123432' }
      end
      
      let(:invalid_number_3) do
        { number: '1231-120-12343' }
      end
      
      it 'should return false' do
        get :check_number_availability, params: invalid_number_1
        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(parsed_response['status']).to eql(false)
        expect(parsed_response['message']).to eql('Invalid Format')
      end

      it 'should return false' do
        get :check_number_availability, params: invalid_number_2
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['status']).to eql(false)
        expect(parsed_response['message']).to eql('Invalid Format')
      end

      it 'should return false' do
        get :check_number_availability, params: invalid_number_3
        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(parsed_response['status']).to eql(false)
        expect(parsed_response['message']).to eql('Invalid Format')
      end
    end
  end

end
