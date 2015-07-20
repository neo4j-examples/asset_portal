## README

This is repo to go along with the `neo4j` gem screencast series by Brian Underwood.  

Each episode has a git tag to refer to the final code result so that you can check out and play with the code.

## Welcome SitePoint readers!

This `sitepoint` branch of the repository has been left for you to examine as a suppliment to the article.  A rake task has been provided for you to load sample data.  A basic UI has also been build so that you can browse the data.  Here is a rundown on how you might get started (refer to the `neo4j` [gem documentation](http://neo4jrb.readthedocs.org/en/latest/) for anything that you might be missing):

 1. Clone this repository
 2. Checkout this branch: `git checkout sitepoint`
 3. Install Neo4j: `rake neo4j:install[community-latest]
 4. Start Neo4j: `rake neo4j:start`
 5. Load the sample data: `rake load_sample_data`
 6. Visit [http://localhost:3000/assets](http://localhost:3000/assets)
 7. Load a rails console with `rails c` to try out making your own queries
 8. Visit the Neo4j web console if you want to browse the data with Cypher [http://localhost:7474](http://localhost:7474)

