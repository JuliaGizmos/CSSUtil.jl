# CSSUtil

CSSUtil provides utilities to create and align
various web elements on the DOM.

## Example Usage
```julia
using WebIO
using CSSUtil

el1 = node(:div, "Hello world!")
el2 = node(:div, "Goodbye world!")

el3 = hbox(el1, el2) # aligns horizontally
el4 = hline() # draws horizontal line
el5 = vbox(el1, el2) # aligns vertically
```
