class LinksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @link = Link.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @link = Link.find_by_id(params["id"])
    render :template =>"/error/404", :status => 404, :layout => false if @link && @link.created_at < 1.month.ago
    # tracking the clicks
    @link.update_attribute(:no_of_clicks, @link.no_of_clicks + 1) if @link
    if Rails.env.production?
      # getting the Ip from which a click has made
      click_ip = request.remote_ip
    else
      click_ip = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
    end
    @link.link_stats.find_or_create_by(ip_address: click_ip, country: Geocoder.search(click_ip).first.country)
    redirect_to @link.url

  end

  def create
    @link = Link.new
    @link.url = params["link"]["url"]
    duplicate_check = Link.where(url: params["link"]["url"]).where.not(short_url: [nil, ""]).last
    # checking for the presence of link
    unless duplicate_check.present?
      @link.short_url = @link.generate_short_url
      @link.save
    else
      @link = duplicate_check
    end

    respond_to do |format|
      format.js { }
    end
  end

private
  def link_params
    params.require(:link).permit(:url)
  end
end
