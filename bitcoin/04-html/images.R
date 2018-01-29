#install.packages(webshot)
#webshot::install_phantomjs()

urls <- c(
  "http://ec2-54-149-163-100.us-west-2.compute.amazonaws.com:3939/content/13/README.html",
  "http://ec2-54-149-163-100.us-west-2.compute.amazonaws.com:3939/content/12/setup-instance.nb.html",
  "http://ec2-54-149-163-100.us-west-2.compute.amazonaws.com:3939/content/4/build-r-from-source.nb.html",
  "http://ec2-54-149-163-100.us-west-2.compute.amazonaws.com:3939/content/7/install-linux-libraries.nb.html",
  "http://ec2-54-149-163-100.us-west-2.compute.amazonaws.com:3939/content/6/install-rstudio.nb.html",
  "http://ec2-54-149-163-100.us-west-2.compute.amazonaws.com:3939/content/14/install-r-packages.nb.html",
  "http://ec2-54-149-163-100.us-west-2.compute.amazonaws.com:3939/content/9/install-postgresql.nb.html",
  "http://ec2-54-149-163-100.us-west-2.compute.amazonaws.com:3939/content/17/config-github.nb.html",
  "http://ec2-54-149-163-100.us-west-2.compute.amazonaws.com:3939/content/15/install-CMS.nb.html",
  "http://ec2-54-149-163-100.us-west-2.compute.amazonaws.com:3939/content/16/config-email.nb.html",
  "http://ec2-54-149-163-100.us-west-2.compute.amazonaws.com:3939/content/11/",
  "http://ec2-54-149-163-100.us-west-2.compute.amazonaws.com:3939/content/10/__swagger__/")

webshot::webshot(urls, "html/img/thumb.png", vheight = 200, vwidth = 200, cliprect = "viewport", delay = 2)
