# Vibes

ICHACK 2023 

## The Idea

Vibes is a navigational wristband system which guides you to your destination, as inputed via a Flutter app running the Google Maps API, using vibrations on your wrists. 

## Who is it for?

We think our product would be helpful for a variety of people. Here are the main people we feel can benefit

- Visually impaired people. This provides a method of getting direction that doesn't rely on having headphones in. Since visually impaired people depend on their hearing, having headphones in can reduce their awareness and safety. We hope this can make their journy safer and also more enjoyable as they can clearly hear what is around them and do not need to ask/depend on others. 
- Cyclists and motorists. Getting around can be tricky - having a GPS up can be distracting, as you have to constantly look down, and equally if it rains it can be difficult to see. This eliviates this problem and allows cyclists and motorists to focus more on the road. 
- Walking with Friends. Walking with friends can be stressful if you constanlty have to check directions on your phone to get to your destination. We hope this product will encourage people to walk to places together as it'll be extremely easy to navigate without having to think.

## How it works

Vibes takes your origin and destination via a Flutter app, which uses the Google Maps API to display a map, allowing you to interactively move and touch-select your destinations. 

It then uses the Google Maps Directions API to collect the maneuver data of the journey and clean it. 

This then connects with two Arduino wristbands. These have been configured into a sender and receiver model, which communicate with each other wirelessly. One of them holds the logic code to the receiver, and sends signals depending on whether it is a left, right or straight turn (that will vibrate on both at the same time) using the appropriate delays. 

## Our Prototype

Eventually, we'd like to have a much smaller control board with the components soldered in (rather than in a breadboars) to make it easily wearable. We also didn't have any vibrating chips or motors at the right currency, so we used LEDs for the purpose of the demonstration. These are just connected to the arduino via digital pins - it would be very easy to attach a small vibrating disk to the same digital pin without changing any code. 
