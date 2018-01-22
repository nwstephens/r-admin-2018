install.packages(webshot)
webshot::install_phantomjs()

urls <- c("http://54.149.163.100:3939/content/1/tmp.nb.html",
           "http://54.149.163.100:3939/content/2/",
          "http://54.149.163.100:3939/content/4/build-r-from-source.nb.html",
          "http://54.149.163.100:3939/content/6/install-rstudio.nb.html",
          "http://54.149.163.100:3939/content/7/install-linux-libraries.nb.html",
          "http://54.149.163.100:3939/content/8/README.html",
          "http://54.149.163.100:3939/content/9/install-postgresql.nb.html",
          "http://54.149.163.100:3939/content/10/__swagger__/")

webshot::webshot(urls, "html/img/thumb.png", vheight = 600, vwidth = 600, cliprect = "viewport")
