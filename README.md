# Rule-Based Stock Valuation Expert System  

This repository contains a **rule-based expert system** for general stock valuation, built using the **CLIPS programming language**. Unlike other expert systems with uncertainty handling, this implementation does **not** integrate a **certainty factor (CF)** mechanism.  

## 📌 Overview  
- Accepts **Earnings Per Share (EPS)** and **Price-to-Book Value (PBV)** as input criteria.  
- Uses **rule-based logic** to determine stock valuation.  
- Built in **CLIPS**, a language specialized for expert systems.  
- Designed **purely for learning purposes**—not financial advice.  

## 🚀 Installation & Usage  
1. Install **CLIPS** from [here](http://www.clipsrules.net/).  
2. Clone this repository:  
   ```bash
   git clone https://github.com/BrandonRafaelLovelyno/stock-expert-system.git  
   cd stock-expert-system  
   ```  
3. Open the CLIPS environment:  
   ```bash
   clips  
   ```  
4. Load the expert system file:  
   ```clips
   (load "Stock Expert System.clp")  
   ```  
5. Run the expert system:  
   ```clips
   (reset)  
   (run)  
   ```  

## 📊 Features  
- **Rule-based** decision-making for general stock valuation.  
- Evaluates **EPS and PBV** to classify stock conditions.  
- **No certainty factor integration**—operates on pure logic-based rules.  
- **Educational purpose only**—not intended for actual stock trading.  

---  
📢 **Happy coding!** 🎯
