## 프랑스 영화 리뷰 데이터 구축과 감정분석

### By Sungwoo Stanislas Kwon (권성우) 2023-82030



주제 변경 이유:

- 형태소 분석 경험 부족으로 인한 어려움.

- 보여주고자 했던 바를 증명하기에는 부족했던 술어들의 다양성.

- 복잡한 분석 보다는 그런 분석에 사용 될 수 있는 새로운 데이터를 스스로 구축 해보는 것도 의미있는 일 일것 같다고 생각.
  
  

새로운 주제:

- 프랑스 텔레비전 산업 관련 사이트 allociné.fr

- 그 중 '영화' 목록에있는 영화들의 제목, 별점, 리뷰 등등 스크랩해와 데이터셋 구축, 감정분석.
  
  

주요 tasks:

- BeautifulSoup를 이용한 데이터 스크래핑과 데이터셋 구축, 전처리 & 간단한 수치들 시각화.

- TF-IDF embedding을 이용해 간단한 감정 분류기 구축(로지스틱 회귀)과 분.
  
  



## 1. 데이터 스크래핑과 전처리

[allociné.fr](https://www.allocine.fr/)에서 십만개가 넘는 영화 url들을 추출하고 그 url에 접근해서 해당 영화 리뷰 (최대) 30개, 별점등을 스크래핑해와 데이터셋 구축

- 데이터셋을 1부터10까지 만들어야 했기에 사실상 가장 복잡했던 부분.

- 또한 처리해야하는 데이터가 상당히 많아서 코드 돌리는데도 시간이 매우 오래걸림.

![image.png](C:\LDS_2023\project\images\example.png)

Polarity coding:

- 1: positive: 4-5점

- 0: neutral: 2점 초과 4점 미만

- -1: negative: 0-2점
  
  

### 평점 별 리뷰 분표

| ![](C:\LDS_2023\project\images\counts.png) | ![](C:\LDS_2023\project\images\percents.png) |
| ------------------------------------------ | -------------------------------------------- |



### 년도별 리뷰 개수



<img title="" src="file:///C:/LDS_2023/project/images/year.png" alt="" width="730">



### 리뷰 길이 별 분포![](project\images\C:\LDS_2023\project\images\year.png)

- 2000자 이상으로 구성되어 있는 리뷰(전체 데이터의 약 6%)는 잘라냄.

<img title="" src="file:///C:/LDS_2023/project/images/length.png" alt="" width="723">

![](project\images\C:\LDS_2023\project\images\year.png)

```python
def loss_percentage(df, previous_length):
    new_length = len(df)
    percentage = 100*(1-(new_length/previous_length))    
    return new_length, percentage  

# 1. 필요없는 열 삭제
dataset_df = dataset_df.drop(columns=['rating', 'date', 'helpful', 'unhelpful'])

# 2. 필요없는 행 삭제 (polarity가 neutral한 행들)
dataset_df = dataset_df[dataset_df['polarity'] != 0]
length, percentage = loss_percentage(dataset_df, initial_len)
print("Length: {} (-{:.1f} %)".format(length, percentage))

# 3. 2000자 넘는 리뷰 삭제
LENGTH_THRESH = 2000
dataset_df = dataset_df[dataset_df['review'].str.len() <= LENGTH_THRESH]
length, percentage = loss_percentage(dataset_df, length)
print("Length: {} (-{:.1f} %)".format(length, percentage))

# 4. 각 영화별 리뷰 30개로 제한
MAX_REVIEWS_PER_FILM = 30
grouped = dataset_df.groupby('film-url')
for ids in grouped.groups.values():
    num_reviews = len(ids)    
    if num_reviews > MAX_REVIEWS_PER_FILM:
        sampling_size = num_reviews - MAX_REVIEWS_PER_FILM
        ids_to_drop = random.sample(list(ids), sampling_size)
        dataset_df = dataset_df.drop(ids_to_drop)

length, percentage = loss_percentage(dataset_df, length)
print("Length: {} (-{:.1f} %)".format(length, percentage))

length, percentage = loss_percentage(dataset_df, initial_len)
print("Total loss: (-{:.1f} %)".format(percentage))
```



그 밖의 전처리

- negative한 리뷰를 -1에서 0으로 코딩

- 텍스트 클리닝 (공백, 줄 바꾸기 제거 등.)

- 비어있는 리뷰 삭제

- 긍정 & 부정 리뷰 개수 맞추기

<img title="" src="file:///C:/LDS_2023/project/images/freq.png" alt="" width="735">







# 2. TF-IDF를 이용한 감정분류 머신러닝 모델 구현



### 데이터 사이즈

![](C:\LDS_2023\project\images\data.png)

### 

### 기본 모델

```python
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline

tfidf_clf = Pipeline([
    ('tfidf', TfidfVectorizer()),
    ('clf', LogisticRegression(n_jobs=-1, verbose=1)),
])

tfidf_clf.fit(X_train, y_train)
```



### 결과

![](C:\LDS_2023\project\images\model_results.png)



### Learning curve



<img title="" src="file:///C:/LDS_2023/project/images/learning_curve.png" alt="" width="758">

### 

### Confusion matrix를 통한 오차 분석



<img title="" src="file:///C:/LDS_2023/project/images/confusion_matrix.png" alt="" width="747">





### 오차 분석에서 잘못 예측한 데이터 기반 말풍선 시각화

```python
false_pos = X_val[(y_val == 0) & (y_pred == 1)]
false_neg = X_val[(y_val == 1) & (y_pred == 0)]
```

![](C:\LDS_2023\project\images\words_cloud.png)

![](C:\LDS_2023\project\images\cloud_fn.png)
