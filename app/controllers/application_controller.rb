class ApplicationController < ActionController::Base

    def require_user_logged_in!
        redirect_to new_user_session_path if current_user.nil?
    end

    def after_sign_in_path_for(resource)
        # return the path based on resource
        spotify_accounts_path  # replace this with your desired path
      end
end
