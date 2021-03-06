RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.authorize_with do
    unless current_user && current_user.level && current_user.level > 9000
      redirect_to main_app.root_path unless current_user.level > 9000
    end
  end
end

#
# Monkey patch to remove default_scope
# fixes an issue with Post's default_scope
#
require 'rails_admin/adapters/active_record'
module RailsAdmin::Adapters::ActiveRecord
  def get(id)
    return unless object = scoped.where(primary_key => id).first
    AbstractObject.new object
  end
  def scoped
    model.unscoped
  end
end


