### 🔫 To-Do

- ➽ Live stats on score distributions
- Adaptive coordinates
    - How to fill in blanks for letters that haven't been typed yet?
    - Iterate moving by sum of error vectors to position keypresses to be compared
- Determine bottlenecks for long lists
- Make settings page and make tolerance, result count tweakable
    - Make tolerance a property instead of passing from argument to argument

---

### ☁ Ideas
   
- Center of gravity could be defined as origin
- Hundreds of tiny invisible __views__ to support faster input
    - Rearrangement on orientation change
- Guess __finger__ behind each tap using radius
- Put a ball corresponding to the location of each letter, have them all attract each other and cluster together, then see which ones are touching and use that graph to look up. Will work. 4sho. 

---

### ⚪️ Neighbors

- Letters __right next to each other__ could give some information. 
- Example: `l` pressed, short distance detected between strokes, then it's probably one of `m` `k` `o` `p`. 
- Go through list of candidates and check that min distances correspond to adjacent letters. Boost likelihood score if so.

---

### 🔵 TwoDim

- Gaussian distribution?
    - Fit, scale: get endpoints, compress/expand comparisons, integrate difference
- NOT relative to last press if possible -> two modes
- Do a least-squares fit of points suspected to be on same row, shuffle around points to get most parallel set of lines.
- Trace a path through points suspected to be on the same row, and note its curviness.

---

### ⚡️ Optimizations

- Speed up sorting for large lists by discarding everything with a score below average.

---

### 🚀 THE FUTURE

- Combined score
    - Touch data interpretation
    - Frequency
- Pressing space, shift, punctuation

---

### 📚 Resources

- [Gutenberg frequency lists](https://en.wiktionary.org/wiki/Wiktionary:Frequency_lists#Project_Gutenberg)
- Least Squares as a Maximum Likelihood Estimator (Numerical Recipes)

Useful symbols: ⚫️⚪️🔴🔵🔨🔫🌀⭐️⚡️🌙‼️⭕️
