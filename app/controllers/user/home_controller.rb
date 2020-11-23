class User::HomeController < ApplicationController
  before_action :authenticate_member!
  def top
    # ありがとう
    @today_thanks = Thank.where("created_at >= ?", Time.zone.today)
    # 本番環境なら
    if Rails.env.production?
      @this_month_thanks = Thank.where("date_format(created_at, '%m') = '?'", Time.zone.now.month)
      @prev_month_thanks = Thank.where("date_format(created_at, '%m') = '?'", Time.zone.now.prev_month.month)
      # 誕生日
      @birthday_members = Member.where("date_format(birthday, '%m') = '?'", Time.zone.now.month).sort_by { |member| member.birthday.day }
      @next_birthday_members = Member.where("date_format(birthday, '%m') = '?'", Time.zone.now.next_month.month).sort_by { |member| member.birthday.day }
    else
      @this_month_thanks = Thank.where("strftime('%m', created_at) = '?'", Time.zone.now.month)
      @prev_month_thanks = Thank.where("strftime('%m', created_at) = '?'", Time.zone.now.prev_month.month)
      # 誕生日
      @birthday_members = Member.where("strftime('%m', birthday) = '?'", Time.zone.now.month).sort_by { |member| member.birthday.day }
      @next_birthday_members = Member.where("strftime('%m', birthday) = '?'", Time.zone.now.next_month.month).sort_by { |member| member.birthday.day }
    end

    @month_to_month_thanks = @this_month_thanks.count - @prev_month_thanks.count
    @thanks = Thank.where(to_id: current_member.id).order(created_at: :desc).limit(5)
      # ありがとうのランキング
    @from_thank_ranks = Member.find(@this_month_thanks.group(:from_id).order("count(from_id) desc").limit(3).pluck(:from_id))
    @to_thank_ranks = Member.find(@this_month_thanks.group(:to_id).order("count(to_id) desc").limit(3).pluck(:to_id))
    # 投稿
    @posts = Post.order(created_at: :desc).limit(5)
  end

  def about; end
end
