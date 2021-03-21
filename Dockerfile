FROM debian
RUN apt-get update
RUN apt-get -y install git ruby
# RUN apt-get -y install texlive-base texlive-luatex texlive-xetex git
# RUN apt-get -y install git texlive-full
# RUN git clone https://github.com/hyphenation/tex-hyphen
# WORKDIR tex-hyphen
WORKDIR tex-hyphen/tests/formats
RUN ./make-formats.sh
# RUN gem install bundle
# RUN bundle install --without test --without development
# RUN bundle exec rake
