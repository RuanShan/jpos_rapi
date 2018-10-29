# https://ruby-china.org/topics/25822
# http://blog.csdn.net/ishxiao/article/details/52211246
# 返回结果的结构示例：
# {
#    data : { // 请求数据，对象或数组均可
#        user_id: 123,
#        user_name: "tutuge",
#        user_avatar_url: "http://tutuge.me/avatar.jpg"
#    },
#    msg : "done", // 请求状态描述，调试用
#    code: 1001, // 业务自定义状态码
#    extra : { // 全局附加数据，字段、内容不定
#        type: 1,
#        desc: "签到成功！"
#    }
# }

# msg字段 - 请求状态描述，调试用
# msg字段是本次请求的业务、状态描述信息，主要用于调试、测试等。
# 如“done”、“请求缺少参数！”
# 服务端可以自由发挥，开发人员看得懂就好。 -_-|||
# code字段 - 业务自定义状态码
# code字段，业务自定义的状态码。
# 其实是否要在API里面自定义业务状态码，非常有争议=。=，因为Http请求本身已经有了完备的状态码，再定义一套状态码直观上感受却是不对劲。但是实际开发中，确实发现自定义业务状态码的必要性，如一次成功的Http status 200的请求，可能由于用户未登录、登录过期而有不同的返回结果和处理方式，所以还是保留了code。
# 状态码的定义也最好有一套规范，如按照用户相关、授权相关、各种业务，做简单的分类：

class Api::V1::BaseController < ApplicationController
  respond_to :json
  attr_accessor :current_api_user

  # disable the CSRF token
  skip_before_action :verify_authenticity_token

  rescue_from ActionController::ParameterMissing do
    api_error(status: 400, errors: 'Invalid parameters')
  end


  def api_error(status: 500, errors: [])
    if errors.blank?
      head :no_content, status: status
    else
      @error_serializer = Api::V1::ErrorSerializer.new(status, errors)
      render @error_serializer,  status: status
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    api_error(status: 404, errors: 'Resource not found!')
  end

  def unauthenticated!
    api_error(status: 401)
  end

  def authenticate_user!
    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)
    # "Authorization: Token token=izrFiion7xEe2ccTj0v0mOcuNoT3FvpPqI31WLSCEBLvuz4xSr0d9+VI2+xVvAJjECIoju5MaoytEcg6Md773w==, \
    #   email=test-user-00@mail.com"
    user_email = options.blank?? nil : options[:email]
    user = user_email && User.find_by(email: user_email)

    if user && ActiveSupport::SecurityUtils.secure_compare(user.authentication_token, token)
      self.current_api_user = user
    else
      return unauthenticated!
    end
  end

  def authenticate_with_api_key
     api_key = request.headers["Authorization"] || params[:api_key]
     self.current_api_user =  User.find_by_api_key(api_key)
     unless self.current_api_user
       return unauthenticated!
     end
  end

  def paginate(resource)
    resource = resource.page(params[:page] || 1)
    if params[:per_page]
      resource = resource.per(params[:per_page])
    end

    return resource
  end

  def invalid_resource!( resource)
    Rails.logger.debug " resource.errors=#{resource.errors.inspect}"
    api_error(status: :unprocessable_entity, errors: resource.errors)
  end


  def not_found!
    Rails.logger.warn { "not_found for: #{current_api_user.try(:id)}" }

    api_error(status: 404, errors: 'Resource not found')
  end


end
