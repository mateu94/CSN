# Complex and Social Networks - Final project
This final project for the course Complex and Social Network at [UPC-FIB](https://www.fib.upc.edu/) is based on the paper: __UDLAP: Sentiment Analysis Using a Graph Based Representation Proc. of 9th International Workshop on Semantic Evaluation (SemEval 2015)__

##### Authors
- Roberto-Junior Ristuccia
- Marc Mateu Sebastián
- Wouter Zorgdrager

## Data
The main data source used in this project is retrieved from [Sentiment140](http://help.sentiment140.com/for-students) which contains ~1.6 million tweets with either a positive or negative sentiment. This is stored in the `tweets_raw.csv` file. However, to reduce complexity we only used a random sample of 10 000 tweets. After pre-processing the data (see paper), the results are stored in `data_processed.csv`. In order to annotate the tweets using the [TreeTagger tool](http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/), `data_processed.csv` also had to be stored in a raw format in `data.txt`. The `data_processed.csv` is divided in a training set (`training.csv`) and test set (`test.csv`) with relatively 80% and 20% of the tweets. The co-occurrence graph is stored in `co-occurrence_graph` in a [graphml format](http://graphml.graphdrawing.org/). Finally the __popular words__ using centrality measures are stored in `top_100_[distance|closeness|betweenness|eigen].txt`.

## Scripts
The scripts we wrote to simulate the methodology described in the given [paper](http://aclweb.org/anthology/S15-2093) are as follows (the order described here is also the order necessary to simulate the paper):
1. `random_upload_dataset.R`: Samples 10 000 tweets from the ~1.6 million tweets.
2. `preprocessing.R`: Preprocesses the tweets using the TreeTagger tool. Ouputs: `data_processed.csv`.
3. `co-occurrence_graph.R`: Build the co-occurrence graph based on the pre-processed data. Outputs: `co-occurrence_graph`.
4. `generate_test_training_data.R`: Divides the preprocessed tweets into a training and test set. Outputs: `training.csv` and `test.csv`.
5. `centrality_measures.R`: Get the most popular words using different centrality measures on the co-ocurrence graph. Outputs: `top_100_[distance|closeness|betweenness|eigen].txt`.
6. `supervised_learning.py`: Executes the supervised learning using the popular words from the centrality measures and the training and test set.

All scripts are written in R apart from the supervised learning which is done in Python 3. 
