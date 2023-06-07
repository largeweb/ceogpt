import openai
import requests
import sys
import random
from bs4 import BeautifulSoup

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

    return text

def summarize_text(text, max_words=2000):
    # Trim the input text if it's too long
    words = text.split()
    if len(words) > max_words:
        words = words[:max_words]
        text = " ".join(words)

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
    return summary

def trim_summary(summary, max_words):
    words = summary.split()
    if len(words) > max_words:
        words = words[:max_words]
        trimmed_summary = " ".join(words)
        return trimmed_summary
    else:
        return summary

def main(links):
    openai.api_key = "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"
    summaries = []

    for link in links:
        try:
            content = extract_content(link)
            summary = summarize_text(content)
            summaries.append(summary)
        except Exception as e:
            print(f"Error processing link {link}: {e}", file=sys.stderr)

    final_summary = " ".join(summaries)
    trimmed_summary = trim_summary(final_summary, 2000)
    return trimmed_summary

if __name__ == "__main__":
    links = sys.argv[1:]
    print(main(links))

