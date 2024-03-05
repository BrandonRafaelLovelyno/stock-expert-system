(deftemplate introduction
(slot done-introducting)
)


(defrule introduct
=>
(printout t "Hello, I am a stock analyst expert system. Nice to meet you!!" crlf)
(printout t "I'll pose a series of questions to assist you in evaluating whether a stock is overvalued or reasonably priced." crlf crlf)
(assert (introduction (done-introducting yes)))
)


; asking stock property

(defrule ask-stock
   ?intro <- (introduction (done-introducting yes))
   =>
   (printout t "Kindly specify the stock you would like me to evaluate." crlf crlf)
   (printout t "1. SIDO" crlf)
   (printout t "2. BBRI" crlf)
   (printout t "3. BBCA" crlf)
   (bind ?response (read))
   (if (member$ ?response (create$ "1" "2" "3"))
       then
       (assert (stock-number (str-to-int ?response)))
       (retract ?intro)
       else
       (printout t "Invalid stock number. Please enter a valid number." crlf))
)

(defrule stock-confirmation
   ?number <- (stock-number ?value)
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
               (printout t "You have chosen BBCA" crlf))))

)
(defrule ask-stock-pbv
?number<-(stock-number ?value)

=>
(printout t "What is the price to book value ?" crlf)
(bind ?response (read))
(assert stock-pbv ?response)
)

(defrule ask-stock-epr
?number<-(stock-number ?value)
?pbv<-(stock-pbv ?value)
=>
(printout t "What is the earning to price ration ?" crlf)
(bind ?response (read))
(assert stock-epr ?response)
)

(defrule ask-stock-roe
?number<-(stock-number ?value)
?pbv<-(stock-pbv ?value)
?epr<-(stock-epr ?value)
=>
(printout t "What is the return on equity ?" crlf)
(bind ?response (read))
(assert stock-roe ?response)
)

(defrule ask-stock-price
?number<-(stock-number ?value)
?pbv<-(stock-pbv ?value)
?epr<-(stock-epr ?value)
?roe<-(stock-roe ?value)
=>
(printout t "What is the stock price ?" crlf)
(bind ?response (read))
(assert stock-price ?response)
)


; determine stock normal parameter

(defrule determine_stock_normal_parameter
?number<-(stock-number ?value)
=>
if(= ?number 1)
then ( assert (stock-normal-pbv 7.22) (stock-normal-epr 0.052) (stock-normal-roe 31.97) (stock-normal-price 828.7))

if(= ?number 2)
then (assert (stock-normal-pbv 2.58) (stock-normal-epr 0.062) (stock-normal-roe 15.72) (stock-normal-price 5659))

if(= ?number 3)
then (assert (stock-normal-pbv 4.77) (stock-normal-epr 0.038) (stock-normal-roe 17.97) (stock-normal-price 10263))
)

; count relaitve deviation

(defrule count_relative_deviation_percentage
  ?number<-(stock-number ?value)
  ?pbv<-(stock-pbv ?value)
  ?normal_pbv<-(stock-normal-pbv ?value)
  ?epr<-(stock-epr ?value)
  ?normal_epr<-(stock-normal-epr ?value)
  ?roe<-(stock-roe ?value)
  ?normal_roe<-(stock-normal-roe ?value)
  ?price<-(stock-price ?value)
  ?normal_price<-(stock-normal-price ?value)
  =>
  (assert (stock-relative-pbv (/ (- ?pbv ?normal_pbv) (* ?normal_pbv 100))))
  (assert (stock-relative-epr (/ (- ?epr ?normal_epr) (* ?normal_epr 100))))
  (assert (stock-relative-roe (/ (- ?roe ?normal_roe) (* ?normal_roe 100))))
  (assert (stock-relative-price (/ (- ?price ?normal_price) (* ?normal_price 100))))
)

; determine stock status

(defrule determine_stock_status
  ?number<-(stock-number ?value)
  ?relative_pbv<-(stock-relative-pbv ?value)
  ?relative_epr<-(stock-relative-epr ?value)
  ?relative_roe<-(stock-relative-roe ?value)
  ?relative_price<-(stock-relative-price ?value)
  => 
  (if (< (abs ?relative_pbv) 7)
      then (assert (stock-status-pbv "normal"))
      else (if (> ?relative_pbv 7)
                then (assert (stock-status-pbv "expensive"))
                else (if (< ?relative_pbv -7)
                          then (assert (stock-status-pbv "cheap"))))
  )
  (if (< (abs ?relative_epr) 7)
      then (assert (stock-status-epr "normal"))
      else (if (> ?relative_epr 7)
                then (assert (stock-status-epr "expensive"))
                else (if (< ?relative_epr -7)
                          then (assert (stock-status-epr "cheap"))))
  )
  (if (< (abs ?relative_roe) 7)
      then (assert (stock-status-roe "normal"))
      else (if (> ?relative_roe 7)
                then (assert (stock-status-roe "expensive"))
                else (if (< ?relative_roe -7)
                          then (assert (stock-status-roe "cheap"))))
  )
  (if (< (abs ?relative_price) 7)
      then (assert (stock-status-price "normal"))
      else (if (> ?relative_price 7)
                then (assert (stock-status-price "expensive"))
                else (if (< ?relative_price -7)
                          then (assert (stock-status-price "cheap"))))
  )
)

; printing evaluation result

(defrule print_evaluation_result
?number<-(stock-number ?value)
?status_pbv<-(stock-status-pbv ?value)
?status_epr<-(stock-status-epr ?value)
?status_roe<-(stock-status-roe ?value)
?status_price<-(stock-status-price ?value)
=>
(printout t "The evaluation result for the stock is as follows:" crlf crlf)

(printout t "Price to Book Value relative deviation: " ?stock-relative-pbv "%" crlf)
(printout t "Earning to Price Ratio relative deviation: " ?stock-relative-epr "%" crlf)
(printout t "Return on Equity relative deviation: " ?stock-relative-roe "%" crlf)
(printout t "Price relative deviation: " ?stock-relative-price "%" crlf crlf)

(printout t "Price to Book Value: " ?status_pbv crlf)
(printout t "Earning to Price Ratio: " ?status_epr crlf)
(printout t "Return on Equity: " ?status_roe crlf)
(printout t "Price: " ?status_price crlf)
)
```
