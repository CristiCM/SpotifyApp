# app/controllers/users/omniauth_callbacks_controller.rb:

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def spotify
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      # request.env['omniauth.auth'] returns a hash of all the information sent by the provider.
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Spotify'
        sign_in_and_redirect @user, event: :authentication
      else
        session['devise.spofity_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
  end
end