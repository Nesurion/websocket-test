FROM ruby:2.1-onbuild
MAINTAINER Maik Schwan <maik.schwan@gmail.com>

EXPOSE 80
CMD ["ruby", "./socker.rb"]
