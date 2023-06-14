class PromotionalCampaignsController < ApplicationController
  before_action :authenticate_user!, only: %i[index new create]
  before_action :check_user, only: %i[index new create]
  before_action :set_promotional_campaign, only: %i[show edit update]

  def index 
    @promotional_campaigns = PromotionalCampaign.all
  end

  def new
    @promotional_campaign = PromotionalCampaign.new
    @companies = Company.all
  end

  def create
    @promotional_campaign = PromotionalCampaign.new(promotional_campaign_params)

    if @promotional_campaign.save
      redirect_to promotional_campaigns_path, notice: t('.promotional_campaign_success')
    else
      @companies = Company.all
      flash.now[:alert] = t('.promotional_campaign_fail')
      render :new
    end
  end

  private

  def set_promotional_campaign
    @promotional_campaign = PromotionalCampaign.find(params[:id])
  end

  def promotional_campaign_params
    params
      .require(:promotional_campaign)
      .permit(:name, :start_date, :end_date, :company_id)
  end
end
