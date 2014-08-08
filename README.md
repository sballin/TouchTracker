### ☁ Ideas

- Identify __finger__ behind each tap, possible to get [radius](http://easyplace.wordpress.com/2013/04/09/how-to-detect-touch-size-in-ios/), then compare relative sizes
- ➽ Ask about __speeding up__ touch recognition on Apple developer forums
- ➽ Dictionary grouping words of __same length__: small arithmetic for a few thousand elements -> not bad, right?
- ➽ __Horizontal__ and __vertical__ fraction paths
    - +/– for direction and scaled with total distances

---

### 🔴 Getting rid of x

Look in different snake paths of just `r`s and `l`s. Probably better than going through all words of the same length.

---

### 🔴 Brain 

- Combines several analyses
    - Snake path: +1 if unbashed path has best of anything
    - Fraction path: take top N from each list
    - TwoDim: 
    - Mountains: 

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
