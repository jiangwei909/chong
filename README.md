# About Chong

chong is a web crawling in ruby

# Install
```
gem install chong
```
or add the following line into your Gemfile
```
gem 'chong'
```

# How to use
## create a chong file
create a ruby file with prefix `chong_` in current directory

such as,

```
get "http://github.com" do |page|
  puts page.title
end
```
the example just print page title, you can add more handle in the block for more purpose.

## run it
run  `chong` in command line

