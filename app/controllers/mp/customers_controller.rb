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

  # GET /customers/new
  def new
    wechat_oauth2 do |openid, access_info|
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

    end

    if @wx_follower.present?
      if @wx_follower.customer.present?
        redirect_to :show
      end
    else
      redirect_to :please_subscribe
    end
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  #创建积攒， 检查用户的积攒数量，领取奖品。
  def create
    permitted_params = customer_params
    permitted_params['customerd_at'] = DateTime.current.to_date
    @customer = Customer.find_or_initialize_by(permitted_params)

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
        @customer = Customer.find(@wx_follower.customer_id)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:game_player_id, :openid)
    end
end
