// Databricks notebook source
//Loading the Data and Data Cleaning

// COMMAND ----------

// MAGIC %sh wget http://kdd.ics.uci.edu/databases/20newsgroups/mini_newsgroups.tar.gz -O /tmp/newsgroups.tar.gz

// COMMAND ----------

// MAGIC %sh tar xvfz /tmp/newsgroups.tar.gz -C /tmp/

// COMMAND ----------

// MAGIC %fs cp -r file:/tmp/mini_newsgroups dbfs:/tmp/mini_newsgroups

// COMMAND ----------

// Loading text file, leave out file paths, converting all strings to lowercase
val corpus = sc.wholeTextFiles("/tmp/mini_newsgroups/*").map(_._2).map(_.toLowerCase())

// COMMAND ----------

corpus.takeSample(false, 1)

// COMMAND ----------

//We will do a bit of simple data cleaning here by removing the metadata of each document
// Split document by double newlines, drop the first block, combine again as a string
val corpus_body = corpus.map(_.split("\\n\\n")).map(_.drop(1)).map(_.mkString(" "))

// COMMAND ----------

// Review first 5 documents with metadata removed
corpus_body.take(5)

// COMMAND ----------

//To use the convenient Feature extraction and transformation APIs, we will convert our RDD into a DataFrame.
// Convert RDD to DF with ID for every document
val corpus_df = corpus_body.zipWithIndex.toDF("corpus", "id")

// COMMAND ----------

display(corpus_df)

// COMMAND ----------

//Text Tokenization : We will use the RegexTokenizer to split each document into tokens. We can setMinTokenLength() here to indicate a minimum token //length, and filter away all tokens that fall below the minimum.
import org.apache.spark.ml.feature.RegexTokenizer

// Set params for RegexTokenizer
val tokenizer = new RegexTokenizer()
  .setPattern("[\\W_]+")
  .setMinTokenLength(4) // Filter away tokens with length < 4
  .setInputCol("corpus")
  .setOutputCol("tokens")

// Tokenize document
val tokenized_df = tokenizer.transform(corpus_df)


// COMMAND ----------

display(tokenized_df.select("tokens"))

// COMMAND ----------

// MAGIC %sh wget http://ir.dcs.gla.ac.uk/resources/linguistic_utils/stop_words -O /tmp/stopwords

// COMMAND ----------

// MAGIC %fs cp file:/tmp/stopwords dbfs:/tmp/stopwords

// COMMAND ----------

val stopwords = sc.textFile("/tmp/stopwords").collect()

// COMMAND ----------

import org.apache.spark.ml.feature.StopWordsRemover

// Set params for StopWordsRemover
val remover = new StopWordsRemover()
  .setStopWords(stopwords) // This parameter is optional
  .setInputCol("tokens")
  .setOutputCol("filtered")

// Create new DF with Stopwords removed
val filtered_df = remover.transform(tokenized_df)

// COMMAND ----------

//Vector of Token Counts
//LDA takes in a vector of token counts as input. We can use the CountVectorizer() to easily convert our text documents into vectors of token counts.
//The CountVectorizer will return (VocabSize, Array(Indexed Tokens), Array(Token Frequency))
//Two handy parameters to note:
//setMinDF: Specifies the minimum number of different documents a term must appear in to be included in the vocabulary.
//setMinTF: Specifies the minimumn number of times a term has to appear in a document to be included in the vocabulary.

// COMMAND ----------

import org.apache.spark.ml.feature.CountVectorizer

// Set params for CountVectorizer
val vectorizer = new CountVectorizer()
  .setInputCol("filtered")
  .setOutputCol("features")
  .setVocabSize(10000)
  .setMinDF(5)
  .fit(filtered_df)

// COMMAND ----------

// Create vector of token counts
val countVectors = vectorizer.transform(filtered_df).select("id", "features")

// COMMAND ----------

//To use the LDA algorithm in the MLlib library, we have to convert the DataFrame back into an RDD.
// Convert DF to RDD
import org.apache.spark.mllib.linalg.Vector

val lda_countVector = countVectors.map { case Row(id: Long, countVector: Vector) => (id, countVector) }

// COMMAND ----------

// format: Array(id, (VocabSize, Array(indexedTokens), Array(Token Frequency)))
lda_countVector.take(1)

// COMMAND ----------

//Create LDA model with Online Variational Bayes
//We will now set the parameters for LDA. We will use the OnlineLDAOptimizer() here, which implements Online Variational Bayes.
//Choosing the number of topics for your LDA model requires a bit of domain knowledge. As we know that there are 20 unique newsgroups in our dataset, we //will set numTopics to be 20.
val numTopics = 20


// COMMAND ----------

//We will set the parameters needed to build our LDA model. We can also setMiniBatchFraction for the OnlineLDAOptimizer, which sets the fraction of corpus //sampled and used at each iteration.
import org.apache.spark.mllib.clustering.{LDA, OnlineLDAOptimizer}

// Set LDA params
val lda = new LDA()
  .setOptimizer(new OnlineLDAOptimizer().setMiniBatchFraction(0.8))
  .setK(numTopics)
  .setMaxIterations(3)
  .setDocConcentration(-1) // use default values
  .setTopicConcentration(-1) // use default values

// COMMAND ----------

//Creating the LDA model with Online Variational Bayes.
val ldaModel = lda.run(lda_countVector)
