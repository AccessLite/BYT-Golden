# BYT (**Bite Your Thumb**)

---

### Contents:
  1. [Intro](https://github.com/AccessLite/BYT-Golden#1-intro)
  2. [Motivation](https://github.com/AccessLite/BYT-Golden#2-motivation)
  3. [Techincal Considerations](https://github.com/AccessLite/BYT-Golden#3-technical-considerations)
  4. [Coding Goals, Principles, Technologies](https://github.com/AccessLite/BYT-Golden#4-coding-goals-principles--technologies)
  5. [Methodology](https://github.com/AccessLite/BYT-Golden#5-methodology)
  6. [Project Overview](https://github.com/AccessLite/BYT-Golden#6-project-overview)
  7. [Lessons Learned](https://github.com/AccessLite/BYT-Golden#7-lessons-learned)
  8. [Version 2.0](https://github.com/AccessLite/BYT-Golden#8-version-2)
  9. [Future Projects](https://github.com/AccessLite/BYT-Golden#9-future-projects)
  10. [Contact Us](https://github.com/AccessLite/BYT-Golden#10-contact-us)
  11. [Final Thanks](https://github.com/AccessLite/BYT-Golden#11-final-thanks)
  
---

## 1. Intro

#### What's in a Name?

My shortlived career as a stage performer came to a frothing crest in grade school when I played [Abram of House Montague](http://www.sparknotes.com/shakespeare/romeojuliet/characters.html). Of the 5 or so lines I was required to memorize, none were as monumetally impactful as:[**"Do you bite your thumb at us, sir?"**](http://nfs.sparknotes.com/romeojuliet/page_8.html). 

> "...thumb biting, which involves biting and then flicking one's thumb from behind the upper teeth, is a Shakespearean version of flipping someone the bird"
> \- [Shmoop.com](http://www.shmoop.com/romeo-and-juliet/thumb-biting-symbol.html) 

My young mind was delighted by an offensive gesture that could be used indiscriminately without fear (because no one knew what the hell it meant). Somehow the phrase/gesture has stuck with me some seventeen years later. When the project was determined to be an insult generator, I knew I wanted to honor my past thespian acheivement. And so, *BYT (Bite Your Thumb)* was chosen. 

## 2. Motivation

#### Louis (Tech Lead/Project Manager/Instructor/Thespian)

I had recently begun instructing an iOS development course for the Queens-based, non-profit *[Coalition for Queens](http://www.c4q.nyc/)*. During a staff curriculum meeting, we were discussing ways to increase engagement in the class. I knew there were students that wanted additional challenges outside of what was being provided in class and the course had not yet had a project-based lesson that mimicked real-world development. While we came to an agreement as to how to better develop the curriculum to keep the class engaged, I decided to go a bit further.

Primarily, I wanted to challenge interested students, but I also wanted to challenge myself in some way. What I ultimately decided on was to conduct an optional, extra-curricular project where I'd play the role of both Lead Dev and Project Manager.

Each week I'd provide specific code & design instructions, told from the unique perspective of a Lead and PM. Participating students were responsible for executing those instructions and submitting a pull request at the end of each week. I would review the PRs offering technical insights and stylistic advice, along with fixes to their code. If a student was able to submit the PR to spec (as determined by that week's instructions), they were invited to move on to the next week of development. 


---
## 3. Technical Considerations

The students were about 1/3 into their coursework and just started touching upon making RESTful API requests in Swift. Other than that, they had working knowledge of basic Swift syntax, types, control structures, delegation and closures. The scope of the project was significantly restricted by the student's current ability, which made it both easy and difficult to decide on a project: easy because there was a small pool of knowledge to draw from, difficult because the project's product would have to be tailored to highlight a few features. 

---
## 4. Coding Goals, Principles & Technologies
  - Entirely programmatic code base (with the exception of a single nib) 
  - *No 3rd party libraries*
  - Dynamic sizing and positioning via Autolayout 
  - Singletons for managing app-wide changes
  - Use of a "backend" by way of [Fieldbook](https://fieldbook.com/). 
  - App updates via changes to "backend" config files
  - Local persistance using `UserDefaults` & serialization
    - User-defined, app settings 
    - JSON config files downloaded from "backend" 
  - Simple and focused animations
  - Principles of material design
    - Fonts (weights, colors and sizing) 
    - Approach to layers
    - Color palettes & UI principles
  - Social media integration in order to share content
  - Generating screenshots with custom watermarks
  - Advanced usage of `NSAttributedString` and `CoreText` to style text. 
  - A `git flow`-styled repo organization and management system
  - Familiarity with daily standups via [Howdy](https://accesslite.slack.com/apps/A09RDP4AW-howdy) (a slack bot plugin)
  - Handling keyboard events and `Notifications`
  - Defensive programming in dealing with malformed backend data and slow internet connections
  - Basic network ptimizations
    - Minimizing calls through opportunistic requests

---
## 5. Methodology
  
The project began with 14 participating students on week 1 and ended with a core group of 4 *very* capapble developers. Each week was designed to take between 10-15 development hours so as to be done concurrently (and not interfere) with classwork. Students were instructed to prioritize classwork and that the project could not be worked on during class hours (10a-6p, M-F). 

Along the way students were taught some industry standards: 
  1. The difference in the role of a Lead and PM
  2. Working on a shared repo
  4. Issue and feature tracking via Trello
  5. Agile development through Scrum
 
---
## 6. Project Overview

#### 6.1) Week 1: Core App

The first week was defined by a very detailed outline from the "Lead" to implement the core code of the app. Students were provided specific class, function, and protocol nomenclature, along with explicit details what each should be responsible for. The "PM" notes provided a basic wireframe of the app along with minor details relating to UI & UX (mostly font details and app interactions) 

**Week 1 Links**
- [General Info](https://github.com/AccessLite/BoardingPass/tree/master/Week%201%20-%20MVP)
- [Tech Lead Notes](https://github.com/AccessLite/BoardingPass/blob/master/Week%201%20-%20MVP/Week1MVP_TechLeadInstructions.md)
- [Project Manager Notes](https://github.com/AccessLite/BoardingPass/blob/master/Week%201%20-%20MVP/Week1MVP_PMInstructions.md)

#### 6.2) Week 2: Problem Solving Refactor
With the participant pool dropping to 7, I decided to further challenge the remaining group by providing less detailed requirements in the Lead's notes. Instead of being explicitly told the classes and functions they would be making, they were instead told the functionality that was required. It was up to their discretion as to how to handle the specifics of the implementation.

The instructions for the week would narrow down their implementations in a somewhat controlled manner, while allowing for abiguity that would require some careful consideration/googling. The exception was `FoaasBuilder`, which was given somewhat explicit functionality via code scaffolding and documentation. 

**Week 2 Links**
- [General Info](https://github.com/AccessLite/BoardingPass/tree/master/Week%202%20-%20MVP)
- [Tech Lead Notes](https://github.com/AccessLite/BoardingPass/blob/master/Week%202%20-%20MVP/Week2MVP_TechLeadInstructions.md)
- [PM Notes](https://github.com/AccessLite/BoardingPass/blob/master/Week%202%20-%20MVP/Week2MVP_PMInstructions.md)

#### 6.3) Week 3.1: UI/UX meets Material Design 
*(Note: for a number of uninteresting reasons, week 3 actually spanned 2-3)*

After having developed the core functionality of the app, the UI/UX was re-evaluated. The design was overhauled to use many of Google's Material Design principles, including font styles, color schemes, and depth of layers. New app icon and launch screen assets were designed and incorporated. Additionally, dynamic resizing and repositioning was added to a number of UI elements. We also transitioned away from tradition iOS navbar design to a pared-down, gesture and button-based navigation. Animations were thrown in to provide clear visual feedback in response to user action. 

This cycle also introduced the API "backend" of the app. The backend provided JSON for two functions: to create a dynamic config that would be downloaded on launch and to store color schemes used in the app.

#### 6.4) Week 3.2: Once more with feeling

Week 3.2 shifted from individual projects into a single, shared repo for the remaining 4 students and myself. This merger was discussed and agreed upon for a few reasons: 

1. The number of participants remaining was a small enough that I'd be able to manage them as an actual development team. 
2. The participants themselves at this point had demonstrated their coding skills and ability to work independently, requiring far less direct oversight.  
3. I wanted to implement some moderately ambitious features that would take far to long if each developer was writing the entirety of the code base
4. Development is commonly done as a team, so the change would be a far more enriching experience. In this manner we could incorporate common industry practices such as peer reviews, a light version of `git flow`, and some aspects of agile development. 

#### 6.5) Week 3.3: Final Touches

*<This section is omitted by accident: I forgot to return to this and now I don't remember what should go here!!>*

**Week 3 Links**
- [General Info](https://github.com/AccessLite/BoardingPass/tree/master/Week%203%20-%20MVP)
- [Tech Lead Notes](https://github.com/AccessLite/BoardingPass/tree/master/Week%203%20-%20MVP/TechNotes)
- [PM Notes](https://github.com/AccessLite/BoardingPass/blob/master/Week%203%20-%20MVP/PM_Notes/README.md)

---
## 7. Lessons Learned 

#### 7.1) Louis (Lead, PM)
<*Carelessly forgets to add his own lessons learned*. There were many, you'll have to trust me!>

#### 7.2) Ana (Developer)

When I heard our instructor Louis was working on a side-project, I did not hesitate much and signed up to work on it. One reason was the lack of challenging projects during class. 

Passing the weekly evaluations while taking fulltime coding classes and working part-time was not easy because of the strict specs and timeline. I have gained valuable constructive feedback from Louis that gave me an opportunity to improve.

Building this app also encouraged me to think outside of the box and use unfamiliar frameworks. Overall, this project was well managed by Louis, and it gave me a great insight for future projects. 

#### 7.3) Tom (Developer)

The first couple months of the Access Code course were mostly about learning the fundamentals of coding, swift and Xcode, and we had just gotten to grips with making API requests. I was doing well with the course and wanted a project to work on in my own time to help sharpen the skills I had learned in class. Our instructor Louis announced that he was putting together an extra-curricular project that simulated real-world development, designed to push us further as developers, I volunteered to be a part of it.

Working in week long sprints, I learned to use Trello and how to break up a project into small tasks, helping me not to get overwhelmed by the thought of the whole project looming.
A lot of the tasks we were given had not been covered in the class so I had to become adept at googling for blogs, tutorials and stack overflow posts to find answers… I learned how to use simple animations, import a fonts into a project,  using attributed text and sharing to Facebook and Twitter.

At first we were working individually but as the the group became smaller we started working together and eventually merged our projects into one and started working on separate features. At this point we switched the project from using storybook layout to programmatic. I preferred working on one project as a team as it allowed us to implement more features and exposed us to working with each other’s code.

Moving forward with the app, I’d like to enable the user to create their own insult templates, share them with friends and to include more popular ones in newer versions of the app.

#### 7.4) Hari (Developer)

Working on Bite Your Thumb was truly my first taste of collaborative programming with a team of other developers. Despite being relatively new to iOS Development when this project started, BYT allowed me to feel fully immersed in a setting which mimicked many mobile engineering teams. The progression of our weekly sprints not only challenged us to continue to improve but also genuinely highlighted the concept of continuously learning. What originally started off as a challenge, eventually became a pivotal experience in the team practices of software development and as a result strengthened my ability to be a better project manager. I hope you all enjoy using the app as much as we did when putting it together!

#### 7.5) Liam (Developer)

We started this project at the same time that Louis was teaching our class about APIs and JSON reading. Louis pushed us beyond what he was teaching us in class, forcing me to dive directly into the Apple documentation and Google for answers to questions that we hadn't covered. Due to the cutoff nature of the project, I had to wade through the discomfort of no longer being guided through coding and teach myself how to read documentation and search through open source code on Stack OverFlow and Github for examples when I got stuck. As the weeks moved on and more people were cut form the project, we shifted gears from an individual project done in tendem to a more traditional team structure where we were all responsible for our own share. I learned how to communicate as a part of a tech team using tools such as Slack and Trello. This gave me a solid foundation when we later moved into our capstone projects and one of our highlights was our simple and clear communication. 

--- 
## 8. Version 2
- Features: ??
  
---

## 9. Future Projects

Currently, I am planning to conduct another project in the coming weeks. With the class completing their studies, it is possible to plan out a more interesting and ambitious project. The overall structure will likely need slight changes as the group transitions from a student-learner role into job seeker. 

---

## 10. Contact Us

*(See contributor for project to contact us)*

---

## 11. Final Thanks 

Thank you to everyone who has participated!!
