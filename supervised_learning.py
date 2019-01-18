from sklearn import svm
from sklearn.metrics import precision_score
from sklearn.metrics import recall_score
from sklearn.metrics import f1_score
import csv

training = []
test = []

with open('training.csv') as f:
    reader = csv.reader(f)
   
    for row in reader:
        training.append(row)
    
    f.close()

with open('test.csv') as f:
    reader = csv.reader(f)
   
    for row in reader:
        test.append(row)
    
    f.close()    

training = training[1:len(training)]
test = test[1:len(test)]

popular_words = []

with open("top_100_distance.txt") as f:
    for row in f:
        popular_words.append(row)
        
with open("top_100_closeness.txt") as f:
    for row in f:
        popular_words.append(row)
        
# Get unique words
popular_words = list(set(popular_words))

# List of all popular words
popular_words = list(map(lambda x: x.rstrip(), popular_words))

training_features = []
test_features = []


count_x = 0
for row in training:
    # Add list of zeros
    training_features.append([0] * len(popular_words))
    
    # Loop through all words in the tweet and count the amount of popular words
    for word in row[10].split(" "):
        if word in popular_words:
            i = popular_words.index(word)
            training_features[count_x][i] +=  1
            
    count_x = count_x + 1
    
count_x = 0
for row in test:
    # Add list of zeros
    test_features.append([0] * len(popular_words))
    
    # Loop through all words in the tweet and count the amount of popular words
    for word in row[10].split(" "):
        if word in popular_words:
            i = popular_words.index(word)
            test_features[count_x][i] +=  1
            
    count_x = count_x + 1

# Sentiment tags
# 0 is negative
# 1 is positive
sentiment_training = []
sentiment_test = []

for row in training:
    if row[2] == "0":
        sentiment_training.append(0)
    else:
        sentiment_training.append(1)
        
for row in test:
    if row[2] == "0":
        sentiment_test.append(0)
    else:
        sentiment_test.append(1)
        
        
# Training testing phase
model = svm.SVC()
model.fit(training_features, sentiment_training)

final = model.score(test_features, sentiment_test)
final_p = model.predict(test_features)

print(f1_score(sentiment_test, final_p))
print(recall_score(sentiment_test, final_p))
print(precision_score(sentiment_test, final_p))

zero_good = 0
one_good = 0

index  = 0
for i in final_p.tolist():
    if i == sentiment_test[index]:
        if i == 0:
            zero_good += 1
        else:
            one_good += 1
    index += 1
    
    
print(zero_good / sentiment_test.count(0))
print(one_good / sentiment_test.count(1))

        