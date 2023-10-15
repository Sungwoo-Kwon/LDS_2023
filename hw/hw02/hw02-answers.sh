# Linguistics and Data Science [hw02]
# Release date: 2023-10-08
# Due date: 2023-10-13 1:00 PM

# Q1. How many recipes contain GARUM? (1pt)
grep -rl "GARUM" data/apicius/recipes/ | wc -l

# Q2. List the 10 most frequent words in the recipes containing FISH (1pt)
egrep -r -o -h -w '\w+' data/apicius/recipes/*FISH* | sort | uniq -c | sort -rn | head -n 10 #무슨 이유에서 인지 교수님의 output과는 미세하게 다른 결과가 나옵니다. 강의 영상을 다시보며 split-recipes.awk 다시 작성해서 돌려보았지만 여전히 미세한 차이가 있습니다.

# Q3. List of all trigrams in all the recipes with their frequencies (2pt)
egrep -roh --include='*.txt' '\b\w+\b \b\w+\b \b\w+\b' data/apicius/recipes/ | sort | uniq -c | sort -nr > hw/hw02/apicius-3grams.txt # 이 코드또한 실행시키면 첫번쨰와 두번쨰로 많이 사용된 트라이그램의 출현빈도가 1씩 차이가 납니다. 정규표현식을 바꿔서 코드를 만들어 봤지만 이 방법이 가장 차이가 적었습니다.

# Q4. Print the English name, the Latin name, and the recipe of each food (1pt)
awk -f hw/hw02/hw02-print-recipes.awk data/apicius/recipes.txt
