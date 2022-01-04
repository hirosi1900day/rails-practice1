# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + '/environment')
# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development
# cronを実行する環境変数をセット
set :environment, rails_env 
# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"

 
every 1.minutes do
  rake 'chat_unread_mail:chat_unread_task'
end

every 1.day, at: '03:00 am' do
  rake 'subscription:update'
end