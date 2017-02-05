class SmsController < ApplicationController
  protect_from_forgery except: :index

  def index
    Rails.logger.info "SMS received: #{params.inspect}"
    # {"To"=>"16173133383", "From"=>"16032891398", "TotalRate"=>"0", "Units"=>"1", "Text"=>"Test for Brandeis", "TotalAmount"=>"0", "Type"=>"sms", "MessageUUID"=>"66a4c728-ebdb-11e6-b621-069a94f6c0f9", "controller"=>"sms", "action"=>"index"}

    number = params['To']
    raise 'This endpoint is for SMS submissions only' unless number

    source_number = SourceNumber.find_by(phone_number: number)
    raise "No matching source found for #{number}" unless source_number 

    post = Post.create(college_id: source_number.college_id, text: params['Text'], from_phone: params['From'])
    message = "Awesome! Now share what you've overheard #{post_url(post)}"
    # TODO: return message in response format

    render json: { message: message }
  end
end
