class SearchPlace < ActiveRecord::Base

  # result
  IN_STOCK = "in stock"
  NOT_IN_STOCK = "not in stock"
  NO_ANSWER = "no answer"
  HANGUP = "hangup"
  RESULT_OPTIONS = [IN_STOCK, NOT_IN_STOCK, NO_ANSWER, HANGUP]

  # steps_completed
  CALL_PLACED = 1
  CALL_ANSWERED = 2
  CALL_RESPONDED = 3
  STEPS_COMPLETED_OPTIONS = [CALL_PLACED, CALL_ANSWERED, CALL_RESPONDED]


  belongs_to :search
  belongs_to :place
end
