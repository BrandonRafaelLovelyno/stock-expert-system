(deftemplate introduction
(slot done-introducting)
)

; introduction


(defrule introduct
=>
(printout t "Hello, I am a stock analyst expert system. Nice to meet you!!" crlf)
(printout t "I'll pose a series of questions to assist you in evaluating whether a stock is overvalued or reasonably priced." crlf crlf)
(assert (introduction (done-introducting yes)))
)


; asking stock property

(defrule ask-stock
   ?intro<-(introduction (done-introducting yes))
   =>
   (printout t "Kindly specify the stock you would like me to evaluate." crlf crlf)
   (printout t "1. SIDO" crlf)
   (printout t "2. BBRI" crlf)
   (printout t "3. BBCA" crlf)
   (bind ?response(read))
   (if (member$ ?response (create$ 1 2 3))
       then
       (assert (stock-number ?response))
       (retract ?intro)
       else
       (printout t "Invalid stock number. Please enter a valid number." crlf))
)


(defrule print-chosen-stock
   (chosen-stock ?value)
   =>
   (if (= ?value 1)
       then
       (printout t "You have chosen SIDO" crlf)
       else
       (if (= ?value 2)
           then
           (printout t "You have chosen BBRI" crlf)
           else
           (if (= ?value 3)
               then
               (printout t "You have chosen BBCA" crlf)))
   )
)

(defrule ask-stock-pbv
?number<-(stock-number ?value)
=>
(printout t "What is the price to book value ?" crlf)
(bind ?response (read))
(if (numberp ?response)
    then
    (assert (stock-pbv (float ?response)))
    else
    (printout t "Invalid input. Please enter a numeric value for the price to book value." crlf))
)

(defrule ask-stock-epr
?number<-(stock-number ?value)
?pbv_fact<-(stock-pbv ?pbv)
=>
(printout t "What is the earning to price ration ?" crlf)
(bind ?response (read))
(if (numberp ?response)
    then
    (assert (stock-epr (float ?response)))
    else
    (printout t "Invalid input. Please enter a numeric value for the earning to price ratio." crlf))
)

(defrule ask-stock-roe
?number<-(stock-number ?value)
?pbv_fact<-(stock-pbv ?pbv)
?epr_fact<-(stock-epr ?epr)
=>
(printout t "What is the return on equity ?" crlf)
(bind ?response (read))
(if (numberp ?response)
    then
    (assert (stock-roe (float ?response)))
    else
    (printout t "Invalid input. Please enter a numeric value for the return on equity." crlf))
)

(defrule ask-stock-price
?number<-(stock-number ?value)
?pbv_fact<-(stock-pbv ?pbv)
?epr_fact<-(stock-epr ?epr)
?roe_fact<-(stock-roe ?roe)
=>
(printout t "What is the stock price ?" crlf)
(bind ?response (read))
(if (numberp ?response)
    then
    (assert (stock-price (float ?response)))
    else
    (printout t "Invalid input. Please enter a numeric value for the stock price." crlf))
)


; determine stock normal parameter

(defrule determine_stock_normal_parameter
   ?number <- (stock-number ?value)
   =>
(if (= ?value 1)
    then
    (assert (stock-normal-pbv 7.22))
    (assert (stock-normal-epr 0.052))
    (assert (stock-normal-roe 31.97))
    (assert (stock-normal-price 828.7))
else
    (if (= ?value 2)
        then
        (assert (stock-normal-pbv 2.58))
        (assert (stock-normal-epr 0.062))
        (assert (stock-normal-roe 15.72))
        (assert (stock-normal-price 5659))
    else
        (assert (stock-normal-pbv 4.77))
        (assert (stock-normal-epr 0.038))
        (assert (stock-normal-roe 17.97))
        (assert (stock-normal-price 10263)))
           
   )
)

; count relaitve deviation

