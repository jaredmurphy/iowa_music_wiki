# ![](https://ga-dash.s3.amazonaws.com/production/assets/logo-9f88ae6c9c3871690e33280fcf557f33.png) Project #2: Building Your First Full-stack Application

## Overview of `The Wiki`

Henrietta is a business magnate and wants to create a internally facing wiki for 
her organization. She wants her employees to be able to write articles in order 
to inform colleagues about their insights.

## Project Details

### Necessary features

A basic implementation of this project must include:

1. All articles should display an author so that anyone who has questions about 
the contents of an article can contact the author
1. All articles should be editable - Henrietta's is a collaborative workplace
1. If an article is changed, the time of that change should be shown so that 
users can know how up-to-date an article is
1. Henrietta wants the articles to be written in markdown so that the content is 
visually appealing
1. Henrietta wants users to be able to add a category to an article so that 
articles can be organized

###  Advanced features

Going above and beyond the basic implementation is very desirable, should you 
have the time.

Feel free to enhance your project with any of the following features:

1. We would like to be able to track who edits what pages, so we would like to
require people to log in using BCrypt to encrypt their passwords.
1. If possible, we'd like to be able to see track updates to the articles.
1. Employees have complained that they feel constrained by a single category and 
would like to be able to assign an article to multiple categories.
1. Visitors want to be able to browse through articles by category.
1. Visitors would like to be able to search articles by title.
1. The dev team is interested in consuming the web app's information via a REST 
API.  They've asked for end points that return data formatted as JSON.

## Tips

Disavowing pizza and Red Bull (the stereotypical food choice of developers) you 
have decided to explore New York City's salad offerings.

- While at Chopt, you overheard two developers chatting about how 
[Redcarpet][redcarpet] is a great ruby gem for rendering markdown.
- On your way back into the office, your DevOps guy warns you about the dangers
of not-encrypting passwords and links you to [BCrypt](https://github.com/codahale/bcrypt-ruby)

[redcarpet]: https://github.com/vmg/redcarpet

## Implementation

### Technologies

You will be expected to use the following technologies to implement this project:

- **HTML**
  Your HTML should be semantic and valid.

- **Ruby and Sinatra**
  Your app will need to have its own server.

- **SQL**
  Your app will need to persist data.
This project is focused on server side scripting and persistence, so that should 
be your focus. 
That being said, once you've got the server side MVP established, you should 
turn some attention to the client side.

- **CSS**
Your app should be pleasing to look at. Your design should take usability into account. E.G. if an element is meant to be clicked, give it the appropriate cursor, and perhaps have its appearance change slightly. Use either Bootstrap or Skeleton to ensure it looks pretty at desktop and mobile width.

- **JavaScript & jQuery**
  Your app should have some interactivity
