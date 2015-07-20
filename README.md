## README

This is repo to go along with the `neo4j` gem screencast series by Brian Underwood.  

Each episode has a git tag to refer to the final code result so that you can check out and play with the code.

## Welcome SitePoint readers!

This `sitepoint` branch of the repository has been left for you to examine as a suppliment to the article.  A rake task has been provided for you to load sample data.  A basic UI has also been build so that you can browse the data.  Here is a rundown on how you might get started (refer to the `neo4j` [gem documentation](http://neo4jrb.readthedocs.org/en/latest/) for anything that you might be missing):

 1. Clone this repository
 2. Checkout this branch: `git checkout sitepoint`
 3. Run `bundle install`
 4. Install Neo4j: `rake neo4j:install[community-latest]`
 5. Start Neo4j: `rake neo4j:start`
 6. Load the sample data: `rake load_sample_data`
 7. Run a server with `rails server` and visit [http://localhost:3000/assets](http://localhost:3000/assets)
 8. Load a rails console with `rails console` to try out making your own queries
 9. Visit the Neo4j web console if you want to browse the data with Cypher [http://localhost:7474](http://localhost:7474)

