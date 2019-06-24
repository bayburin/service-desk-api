class Ahoy::Store < Ahoy::DatabaseStore
  def track_visit(data)
    data[:ip] = request.env["HTTP_X_FORWARDED_FOR"]
    data[:user_tn] = controller.current_user.tn
    data[:user_fio] = controller.current_user.fio
    super(data)
  end
end

Ahoy.api_only = true
Ahoy.geocode = false
# set to true for JavaScript tracking
Ahoy.api = false