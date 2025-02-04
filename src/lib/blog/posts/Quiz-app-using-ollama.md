---
title: Building a Quiz App with Python and Ollama Mistral
date: 2024-12-07
published: true
---

This blog demonstrates how to build a quiz app for children using Python and Ollama Mistral, with a focus on simplicity and usability. Let’s dive into the details!

#### Case Study

My nephew enjoys quiz games and often asks me to play with him. He wants questions in categories such as general knowledge or current affairs (history, geography, arts, sports), but manually preparing questions and verifying answers online is tedious.

To simplify this, I decided to create a quiz application that he can use independently. Here are the key goals for this app:

- The app should be extremely easy to use.

- The responses should be self-explanatory for children to navigate.

#### Tech Stack

For this project, I’ll primarily use:

- Python

- Ollama Mistral for language model integration

- Rich Library for terminal-based UI testing

- Pydantic for data validation

In the second phase, I plan to build the UI using Flask or FastHTML.

Step 1: Generating Quiz Questions

To generate trivia questions, we will prompt the language model for a specific category. The questions will relate to India to make the context relevant and engaging. Below is the function for generating questions:

```python
def generate_question(self, category):
    """Generate a question for the given category using Ollama"""
    prompt = f"""Generate a {category} trivia question related to India.
    Respond with only the question on one line, followed by the answer on the next line.
    Make it challenging and interesting."""
    
    print(prompt)
    try:
        response = requests.post('http://localhost:11434/api/generate',
                                 json={
                                     "model": "mistral",
                                     "prompt": prompt,
                                     "stream": False
                                 })
        response.raise_for_status()
        result = response.json()
        
        # Split the response into question and answer
        lines = result['response'].strip().split('\n')
        if len(lines) >= 2:
            question = lines[0].strip()
            answer = lines[1].strip().lower().replace('answer:', '').strip()
            return {"question": question, "answer": answer}
    except Exception as e:
        print(f"Error generating question: {e}")
        return None
```

Step 2: Checking Answers

To ensure children can get immediate feedback on their answers, I implemented a robust answer-matching logic using Python's SequenceMatcher. This approach handles variations in spelling and phrasing.

```python
def check_answer(self, user_answer, correct_answer):
    """Check the user's answer against the correct answer using robust matching"""
    player_answer = user_answer.lower().strip()
    correct_answer = correct_answer.lower().strip()

    # Direct match
    if player_answer == correct_answer:
        return True

    # Check similarity
    similarity = SequenceMatcher(None, player_answer, correct_answer).ratio()
    if similarity >= 0.8:
        return True

    # Check if the answer is a more specific version
    player_words = player_answer.split()
    correct_words = correct_answer.split()
    important_words = {word for word in correct_words if len(word) > 3}
    
    return important_words.issubset(player_words)
```

#### Testing the Application

For terminal-based testing, I am using Python's Rich library. It helps create a visually appealing CLI for the quiz app.
You can follow instructions from my github repo to run this in terminal and try it yourself.

In the next blog, I will demonstrate how to build a simple UI using Flask/FastHTML.

#### Conclusion

By combining the power of Python and Ollama Mistral, this quiz app can turn study time into an enjoyable and interactive experience for children. Stay tuned for the next part where we’ll add a user-friendly interface! You can take a look at the source code on [GitHub](https://github.com/summii/quizzie).