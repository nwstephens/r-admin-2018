# A guide to professional R tooling and integration

This repository explains the tooling for a scalable data lab that integrates with other systems. See the [RStudio admin docs](http://docs.rstudio.com/) for detailed information.

### Data Lab

Use these files to set up a data lab on a server instance. This data lab will allow you to host Shiny apps and API's at scale that connect to your database. You will also be able to automate your work and allow others to customize your content.

Integrate your content with other systems. Embed Shiny apps into webpages, email reports on demand or on an automated schedule, and make API's available to REST based calls.

### Bitcoin Demo

These files demonstrate how to create content in R and then integrate that content into other systems. The bitcoin demo downloads data from a web API every 15 minutes and loads it into a database. These assets are created and shared. All assets are connected to the database which gets updated every 15 minutes.

Content Type | Data Lab Capability |  Systems Integration
-----------------------|-------------------------------------|---------------------------------
1. R Notebook     | Automate simple workflows | Pull data from the web and write to a database
2. Shiny app | Easily publish, host, and manage at scale | Web page on Apache web server
3. R Markdown Report | Create dynamic, self-serve reports | Email on demand or scheduled
4. Plumber API | Easily host multiple endpoints and output types | REST call

