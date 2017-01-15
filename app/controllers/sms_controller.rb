class SmsController < ApplicationController
  def index
    puts "params: #{params.inspect]}"

    # source_number = SourceNumber.find_by(phone_number: params['NUMBER_FIELD'])
    # raise "No matching source found for #{params['NUMBER_FIELD}" unless source_number
    #
    # post = Post.create(college_id: source_number.college_id, text: params['TEXT_FIELD'])
    # message = "Awesome! Now share what you overheard at #{post_url(post)}"
    # return message in response format

  end
end
