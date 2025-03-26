import string

def prepare(text):
    text = text.lower()
    text = ''.join(char for char in text if char in string.ascii_lowercase + ' ');
    words = text.split() # Split
    return words

def to_lexicon(lexicon_file):
    lexicon = {}

    with open(lexicon_file, 'r') as file:
        for line in file:
            parts = line.strip().split()
            word = parts[0].lower()
            phonemes = ' '.join(parts[1:])
            lexicon[word] = phonemes

    return lexicon

def to_phonemes(sentence, lexicon):
    words = prepare(sentence)  
    phoneme_sentence = ['sil']  # Add sil

    for word in words:
        if word in lexicon:
            phoneme_sentence.append(lexicon[word])  
        else:
            phoneme_sentence.append('sil')  # Add sil

    phoneme_sentence.append('sil')  # Add sil
    return ' '.join(phoneme_sentence) 

def to_files(lexicon_file, input_file, output_file):
    lexicon = to_lexicon(lexicon_file)

    for subset in ['train', 'dev', 'test']:
        text_file = f'{input_file}/{subset}/text'
        output_file = f'{output_file}/{subset}/final_text'

        with open(text_file, 'r') as file:
            lines = file.readlines()

        with open(output_file, 'w') as output:
            for line in lines:
                utt_id, sentence = line.strip().split(' ', 1)
                phoneme_sentence = to_phonemes(sentence, lexicon)
                output.write(f'{utt_id} {phoneme_sentence}\n')

lexicon_file = '/home/zeno/kaldi/egs/project1/dataset/usc/lexicon.txt'
input_file = '/home/zeno/kaldi/egs/project1/data'  
output_file = '/home/zeno/kaldi/egs/project1/data'  

to_files(lexicon_file, input_file, output_file)
