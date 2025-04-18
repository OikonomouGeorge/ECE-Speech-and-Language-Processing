import os
import warnings
import numpy as np
import torch
import matplotlib.pyplot as plt

from sklearn.exceptions import UndefinedMetricWarning
from sklearn.preprocessing import LabelEncoder
from torch.utils.data import DataLoader
from torch.nn.utils.rnn import pad_sequence
from sklearn.metrics import accuracy_score, f1_score, recall_score
from config import EMB_PATH
from dataloading import SentenceDataset
from models import BaselineDNN, LSTM
from attention import SimpleSelfAttentionModel, MultiHeadAttentionModel, TransformerEncoderModel
from early_stopper import EarlyStopper
from training import train_dataset, eval_dataset, torch_train_val_split
from utils.load_datasets import load_MR, load_Semeval2017A
from utils.load_embeddings import load_word_vectors

warnings.filterwarnings("ignore", category=UndefinedMetricWarning)

########################################################
# Configuration
########################################################

# 1 - point to the pretrained embeddings file (must be in /embeddings folder)
EMBEDDINGS = os.path.join(EMB_PATH, "glove.twitter.27B.50d.txt")

# 2 - set the correct dimensionality of the embeddings
EMB_DIM = 50
EMB_TRAINABLE = False
BATCH_SIZE = 128
EPOCHS = 150
DATASET = "Semeval2017A" # options: "MR", "Semeval2017A"

DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")

########################################################
# Define PyTorch datasets and dataloaders
########################################################

# load word embeddings
print("loading word embeddings...")
word2idx, idx2word, embeddings = load_word_vectors(EMBEDDINGS, EMB_DIM)

# load the raw data
if DATASET == "Semeval2017A":
    X_train, y_train, X_test, y_test = load_Semeval2017A()
elif DATASET == "MR":
    X_train, y_train, X_test, y_test = load_MR()
else:
    raise ValueError("Invalid dataset")

########################################################
# EX1
########################################################

label_encoder = LabelEncoder()

label_encoder.fit(y_train) # fit the encoder on the training labels

# convert data labels from strings to integers
y_train = label_encoder.transform(y_train) 	# EX1
y_test = label_encoder.transform(y_test) 	# EX1
n_classes = label_encoder.classes_.size 	# EX1 

# print("############## EX1 #", DATASET, "##############\n")
# for i in y_train[0:10]:
# 	print(label_encoder.classes_[i], i)
# print()

########################################################
# EX2
########################################################

# import nltk
# nltk.download('punkt')

# Define our PyTorch-based Dataset
train_set = SentenceDataset(X_train, y_train, word2idx)
test_set = SentenceDataset(X_test, y_test, word2idx)

# print("############## EX2 #", DATASET, "##############\n")
# print(train_set.tokenized_data[:10],"\n")

########################################################
# EX3
########################################################

# print("############## EX3 #", DATASET, "##############\n")

# for i in range(5):
#        original_sentence = X_train[i]
#        tokenized_sentence, label, length = train_set[i]
#        print(f"Original Sentence: {original_sentence}")
#        print(f"Tokenized Sentence: {tokenized_sentence}")
#        print(f"Label: {label}")
#        print(f"Length: {length}\n")

########################################################
# EX7
########################################################

# Define our PyTorch-based DataLoader
# train_loader = DataLoader(train_set, batch_size=BATCH_SIZE, shuffle=True) # REMOVED FOR MAIN LAB QUERIES
# test_loader = DataLoader(test_set, batch_size=BATCH_SIZE, shuffle=True)   # REMOVED FOR MAIN LAB QUERIES


train_loader, test_loader = torch_train_val_split(train_set, BATCH_SIZE, BATCH_SIZE)

#############################################################################
# Model Definition (Model, Loss Function, Optimizer)
#############################################################################

# model = BaselineDNN(output_size=n_classes, embeddings=embeddings, trainable_emb=EMB_TRAINABLE)
# model = LSTM(output_size=n_classes, embeddings=embeddings, trainable_emb=EMB_TRAINABLE, bidirectional=False)
# model = LSTM(output_size=n_classes, embeddings=embeddings, trainable_emb=EMB_TRAINABLE, bidirectional=True)
# model = SimpleSelfAttentionModel(output_size=n_classes, embeddings=embeddings)
# model = MultiHeadAttentionModel(output_size=n_classes, embeddings=embeddings)
model = TransformerEncoderModel(output_size=n_classes,embeddings=embeddings)

# move the mode weight to cpu or gpu
model.to(DEVICE)
print(model)

# We optimize ONLY those parameters that are trainable (p.requires_grad==True)
if (n_classes == 2):
    criterion = torch.nn.BCEWithLogitsLoss() # EX8
else:
    criterion = torch.nn.CrossEntropyLoss() # EX8

parameters = filter(lambda p: p.requires_grad, model.parameters())
optimizer = torch.optim.Adam(parameters, lr=0.001)

#############################################################################
# Training Pipeline
#############################################################################

train_loss_all = []
test_loss_all = []

# added code for main project queries 
save_path = f'{DATASET}_{model.__class__.__name__}.pth'
early_stopper = EarlyStopper(model, save_path, patience=5) 

for epoch in range(1, EPOCHS + 1):
    # train the model for one epoch
    train_dataset(epoch, train_loader, model, criterion, optimizer, DATASET)

    # evaluate the performance of the model
    # default: y_train_gold, y_train_pred
    # correct: y_train_pred, y_train_gold
    train_loss, (y_train_pred, y_train_gold) = eval_dataset(train_loader,
                                                            model,
                                                            criterion,
                                                            DATASET)
    # default: y_test_gold, y_test_pred
    # correct: y_test_pred, y_test_gold
    test_loss, (y_test_pred, y_test_gold) = eval_dataset(test_loader,
                                                         model,
                                                         criterion,
                                                         DATASET)
    
    train_loss_all.append(train_loss)
    test_loss_all.append(test_loss) 

    y_train_true = np.concatenate(y_train_gold, axis=0)
    y_test_true = np.concatenate(y_test_gold, axis=0)
    y_train_pred = np.concatenate(y_train_pred, axis=0)
    y_test_pred = np.concatenate(y_test_pred, axis=0)

    print(f"\nEpoch {epoch}")
    print("Train loss:" , train_loss)
    print("Test loss:", test_loss)
    print("Train accuracy:" , accuracy_score(y_train_true, y_train_pred))
    print("Test accuracy:" , accuracy_score(y_test_true, y_test_pred))
    print("Train F1 score:", f1_score(y_train_true, y_train_pred, average='macro'))
    print("Test F1 score:", f1_score(y_test_true, y_test_pred, average='macro'))
    print("Train Recall:", recall_score(y_train_true, y_train_pred, average='macro'))
    print("Test Recall:", recall_score(y_test_true, y_test_pred, average='macro'))

    if early_stopper.early_stop(test_loss):
        print('Early stopping was activated.')
        print(f'Epoch {epoch}/{EPOCHS}, Loss at training set: {train_loss}\n\tLoss at validation set: {test_loss}')
        print('Training has been completed.\n')
        break

plt.plot(range(1, len(train_loss_all) + 1), train_loss_all, label='Training Loss')
plt.plot(range(1, len(test_loss_all) + 1), test_loss_all, label='Test Loss')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.title('Training and Test Loss')
plt.legend()
plt.show()
