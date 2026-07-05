---
name: explain-this
description: Explain a concept, term, mechanism, system, code idea, vulnerability, workflow, or technical/non-technical topic using a clear What-Why-How framework. Use when the user asks to explain, clarify, break down, understand, teach, summarize for learning, or make sense of something.
---

# Explain This

## Core Shape

Use the What-Why-How framework as the default explanation shape:

1. **What**: Define the concept plainly. Say what it is, what it is not, and the key terms needed to discuss it accurately.
2. **Why**: Explain why it matters. Connect it to the problem it solves, the tradeoff it addresses, or the real-world situation where it appears.
3. **How**: Explain how it works. Break the mechanism, workflow, reasoning, or execution path into understandable steps.

Keep the framework visible unless the user asks for a different format.

## Response Pattern

Prefer this structure:

```md
## What
<Plain definition and boundaries.>

## Why
<Why it matters, what problem it solves, and where it appears.>

## How
<Step-by-step mechanism, process, or reasoning.>

## Example
<Concrete example, analogy, code path, scenario, or mini case.>

## Common Misunderstandings
<Correct the most likely wrong assumptions, if useful.>

## TL;DR
<One short summary.>
```

Omit optional sections when the answer should be short. For a quick user question, a compact What/Why/How plus one example is enough.

## Depth And Tone

Adapt depth to the user's wording:

- For "simply", "beginner", or "ELI5": use short sentences, everyday analogies, and minimal jargon.
- For "in detail", "deep dive", or "technical": include internals, edge cases, tradeoffs, and precise terminology.
- For code: explain execution flow, data flow, inputs/outputs, and why the code is structured that way.
- For security: include attacker goals, defender concerns, abuse cases, mitigations, and detection ideas when relevant.
- For ambiguous topics: state the most likely interpretation first, then briefly mention alternate meanings.

Start with intuition, then add precision. Avoid simplifying so much that the explanation becomes false.

## Explanation Rules

- Preserve factual accuracy over neatness of the framework.
- Use examples whenever they make the concept less abstract.
- Define specialized terms before relying on them.
- Prefer concrete mechanisms over vague claims such as "it optimizes performance" or "it improves security."
- Mention assumptions when the answer depends on a domain, implementation, or context.
- Do not pad with a long conclusion; keep the TL;DR genuinely short.

## Useful Framing Moves

- Contrast with nearby concepts when confusion is likely: "X is not Y; X does..."
- Use a tiny scenario when the topic is abstract: "Imagine a request enters a server..."
- For mechanisms, number the steps in the How section.
- For tradeoffs, name both the benefit and the cost.
- For math, algorithms, protocols, and systems, explain the invariant or goal before the procedure.
