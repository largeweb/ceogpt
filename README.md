# CEOGPT - Business Automation Solution

CEOGPT is an innovative and adaptable business automation solution designed to streamline complex business processes. This open-source project supports a broad range of tasks including social media management, email marketing, content creation, sales and lead generation, customer support, and project management.

## Getting Started

These instructions provide a step-by-step guide to install and configure CEOGPT, tailoring it to your unique busniness needs:

### Step 1: Repository Cloning and Package Installation

Clone the CEOGPT repository to your local machine using the following command:

```bash
 git clone https://github.com/yourusername/ceogpt.git
```

Then, navigate to the project directory:

```
 cd ceogpt
```

Install the necessary packages with this command:

```
 npm install
```

### Step 2: Server Initialization

You can start the server by executing the following command:

```
 npm start
```

Upon successful startup, the server should be accessible at http://localhost:3333.

### Step 3: Personal Information Configuration in the .env file

Update the .env file with your personal details, such as API keys and other sensitive data. This step ensures the safe and secure storage of your credentials separate from the main application code.

```bash
 OPENAI_API_KEY=your_api_key_here
```

### Step 4: Action Modification

Removal of Actions:

If you wish to remove actions, simply delete the corresponding lines from the availableactions.txt file. Save the changes, and the actions will no longer be available.

Addition of Actions:

To incorporate new actions, follow these steps:

1. Update the availableactions.txt file with the description of the new action.
2. Include the intent of the new action to the intents.json file in the inference directory, following this JSON format:

```json
 {
   "tag": "researchx",
   "patterns": [ "Research a Topic", "Research about a given topic.", "The next action is to research about a search term.", "Next action: research.", "Research" ],
   "responses": [ "/path/to/your/action/script.sh" ]
 }
```

Here, the tag field is any unique identifier for the action. The patterns field contains phrases to train the neural net to recognize and trigger the corresponding action. The responses field should contain a single command, such as "/path/to/bash/script.sh" or "python3 /path/to/python/script.py", to execute the action script.

To retrain the neural net, use this command:
 cd inference
 python3 train.py

1. Implement the new action following the established format in the relevant code files. The action script should handle all arguments as the action input updated by ChatGPT will be variable in nature. These arguments can be parsed in Python, bash, or any other language that meets this requirement. Furthermore, the script should manage potential exceptions to ensure reliable execution.

2. Update the details.txt file within the action script to capture the action's result. The action script should completely overwrite this file. This step is vital and required, as details.txt plays a crucial role in the system.

## Using CEOGPT

Once the setup and configuration steps are complete, CEOGPT is ready to automate your business operations. Interact with the application through the provided user interface or API, and CEOGPT will handle your tasks with optimal efficiency.

We appreciate your interest in CEOGPT, and hope
