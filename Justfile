install:
    bundle install

run:
    bundle exec ruby main.rb

format-code target="":
    bundle exec standardrb --fix {{target}}
