class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  CurrentUser = Struct.new(:session) do
    def canvas_id
      session_canvas_element('canvas_id')
    end

    def full_name
      session_canvas_element('full_name')
    end

    def roles
      session_canvas_element('roles')
    end

    def given_name
      session_canvas_element('given_name')
    end

    def family_name
      session_canvas_element('family_name')
    end

    def session_canvas_element(element)
      session && session['canvas'] && session['canvas'][element]
    end

  end

  # utilities
  def current_user
    CurrentUser.new(session)
  end

end
