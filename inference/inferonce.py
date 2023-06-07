import sys
import random
import json

import torch

from model import NeuralNet
from nltk_utils import bag_of_words, tokenize

def chatbot_response(sentence):
    sentence = tokenize(sentence)
    X = bag_of_words(sentence, all_words)
    X = X.reshape(1, X.shape[0])
    X = torch.from_numpy(X).to(device)

    output = model(X)
    _, predicted = torch.max(output, dim=1)

    tag = tags[predicted.item()]

    probs = torch.softmax(output, dim=1)
    prob = probs[0][predicted.item()]
    if prob.item() > 0.45:
        for intent in intents['intents']:
            if tag == intent["tag"]:
                return random.choice(intent['responses'])
    else:
        return "I do not understand..."

if __name__ == "__main__":
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

    # with open('intents.json', 'r') as json_data:
    with open('/home/matt/projects/ceogpt3/inference/intents.json', 'r') as json_data:
        intents = json.load(json_data)

    FILE = "/home/matt/projects/ceogpt3/inference/data.pth"
    data = torch.load(FILE)

    input_size = data["input_size"]
    hidden_size = data["hidden_size"]
    output_size = data["output_size"]
    all_words = data['all_words']
    tags = data['tags']
    model_state = data["model_state"]

    model = NeuralNet(input_size, hidden_size, output_size).to(device)
    model.load_state_dict(model_state)
    model.eval()

    if len(sys.argv) > 1:
        input_sentence = sys.argv[1]
        response = chatbot_response(input_sentence)
        print(response)
    else:
        print("Please provide a sentence as an argument.")
