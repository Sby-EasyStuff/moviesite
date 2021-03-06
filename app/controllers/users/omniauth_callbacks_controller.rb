class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def oauth(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, :kind => provider.capitalize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def google
    oauth("google")
  end

  def failure
    set_flash_message(:alert, :failure, :kind => "Google", reason: failure_message) if is_navigational_format?
    redirect_to root_path
  end
end
