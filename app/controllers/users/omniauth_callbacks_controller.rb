class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

    def facebook
       @user = User.from_facebook(request.env['omniauth.auth'])
       if @user.persisted?
        sign_in_and_redirect @user, event: :authenttication
       else
        session['devise.facebook'] = request.env['omniauth']
        redirect_to new_user_registration_url
       end
    end

end