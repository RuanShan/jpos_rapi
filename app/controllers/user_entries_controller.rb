class UserEntriesController < ApplicationController
  respond_to :html, :json
  skip_before_action :verify_authenticity_token, if: :is_cors?
  before_action :set_user, only: [:create]
  before_action :set_user_entry, only: [:show, :edit, :update, :destroy]

  # GET /user_entries
  # GET /user_entries.json
  def index
    @user_entries = UserEntry.all
  end

  # GET /user_entries/1
  # GET /user_entries/1.json
  def show
  end

  # GET /user_entries/new
  def new
    @user_entry = UserEntry.new
  end

  # GET /user_entries/1/edit
  def edit
  end


  # 创建用户打卡信息
  # POST /user_entries
  # POST /user_entries.json
  def create
    #判断用户使用有创建打卡的权限
    # 禁止，似乎导致session过期
    #ability = Spree::Ability.new( @user )
    #ability.authorize! :create, UserEntry

    @user_entry = UserEntry.new(user_entry_params)
    @user_entry.user = @user
    respond_to do |format|
      if @user_entry.save
        format.html { redirect_to @user_entry, notice: 'User entry was successfully created.' }
        format.json { render :show, status: :created, location: @user_entry }
      else
        Rails.logger.debug "@user_entry =#{@user_entry.inspect} #{@user_entry.errors.inspect}, store= #{@user_entry.store}"
        format.html { render :new }
        format.json { render json: @user_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_entries/1
  # PATCH/PUT /user_entries/1.json
  def update
    respond_to do |format|
      if @user_entry.update(user_entry_params)
        format.html { redirect_to @user_entry, notice: 'User entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_entry }
      else
        format.html { render :edit }
        format.json { render json: @user_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_entries/1
  # DELETE /user_entries/1.json
  def destroy
    @user_entry.destroy
    respond_to do |format|
      format.html { redirect_to user_entries_url, notice: 'User entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_entry
      @user_entry = UserEntry.find(params[:id])
    end

    #根据用户名和密码，设置打卡用户
    def set_user
      @user = User.new
      #使用当前登录用户
      if params[:is_current]
        @user = current_user
      else
        permitted_user_params = user_params
        user = User.find_by_username( permitted_user_params[:username] )
        if user.valid_password?( permitted_user_params[:password] )
          @user = user
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_entry_params
      params.require(:user_entry).permit(:state, :user_id, :store_id, :day)
    end

    def user_params
      params.require(:user).permit(:username, :password)
    end

    def is_cors?
      Rails.logger.debug "request.host=#{request.host} local=#{request.local?} "
      request.local? || request.host=~/jpos|localhost/
    end
end
