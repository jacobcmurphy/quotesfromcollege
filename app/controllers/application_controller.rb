class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def honeypot_fields
  	{
  		bot_stop: 'Stop bots from submitting.',
  		seems_legit: 'No spam castles here.'
  	}
  end

  def honeypot_string
  	'These are the droids you are looking for.'
  end
end
