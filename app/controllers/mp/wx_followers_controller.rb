#
# 微信用户通过微信公众号，注册，查看自己的订单
#
#
class Mp::WxFollowersController < Mp::BaseController

  before_action :set_wx_follower, only: [:show, :edit, :update, :destroy]

  # 微信会员入口
  # 关联会员账号，或创建会员账号
  def order_entry
    wechat_oauth2 do |openid, access_info|
      #查找用户，强制关注
      user = wechat.user( openid )
      if user.blank?
        redirect_to :please_subscribe and return
      end
      #微信用户已经关注
      @wx_follower = WxFollower.find_by(openid: openid)

      if @wx_follower.try(:customer)
        #如果微信用户已经关联会员账号
        Rails.logger.debug "found customer, redirect #{ mp_wx_follower_path( @wx_follower ) }"
        redirect_to  mp_wx_follower_path( @wx_follower ) and return
      elsif @wx_follower.present?
        #customer 客户信息被删除， 微信用户需要重新关联
        @wx_follower.destroy
      end
    end

    @wx_follower = WxFollower.new
  end

  # GET /customers/1/edit
  def edit
  end

  def show
    @customer = @wx_follower.customer
    @prepaid_card = @customer.prepaid_card || Spree::Card.style_prepaid.new
    #我的订单数量
    @order_count = @customer.orders.type_normal.count
    #我的订单金额
    @order_total = @customer.orders.type_normal.sum(:total)
    #我的充值金额
    @card_total = @customer.orders.type_card.sum(:total)
    #最近订单及物品
    @inprogress_groups_orders  = @customer.orders.inprogress_groups.includes(:payments, :line_item_groups)
    #最近订单物品
    @line_item_groups = @inprogress_groups_orders.map(&:line_item_groups).flatten
    #新订单数量
    @pending_line_item_group_count = @line_item_groups.select{|group| group.pending? }.count
    #待领取数量
    @ready_line_item_group_count = @line_item_groups.select{|group| group.ready? }.count
    #工作中
    @processing_line_item_group_count = @line_item_groups.length - @pending_line_item_group_count  - @ready_line_item_group_count

  end

  # POST /customers
  # POST /customers.json
  # 创建公众号 WxFollower, 创建Customer
  # 参数 短信和短信验证码
  #
  def associate_customer
    wechat_oauth2 do |openid, access_info|

      permitted_params = wx_follower_params

      #查找用户，强制关注
      user = wechat.user( openid )
      @wx_follower = WxFollower.find_or_initialize_by(openid: openid) do |wx_follower|
        wx_follower.nickname = user['nickname']
        wx_follower.headimgurl = user['headimgurl']
        wx_follower.sex = user['sex']
        wx_follower.language = user['language']
        wx_follower.city = user['city']
        wx_follower.province = user['province']
        wx_follower.country = user['country']
        wx_follower.subscribe_time = user['subscribe_time']
      end
      @wx_follower.assign_attributes( permitted_params )
      # 检查手机验证码
      verify_sms
      if @sms.errors.present?
        @sms.errors.each{|key, value|
          @wx_follower.errors.add(key, value)
        }
      end

      # 检查手机号码对应的客户是否存在

      respond_to do |format|
        if @wx_follower.save
          format.html {
            #@orders = @wx_follower.customer.orders
            @customer = @wx_follower.customer
            @prepaid_card = @wx_follower.customer.prepaid_card
            redirect_to  mp_wx_follower_path( @wx_follower ), notice: 'wx_follower was successfully created.'
          }
          format.json { render :show, status: :created}
        else
          format.html { render :new }
          format.json { render json: @wx_follower.errors, status: :unprocessable_entity }
        end
      end
    end

  end


  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(wx_follower_params)
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

  # jquery.validator 调用，
  # 检验会员的手机号码是否存在，只有存在的会员才能关联微信号
  # params
  #  mobile: 需要验证的电话号码
  # response
  #  json: { ret: 'success'|'failure'   }
  def validate_mobile
    mobile = params[:mobile]
    exists = Customer.exists?( mobile: mobile )
    render json: ( exists ? 'true' : 'false' )
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wx_follower
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
    def wx_follower_params
      params.require(:wx_follower).permit(:mobile, :verify_code)
    end

    def verify_sms
      permitted_params = wx_follower_params
      serialized_sms = session[:sms]||{}
      # sms serialized as json in session, it is string key hash here
      @sms = Sms.new( mobile: serialized_sms['mobile'], verify_code: serialized_sms['verify_code'], send_at: serialized_sms['send_at'])
      @sms.validate_for_sign_up( permitted_params['mobile'],permitted_params['verify_code'])
    end
end
