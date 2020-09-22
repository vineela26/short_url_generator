class LinkStatsController < ApplicationController
  def show
    @link_stats = LinkStat.pluck(:link_id).uniq
  end
end