class PaymentDecorator < Draper::Decorator
  delegate_all

  def contract_valid_period
    "#{object.current_period_start.to_date}〜#{object.current_period_end.to_date}"
  end
end
