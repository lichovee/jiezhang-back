# 洁账后端
> Rails 提供的洁账小程序后端Api代码

### 洁账小程序代码
https://github.com/yigger/jiezhang

### 版本要求
```
Ruby 2.3.1
Mysql 5.7.1
Rails 5.1.3
```

### 安装
```
cp config/environments/development.rb.example config/environments/development.rb

cp config/settings/development.yml.exmaple config/settings/development.yml

cp config/secrets.yml.example config/secrets.yml

bundle exec rake db:create RAILS_ENV=development

bundle exec rake db:migrate RAILS_ENV=development

bundle install
```

### 启动
```
// 开发模式下启动项目
bundle exec unicorn_rails -l 0.0.0.0:3000 -D -E development -c config/unicorn.rb

// 生产环境下启动项目
bundle exec unicorn_rails -l 0.0.0.0:3000 -D -E development -c config/unicorn.rb 
```

### Docker运行

+ 复制 Gemfile 和 Gemfile.lock 到 docker 文件夹
+ docker build -t jz -f ./Dockerfile .
+ docker exec -it jz /bin/bash
+ docker-machine 挂载路径问题 https://xiaoyounger.com/article/17

### 可能遇到的问题
```
bundle 过程中, rmagick 安装失败的话可以执行以下语句
sudo apt-get install imagemagick libmagickcore-dev libmagickwand-dev

Mysql 错误
错误代码:
SELECT list is not in GROUP BY clause and contains nonaggregated column 'ljt.statements.id' which is not functionally de ...
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
sudo service mysql restart

Docker可能存在的问题
1. 挂载目录的问题
2. rails 更改文件不生效的问题
3. 时区相差8小时 /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone
docker run -it --name jz -p 80:3000 -v /ljt:/home/ljt -d jz /bin/bash
bundle exec rails s -p 3000 -b '0.0.0.0'
```