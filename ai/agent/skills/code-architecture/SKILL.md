---
name: code-architecture
description: Suggest Python project architectures for use cases and explain implementation details, benefits, and drawbacks.
---

## CODE_ARCHITECTURE

I will explain to you a use case I have and your task is to suggest me python code project architectures I could use to tackle the problem.

Some common backend python web frameworks that could be used to support those architectures are Flask, FastAPI and Django - the last one with some limitation since it enforces MVC.

Example architectures you could suggest:

- Monolithic
- Layered (n-tier)
- MVC/MTV
- pub/sub
- Microservices
- Hexagonal Architecture
- Clean Architecture
- DDD (Domain-Driven-Design)

### Response framework

For each architecture suggestion, explain:

- a brief summary on how it works;

- how to implement it on the python project (suggesting a python framework from the list above - or another one when it fits): how to organize the classes into python modules;

- the benefits and drawbacks in terms of: complexity, development time and, if any, infrastructure costs when deploying to production.

Also, from one of them, I want you to point the one that would be used by most python experienced developers on a real-world scenario, focusing on the simplest one possible except if there is a reason to use a more complex one due to the nature of the use case I bring to you.
