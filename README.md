# Tarot Api

## Requests

`GET /` [[run]](http://tarot-api.com)

Returns an array of every card

`GET /cards` [[run]](http://tarot-api.com/cards)

Returns an array of every card

`GET /cards/[suit]/[rank]` [[run]](http://tarot-api.com/cards/swords/10)

| argument | values                                                                  | required |
|----------|-------------------------------------------------------------------------|----------|
| suit     | one of: swords, wands, cups, coins, or major                            | yes      |
| rank     | one of: king, queen, 1-10 for swords/wands/cups/coins or 0-21 for major | yes      |

Returns a single card in the form of

| field              | type             | description                                                                                 |
|--------------------|------------------|---------------------------------------------------------------------------------------------|
| fortune_telling    | array of strings | what this card might mean in a fortune                                                      |
| keywords           | array of strings | what words are associated with this card                                                    |
| meanings           | hash             |                                                                                             |
| meanings["light"]  | array of strings | meanings for this card in the upright position                                              |
| meanings["shadow"] | array of strings | meanings for this card in the reverse position                                              |
| name               | string           | the name of the card written out in words                                                   |
| rank               | string or int    | rank of the card in the suit up to 21 for major arcana, king through 10 for all other suits |
| suit               | string           | major, coins, cups, swords, or wands                                                        |

### Example

`GET /cards/swords/10`

<details>
  <summary>
    returns the following JSON
  </summary>

  ```JSON
  {
   "fortune_telling":[
      "Disaster",
      "Put off plans and do not take action until omens are better"
   ],
   "keywords":[
      "exhaustion",
      "ruin",
      "disaster",
      "stamina",
      "obsession"
   ],
   "meanings":{
      "light":[
         "Seeing the signs that you've reached your limits",
         "Paying attention to what your body is trying to tell you",
         "Giving in to the need for rest and renewal",
         "Acknowledging that you've hit bottom",
         "Committing to a turnaround",
         "Knowing the worst is over"
      ],
      "shadow":[
         "Accepting defeat prematurely",
         "Driving yourself to total exhaustion, especially mentally",
         "Experiencing a mental breakdown",
         "Obsessing on a problem to the breaking point",
         "Giving up",
         "Refusing to move from thought to action",
         "Deeply unhealthy thoughts"
      ]
   },
   "name":"ten of swords",
   "rank":10,
   "suit":"swords"
  }
  ```
</details>

`GET /draw/[n]` [[run]](http://tarot-api.com/draw/3)

Returns n randomly selected cards

| argument | values       | required |
|----------|--------------|----------|
| n        | positive int | yes      |

`GET /find/:name` [[run]](http://tarot-api.com/find/The%20Magician)

Returns the card by the specified name. Note that the numbers will be spelled out and pentacles will be replaced by coins.

| argument | values                                     | required |
|----------|--------------------------------------------|----------|
| name     | string name of the card (eg: The Magician) | yes      |


## Testing

  ```
  rake test
  ```

## Getting Started

  ```
  bundle install
  rackup
  ```

## Thanks

* Sinatra API template https://github.com/noplay/sinatra-api-template
* Tarot Corupus from https://github.com/dariusk/corpora
