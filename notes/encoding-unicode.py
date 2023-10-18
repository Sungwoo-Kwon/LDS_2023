from unicodedata import normalize 
syllable = '간'
decomposed = normalize(syllable)
print(decomposed, len(decomposed))
