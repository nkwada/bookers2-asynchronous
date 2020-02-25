class ApplicationController < ActionController::Base
	before_action :authenticate_user!, except: [:top, :about]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search
	#デバイス機能実行前にconfigure_permitted_parametersの実行をする。
	protect_from_forgery with: :exception


  def set_search
    @q = User.ransack(params[:q])
    @q.build_condition if @q.conditions.empty?
  end

  protected
  def after_sign_in_path_for(resource)
    users_path
  end

  #sign_out後のredirect先変更する。rootパスへ。rootパスはhome topを設定済み。
  def after_sign_out_path_for(resource)
    root_path(resource)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email])
    #sign_upの際にnameのデータ操作を許。追加したカラム。
  end
end
