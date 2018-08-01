From ruby:2.3.1

ENV RAILS_ROOT /home/ljt
WORKDIR $RAILS_ROOT

# Update apt-get and install
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
     echo "deb http://mirrors.163.com/debian/ jessie main non-free contrib" >/etc/apt/sources.list && \
     echo "deb http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list && \
     echo "deb-src http://mirrors.163.com/debian/ jessie main non-free contrib" >>/etc/apt/sources.list && \
     echo "deb-src http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list

RUN apt-get update -qq && apt-get install -y build-essential \
    vim nodejs npm python-setuptools python-docutils build-essential zlib1g-dev \
    libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev curl openssh-server \
    checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev vim python imagemagick libmagickcore-dev \
    imagemagick-common libmagickwand-dev sudo ntpdate snmpd snmp libpng-dev libjpeg-dev rsync tk libpcre3-dev \
    libmysqlclient-dev mysql-client autoconf automake gettext libpq-dev cmake redis-server
RUN apt-get install -y imagemagick libmagickcore-dev libmagickwand-dev
RUN gem install bundler
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone
EXPOSE 3000