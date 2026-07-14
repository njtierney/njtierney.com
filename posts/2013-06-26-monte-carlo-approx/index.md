---
title: Monte Carlo Approximiation
date: "2013-06-26"
categories:
- Statistics
slug: monte-carlo-approx
aliases:
  - /post/2013/06/26/monte-carlo-approx/
---

There are a lot of explanations of Monte Carlo approximation out there.

Here is one that worked for me.

A famous mathematician named Stan Ulam liked solitaire.

He wanted to work out the probability of getting a perfect solitaire hand.

Being a mathematician, he also wanted to work this out analytically.

What does analytical mean? It's a fair question, as it's [wikipedia page](http://en.wikipedia.org/wiki/Analytic) shows that there are many definitions

<p style="text-align: center;"><strong>Wikipedia definition:</strong></p>
<p style="text-align: center;"><em>"Analytic Solution" </em></p>
<p style="text-align: center;"><em>- A solution to a problem that can be written in"closed form" in terms of known functions, constants, etc.</em></p>
<p style="text-align: left;">I find that such a definition relies on the reader knowing what the words 'closed form', 'known functions' and 'constants' are.</p>
<p style="text-align: center;">So here's <strong>my definition:</strong></p>
<p style="text-align: center;"><em>"Analytic Solution"</em></p>
<p style="text-align: center;"><em>A solution where everything needed to solve a particular question is presented clearly and logically, with all assumptions defined.
</em></p>
So, getting back on track...

When Stan Ulam said that he wanted to find the probability of getting a perfect solitaire hand, he was going to do some really complex probability equations using:
<ul>
	<li>The information about a deck of cards
<ul>
	<li>52 cards</li>
	<li>Number of red cards</li>
	<li>Number of black cards</li>
	<li>Number of different numbers...etc.</li>
</ul>
</li>
	<li>And a pen and paper</li>
	<li>(and maybe a calculator, but this was the 1940s so it is less likely. But then, he <em>was</em> a famous mathematician - it is more likely he would have had access to a computer) to arrive at a 'perfect solution'.</li>
</ul>
The analytic solution ends up looking really complicated, and is<em> quite</em> complex.

So instead of finding an analytical solution, he wanted to <em>approximate </em>a solution.

Basically you follow these steps,
<ol>
	<li>Shuffle and deal a hand of solitaire</li>
	<li>Is it a perfect hand?</li>
	<li>If no, add one to the total number of hands dealt, go back to step 1.</li>
	<li>If yes, add one to the number of successful hands AND total number of hands dealt, go back step 1</li>
	<li>Repeat steps 1-4 1000s of times.</li>
	<li>Divide the # successful hands / total # hands.</li>
	<li>You have now arrived at an approximate probability of getting a perfect hand in solitaire.</li>
</ol>
Crazy as it sounds, this probability gets closer to the 'true' probability you would have found, had you worked it out analytically.

The more trial simulations (iterations) you run, the better the answer.

Now imagine that instead of wanting to know the probability of getting a perfect hand, but
<ul>
	<li>Getting a red card first draw</li>
	<li>The ace of spades first draw</li>
	<li>TWO black cards...</li>
</ul>
Monte Carlo provides a simpler solution than the analytic method.I shall write another post extending on this one soon.

Let me know if what I wrote makes sense for you!

Reference: [MathematicalMonk's Youtube channel](http://www.youtube.com/watch?v=7TybpwBlcMk).
