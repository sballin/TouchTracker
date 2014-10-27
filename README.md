### 🔫 To-Do

- Hundreds of tiny invisible views to support faster input
    - Rearrangement on orientation change
- Adaptive coordinates
    - How to fill in blanks for letters that haven't been typed yet?
    - Iterate moving by sum of error vectors to position keypresses to be compared
- Determine most costly operation for long lists
- Make settings page and make tolerance, result count tweakable
- AsyncDisplayKit

---

### ☁ Ideas
   
- Identify __finger__ behind each tap using radius
- ➽ Repeat dictionary
- ➽ Different color for space pressed, back pressed

---

### 🔴 Brain 

- Combines several analyses
    - Snake path: +1 if unbashed path has best of anything
    - Fraction path: take top N from each list
    - TwoDim: 
    - Mountains: ???

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

- Can make plist format dictionaries using __Python__
- Use __NSSet__ in snakeDictionary instead of NSMutableArray to do intersection stuff and maybe speedup
- __Average__ fraction paths for words and keep in an __NSMutableDictionary__

---

### 🚀 THE FUTURE

- 🔴 Short words
- Combined score
    - Touch data interpretation
    - Frequency
- Pressing space, shift, punctuation

---

### 📚 Resources

- [Gutenberg frequency lists](https://en.wiktionary.org/wiki/Wiktionary:Frequency_lists#Project_Gutenberg)
- Least Squares as a Maximum Likelihood Estimator (Numerical Recipes)

Useful symbols: ⚫️⚪️🔴🔵🔨🔫🌀⭐️⚡️🌙‼️⭕️
