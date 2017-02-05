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
    message = "Got it! Now you can share it with your friends #{post_url(post)}"
    notify_user_about_post(params['From'], params['To'], message)

    render json: { message: message }
  end

  private

  def notify_user_about_post(to, from, message)
    plivo = Plivo::RestAPI.new(Rails.application.secrets.plivo_id, Rails.application.secrets.plivo_token)

    params = {
      'dst' => to,
      'src' => from,
      'text' => message
    }

    plivo.send_message(params)
  end
end
