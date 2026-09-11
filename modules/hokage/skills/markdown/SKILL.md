---
name: markdown
description: Use when the user asks for a Markdown report of implemented changes that can be pasted into an issue tracker.
---

# Markdown Implementation Report

Give the user a proper Markdown text reporting the things that were implemented so they can use it in an issue tracker.

Write a concise, self-contained report based on the completed work. Include relevant implementation details, affected behavior, and verification performed. Use clear headings, lists, fenced code blocks, inline code, links, tables, and other Markdown formatting whenever they improve readability. Do not include conversational introductions, closing remarks, or claims that are not supported by the work.

Return the complete report as raw Markdown inside a single fenced code block so it can be copied directly from the OpenCode view. Do not put any report text outside that block. If the report contains fenced code blocks, use an outer fence with more backticks than any fence inside the report.
