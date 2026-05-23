---
description: Read paper and create a note in Obsidian
agent: build
---

## Task

Make a academic document of the paper highlight direct important quotes and ideas. Be in depth, make no use of bullet points, add direct quotes from the text. Explain this paper to me in depth using the Feynman technique, as if you were its author.

Summarize each section in the paper first (section by section, so the outline will be the same as the original paper to give reader an overview of the whole paper), then add other in depth notes/ideas at the end. Include every technical detail in each section!

Also, add a header called "Podcast Intro" and get the audio file from the child item from the same Zotero paper item. Then, fill the following pattern to the note. I already add the symlink of Zotero storage to the vault, so you can use the path inside the Obsidian vault.

```
![[/path/to/the/audio/file]]
```

## Podcast Audio Generation

If there's no audio item inside the paper item in Zotero, you should ask me if I want a podcast for this paper. If the answer is positive, you can generate it on your own. You can use "notebooklm" skill to interact with Google NotebookLM. To generate the podcast about this paper, you need to do the following step by step.

1. Create a new notebook with the paper title
2. Upload the paper to it
3. Get the podcast with prompts
    - Here, you need to give me some possible choices to let me choose the instructions about the podcast style
    - Also, provide a default option with no extra instruction given
4. Put the audio file to "~/Downloads/" and I'll add it to Zotero and fill the path in the note on my own

## Outline Pattern

The whole note should look like this:

- Citation
- TL;DR
- Podcast Intro
- Section-by-Section Summary
    - Abstract (full text translation)
    - other
    - secitons
    - go
    - here
- Feynman Explanation
- Peer Review (giving critical evaluation as an expert)
- In-Depth Notes
- Important Assets To Capture (optional)
- Overall Takeaway

## Filename & File path

You should create a high quality notes in "Literature Notes" folder in Obsidian with the filename as the citekey in Zotero, and give it an alias with the title of the paper (but use the citekey as the title as well). So it will be like this:

```yml
aliases:
    - "Z3: An Efficient SMT Solver"
```

Also, you should insert the note with a template called "Literature Notes" in Obsidian.

## Target paper

"$1". You can find it in Zotero.

## Format

The output format should be in markdown. I want it to be sectioned report with citation of the original paper, so that I can quickly check the section and the sentence that support your analysis.

## Rules & Notes

- In Traditional Chinese
- Use Obsidian CLI to interact with Obsidian (`Obsidian --help`)
- Cover entire paper content
- Include both critical evaluation and explanatory breakdowns in "Peer Review"
- Full text translation of the abstract part
- Don't use the quotation mark for quotes, just use markdown `>` syntax
- Don't use "\`" for emphasis, use "\*\*"
- Only add "paper-notes" and "literature-notes" to the tags in metadata, I'll add others in Obsidian on my own
- You should add the zotero link to the "sources" field in the front matter.
- Only keep the title in the metadata, instead of in the content (since that way Obsidian will parse it twice)
- Latex & footnotes are supported
- If there are any assets you think are important, include them in the note
    - Code snippets
    - Tables (if the table is too complex to create in markdown, you should point out the table position and I'll take a screenshot of it)
    - Etc
- If there are any charts/diagrams/images that you think are important, mention them in the note and I'll screen shot them and add them to the note
    - Include the pages, sections so I can find it easier
- Write the note like a professional reseacher's article, instead of the output of the chat
- **After finishing the article, read the whole article again and make sure is coherent, fluent, and professional**
- When all things done, use Obsidian CLI to open the note in Obsidian's **new tab** and I'll review it
