class ApplicationController < ActionController::Base

    def require_user_logged_in!
        redirect_to new_user_session_path if current_user.nil?
    end
end
