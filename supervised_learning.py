from sklearn import svm
from sklearn.metrics import precision_score
from sklearn.metrics import recall_score
from sklearn.metrics import f1_score
import csv

# Reads a CSV file
def read_file(name):
    file = []
    
    with open(name) as f:
        reader = csv.reader(f)
   
        for row in reader:
            file.append(row)
    
        f.close()
        
    return file


# Get popular words by file_name.
def get_popular_words(name):
    file = []
    
    with open(name) as f:
        for row in f:
            file.append(row)
            
    return file

# Get popular words based on a centrality measure:
# 1. distance
# 2. closeness
# 3. betweenness
# 4. eigenvector
# 5. all combined
def get_popular_words_by_id(num):
    if num is 1:
        print("Centrality measure: distance")
        return get_popular_words("top_100_distance.txt")
    elif num is 2:
        print("Centrality measure: closeness")
        return get_popular_words("top_100_closeness.txt")
    elif num is 3:
        print("Centrality measure: betweenness")
        return get_popular_words("top_100_betweenness.txt")
    elif num is 4:
        print("Centrality measure: eigen")
        return get_popular_words("top_100_eigen.txt")
    else:
        print("Centrality measure: all combined (distance, closeness, betweenness, eigen)")
        return set(get_popular_words("top_100_distance.txt")).union(set(get_popular_words("top_100_closeness.txt")),set(get_popular_words("top_100_betweenness.txt")), set(get_popular_words("top_100_eigen.txt")))

# Retrieve a feature matrix using a dataset and popular words.
def retrieve_features(dataset, popular_words):
    features = []
    i = 0
    
    # For every row in the dataset
    for row in dataset:
        
        # Add list of zeros
        features.append([0] * len(popular_words))
    
        # Loop through all words in the tweet and count the amount of popular words
        for word in row[10].split(" "):
            if word in popular_words:
                j = popular_words.index(word)
                features[i][j] += 1
            
        i += 1
    
    return features

# Execute the supervised learning using a support vector machine.
def supervised_learning(training_features, sentiment_training, test_features, sentiment_test):
    # Training/testing phase
    model = svm.SVC()

    print("Now starting training phase...")
    
    # Fit the training features
    model.fit(training_features, sentiment_training)
    
    # Do the prediction and score
    final_p = model.predict(test_features)
    final = model.score(test_features, sentiment_test)

    print("Accuracy: %f" % final)
    print("Recall: %f" % recall_score(sentiment_test, final_p))
    print("Precision: %f " % precision_score(sentiment_test, final_p))
    print("F1 score: %f"  % f1_score(sentiment_test, final_p))

    # Calculate the percentages correctly classified
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
    
    neg_perc = zero_good / sentiment_test.count(0)
    pos_perc = one_good / sentiment_test.count(1)
    
    print("Negative  tweets correctly classified: %f%%" % neg_perc)
    print("Positve tweets correctly classified: %f%%" % pos_perc)
    

# Read both training and test data
training = read_file('training.csv')
test = read_file('test.csv')

# Remove header
training = training[1:len(training)]
test = test[1:len(test)]

def execute(centrality_id):
    # Get popular words by id
    popular_words = get_popular_words_by_id(centrality_id)
            
    # List of all popular words without \n
    popular_words = list(map(lambda x: x.rstrip(), popular_words))
    
    # Get feature matrices
    training_features = retrieve_features(training, popular_words)
    test_features = retrieve_features(test, popular_words)
    
    # Sentiment tags
    # 0 is negative
    # 1 is positive
    sentiment_training = list(map(lambda x: 0 if x[2] == "0" else 1, training))
    sentiment_test = list(map(lambda x: 0 if x[2] == "0" else 1, test))
    
    # Start the supervised learning
    supervised_learning(training_features, sentiment_training, test_features, sentiment_test)

# Prints a menu
def print_menu():
    print(30 * "-" , "MENU" , 30 * "-")
    print("1. Use distance centrality")
    print("2. Use closeness centrality")
    print("3. Use betweenness centrality")
    print("4. Use eigenvector centrality")
    print("5. Use all above centralities combined")
    print("6. Exit")
    print(67 * "-")
    
loop=True      
  
while loop:          ## While loop which will keep going until loop = False
    print_menu()    ## Displays menu
    choice = int(input("Enter your choice [1-6]: "))

    if choice==1:     
        execute(1)
    elif choice==2:
        execute(2)
    elif choice==3:
        execute(3)
    elif choice==4:
        execute(4)
    elif choice==5:
        execute(5)
    elif choice==6:
        print("Now exiting...")
        loop = False
    else:
        print("Wrong option selection. Enter [1-6]...")
                
        