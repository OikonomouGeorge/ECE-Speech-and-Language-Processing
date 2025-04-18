import os
import warnings
import random

from sklearn.preprocessing import LabelEncoder
from torch.utils.data import DataLoader
from config import EMB_PATH
from training import train_dataset, eval_dataset
from utils.load_datasets import load_MR, load_Semeval2017A
from utils.load_embeddings import load_word_vectors

DATASET = "MR" # options: "MR", "Semeval2017A"

def load_dataset(DATASET):
    if DATASET == "Semeval2017A":
        X_train, y_train, _, _ = load_Semeval2017A()  # Only load training data
    elif DATASET == "MR":
        X_train, y_train, _, _ = load_MR()  # Only load training data
    else:
        raise ValueError("Invalid dataset")
    
    label_encoder = LabelEncoder()
    label_encoder.fit(y_train) 

    # convert data labels from strings to integers
    y_train = label_encoder.transform(y_train) 	
    n_classes = label_encoder.classes_.size 

    return X_train, y_train, n_classes

# Load the chosen dataset (only training data)
X_train, y_train, n_classes = load_dataset(DATASET)

# Organize by class
class_samples = {label: [] for label in range(n_classes)}

for x, y in zip(X_train, y_train):
    if len(class_samples[y]) < 20:
        class_samples[y].append(x)
    # Stop early if we already have 20 for each class
    if all(len(samples) == 20 for samples in class_samples.values()):
        break

# Combine all sentences from each class
all_samples = []
for label, samples in class_samples.items():
    for sentence in samples:
        all_samples.append((sentence, label))

# Shuffle them randomly
random.shuffle(all_samples)

# Save sentences and labels to separate files
with open("shuffled_sentences.txt", "w", encoding="utf-8") as f_sentences, \
     open("shuffled_labels.txt", "w", encoding="utf-8") as f_labels:
    for sentence, label in all_samples:
        f_sentences.write(sentence + "\n\n")
        f_labels.write(str(label) + "\n\n")

print("Shuffled sentences saved")