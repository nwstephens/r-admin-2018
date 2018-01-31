# A guide to professional R tooling and integration

This repository explains the tooling for a scalable data lab that integrates with other systems.

### Data Lab

Use these files to set up a data lab on a server instance. This data lab will allow you to host Shiny apps and API's at scale that connect to your database. You will also be able to automate your work and allow others to customize your content.

Integrate your content with other systems. Embed Shiny apps into webpages, email reports on demand or on an automated schedule, and make API's available to REST based calls.

### Bitcoin Demo

These files demonstrate how to create content in R and then integrate that content into other systems. The bitcoin demo downloads data from a web API every 15 minutes and loads it into a database. These assets are created and shared. All assets are connected to the database which gets updated every 15 minutes.

Content Type | Integration
--------------------------------|---------------------------------
Shiny app | Web page on Apache web server
Parameterized R Markdown Report | Email on demand and scheduled
Plumber API | REST call

