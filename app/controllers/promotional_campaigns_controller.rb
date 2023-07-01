class PromotionalCampaignsController < ApplicationController
  before_action :authenticate_user!, only: %i[index new create show edit update]
  before_action :check_user, only: %i[index new create show edit update]
  before_action :set_promotional_campaign, only: %i[show edit update]
  before_action :add_index_breadcrumb, only: %i[show new edit create update]

  def index
    add_breadcrumb('Campanhas Promocionais')
    @promotional_campaigns = PromotionalCampaign.all
  end

  def show
    add_breadcrumb("Campanha Promocional #{@promotional_campaign.name}")
    @campaign_category = CampaignCategory.new
    @categories = ProductCategory.where.not(id: @promotional_campaign.product_categories.pluck(:id)).where(active: true)
  end

  def new
    add_breadcrumb('Nova Campanha Promocional')
    @promotional_campaign = PromotionalCampaign.new
    bring_companies
    @companies = Company.where(active: true).order(:brand_name)
  end

  def edit
    @companies = Company.all
    add_breadcrumb("Editar #{@promotional_campaign.name}")
  end

  def create
    add_breadcrumb('Nova Campanha Promocional')
    @promotional_campaign = PromotionalCampaign.new(promotional_campaign_params)

    if @promotional_campaign.save
      redirect_to promotional_campaign_path(@promotional_campaign), notice: t('.promotional_campaign_success')
    else
      @companies = Company.all
      flash.now[:alert] = t('.promotional_campaign_fail')
      render :new
    end
  end

  def update
    add_breadcrumb("Editar #{@promotional_campaign.name}")

    if @promotional_campaign.update(promotional_campaign_params)
      redirect_to promotional_campaign_path(@promotional_campaign), notice: t('.promotional_campaign_success')
    else
      @companies = Company.all
      flash.now[:alert] = t('.promotional_campaign_fail')
      render :edit
    end
  end

  private

  def add_index_breadcrumb
    add_breadcrumb('Campanhas Promocionais', promotional_campaigns_path)
  end

  def set_promotional_campaign
    @promotional_campaign = PromotionalCampaign.find(params[:id])
  end

  def promotional_campaign_params
    params
      .require(:promotional_campaign)
      .permit(:name, :start_date, :end_date, :company_id)
  end
end
