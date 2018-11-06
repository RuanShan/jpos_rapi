module AuditorGeneralService
  thread_mattr_accessor :origin

  def self.log(options = {})
    AuditorGeneralLog.create(
      model_type: options[:model_type],
      model_id: options[:model_id],
      action: options[:action],
      alterations: options[:alterations],
      message: options[:message],
      origin_id: AuditorGeneralService.origin
    )
  end
end
