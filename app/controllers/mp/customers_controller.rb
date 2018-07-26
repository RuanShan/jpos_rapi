#
# 用户通过微信公众号，注册，查看自己的订单
#
#
class Mp::CustomersController < Mp::BaseController

  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /customers/1
  # GET /customers/1.json
  def show

  end

  # 关联会员账号，或创建会员账号
  def new
    wechat_oauth2 do |openid, access_info|
      #查找用户，强制关注
      user = wechat.web_userinfo( access_info['access_token'], openid )
      @wx_follower = WxFollower.find_by(openid: openid)

      if @wx_follower.present?
        if @wx_follower.customer.present?
          redirect_to :show
        end
      else
        render :please_subscribe
      end
    end

    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  # 创建公众号 WxFollower, 创建Customer
  # 参数 短信和短信验证码
  def create
    wechat_oauth2 do |openid, access_info|

      permitted_params = customer_params

      #查找用户，强制关注
      user = wechat.web_userinfo( access_info['access_token'], openid )
      @wx_follower = WxFollower.find_or_create_by!(openid: openid) do |wx_follower|
        wx_follower.nickname = user['nickname']
        wx_follower.headimgurl = user['headimgurl']
        wx_follower.sex = user['sex']
        wx_follower.language = user['language']
        wx_follower.city = user['city']
        wx_follower.province = user['province']
        wx_follower.country = user['country']
        wx_follower.subscribe_time = user['subscribe_time']
      end

      @customer = Customer.find_or_initialize_by(permitted_params)

      verify_sms
      unless @sms.errors.empty?
        @sms.errors.each{|key, value|
          @customer.errors.add(key, value)
        }
      end

      respond_to do |format|
        if @customer.save
          format.html { redirect_to @customer, notice: 'Customer was successfully created.' }
          format.json { render :show, status: :created, location: @customer }
        else
          format.html { render :new }
          format.json { render json: @customer.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      wechat_oauth2 do |openid|
        @wx_follower = WxFollower.find_by_openid( openid )
        @customer =  @wx_follower.try(:customer)
        #微信用户没有关联会员账号
        if @customer.blank?
          redirect_to action: :new
        end
      end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:game_player_id, :openid)
    end

    def verify_sms
      permitted_params = customer_params
      serialized_sms = session[:sms]||{}
      # sms serialized as json in session, it is string key hash here
      @sms = Sms.new( phone: serialized_sms['phone'], code: serialized_sms['code'], send_at: serialized_sms['send_at'])
      @sms.verify_sign_up_sms( permitted_params['cellphone'],permitted_params['verification_code'])
    end
end
