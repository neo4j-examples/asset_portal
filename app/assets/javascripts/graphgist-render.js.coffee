#= require MathJax/MathJax
#= require MathJax/config/TeX-AMS-MML_HTMLorMML


#= require jquery-ui.min
#= require d3.min
#= require jquery.dataTables.min
#= require cypher.datatable
#= require neod3
#= require neod3-visualization
#= require console
#= require gist
#= require dot
#= require graphgist
#= require base64
#= require mutate.min

#= require prism
#= require prism-cypher


MathJax.Hub.Config
  tex2jax:
    inlineMath: [['$','$'],['\\(','\\)']]

# Transform ASCIIdoc HTML output to match Semantic UI expectations
$('.sect1').addClass('ui container')
for element in $('div.paragraph')
  $(element).replaceWith($('<p>' + element.innerHTML + '</p>'));

DEFAULT_VERSION = '2.2'
CONSOLE_VERSIONS =
  '2.0.0-M06': 'http://neo4j-console-20m06.herokuapp.com/'
  '2.0.0-RC1': 'http://neo4j-console-20rc1.herokuapp.com/'
  '2.0.0': 'http://neo4j-console-20.herokuapp.com/'
  '2.0.1': 'http://neo4j-console-20.herokuapp.com/'
  '2.0.2': 'http://neo4j-console-20.herokuapp.com/'
  '2.0.3': 'http://neo4j-console-20.herokuapp.com/'
  '2.0.4': 'http://neo4j-console-20.herokuapp.com/'
  '2.1.0': 'http://neo4j-console-21.herokuapp.com/'
  '2.1.1': 'http://neo4j-console-21.herokuapp.com/'
  '2.1.2': 'http://neo4j-console-21.herokuapp.com/'
  '2.1.3': 'http://neo4j-console-21.herokuapp.com/'
  '2.1': 'http://neo4j-console-21.herokuapp.com/'
  '2.2': 'http://neo4j-console-22.herokuapp.com/'
  '2.3': 'http://neo4j-console-23.herokuapp.com/'
  'local': 'http://localhost:8080/'
  '1.9': 'http://neo4j-console-19.herokuapp.com/'


GraphGistRenderer.renderContent()

