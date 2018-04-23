FROM yastdevel/ruby:sle15
COPY . /usr/src/app
RUN zypper --non-interactive in --no-recommends skelcd-control-SLES

