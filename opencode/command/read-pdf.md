---
description: Read a PDF in the current directory and create a note in Obsidian
agent: build
---

## Task

Read the PDF file "$1", then create a high-quality academic-style note in Obsidian.

The note should deeply explain the document, directly highlight important quotes, and extract the key ideas in a way that helps serious study and later reference. Write in an in-depth expository style, with no bullet points unless absolutely necessary for preserving the original structure of the source. Include direct quotes from the document wherever they are especially important, and explain the material using the Feynman technique, as if you were the author trying to teach an attentive reader from first principles.

You should create the note in the "Fleeting Notes" folder in Obsidian. The filename should be based on the PDF title or document title, with `:` replaced by `-`. For example, `aaa: bbb ccc ddd` should become `aaa - bbb ccc ddd`.

Also, insert the note using the template called "Fleeting Notes" in Obsidian.

## Target document

The target file is "$1".

## Format

The output format should be markdown.

The note should be written as a sectioned report with citations to the original document, so I can quickly verify which section, page, or sentence supports your analysis.

If the document has clear section divisions, summarize it section by section first, preserving the original structure as much as possible so the overview matches the source. If the document is a slide deck, presentation, or another format without standard paper sections, organize the note according to the document’s actual flow, such as slide order, chapter order, or thematic blocks.

After the structured summary, add a separate in-depth analysis section at the end for deeper ideas, implications, critiques, conceptual clarifications, and connections across the document.

## Rules & Notes

- Write in Traditional Chinese
- Cover the entire document content
- In metadata, only add the tags "fleeting-notes"
- Do NOT add items to "sources" in the metadata of the note in Obsidian
    - Only keep whatever is already present in the template originally
- Only keep the title in the metadata, instead of repeating the title again in the content
- LaTeX and footnotes are supported
- If there are any code snippets you think are important, include them in the note
- If there are any charts, diagrams, images, or slides that are important, mention them in the note and specify their page numbers, slide numbers, or section locations so I can find them easily and add screenshots myself
- When quoting directly, prefer short but important excerpts, and explain why they matter
- Be precise about where each claim comes from by referencing page numbers, section titles, or slide numbers whenever possible
- Write the note like a professional reseacher's article, instead of the output of the chat
- **After finishing the article, read the whole article again and make sure is coherent, fluent, and professional**
