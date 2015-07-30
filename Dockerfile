FROM ruby:2.1-onbuild
MAINTAINER Maik Schwan <maik.schwan@gmail.com>

EXPOSE 4567
CMD ["ruby", "./socker.rb"]
