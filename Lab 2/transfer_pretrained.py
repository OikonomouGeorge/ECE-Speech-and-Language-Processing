from transformers import pipeline
from sklearn.preprocessing import LabelEncoder
from tqdm import tqdm
from utils.load_datasets import load_MR, load_Semeval2017A
from training import get_metrics_report
from config import EMB_PATH

#########################################################
# Two-Classes Models For Dataset: MR
# 1. siebert/sentiment-roberta-large-english
# 2. distilbert/distilbert-base-uncased-finetuned-sst-2-english
# 3. facebook/bart-large-mnli
#########################################################

#########################################################
# Three-Classes Models For Dataset: Semeval2017A
# 1. cardiffnlp/twitter-roberta-base-sentiment
# 2. finiteautomata/bertweet-base-sentiment-analysis
# 3. j-hartmann/sentiment-roberta-large-english-3-classes
#########################################################

# DATASET = 'Semeval2017A'
# PRETRAINED_MODEL = 'nlptown/bert-base-multilingual-uncased-sentiment'

DATASET = 'MR'
PRETRAINED_MODEL = 'facebook/bart-large-mnli'

LABELS_MAPPING = {
    'siebert/sentiment-roberta-large-english': {
        'POSITIVE': 'positive',
        'NEGATIVE': 'negative',
    },
    'distilbert/distilbert-base-uncased-finetuned-sst-2-english': {
        'POSITIVE': 'positive',
        'NEGATIVE': 'negative',
    },
    'facebook/bart-large-mnli': {
        'positive': 'positive',
        'negative': 'negative',
    },
    'cardiffnlp/twitter-roberta-base-sentiment': {
        'LABEL_0': 'negative',
        'LABEL_1': 'neutral',
        'LABEL_2': 'positive',
    },
    'finiteautomata/bertweet-base-sentiment-analysis': {        
        'NEG': 'negative',
        'NEU': 'neutral',
        'POS': 'positive',
    },
    'j-hartmann/sentiment-roberta-large-english-3-classes': {
        'negative': 'negative',
        'neutral': 'neutral',
        'positive': 'positive',
    }
}

if __name__ == '__main__':
    # load the raw data
    if DATASET == "Semeval2017A":
        X_train, y_train, X_test, y_test = load_Semeval2017A()
    elif DATASET == "MR":
        X_train, y_train, X_test, y_test = load_MR()
    else:
        raise ValueError("Invalid dataset")

    # encode labels
    le = LabelEncoder()
    le.fit(list(set(y_train)))
    y_train = le.transform(y_train)
    y_test = le.transform(y_test)
    n_classes = len(list(le.classes_))

    # define a proper pipeline
    if PRETRAINED_MODEL == 'facebook/bart-large-mnli':
        sentiment_pipeline = pipeline("zero-shot-classification", model=PRETRAINED_MODEL)
    else:
        sentiment_pipeline = pipeline("sentiment-analysis", model=PRETRAINED_MODEL)

    y_pred = []
    for x in tqdm(X_test):
        if PRETRAINED_MODEL == 'facebook/bart-large-mnli':
            # Use the zero-shot pipeline to predict positive/negative
            result = sentiment_pipeline(x, candidate_labels=["positive", "negative"])
            label = result['labels'][0] 
            y_pred.append(LABELS_MAPPING[PRETRAINED_MODEL][label])
        else:
            # Standard sentiment analysis for other models
            label = sentiment_pipeline(x)[0]['label']
            y_pred.append(LABELS_MAPPING[PRETRAINED_MODEL][label])

    y_pred = le.transform(y_pred)
    print(f'\nDataset: {DATASET}\nPre-Trained model: {PRETRAINED_MODEL}\nTest set evaluation\n{get_metrics_report([y_test], [y_pred])}')
