# ![](https://ga-dash.s3.amazonaws.com/production/assets/logo-9f88ae6c9c3871690e33280fcf557f33.png) Project #2: Building Your First Full-stack Application

## Overview of `The Forum`

Jake loves discussion amongst his friends, but he wants a way to keep it organized. 
He wants his own forum.

## Project Details

### Necessary features

A basic implementation of this project must include:

1. Jake wants his friends to be able to discuss things by topics. Users should 
be able to create topics, and other users should be able to comment on those topics.
2. Jake isn't concerned about sub-comments, for now.
3. Jake also wants to be able to see what topics have the most comments.
4. Jake thinks it would be cool if users could vote on topics, and have the 
topics displayed based on popularity.
5. Jake is a nerd, and is a fan of proper formatting. He wants everyone to write 
their discussion posts in markdown format.

###  Advanced features

Going above and beyond the basic implementation is very desirable, should you 
have the time.

Feel free to enhance your project with any of the following features:

1. To prevent spam, and to make sure his friends can't impersonate each other,
Jake would like his friends to be able to log in using an email and password.
1. *NEVER* store passwords in "plain-text", use BCrypt to encrypt them.
1. Jake's friends all use Gravatar for profile images and would love to see them
on their profile page.
1. Jake's friends love adding comments to topics, but they want to be able to 
comment on comments.

### Tips

Your friend recently completed WDI and last week you ran into her at 
Neo-Folk/House fusion show in Bushwick. Over the loud basslines and banjo twangs, 
you mention the app Jake wants made.

- "I've actually done something with markdown formatting. I think I used a 
library called [Redcarpet][redcarpet]."
- A friend of yours database was recently hacked, and made off with all of his
user's passwords, he warns you to use [BCrypt](https://github.com/codahale/bcrypt-ruby)

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
be your focus. That being said, once you've got the server side MVP established, 
you should turn some attention to the client side.

- **CSS**
  Your app should be pleasing to look at. Your design should take usability into 
  account. E.G. if an element is meant to be clicked, give it the appropriate 
  cursor, and perhaps have its appearance change slightly. Use either Bootstrap or 
  Skeleton to ensure it looks pretty at desktop and mobile width.

- **JavaScript & jQuery**
  Your app should have some interactivity
