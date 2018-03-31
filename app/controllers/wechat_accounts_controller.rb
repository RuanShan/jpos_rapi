class WechatAccountsController < ApplicationController
  before_action :set_wechat_account, only: [:show, :edit, :update, :destroy]

  # GET /wechat_accounts
  # GET /wechat_accounts.json
  def index
    @wechat_accounts = WechatAccount.all
  end

  # GET /wechat_accounts/1
  # GET /wechat_accounts/1.json
  def show
  end

  # GET /wechat_accounts/new
  def new
    @wechat_account = WechatAccount.new
  end

  # GET /wechat_accounts/1/edit
  def edit
  end

  # POST /wechat_accounts
  # POST /wechat_accounts.json
  def create
    @wechat_account = WechatAccount.new(wechat_account_params)

    respond_to do |format|
      if @wechat_account.save
        format.html { redirect_to @wechat_account, notice: 'Wechat account was successfully created.' }
        format.json { render :show, status: :created, location: @wechat_account }
      else
        format.html { render :new }
        format.json { render json: @wechat_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wechat_accounts/1
  # PATCH/PUT /wechat_accounts/1.json
  def update
    respond_to do |format|
      if @wechat_account.update(wechat_account_params)
        format.html { redirect_to @wechat_account, notice: 'Wechat account was successfully updated.' }
        format.json { render :show, status: :ok, location: @wechat_account }
      else
        format.html { render :edit }
        format.json { render json: @wechat_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wechat_accounts/1
  # DELETE /wechat_accounts/1.json
  def destroy
    @wechat_account.destroy
    respond_to do |format|
      format.html { redirect_to wechat_accounts_url, notice: 'Wechat account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wechat_account
      @wechat_account = WechatAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wechat_account_params
      params.require(:wechat_account).permit(:name, :account, :key, :secret, :access_token)
    end
end
