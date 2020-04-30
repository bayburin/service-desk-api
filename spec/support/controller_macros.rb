module ControllerMacros
  def sign_in_user
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in create(:content_manager_user)
    end
  end

  def sign_in_guest_user
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in create(:guest_user)
    end
  end
end
