---
author: ["sidecus"]
title: Guide to Build Ai Agents
date: 2025-10-20T16:55:14+08:00
description: ""
tags: []
categories: ["Agentic AI"]
ShowToc: true
TocOpen: false
draft: true
---

01 Complex decision-making: 

Workflows involving nuanced judgment, exceptions, or 
context-sensitive decisions, for example refund approval 
in customer service workflows.

02 Difficult-to-maintain rules:

Systems that have become unwieldy due to extensive and 
intricate rulesets, making updates costly or error-prone, 
for example performing vendor security reviews. 

03 Heavy reliance on unstructured data:

Scenarios that involve interpreting natural language, 
extracting meaning from documents, or interacting with 
users conversationally, for example processing a home 
insurance claim.


Broadly speaking, agents need three types of tools:
Type Description Examples
Data Enable agents to retrieve context and 
information necessary for executing 
the workflow.
Query transaction databases or 
systems like CRMs, read PDF 
documents, or search the web.
Action Enable agents to interact with 
systems to take actions such as 
adding new information to 
databases, updating records, or 
sending messages.   
Send emails and texts, update a CRM 
record, hand-off a customer service 
ticket to a human.
Orchestration Agents themselves can serve as tools 
for other agents—see the Manager 
Pattern in the Orchestration section.
Refund agent, Research agent, 
Writing agent

[How to Build AI Agents](https://github.com/skolte/OpenAI-Building-Agents/blob/main/AI%20Agents%20OpenAI%20Paper.jpeg)
Diagram Credit: https://github.com/skolte/OpenAI-Building-Agents
