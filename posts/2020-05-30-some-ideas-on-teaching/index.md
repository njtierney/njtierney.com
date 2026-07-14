---
title: Some ideas on teaching
date: '2020-05-30'
slug: teaching-ideas
categories:
- blag
- teaching
- rstats
aliases:
  - /post/2020/05/30/teaching-ideas/
---


On July 31, 2018, I presented a talk at the SSA Victoria branch called: ["Rethinking teaching statistical computing: Understanding how learning works means we need to rethink how we teach."](https://njt-rethink-stat.netlify.app/#1). The abstract for the talk was:

> Researchers, analysts, and statisticians need to perform analyses, and this (usually) means that they need to learn how to code. They are, however, often not taught how to code. So how do they start? This talk discusses evidence based principles on teaching from the book: "How Learning Works", and how they can be applied to teach statistical computing. The talk is based off of Nick's experience going through Software Carpentries Trainer Training curriculum, and his experience learning and teaching R over the past 5 years.

# Writing is hard, and putting content somewhere is better than nowhere.

Ever since UseR!2018 in Brisbane, [seeing Roger Peng's keynote, "From tapply to tidyverse](https://www.youtube.com/watch?v=5033jBHFiHE) and the [accompanying blog post](https://simplystatistics.org/2018/07/12/use-r-keynote-2018/), I have always had ambitions to write a blog post that summarises my thoughts of a talk that I give. Unfortunately, I haven't ever managed to do this.

So, since writing this blog post it has been nearly ... two years since I gave the talk at SSA, I figured it is better to get something out, rather than nothing. Also, [Garrick Aden-Buie](https://garrickadenbuie.com/) gave me a friendly push in the right direction to get this post out.

# Learning to teach

In 2015 I helped contribute some teaching material to SEB113, the mandatory introductory statistics subject for science students at [QUT](https://www.qut.edu.au/). I worked closely with [Sam Clifford](https://www.samclifford.info/), to create teaching material in video form, which was shared with students as an R markdown document.  From 2015 onwards, I've had a great opportunity to undertake training with [The Carpentries](https://carpentries.org/) as an Instructor Trainer by [Karen Word](https://github.com/karenword), where we read through the fantastic book, [How Learning Works: Seven Research-Based Principles for Smart Teaching](https://www.wiley.com/en-au/How+Learning+Works%3A+Seven+Research+Based+Principles+for+Smart+Teaching-p-9780470484104). As well as taking [RStudio](http://rstudio.org/)'s Teach the Tidyverse in 2018. 

My point is, I feel very lucky to have received some amazing education from inspiring folks like [Karen Word](https://github.com/karenword), [Garret Grolemund](https://scholar.google.com/citations?user=wgdI_m4AAAAJ&hl=en), and [Sam Clifford](https://www.samclifford.info/). Over the years, I've taken a bunch of notes from these times. I had great ambitions of writing up all these notes into something super coherent and well put together.

Instead it's been in my drafts folder since 2018-08-01. So, here's something a bit more scrappy, but hopefully useful. 

Reading over these notes reminds of how much I can improve my own teaching. There are so many ideas where I'm like: 

> Yes, 100% I will do that

And then it ends up being something I don't do, because it's hard, or it takes more time, or I find myself running out of time. For me, these are things like getting students to do more exercises throughout class, and providing frequent opportunities for feedback, and incorating peer review into class.

Also full disclosure, I was making these notes for myself, and in the process might have copied a bit closely from slides or texts. It has been so long since I've collected these notes, that I can't actually remember where they came from. I just figured I'd rather get this content out there - but keep in mind that it's __most likely__ from one of these sources:

- [Karen Word](https://github.com/karenword)
- [How Learning Works: Seven Research-Based Principles for Smart Teaching](https://www.wiley.com/en-au/How+Learning+Works%3A+Seven+Research+Based+Principles+for+Smart+Teaching-p-9780470484104).
- [Garret Grolemund](https://rstudio.com/speakers/garrett-grolemund/) / [rstudio education](https://education.rstudio.com/)

# Some notes on teaching I've collected

Course climate: 

- Resist a Single Right Answer (setup the tower of babel approach)
- Get students talking to each other within the first 5 minutes of class
- Watch dismissive language
- Make Uncertainty Safe

Understanding Learning:

- Explain Growth and fixed mindsets for learning
- Reframe success and failure into opportunities for growth

Practical approaches:

- Provide Early Success Opportunities (e.g., teach visualisation first)
- Intersperse each 5-10 minutes of demo / lecture with 1-10 minutes of exercises
- Use live coding

Getting Feedback:

  - Balance Strengths and Weaknesses in Your Feedback
  - Design Frequent Opportunities to Give Feedback
  - Incorporate Peer Feedback
  
Key points for teaching:

- Live Coding
- Creating a good course climate:
    - Set the tone at the start
    - Balance Strengths and Weaknesses in Your Feedback
    - Dismissive Language
    - Model Inclusive Language, Behaviour, and Attitudes
      - avoid: "guys"
      - use: "everyone", "folks", "people", "y'all", "peeps"
      - avoid: "he or she", "him or her"
      - use: "they" 
    
Three key points for R content:

- Teach the tidyverse
- Teach visualisation first
- Teach rmarkdown document

- Explain practice: 
  - Describe Effective Study Strategies
  - Build in Multiple Opportunities for Practice
  - Show Students What You Do Not Want

# Some abbreviated notes of the seven principles from [How Learning Works](https://www.wiley.com/en-au/How+Learning+Works%3A+Seven+Research+Based+Principles+for+Smart+Teaching-p-9780470484104)

- 1: Students' prior knowledge can help or hinder learning.
    - Coming from another language (Python, Matlab, SPSS, STATA) (help + hinder)
    - Important to do some kind of assessment/test

- 2: How students organize knowledge influences how they learn and apply what they know.
    - Draw concept map of course topics and go from complex to atomic
    - Get students to draw their own concept map
    - Make connections amongst concepts explicit: always do more than you think you need
  
- 3: Students' motivation determines, directs, and sustains what they do to learn.
    - Provide early success opportunities (e.g., visualisation first)
    - Teach the different ways to explain success and failure
    - Teach effective strategies for study

- 4: To develop mastery, students must acquire component skills, practice integrating them, and know when to apply what they have learned.

  - Recognize that you have an expert blind sport and try very hard to put yourself in your student's shoes.
  - Identify weak or missing skills, and provide isolated practice of these.

- 5: Goal-directed practice coupled with targeted feedback enhances the quality of students' learning.
  - Use peer review
  - Demonstrate behaviour / output you do not want
  - Provide scaffolding in assignments
  - Provide many opportunities for practice
  - Design frequent opportunities to give feedback

- 6: Students' current level of development interacts with the social, emotional, and intellectual climate of the course to impact learning.

  - Establish course climate at day 1.
  - Make uncertainty a safe thing (like, make mistakes in front of students)
  - Resist the need to have a single right answer
  - Model Inclusive Language, Behaviour, and Attitudes
  - Set Up Processes to Get Feedback on the Climate
  - Facilitate Active Listening

- 7: To become self-directed learners, students must learn to monitor and adjust their approaches to learning.
  -   Use Peer Review/Reader Response
  -   Provide Opportunities for Self-Assessment
  -   Broaden Students' Understanding of Learning
  -   Scaffold Students in Their Metacognitive Processes

# Recommended resources from here

Read the book, ["How learning works"](https://www.wiley.com/en-au/How+Learning+Works%3A+Seven+Research+Based+Principles+for+Smart+Teaching-p-9780470484104) - even if you only skim through the start and end of each of the chapters, I guarantee you that you will learn something. I should read this again.

