# Calendar Exercise - Major Clarity

Your product owner is asking you to implement a new feature in the calendar system that is in your scheduling tool. The feature needs to support arranging a set of meetings within an 8 hour day in a way that makes them work, and let the user know if the meetings cannot fit into the day.
For this feature there will be two kinds of meetings, on-site meetings and off-site meetings. On-site meetings can be scheduled back to back with no gaps in between them, but off-site meetings must have 30 minutes of travel time padded to either end. This travel time however can overlap for back to back off-site meetings, and can extend past the start and end of the day.

## Setup

```bash
 $ git clone git@github.com:chantal66/calendar-exercise.git
```

```bash
 $ cd calendar-exercise 
```

```bash
 $ bundle install
```

## Run the calendar

```bash
 $ pry -I lib -r calendar_client
```

```ruby
CalendarClient.execute
```

> To see different outputs, In `calendar_client.rb` you can switch `MEETINGS_FILE.first[:day1]` for: 
> `MEETINGS_FILE[1][:day2]`
> `MEETINGS_FILE[2][:day3]`
> `MEETINGS_FILE[3][:day4]`

## Run the Test Suite

```bash
 $ bundle exec rspec 
```

Given a set of meetings (below is an example of a set of meetings):

```
{
    { name: 'Meeting 1', duration: 3, type: :onsite },
    { name: 'Meeting 2', duration: 2, type: :offsite },
    { name: 'Meeting 3', duration: 1, type: :offsite },
    { name: 'Meeting 4', duration: 0.5, type: :onsite }
}
```

You must write code to determine if these meetings can fit into a 9 to 5 schedule, and propose a layout for those meetings in a format like this:
9:00 - 12:00 - Meeting 1 12:00 - 12:30 - Meeting 4 1:00 - 3:00 - Meeting 2 3:30 - 4:30 - Meeting 3
Here are a few example sets for you to test against:

Example 1:

```
{
    { name: 'Meeting 1', duration: 1.5, type: :onsite }, 
    { name: 'Meeting 2', duration: 2, type: :offsite },
    { name: 'Meeting 3', duration: 1, type: :onsite }, 
    { name: 'Meeting 4', duration: 1, type: :offsite }, 
    { name: 'Meeting 5', duration: 1, type: :offsite },
}
```

Yes, can fit. One possible solution would be: 

9:00 - 10:30 - Meeting 1
10:30 - 11:30 - Meeting 3
12:00 - 1:00 - Meeting 5
1:30 - 2:30 - Meeting 4 3:00 - 5:00 - Meeting 2

Example 2:
```
{
    { name: 'Meeting 1', duration: 4, type: :offsite }, 
    { name: 'Meeting 2', duration: 4, type: :offsite }
}
```
No, can’t fit.

Example 3:
```
{
    { name: 'Meeting 1', duration: 0.5, type: :offsite }, { name: 'Meeting 2', duration: 0.5, type: :onsite }, { name: 'Meeting 3', duration: 2.5, type: :offsite }, { name: 'Meeting 4', duration: 3, type: :onsite }
}
```
Yes, can fit. One possible solution would be: 

9:00 - 9:30 - Meeting 2
10:00 - 10:30 - Meeting 1
11:00 - 2:00 - Meeting 4
2:30 - 5:00 - Meeting 3

Instructions

1. Write the solution in Ruby.
2. Put the code up on Github, Bitbucket, etc...
3. Commit early and often so we can see progress as you work through the solution.
4. No need to create a complex UI, just a command line application is enough.
5. The data samples can be hardcoded into the solution, no need to read in external data.
