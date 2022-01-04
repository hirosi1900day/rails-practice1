class Mypage::Contract::ContractCancellationsController < ApplicationController
    def create
        contract = current_user.stop_subscript!
        redirect_to mypage_plans_path, success: "#{contract.plan.name}を解約しました"
    end
end
