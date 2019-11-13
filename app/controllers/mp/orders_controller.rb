#
# 用户通过微信公众号，注册，查看自己的订单
#
#
class Mp::OrdersController < Mp::BaseController
  before_action :set_wx_follower
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  #最新订单
  def recent
    @group_state = params[:group_state] || 'pending'


    inprogress_groups_orders = @customer.orders.includes(line_item_groups: :images).inprogress_groups.reverse_chronological
    #新订单
    @pending_orders = inprogress_groups_orders.select{|o| o.group_state=='pending' }
    #待领取
    @ready_orders = inprogress_groups_orders.select{|o|  o.group_state =='ready' }

    #工作中
    @working_orders = inprogress_groups_orders - @pending_orders - @ready_orders

    Rails.logger.debug "@pending_orders= #{@pending_orders.length}, @ready_orders= #{@ready_orders.length}, @working_orders=#{ @working_orders.length}"
  end

  # 物品维修订单
  def normal
    @orders = @customer.orders.type_normal.reverse_chronological.page params[:page]
  end

  # 充值卡订单
  def card
    #只显示充值成功的
    @orders = @customer.orders.with_state(:cart).type_card.reverse_chronological.page params[:page]

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
    def set_wx_follower
      wechat_oauth2 do |openid|
        @wx_follower = WxFollower.find_by_openid( openid )
        #微信用户没有关联会员账号
        if @wx_follower.blank?
          redirect_to follower_order_entry_path
        end
        @customer = @wx_follower.customer
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Spree::Order.find( params[:id] )
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
