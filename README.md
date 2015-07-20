## README

This is repo to go along with the `neo4j` gem screencast series by Brian Underwood.  

Each episode has a git tag to refer to the final code result so that you can check out and play with the code.

## Welcome SitePoint readers!

This `sitepoint` branch of the repository has been left for you to examine as a suppliment to the article.  A rake task has been provided for you to load sample data.  A basic UI has also been build so that you can browse the data.  Here is a rundown on how you might get started (refer to the `neo4j` [gem documentation](http://neo4jrb.readthedocs.org/en/latest/) for anything that you might be missing):

 # Clone this repository
 # Checkout this branch: `git checkout sitepoint`
 # Install Neo4j: `rake neo4j:install[community-latest]
 # Start Neo4j: `rake neo4j:start`
 # Load the sample data: `rake load_sample_data`
 # Visit [http://localhost:3000/assets](http://localhost:3000/assets)
 # Load a rails console with `rails c` to try out making your own queries
 # Visit the Neo4j web console if you want to browse the data with Cypher [http://localhost:7474](http://localhost:7474)

