## pre-requisites.

### parepare installed jdk7 && jeus6 archives. (on ubuntu VM)
- prepare on a fresh ubuntu xenial vm. 
- create a user 'vcap' and switch to 'vcap' user
- install jdk7 && jeus6 under /home/vcap/app/jdk7, /home/vcap/app/jeus6
- make home_vcap_app_image.tar.gz for /home/vcap/app folder 
- copy to jeus-buildpack/prebuilt-archives/home_vcap_app_image/home_vcap_app_image.tar.gz
- split by run jeus-buildpack/prebuilt-archives/split_home_vcap_app_image_for_github.sh ./home_vcap_app_image
- delete jeus-buildpack/prebuilt-archives/home_vcap_app_image/home_vcap_app_image.tar.gz
- git push

## build jeus-buildpack (on linux machine)

```
$ git clone https://github.com/myminseok/jeus-buildpack
$ cd jeus-buildpack

```

```
$ cat package-buildpack.sh

source .envrc

gem install bundler -v '< 2'

bundle install --path vendor/bundle

bundle exec buildpack-packager --cached


=> jeus_buildpack-cached-v0.1.0.zip

```


```
$ cat cf-upload-buildpack.sh

cf delete-buildpack jeus-buildpack
cf create-buildpack jeus-buildpack ./jeus_buildpack-cached-v0.1.0.zip 25


$ cf buildpacks
Getting buildpacks...

buildpack                position   enabled   locked   filename                                             stack
...
jeus-buildpack           24         true      false    jeus_buildpack-cached-v0.1.0.zip
```


## how to deploy ear

1. prepare application (ear)

```
$ git clone https://github.com/myminseok/jeus-buildpack
$ cd jeus-buildpack/test/sample-app-ear

$ ls -al

Gemfile
Gemfile.lock
myexamples.ear
manifest.yml

$ cat manifest.yml

---
applications:
- name: sample
  buildpack: jeus
  command: /home/vcap/app/start-jeus.sh
  memory: 2GB
  disk_quota: 2GB
  health-check-type: process



$ cf push

$ cf app sample


open http:/sample.apps.<pcf-domain>

```

## how to access jeus webadmin UI

### get app container IP
```
$ cf ssh <app name> -i <container index>


$ cf ssh sample -i 1
vcap@112d5338-eaf5-45b8-4acf-4c33:~$ cat /etc/hosts
127.0.0.1 localhost
10.255.128.33 112d5338-eaf5-45b8-4acf-4c33                  <===== container IP.
  

vcap@112d5338-eaf5-45b8-4acf-4c33:~$ exit

```

### make ssh tunnel to app container
ssh
```
cf ssh -L <your local pc port>:<app container ip>:<app container port> <app name> -i <container index>

$ cf ssh -L 9744:10.255.128.33:9744 sample -i 1   
vcap@112d5338-eaf5-45b8-4acf-4c33  :~$

vcap@112d5338-eaf5-45b8-4acf-4c33:~$ netstat -an
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 0.0.0.0:9736            0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:61001           0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:61002           0.0.0.0:*               LISTEN
tcp        0      0 127.0.0.1:61003         0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:9901            0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:2222            0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN <--- jeus service port
tcp        0      0 0.0.0.0:9744            0.0.0.0:*               LISTEN <--- jeus webadminn process
tcp        0      0 0.0.0.0:9908            0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:34325           0.0.0.0:*               LISTEN


```

### access jeus web admnin
```
open http://localhost:9744/webadmin/

```
 
==================================================================================================


# Refer to 
http://engineering.pivotal.io/post/creating-a-custom-buildpack/
https://docs.cloudfoundry.org/buildpacks/custom.html/
https://github.com/cloudfoundry/buildpack-packager/
Official buildpack documentation can be found at [ruby buildpack docs](http://docs.cloudfoundry.org/buildpacks/ruby/index.html).
https://github.com/rstudio/shiny-examples




