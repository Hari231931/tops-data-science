import streamlit as st
import requests

st.set_page_config(page_title="Dish Description Generator", page_icon="🍽️")

st.title("🍽️ LLM-Powered Dish Description Generator")

dish_name = st.text_input("Dish Name", placeholder="Paneer Tikka Masala")
cuisine_type = st.text_input("Cuisine Type", placeholder="North Indian")

description_length = st.selectbox(
    "Description Length",
    ["Short", "Medium", "Long"]
)

def generate_description(prompt):
    response = requests.post(
        "http://localhost:11434/api/generate",
        json={
            "model": "llama3.1  ",
            "prompt": prompt,
            "stream": False
        }
    )

    if response.status_code == 200:
        return response.json()["response"]
    else:
        return "Error: Unable to generate description."

if st.button("Generate Description") or st.button("Regenerate"):
    if not dish_name or not cuisine_type:
        st.error("Please enter both Dish Name and Cuisine Type.")
    else:
        prompt = f"""
You are a professional food menu copywriter.

Dish Name: {dish_name}
Cuisine Type: {cuisine_type}
Description Length: {description_length}

Write an appetising, customer-facing promotional description for this dish.
Make it sound delicious, attractive, and suitable for a food delivery menu.
Do not include extra headings.
"""

        print("Final Prompt Sent to LLM:")
        print(prompt)

        with st.spinner("Generating description…"):
            description = generate_description(prompt)

        with st.container(border=True):
            st.subheader("Generated Description")
            st.write(description)

        st.write(f"Character Count: {len(description)}")