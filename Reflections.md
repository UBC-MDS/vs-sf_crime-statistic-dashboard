
## Reflection (10%)
rubric={raw:10}

In this section, you should (as a group) critique your dashboard and point out what it does well, what its limitations are, and what are good future improvements and additions. 
In this section, you should also **clearly document** how you addressed the feedback (GitHub issues) you received from your peers and the TAs.
Point form is fine, but they need to be full sentences.
This section should not be more than 500 words.



One of the main issues of this dashboard lies in the data we use for plotting; it lacks the population of a district. Hence, this fact leaves us with no ability to normalize the number of crime occurrences per population of a district as it would have been more insightful to show crimes per capita.
Another issue we'd encountered during the building of this app is its speed. The problem is primarily caused by the map plot. The way it works with our dataset is that every crime has location coordinates attached to it, Altair plots every data point individually and it appears as a map. Our dashboard wrangles data based on the user's selection and plots the Altair plot once again from scratch. The whole process takes time and it causes delays in between user's input and actual replotting the data.
Due to the lack of designers in our team, users can observe that overall showcasing of the app could have been better. The fonts and coloring needs significant improvement but in order to prevent this app from looking like an eyesore, we played it safe and left the design for future modifications.


For milestone three, we decided to make a few changes to our python app.

The first change we made is to shorten text of the app description. We choose to prioritize this because it is first easy to change and we realize that the previous description is unnecessarily long and not fundamental for the users to read in order to use the app.
[This is the link to description update issue](https://github.com/UBC-MDS/Victorious_Secret_DSCI_532/issues/40)

The second change is to add a plot title for the bottom two graphs. We choose to prioritize this because it is first easy to change and it really helps to clarify the graph. 
[This is the link to title issue](https://github.com/UBC-MDS/Victorious_Secret_DSCI_532/issues/42)

The third change we made is to change the font size of labels. Again we choose to do this because it can improve the interface of the app with little time commitment.
[This is the link to font issue](https://github.com/UBC-MDS/Victorious_Secret_DSCI_532/issues/41)


The fifth change is that we modularized our code. We chose to prioritize this because it is easier to debug and the code can be reused the code later if we choose because we keep different modules separate. Even though our current app is not very complex, modularizing our code improves readability.
[This is the link to the github issue for modulariztion update](https://github.com/UBC-MDS/Victorious_Secret_DSCI_532/issues/32)

The sixth change is that we added docstrings to our plotting functions. We choose to prioritize this because it would help future collaborators  understand what a function is doing. We consider it necessary as it can help someone who has not used dash before to understand our code.
[This is the link to the github issue for docstring update](https://github.com/UBC-MDS/Victorious_Secret_DSCI_532/issues/33)

Feedback received:
Generally there are two types of feedback. One type is regarding to the style of the graphs like changing the front size. The other type is relating to chaning the type of the plot, like change bar graph to a line graph.
[Link to a comprehensive list of advise](https://github.com/UBC-MDS/Victorious_Secret_DSCI_532/issues/39)


Reflection on feedback:
It appears that our app is mostly clear and easy to use. The only problem they encounter when using it is for the dash dropdown right below the description of the app. Beucase of its location, user are not sure which plot it controls. 
Multiple reviewers commented on our lack of a bold app heading. We included an app heading, but because it is not placed at the center of the app interface, users did not perceive this as a title since it looks like normal text.
Due to the time constraints, we decided to change the elements that are easy to fixes and improve the interface by making the plots more clear. This includes adding titles, changing font size and changing the app description.

We will explore changing plot types in the R iteration of this app since this change requires data wrangling, which is a big time commitment. Other suggestions are technically impossible to achieve since they are built into Altair like changing slider and drop down names. We will also attempt to incorporate layout suggestions in the DashR version of the app. 
