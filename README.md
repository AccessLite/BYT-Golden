# BYT (**Bite Your Thumb**)

---

### Topics to add into `README`:

- Why BYT?
  - Origin/meaning of the name (found at [Shmoop](http://www.shmoop.com/romeo-and-juliet/thumb-biting-symbol.html) and [Urban Dictionary](http://www.urbandictionary.com/define.php?term=do%20you%20bite%20your%20thumb%20at%20us%20sir)
  - Significance of the phrase: "My shortlived career as a stage performer in grade school came to a frothing crest when I played [Abram of House Montague](http://www.sparknotes.com/shakespeare/romeojuliet/characters.html). Of the 5 or so lines I was required to memorize, none were as monumetally impressioning as was the one that read: [**"Do you bite your thumb at us, sir?"**](http://nfs.sparknotes.com/romeojuliet/page_8.html). My thirteen year old mind was delighted by now knowing a "curse word" that I could use indiscriminately without fear (because no one knew what the hell it meant). Somehow the phrase has stuck with me some seventeen years later. When the project was determined to be an insult generator, I knew I wanted to honor my past thespian acheivements. And so, *BYT (Bite Your Thumb)* was born. 
- Motivation
  - Intro from Louis: "I had recently begun instructing a iOS development course for a Queens-based non-profit, Coalition 4 Queens. The students were half-way into their semester and just started touching upon making RESTful API requests using Swift. Looking for a challenge, I reflected on a few ideas/concepts/points of focus that I had gathered in the prior weeks. For example, there were students that wanted an additional challenge outside of what was being provided in class. Additionally, at that time I felt that the course lacked project-based lessons that are usefull in understanding real-world development. Moreover, I was a bit bored and wanted to challenge myself in some manner. From those thoughts/ideas/feelings I decided to conduct an optional, extra-curricular project where I'd play the role of Lead and Project Manager. Each week I'd provide specific code & design instructions told from the perspective of the Lead and PM, respectively. At the end of the week, participating students would submit a PR of the current project spec. I would then review the PRs offering advice and fixes on their code. If a student was able to submit a PR to spec, they were invited to move on to the next week of development." 
  - Results from Louis: "The project began with 14 participating students and ended with 4. Along the way students were shown the differences in the role of the Lead and PM, working on a shared repo, how a software production cycle feels, how to track issues, features and requests on Trello, and aspects of scrum. In all, we totaled (estimate a more accurate number) 100 development hours across participating students for the duration of the project."
- Technologies and Coding Principles
  - Entirely programmatic code base with the exception of a single nib. 
  - A specific focus on using constraint-based and dynamic layouts, without the aid of cocoapods.
  - Usage of singletons to centralize and manage app-wide changes. 
  - Simulated backend by using the Fieldbook API. 
  - Dynamic app settings by allowing for updates to be sent to the app via RESTful calls to the "backend."
  - Local persistance of user-defined app settings and backend, JSON config files. 
  - Animations without the use of cocoapods
  - Principles of material design, including specifications for font family (Roboto), weights, colors and sizes. 
  - Ability to integrate social media in order to share content
  - Generating screenshots with custom watermarks
  - Advanced usage of `NSAttributedString` and `CoreText` to style text. 
  - A `git flow`-styled repo organization and management system
  - Familiarity with daily standups via [Howdy](https://accesslite.slack.com/apps/A09RDP4AW-howdy) (a slack bot plugin)
  - Handling keyboard events
  - Defensive programming in dealing with malformed backend data and slow internet connections
  - Network request optimizations (as in limiting the total and making requests opportunistic - as in they only run if necessary)
  - Others??? Discuss!!!
- The Process
  - Week 1: The first week was defined by a very detailed outline from the "Lead" to implement the very core code of the app. Students were provided specific class, method, and protocol names along with what each should be responsible for. The "PM" notes provided a basic mock up of the app along with minor details relating to UI & UX (mostly font details and app interactions) 
    - Week 1: [General Info](https://github.com/AccessLite/BoardingPass/tree/master/Week%201%20-%20MVP)
    - Week 1: [Tech Lead Notes](https://github.com/AccessLite/BoardingPass/blob/master/Week%201%20-%20MVP/Week1MVP_TechLeadInstructions.md)
    - Week 1: [Project Manager Notes](https://github.com/AccessLite/BoardingPass/blob/master/Week%201%20-%20MVP/Week1MVP_PMInstructions.md)
  - Week 2: With the participant pool dropping to 7, I decided to further challenge the remaining group by providing less detailed requirements in the Lead's notes. The instructions themselves would narrow down their implementations in a somewhat controlled manner, while allowing for some abiguity that would require some carefull consideration/googling.
    - Week 2: [General Info](https://github.com/AccessLite/BoardingPass/tree/master/Week%202%20-%20MVP)
    - Week 2: [Tech Lead Notes](https://github.com/AccessLite/BoardingPass/blob/master/Week%202%20-%20MVP/Week2MVP_TechLeadInstructions.md)
    - Week 2: [PM Notes](https://github.com/AccessLite/BoardingPass/blob/master/Week%202%20-%20MVP/Week2MVP_PMInstructions.md)
  - Week 3 & Beyond: After having developed the core functionality of the app, it was time to update the UI and refine the user experience. The design was overhauled to use many of Google's Material Design principles including font styles, color schemes, and depth of layers. New app icon and launch screen assets were designed and added. Additionally, dynamic resizing and repositioning to a number of text elements was added, along with a pared-down, gesture and button-based navigation. Animations were added to provide clear visual feedback in response to user action. Week 3 introduced the API "backend" of the app which would be used to update the color schemes available to the app, along with a brief message to the user regarding the version of the API in use. 
  - Week 3+: Week 3 shifted away from individual projects into a single, shared repo for the remaining 4 students and myself. This was agreed upon for a few reasons: 
    1. The number of participants remaining was a small enough group that I'd be able to manage as an actual development team. 
    2. The participants themselves at this point had demonstrated their coding skills and ability to work independently, requiring far less direct oversight.  
    3. I wanted to implement some moderately ambitious features that would take far to long if each developer was writing the entirety of the code base
    4. Development is commonly done with at least one other person, so it would be a far more enriching experience. In this manner we could incorporate common industry practices such as comprehensive peer reviews, a light version of `git flow`, and some aspects of agile development. 
    - Week 3: [General Info](https://github.com/AccessLite/BoardingPass/tree/master/Week%203%20-%20MVP)
    - Week 3: [Tech Lead Notes](https://github.com/AccessLite/BoardingPass/tree/master/Week%203%20-%20MVP/TechNotes)
    - Week 3: [PM Notes](https://github.com/AccessLite/BoardingPass/blob/master/Week%203%20-%20MVP/PM_Notes/README.md)
- Lessons Learned (experiences learned as a Lead/PM, individual observations from liam, ana, tom, hari)
  - Louis: 
  - Ana: 
  - Tom: 
  - Hari:
  - Liam:
- Version 2.0
  - Features: ??
- Future Work
  - It is planned to conduct another of these optional projects in the following weeks. Now with the class completing their studies, it is possible to plan out a more interesting and ambitious project. The overall structure will however, remain the same (Week-long sprints with participant dropoff, four weeks maximum, final project team of < 5)
- Contact Info (for each of the final members)
- Final Thanks (acknowledgement of all participants)
  - Thank you to everyone who has participated (list names & github links)
