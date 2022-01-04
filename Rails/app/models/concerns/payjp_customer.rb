module PayjpCustomer
    extend ActiveSupport::Concern
  
    included do
      has_many :contracts, dependent: :restrict_with_error
      scope :subscription_to_be_updated, lambda {
        joins(contracts: :payments).joins('LEFT OUTER JOIN contract_cancellations ON contracts.id = contract_cancellations.contract_id')
                                   .where(contracts: { id: Contract.group(:user_id).select('max(id)') }) # 最新の一件
                                   .where(contract_cancellations: { id: nil })
                                   .where(payments: { id: Payment.group(:contract_id).select('max(id)') }) # 最新の一件
                                   .where('payments.current_period_end < ?', Time.current)
      }
    end
  
    # 最新の契約
    def latest_contract
      contracts.last
    end
  
    # 当該プランを契約しているか
    def subscripting_to?(plan)
      subscripting? &&
        latest_contract.plan.code == plan.code
    end
  
    # 当該プランをキャンセルしているか
    def about_to_cancel?(plan)
      subscripting_to?(plan) &&
        latest_contract.contract_cancellation.present?
    end
  
    # プランはどうあれ契約中か
    def subscripting?
      latest_contract.present? &&
        latest_contract.payments.last.current_period_end >= Time.current.to_date
    end
  
    # ベーシックプランを契約中か
    def subscripting_basic_plan?
      subscripting_to?(Plan.find_by!(code: '0001'))
    end
  
    # プレミアムプランを契約中か
    def subscripting_premium_plan?
      subscripting_to?(Plan.find_by!(code: '0002'))
    end
  
    # クレジットカードを登録する
    def register_creditcard!(token:)
      customer = add_customer!(token: token)
      update!(customer_id: customer.id)
    end
  
    # 当該プランを契約する
    def subscript!(plan)
      contract = contracts.create!(plan: plan)
      
      
      
      pay!
      contract
    end
  
    # 解約する
    def stop_subscript!(reason: :by_user_canceled)
      latest_contract.cancel!(reason: reason)
    end
  
    # 実際に支払う
    def pay!
      charge = charge!(latest_contract.plan.price)
      
      latest_contract.pay!(charge)
    end
  
    # PAYJPに登録しているカードを変更する
    def change_default_card!(token:)
      old_card = default_card
      customer.cards.create(
        card: token,
        default: true
      )
      old_card.delete
    end
  
    # PAYJPに登録しているデフォルトカードを取得する
    def default_card
      @default_card ||= customer.cards.retrieve(customer.default_card)
    end
  
    private
  
    # PAYJPに顧客を追加する
    def add_customer!(token:)
      Payjp::Customer.create(card: token, email: email, metadata: { name: name })
    end
  
    # PAYJPの顧客を取得する
    def customer
      @customer ||= Payjp::Customer.retrieve(customer_id)
    end
  
    # 実際に支払いを行う
    def charge!(amount)
      Payjp::Charge.create(currency: 'jpy',
                           amount: amount,
                           customer: customer_id)
    end
  end