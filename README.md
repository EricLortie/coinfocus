# Coinfocus: Cryptocurrency Tracking & Predictions

This app exists to track cryptocurrency prices and social media & news mentions. I started doing this with an eye towards building up a meaningful quantity of data in order to make machine learning predictions on the prices of cryptocurrencies. While putting together the infrastructure to gather this data I decided it would be worthwhile to also surface this data in a web app, maybe with an eye towards charging subscriptions for access to the data. The app is hosted on Heroku, with an average monthly cost between 100$ and 700$, depending on where I've been in the development phase.

The URL for the site is http://coinfocus.io


## Important Notes:

This is a hobby project. I'm not sure of the total hours I've put into it. I started it in late January after the price of bitcoin reached absurd levels. It was originally built as a clone of coinmarketcap.com and then sort of went off the rails. Most of the code in this project was written between 9pm and 11pm after a full day of other work + parenting, so it's a bit of a gong show. There are no unit tests and very little comments, as I mostly just leave TODO items for myself and delete them.


## What's cool about it?

1. Check out /app/schedulers/* and /app/workers/* for the files that were used to gather data. I pulled data from Reddit (Through a Gem), Twitter (through a Gem) and multiple news services through an external API. These are controlled through config/sidekiq.yml

  * I'd done work with delayed/cron jobs before, but never to this extent. All in all the app processed over 12 million background jobs since January, accumulating 12Gb+ worth of relevant data. Threading the needle between getting the needing and using the hardware I could afford was a fun challenge, and I spent a lot of time trying to optimize my queries.

  * I'm really happy with the overal quality of the SQL queries and table indexing. For example the snapshots table has millions and millions of records, but join queries are fairly snappy.

2. /lib/worker_module.rb is the main workhorse for the whole project. Future iterations of the project

## What needs work?

1. Code isn't as DRY as it should be, especially with the views. I need to build some more partials.

2. WorkerModule should be broken up into multiple files. I didn't plan on it becoming such a beast.

3. The lack of unit tests is especially problematic given that there isn't a staging environment.

4. It doesn't actually make any money.


