#http://stackoverflow.com/questions/7614798/devise-api-authentication
class Api::V1::SessionsController <  Api::V1::BaseController

  attr_accessor :current_user

  #$ curl -i -X POST -d "user[email]=test-user-00@mail.com&user[password]=123123" http://localhost:3000/api/v1/sessions.json
  # 通過用戶名和密碼，拿到用户的 token
  def create
     @user = User.find_by(email: user_params[:email])
     if @user && @user.valid_password?(user_params[:password])
       self.current_user = @user
       # 我们使用 jbuilder
       # render(
       #   json: Api::V1::SessionSerializer.new(user, root: false).to_json,
       #   status: 201
       # )
     else
       return api_error(status: 401)
     end
   end

   private

   def user_params
     params.require(:user).permit(:email, :password)
   end

end
