module SessionsHelper
    def log_in(user)
        session[:user_id] = user.id
    end

    def current_user
        if user_id = session[:user_id]
            @current_user ||= User.find_by(id: user_id)
        end
    end

    def is_current_user?
        params[:id].to_i == current_user.id if current_user
    end

    def logged_in?
        !current_user.nil?
    end

    def log_out
        session.delete(:user_id)
        @current_user = nil
    end
end
