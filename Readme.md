# Grog 2500 Readme

## Introduction

Grog 2500 is a simple text adventure game platform for the mobile emoji world of today.

## Game Play

- Single player
- Choose-your-own-adventure style stories
- Mutiple choice responses
- Multiple stories
- Player can earn and lose points and health
- Player can earn bonus points by winning in a minimum number of moves

## Compatibility

- iPhone SE, 5, 5s, 6, 6+, 7, 7+, and beyond
- iOS 10.3 and above

## TODO List

- Game server and online/offline content
- Game authoring tool
- Mutiple game support
- Automatic management of saving progress
- Templating such that properties and varibles can be included in game text
- Multi-language support and internationalization
- Advanced theme of UI with graphics and textures

## Game Authoring

Grog 2500 games are based the concept of a storybook. A single game can be a single
storybook or multiple storybooks. Each storybook is composed of a list of pages, a
theme, a budget, and an end game. Each storybook also has a name and unique ID.

- Storybook details
  - Graphics are not supported (outside of emoji)
  - Multiple fonts, font styles, or font sizes are not support
  - Storybook names should be short and sweet
  - Storybook ID should be >= 1000 up to the size of a Swift Int
  - A game can be comeposed of multiple storybooks--as many as you like
  - Multiple storybooks can be used for subplots, guides, help, glossaries
  - Storybooks are not chapters as the user can consume them simultaneously
    - Which is probably ok for non-linear chapters!
  - Storybooks are composed of pages, which should be about a paragraph of text
  - Pages can be associated with up to 12 commands
    - Besure to leave room for commands that link to other stories in the same game!
  - Commands come in 3 flavors...
    - Clear, which restarts the game
    - Jump, which jumps to any other page in a story
    - Swap, which jumps to any other storybook in a game
    - (I probably need to add intra-storybook jumping)
  - Storybooks come with a budget and commands have costs
    - (I need to add storybook goals and command rewards)
  - For each outcome you want as an author you have to define both a page and commands
    - This includes just moving the story forward or greating a problem to be solved
    - (I need to create the ability to lock and unlock storybooks)

