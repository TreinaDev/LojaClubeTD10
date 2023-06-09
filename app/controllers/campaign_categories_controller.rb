class CampaignCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user
  before_action :set_promotional_campaign, only: %i[create destroy]
  before_action :set_campaign_category, only: %i[destroy]

  def create
    campaign_category_params = params.require(:campaign_category).permit(:product_category_id, :discount)
    @campaign_category = CampaignCategory.new(campaign_category_params)
    @campaign_category.promotional_campaign = @promotional_campaign

    if @campaign_category.save
      redirect_to @promotional_campaign, notice: t('.campaign_category_success')
    else
      @categories = ProductCategory.all
      flash.now[:alert] = t('.campaign_category_fail')
      render 'promotional_campaigns/show'
    end
  end

  def destroy
    if @campaign_category.future?
      if @campaign_category.destroy
        redirect_to @promotional_campaign, notice: t('.campaign_category_success')
      else
        redirect_to @promotional_campaign, alert: t('.campaign_category_fail')
      end
    else
      redirect_to @promotional_campaign, alert: t('.campaign_no_future')
    end
  end

  private

  def set_campaign_category
    @campaign_category = CampaignCategory.find(params[:id])
  end

  def set_promotional_campaign
    @promotional_campaign = PromotionalCampaign.find(params[:promotional_campaign_id])
  end
end
