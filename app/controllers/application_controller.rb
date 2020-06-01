class ApplicationController < ActionController::Base
  # sessions_controllerもusers_controllerもApplicationControllerを継承しているので、
  # ここに便利メソッドを入れておくと全部の子Controllerにも継承できる
  include SessionsHelper

  # def hello
  #   render html: "hi!"
  # end
end
