class ApplicationController < ActionController::API
  def index
    render json: {
        hello: ENV.fetch("NAME", "Set your name through NAME env")
    }
  end
end
