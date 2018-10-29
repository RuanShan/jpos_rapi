class Api::V1::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    # 我们现在使用 app/views/api/v1/users/show.json.jbuilder
    # render(json: Api::V1::UserSerializer.new(user).to_json)
  end
end
