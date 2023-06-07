import openai
import requests
from bs4 import BeautifulSoup
import sys

# NOT CURRENTLY CONFIGURED WITH CEOGPT V3

# Replace with your OpenAI API key
OPENAI_API_KEY = "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"
openai.api_key = OPENAI_API_KEY

# # Extract main content from URL
# def extract_content(url):
#     article = Article(url)
#     article.download()
#     article.parse()
#     return article.text
# Extract main content from URL

# def extract_content(url):
#     headers = {
#         "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.3"
#     }
#     response = requests.get(url, headers=headers)
#
#     soup = BeautifulSoup(response.content, "html.parser")
#     main_content = soup.find("div", {"class": "abstract-content"})
#     print(f"Fetched URL: {url}")
#     print(f"Extracted content:\n{main_content.get_text(strip=True)}\n")
#     return main_content.get_text(strip=True)

def extract_content(url):
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.3"
    }
    response = requests.get(url, headers=headers)

    soup = BeautifulSoup(response.content, "html.parser")
    main_content = soup.find("div", {"class": "abstract-content"}) or soup.find("article") or soup.find_all("p")

    if isinstance(main_content, list):
        text = " ".join([p.get_text(strip=True) for p in main_content])
    else:
        text = main_content.get_text(strip=True)

    print(f"Fetched URL: {url}")
    print(f"Extracted content:\n{text}\n")
    return text

# Split text into smaller chunks
def split_text(text, max_size):
    words = text.split()
    chunks = []
    current_chunk = []

    for word in words:
        if len(" ".join(current_chunk + [word])) <= max_size:
            current_chunk.append(word)
        else:
            chunks.append(" ".join(current_chunk))
            current_chunk = [word]

    if current_chunk:
        chunks.append(" ".join(current_chunk))

    for idx, chunk in enumerate(chunks, start=1):
        print(f"Text chunk {idx}:\n{chunk}\n")

    return chunks

# Summarize text using GPT-3
def summarize_text(text):
    prompt = f"Please summarize the following text:\n\n{text}\n\nSummary:"
    response = openai.Completion.create(
        engine="text-davinci-003",
        prompt=prompt,
        max_tokens=500,
        n=1,
        stop=None,
        temperature=0.7,
    )
    summary = response.choices[0].text.strip()
    print(f"Input text:\n{text}\n")
    print(f"GPT-3 prompt:\n{prompt}\n")
    print(f"Generated summary:\n{summary}\n")
    return summary

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 summarize_url.py <url>")
        sys.exit(1)

    url = sys.argv[1]
    content = extract_content(url)
    chunks = split_text(content, 1900)

    summarized_chunks = []
    for chunk in chunks:
        summary = summarize_text(chunk)
        summarized_chunks.append(summary)

    final_summary = " ".join(summarized_chunks)
    print(f"Number of summarized chunks: {len(summarized_chunks)}")
    print("Final summarized content:")
    print(final_summary)

