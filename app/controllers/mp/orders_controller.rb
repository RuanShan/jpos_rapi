#
# 用户通过微信公众号，注册，查看自己的订单
#
#
class Mp::OrdersController < Mp::BaseController

  before_action :set_order, only: [:show, :edit, :update, :destroy]

  #最新订单
  def recent
    @customer = Customer.find 2
    

  end

  # GET /orders/1
  # GET /orders/1.json
  def show

  end

  # 关联会员账号，或创建会员账号
  def new
    wechat_oauth2 do |openid, access_info|
      #查找用户，强制关注
      user = wechat.web_userinfo( access_info['access_token'], openid )
      @wx_follower = WxFollower.find_by(openid: openid)

      if @wx_follower.present?
        if @wx_follower.order.present?
          redirect_to :show
        end
      else
        render :please_subscribe
      end
    end

    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  # 创建公众号 WxFollower, 创建Order
  # 参数 短信和短信验证码
  def create
    wechat_oauth2 do |openid, access_info|

      permitted_params = order_params

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

      @order = Order.find_or_initialize_by(permitted_params)

      verify_sms
      unless @sms.errors.empty?
        @sms.errors.each{|key, value|
          @order.errors.add(key, value)
        }
      end

      respond_to do |format|
        if @order.save
          format.html { redirect_to @order, notice: 'Order was successfully created.' }
          format.json { render :show, status: :created, location: @order }
        else
          format.html { render :new }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      wechat_oauth2 do |openid|
        @wx_follower = WxFollower.find_by_openid( openid )
        @order =  @wx_follower.try(:order)
        #微信用户没有关联会员账号
        if @order.blank?
          redirect_to action: :new
        end
      end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:game_player_id, :openid)
    end

    def verify_sms
      permitted_params = order_params
      serialized_sms = session[:sms]||{}
      # sms serialized as json in session, it is string key hash here
      @sms = Sms.new( phone: serialized_sms['phone'], code: serialized_sms['code'], send_at: serialized_sms['send_at'])
      @sms.verify_sign_up_sms( permitted_params['cellphone'],permitted_params['verification_code'])
    end
end
