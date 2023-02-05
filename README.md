# Vibes

ICHACK 2023 

## The Idea

Vibes is a navigational wristband system which guides you to your destination, as inputed via a Flutter app running the Google Maps API, using vibrations on your wrists. 

You can see a demo here : https://youtu.be/3VCT6xzchRs 

## Who is it for?

We think our product would be helpful for a variety of people. Here are the main people we feel can benefit

- Visually impaired people. This provides a method of getting direction that doesn't rely on having headphones in. Since visually impaired people depend on their hearing, having headphones in can reduce their awareness and safety. We hope this can make their journey safer and also more enjoyable as they can clearly hear what is around them and do not need to ask/depend on others. 
- Cyclists. Getting around can be tricky - having a GPS up can be distracting, as you have to constantly look down, and equally if it rains it can be difficult to see. This alleviates this problem and allows cyclists to focus more on the road. 
- Walking with Friends. Walking with friends can be stressful if you constantly have to check directions on your phone to get to your destination. We hope this product will encourage people to walk to places together as it'll be extremely easy to navigate without having to think.

## Sustainability

We hope our product makes walking and cycling a more enjoyable and hassle-free experience, and thus encourages people to take it up more.

Cycling in unfamiliar places or for long distances can be daunting if directions aren't known before and someone constantly has to stop and check their phone. This is an easy solution that not only makes cycling more hassle-free, but also a lot safer. Many people are also scared to cycle due to safety risk. By reducing possible distractions, we hope to make it a safer experience and remove some of this stress. 

We also hope to improve people's experiences when walking alone or with friends. It allows them to take in their surroundings and not need to rely on a screen, thus appreciating and enjoying the experience more. 


## Breaking Boundaries and Bringing People Together

Our idea breaks boundaries and brings people together both literally and metaphorically. 

Literally: We remove a big problem - break a boundary you could say - that stops people from getting together from A to B. We want people to have more options, and greener options, for moving around in a hassle-free and enjoyable way. 

Metaphorically: For people walking together, we want them to be able to make the experience a more enjoyable time to have quality conversation, rather than being stressed and consistently looking at a screen to know what way to turn. We also hope this brings people together with their surroundings more. 

## How it works

Vibes takes your origin and destination via a Flutter app, which uses the Google Maps API to display a map, allowing you to interactively move and touch-select your destinations. 

It then uses the Google Maps Directions API to collect the manoeuvre data of the journey and clean it. 

This then connects with two Arduino wristbands. These have been configured into a sender and receiver model, which communicate with each other wirelessly. One of them holds the logic code to the receiver and sends signals depending on whether it is a left, right or straight turn (that will vibrate on both at the same time) using the appropriate delays. 

## Our Prototype

Eventually, we'd like to have a much smaller control board with the components soldered in (rather than in a breadboard) to make it easily wearable. We also didn't have any vibrating chips or motors at the right currency, so we used LEDs for the purpose of the demonstration. These are just connected to the Arduino via digital pins - it would be very easy to attach a small vibrating disk to the same digital pin without changing any code. 
