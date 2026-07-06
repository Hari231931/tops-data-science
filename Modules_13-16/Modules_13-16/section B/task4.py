from langchain_community.llms import Ollama
from langchain_classic.chains import ConversationChain
from langchain_classic.memory import ConversationBufferMemory
from langchain_classic.prompts import PromptTemplate

# 1. Load LLM
llm = Ollama(model="llama3.1")

# 2. Create memory
# memory_key MUST match {history} in prompt
memory = ConversationBufferMemory(memory_key="history")

# 3. System prompt template
template = """
You are a helpful food order assistant for QuickBite Food Delivery.

Rules:
- Remember the user's delivery address once they mention it.
- Remember the user's dietary preference once they mention it.
- Use the saved address and dietary preference in later answers.
- Help with food recommendations, delivery suggestions, and order-related questions.
- Be polite, short, and customer-friendly.

Conversation history:
{history}

User: {input}
QuickBite:
"""

prompt = PromptTemplate(
    input_variables=["history", "input"],
    template=template
)

# 4. Attach memory to ConversationChain
conversation = ConversationChain(
    llm=llm,
    memory=memory,
    prompt=prompt,
    verbose=False
)

turn_count = 0

# 5. Simulated conversation
simulated_inputs = [
    "My delivery address is 25 MG Road, Ahmedabad.",
    "I am vegetarian.",
    "Can you recommend something for dinner?",
    "Can you suggest something that fits my preference and can be delivered to my address?",
    "What is the benefit of drinking water before meals?",
    "exit"
]

for user_input in simulated_inputs:
    if user_input.lower() == "exit":
        print("\nExit command received.")
        print("Total number of turns:", turn_count)
        print("\nFull Memory Buffer:")
        print(memory.buffer)
        break

    response = conversation.predict(input=user_input)
    turn_count += 1

    print("User:", user_input)
    print("QuickBite:", response)
    print("-" * 60)