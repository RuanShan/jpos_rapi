class Api::V1::CampaignsController < Api::V1::BaseController

  before_action :set_campaign, only: [:show, :edit, :update, :destroy]


  # curl -i http://localhost:3000/api/v1/campaigns.json
  # GET /campaigns.json
  # {"campaigns":[{"id":1,"name":"六一儿童节快乐联欢","start_at":null,"end_at":null}]}
  def index
    @campaigns = paginate Campaign
  end

  # curl -i http://localhost:3000/api/v1/campaigns/1
  # GET /campaigns/1.json
  #{"campaign":{"id":1,"name":"六一儿童节快乐联欢","start_at":null,"end_at":null,"created_at":"2017-05-20T15:28:51.000+08:00"}}
  def show
  end

  # POST /campaigns.json
  #$ curl -i -X POST -d "campaign[name]=六一儿童节快乐联欢&campaign[start_at]=2017-05-24T06:32:39+08:00" http://localhost:3000/api/v1/campaigns
  #$ curl -i -X POST -d "campaign[name]=六一儿童节快乐联欢&campaign[start_at]=2017-05-24T06:32:39" http://localhost:3000/api/v1/campaigns
  # {"status":"unprocessable_entity","errors":[{"title":"不能为空字符","detail":"不能为空字符"}]}
  def create
    @campaign = Campaign.new(campaign_params)

    if @campaign.save
       render :show, status: :created
    else
       invalid_resource!( @campaign )
    end

  end

  # PATCH/PUT /campaigns/1.json
  # curl -i -X PUT -d "campaign[name]=庆祝六一儿童节快乐联欢&campaign[end_at]=2017-05-29T06:32:39" http://localhost:3000/api/v1/campaigns/1
  # {"campaign":{"id":1,"name":"庆祝六一儿童节快乐联欢","start_at":null,"end_at":null,"created_at":"2017-05-20T15:28:51.000+08:00"}}
  def update
      if @campaign.update(campaign_params)
        render :show, status: :ok
      else
        invalid_resource! @campaign
      end
  end

  # curl -i -X DELETE  http://localhost:3000/api/v1/campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params.require(:campaign).permit(:name, :start_at, :end_at)
    end


end
