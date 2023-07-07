# Tarot Api

## Requests

`GET /` [[run]](https://tarot-api.com)

Returns an array of every card

`GET /cards` [[run]](https://tarot-api.com/cards)

Returns an array of every card

`GET /cards/[suit]/[rank]` [[run]](https://tarot-api.com/cards/swords/10)

| argument | values                                                                      | required |
|----------|-----------------------------------------------------------------------------|----------|
| suit     | one of: swords, wands, cups, coins, or major                                | yes      |
| rank     | one of: king, queen, 1-10 for swords/wands/cups/pentacles or 0-21 for major | yes      |

Returns a single card in the form of

| field                | type             | description                                                                                 |
|----------------------|------------------|---------------------------------------------------------------------------------------------|
| meanings             | hash             |                                                                                             |
| meanings["upright"]  | array of strings | meanings for this card in the upright position                                              |
| meanings["reversed"] | array of strings | meanings for this card in the reverse position                                              |
| name                 | string           | the name of the card written out in words                                                   |
| rank                 | string or int    | rank of the card in the suit up to 21 for major arcana, king through 10 for all other suits |
| suit                 | string           | major, wands, cups, swords, or pentacles                                                    |
| planet               | string           | planet associated with this card                                                            |
| signs                | array of strings | astrological sign(s) associated with this card                                              |
| element              | string           | element associated with this card                                                           |


### Example

`GET /cards/swords/10`

<details>
  <summary>
    returns the following JSON
  </summary>

  ```JSON
   {
      "name": "Ten of Swords",
      "rank": 10,
      "suit": "swords",
      "planet": null,
      "element": "air",
      "sign": [
         "gemini",
         "libra",
         "aquarius"
      ],
      "meanings": {
         "upright": [
            "failure",
            "defeat",
            "deep wounds",
            "loss",
            "crisis",
            "betrayal"
         ],
         "reversed": [
            "recovery",
            "rebirth",
            "moving on",
            "restoration"
         ]
      }
   }
  ```
</details>

`GET /draw/[n]` [[run]](https://tarot-api.com/draw/3)

Returns n randomly selected cards

| argument | values       | required |
|----------|--------------|----------|
| n        | positive int | yes      |

`GET /find/:name` [[run]](https://tarot-api.com/find/The%20Magician)

Returns the card by the specified name. Note that the numbers will be spelled out

| argument | values                                     | required |
|----------|--------------------------------------------|----------|
| name     | string name of the card (eg: The Magician) | yes      |


## Testing

  ```
  bundle exec rake test
  ```

## Getting Started

  ```
  bundle install
  bundle exec rackup
  ```

## Thanks

* Sinatra API template https://github.com/noplay/sinatra-api-template
