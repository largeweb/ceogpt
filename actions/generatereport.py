import openai
from fpdf import FPDF
import re
import fs

OPENAI_API_KEY = "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"
openai.api_key = OPENAI_API_KEY

def gpt3_generate_content(prompt):
    messages = [
        {
            "role": "system",
            "content": "You are an AI that generates content for a formal report about the current status of a company and recent advancements."
        },
        {
            "role": "user",
            "content": prompt
        }
    ]

    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=messages
    )

    content = response.choices[0].message.content.strip()
    return content

def read_file(file_path):
    with open(file_path, 'r') as file:
        content = file.read().strip()
    return content

def remove_special_characters(text):
    return re.sub(r"[^a-zA-Z0-9\s,.!?]+", "", text)

def generate_pdf_report():
    # Initialize FPDF instance
    pdf = FPDF('P', 'mm', 'A4')
    pdf.set_auto_page_break(auto=True, margin=15)
    pdf.add_page()

    action_input = read_file("/home/matt/projects/ceogpt3/prompts/actioninput.txt")
    action_input = remove_special_characters(action_input)

    # Set the title
    pdf.set_font("Arial", 'B', size=16)
    title_prompt = f"{action_input} Generate a title for a formal report about the current status of the company and recent advancements."
    title = gpt3_generate_content(title_prompt)
    pdf.cell(0, 10, txt=title, align='C', ln=1)

    # Executive Summary
    pdf.set_font("Arial", 'B', size=12)
    pdf.cell(0, 10, txt="Executive Summary", ln=1)
    pdf.set_font("Arial", size=10)
    executive_summary_prompt = f"{action_input} Generate an executive summary for a formal report about the current status of the company and recent advancements."
    executive_summary = gpt3_generate_content(executive_summary_prompt)
    pdf.multi_cell(0, 10, txt=executive_summary, align='L')

    # Section titles and prompts
    sections = [
        ("Introduction", read_file("/home/matt/projects/ceogpt3/prompts/initialprompt.txt")),
        ("Company Status and Recent Advancements", read_file("/home/matt/projects/ceogpt3/prompts/companystatus.txt")),
        ("CEO Insights", read_file("/home/matt/projects/ceogpt3/prompts/thinking.txt")),
        ("Investors and Stakeholders", read_file("/home/matt/projects/ceogpt3/prompts/details.txt")),
        ("Conclusion", read_file("/home/matt/projects/ceogpt3/prompts/endingprompt.txt")),
    ]

    for section_title, prompt in sections:
        pdf.add_page()
        pdf.set_font("Arial", 'B', size=12)
        pdf.cell(0, 10, txt=section_title, ln=1)
        pdf.set_font("Arial", size=10)
        prompt = remove_special_characters(prompt)
        content = gpt3_generate_content(f"{action_input} {prompt}")
        pdf.multi_cell(0, 10, txt=content, align='L')

    # Save the PDF file
    output_file = "/home/matt/projects/ceogpt3/generated_documents/report.pdf"
    pdf.output(output_file)
    print(f"PDF report saved to '{output_file}'")

if __name__ == "__main__":
    generate_pdf_report()
    file_path = "/home/matt/projects/ceogpt3/prompts/details.txt"
    content = "The report has been generated."
    with open(file_path, 'w') as file:
        file.write(content)