(defrule count_relative_deviation_percentage
  ?number<-(stock-number ?value)
  ?pbv_fact<-(stock-pbv ?pbv)
  ?normal-pbv_fact<-(stock-normal-pbv ?normal-pbv)
  ?epr_fact<-(stock-epr ?epr)
  ?normal-epr_fact<-(stock-normal-epr ?normal-epr)
  ?roe_fact<-(stock-roe ?roe)
  ?normal-roe_fact<-(stock-normal-roe ?normal-roe)
  ?price_fact<-(stock-price ?price)
  ?normal-price_fact<-(stock-normal-price ?normal-price)
  =>
  (assert (stock-relative-pbv (*(/ (- ?pbv ?normal-pbv) ?normal-pbv) 100)))
(assert (stock-relative-epr (*(/ (- ?epr ?normal-epr) ?normal-epr) 100)))
(assert (stock-relative-roe (*(/ (- ?roe ?normal-roe) ?normal-roe) 100)))
(assert (stock-relative-price (*(/ (- ?price ?normal-price) ?normal-price) 100)))
)

; determine stock status

(defrule determine_stock_status
  ?number<-(stock-number ?value)
  ?relative_pbv_fact<-(stock-relative-pbv ?relative-pbv)
  ?relative_epr_fact<-(stock-relative-epr ?relative-epr)
  ?relative_roe_fact<-(stock-relative-roe ?relative-roe)
  ?relative_price_fact<-(stock-relative-price ?relative-price)
  => 
  (if (< (abs ?relative-pbv) 7)
      then (assert (stock-status-pbv "normal"))
      else (if (> ?relative-pbv 7)
                then (assert (stock-status-pbv "expensive"))
                else (if (< ?relative-pbv -7)
                          then (assert (stock-status-pbv "cheap"))))
  )
  (if (< (abs ?relative-epr) 7)
      then (assert (stock-status-epr "normal"))
      else (if (> ?relative-epr 7)
                then (assert (stock-status-epr "expensive"))
                else (if (< ?relative-epr -7)
                          then (assert (stock-status-epr "cheap"))))
  )
  (if (< (abs ?relative-roe) 7)
      then (assert (stock-status-roe "normal"))
      else (if (> ?relative-roe 7)
                then (assert (stock-status-roe "expensive"))
                else (if (< ?relative-roe -7)
                          then (assert (stock-status-roe "cheap"))))
  )
  (if (< (abs ?relative-price) 7)
      then (assert (stock-status-price "normal"))
      else (if (> ?relative-price 7)
                then (assert (stock-status-price "expensive"))
                else (if (< ?relative-price -7)
                          then (assert (stock-status-price "cheap"))))
  )
)

; printing evaluation result

(defrule print_evaluation_result
   ?number<-(stock-number ?value)
   ?status_pbv_fact<-(stock-status-pbv ?status-pbv)
   ?status_epr_fact<-(stock-status-epr ?status-epr)
   ?status_roe_fact<-(stock-status-roe ?status-roe)
   ?status_price_fact<-(stock-status-price ?status-price)
    ?relative_pbv_fact<-(stock-relative-pbv ?stock-relative-pbv)
    ?relative_epr_fact<-(stock-relative-epr ?stock-relative-epr)
    ?relative_roe_fact<-(stock-relative-roe ?stock-relative-roe)
    ?relative_price_fact<-(stock-relative-price ?stock-relative-price)
   =>
   (printout t "The evaluation result for the stock is as follows:" crlf crlf)

   (printout t "Price to Book Value relative deviation: " ?stock-relative-pbv "%" crlf)
   (printout t "Earning to Price Ratio relative deviation: " ?stock-relative-epr "%" crlf)
   (printout t "Return on Equity relative deviation: " ?stock-relative-roe "%" crlf)
   (printout t "Price relative deviation: " ?stock-relative-price "%" crlf crlf)

   (printout t "Price to Book Value: " ?status-pbv crlf)
   (printout t "Earning to Price Ratio: " ?status-epr crlf)
   (printout t "Return on Equity: " ?status-roe crlf)
   (printout t "Price: " ?status-price crlf)
)

