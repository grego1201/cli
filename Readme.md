This is a CLI (Command Line Interpreter) to show the weather temperature in a spanish location using api.tiempo.com endpoints.

# Config

You should create a file named `application.yml` in the folder `config/` where you should place your affiliate_id. You can obtain more info from from [here](https://www.tiempo.com/api/#/login). You can use `cp config/application_example.yml config/application.yml` to copy the file structure.

# User guide

First of all you should do a `bundle install` in root folder to install all gems.

To call it you can use `ruby eltiempo -option city` or `./eltiempo -option city`. It will return today weather temperature, average of min or max temperatures of the location, dependinig of the option choosen. Options are:

    - -today

    - -av_min

    - -av_max
    
# Development info

This CLI was created and tested on a Debian 9 Stretch version.
