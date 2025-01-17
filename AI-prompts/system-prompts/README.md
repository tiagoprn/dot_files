# Notes

## Anthropic's Claude specific

- Claude projects can be used to give more context to it so I can e.g. create a full app of something that needs lots of files. More about them: <https://www.anthropic.com/news/projects>.
I can e.g. create one to create a python app, as described here: <https://simonwillison.net/2024/Dec/19/one-shot-python-tools/#writing-these-with-the-help-of-a-claude-project>. In summary, I can create a system prompt (or custom instructions on user prompt) to explain to LLMs how to implement patterns that do not exist yet on their training data.

- I can use `langchain` library on `python` to make use of LLMs.
Here is an example: <https://gist.github.com/christopherwoodall/a882b5db45e6a80a2fd8276e893c7de8> (see the "generate a script" section - it uses Ollama, but I could use claude or chatgpt.)
Here is langchain's documentation: <https://python.langchain.com/docs/introduction/>

- I can also export my Claude's account personal conversation and user data on the WebUI under my [Account Settings](https://claude.ai/settings/account).

