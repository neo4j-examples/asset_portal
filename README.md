# README

This is repo to go along with the `neo4j` gem screencast series by Brian Underwood.  

Each episode has a git tag to refer to the final code result so that you can check out and play with the code.

## Setting up the app

 1. Clone this repository
 2. Checkout this branch: `git checkout sitepoint`
 3. Install Neo4j: `rake neo4j:install[community-latest]`
 4. Start Neo4j: `rake neo4j:start`
 5. Load the sample data: `rake load_sample_data`
 6. Visit [http://localhost:3000/assets](http://localhost:3000/assets)
 7. Load a rails console with `rails c` to try out making your own queries
 8. Visit the Neo4j web console if you want to browse the data with Cypher [http://localhost:7474](http://localhost:7474)

## Neo4j gem Screencasts

Part of the reason for creating this application was to serve as a demonstration application for a screencast series on the `neo4j` and `neo4j-core` gems.  You can find the episodes here:

### Episode 1 - Create a Neo4j Rails Application

https://www.youtube.com/watch?v=n0P0pOP34Mw

### Episode 2 - Properties

https://www.youtube.com/watch?v=2pCSQkHkPC8

### Episode 3 - Associations

https://www.youtube.com/watch?v=veqIfIqtoNc
