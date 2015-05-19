## Setup
* Run ```npm install```
* Ensure a MongoDB database is available for use. Either install MongoDB on the server locally, or use a hosted services such as [Compose](https://compose.io) or [MongoLab](https://mongolab.com/).
* Supply the MongoDB URI in the config/config.js file, under the appropriate environment. Make sure your environment variables are set up to the right one.
* Change the port to whatever is needed - either port 80 if it is the only thing running on this server, or another port, and use something like Nginx reverse proxying to route traffic to this.
* Use ```npm start``` to start the app. Something like [forever](https://www.npmjs.com/package/forever) will help ensure it's always up.

__Note__: While this will run and compile on Heroku, image uploads will __NOT__ work. This is due to a limitation with Heroku having read-only settings for their dynos, and would require a separate image host.
