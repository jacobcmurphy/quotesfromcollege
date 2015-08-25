class LayoutsController < ApplicationController

  def college_select
    @schools_in_state = College.in_state params[:state]

    if(@schools_in_state.size > 0)
      respond_to do |college_select|
        college_select.html { render layout: false }
      end
    else
      render nothing: true
    end
  end

end