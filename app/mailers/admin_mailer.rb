class AdminMailer < ApplicationMailer
  def new_user_waiting_for_approval(user)
    @user = user
    @url  = new_user_registration_path(@user)
    mail(:to => @user.email, :subject => "Welcome to Coinfocus.  <a href='#{@url}'>Click here to register</a>")
  end
end
