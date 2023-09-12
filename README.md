### Caching
We can enable caching so the next request will not require the system to process all 20K records again.
We first need to turn on caching for the rails portion of the application with the following:
```
rails dev:cache
```