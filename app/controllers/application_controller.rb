class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # utilities
  def current_user

    # returning the actual Student ActiveRecord object here might require extra SQL calls
    #  the two values pulled from the session are already supplied when Canvas POSTs to
    #  launch a session of the app.
    #
    #  If this must be extended with the ActiveRecord object, perhaps use '.user' or '.local_user'
    Struct.new do
      def canvas_id
        session[:canvas][:user_id].to_i
      end

      def user_name
        session[:canvas][:user_name]
      end
    end
  end

end
