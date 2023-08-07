Two Types of large language models (LLMS)

1 - Base LLM
    - Predicts next word, based on text training data
    - Based on what encounters on the internet.

**Response Examples**

Promtp : Once upon a time, there was a unicorn
Response : that lived in a magical forest with all her unicorn friends

Promt : What is the capital of France?
Response : What is France's largest City?
           What is France's population?

2 - Instruction Tuned LLM
    - Starts as a Base LLM trained with a huge amount of text data
    - Further training with inputs and outputs that are instructions and goods attempts to follow those instructions
    - Further refine with a technique called RLHF: Reinforcement learning with Human Feedbac

**Response examples**

Prompt : What is the capital of France?
Response : The capital of France is Paris
