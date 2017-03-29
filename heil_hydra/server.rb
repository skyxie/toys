require 'sinatra'

get '/:duration' do
  begin
    sleep Integer(params['duration'])
    [200, 'Thanks for waiting']
  rescue Exception => e
    [400, "Oops"]
  end
end

