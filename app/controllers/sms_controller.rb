class SmsController < ApplicationController
  before_action :set_sms, only: [:validate]

  def create
    less_than_one_minute = false
    if session[:sms]
      last_send_time = Time.parse(session[:sms]['send_at'])
      send_duration = Time.now - last_send_time
      less_than_one_minute = send_duration <= 60
    end

    status = 0
    if less_than_one_minute
      set_sms
      @sms.errors.add(:verification_code, "验证码每分钟只能发送一次")
    else
      @sms = Sms.new( mobile: params[:mobile] )
      # validate phone number
      if @sms.valid?
        # send successfully
        if @sms.send_for_sign_up
          session[:sms] = @sms
          status = 1
        end
      end
    end
    logger.debug "sms=#{@sms.inspect}"
    render json: { status: status, sms: @sms }
  end

  def validate

  end

  private
    def set_sms
      if session[:sms]
        sms_params = session[:sms].slice 'mobile', 'code', 'send_at'
        @sms = Sms.new sms_params
      else
        @sms = Sms.new(  )
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    #def set_sms
    #  unless current_user
    #    session[:sign_up_sms]
    #  end
    #end

    # Never trust parameters from the scary internet, only allow the white list through.
    #def sms_params
    #  params.require(:phone)
    #end
end
