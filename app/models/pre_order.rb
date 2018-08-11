class PreOrder < ApplicationRecord

  state_machine :state, initial: :pending do
    event :bought do
      transition pending: :bought
    end

    event :reset do
      transition bought: :pending
    end

    state :pending
    state :bought
  end

end
