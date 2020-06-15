# King Shan family tree

## Problem

Refer to ![this document](./problem-statement.pdf) for the problem statement

## Prerequisite

- Ruby >= 2.6.0
- bundler >= 2.1.0

## Instructions

Make sure you are at the same directory level with this README

### Run command

```
ruby main.rb path_to_input_file
```

#### Example

```
ruby main.rb examples/sample_1.txt
```

The output will be printed to STDOUT

### Run tests

#### Install gems

```
bundle install
```

#### Run rspec

```
bundle exec rspec
```

## Brief Architecture

```
├── error.rb         # Represent all program's errors
├── gender.rb        # Supported genders
├── models
│   ├── family.rb    # Represent a family. It contains all family members (which is a person model)
│   └── person.rb    # Represent a person
├── program
│   ├── command.rb   # Supported program's commands
│   ├── parser.rb    # Parse a string in to a program's command
│   ├── presenter.rb # Present a command result
│   └── runner.rb    # Run a program command
└── relationship.rb  # Repository pattern to get relationships of a person
```
