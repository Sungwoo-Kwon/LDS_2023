from collections import Counter
import nltk
counter_all = Counter()

with open('word-freq.txt', 'r') as file:
    for line in file:
        count, word = line.strip().split(None, 1) 
        counter_all[word] = int(count)  


nltk.download('stopwords')
stopword_list = nltk.corpus.stopwords.words('english')

counter_content = Counter({word: count for word, count in counter_all.items() if word not in nltk.corpus.stopwords.words('english')})

print(counter_content.most_common(5))

plot(counter_content)