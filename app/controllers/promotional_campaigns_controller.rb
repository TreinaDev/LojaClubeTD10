class PromotionalCampaignsController < ApplicationController
  def index 
    @promotional_campaigns = PromotionalCampaign.all
  end
end
