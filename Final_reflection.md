## Reflection (10%)
rubric={raw:10}

In this section, you should (as a group) critique your dashboard and point out what it does well, what its limitations are, and what are good future improvements and additions. 
In this section, you should also **clearly document** how you addressed the feedback (GitHub issues) you received from your peers and the TAs.
Point form is fine, but they need to be full sentences.
This section should not be more than 500 words.
The `reflection.md` should live in your GitHub.com repo.
This file should be worked on collaboratively and each team member should submit a link to the same file.


After going through peer and TA reviews it appears that our R app is mostly effective and easy to use. Some of the issues from the previous reflection remain unresolved, such as the speed of the app. The performance worsened compared to Altair. The problem seems to be caused by our map plot. To form a map it has to plot every single data point based on latitude and longitude, which takes a lot of processing time. Altair seems to do a better job in handling such a massive amount of data. And because of that we also had some issues deploying the app. One of the biggest issues is lack of district population data; without it our app still struggles to answer some of the research questions. The solution for this issue is beyond our control.

As for improvements, we changed our default settings for both Python and R. It's easier to navigate and more intuitive. We also paid more attention to the design and layout of the R app compared to Python. The app layout was chosen based on the feedback from peers and seems to be more effective than the one we had before. We improved the by implementing new color schemes. We did research as well on color trends for 2019; that contributed to our bold choice of bright colors. For the Python version of the app, we also condensed the text introduction to encourage people to read it.
Overall the app is effective and relatively easy to use. Issues with speed still require future modifications.  