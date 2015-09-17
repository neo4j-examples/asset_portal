Prism.languages.cypher = { 
  //'comment': {
  //  pattern: /(^|[^\\])(\/\*[\w\W]*?\*\/|((--)|(\/\/)|#).*?(\r?\n|$))/g,
  //  lookbehind: true
  //},
  //'string' : {
  //  pattern: /(^|[^@])("|')(\\?[\s\S])*?\2/g,
  //  lookbehind: true
  //},
  //'variable': /@[\w.$]+|@("|'|`)(\\?[\s\S])+?\1/g,
  //'function': /\b(?:COUNT|SUM|AVG|MIN|MAX|FIRST|LAST|UCASE|LCASE|MID|LEN|ROUND|NOW|FORMAT)(?=\s*\()/ig, // Should we highlight user defined functions too?
  'keyword': /\b(?:MATCH|OPTIONAL MATCH|START|CREATE|CREATE UNIQUE|MERGE|SET|DELETE|REMOVE|WHERE|CASE|END|FOREACH|WITH|RETURN|LIMIT|ORDER BY|SKIP|UNWIND|UNION|UNION ALL|USING)\b/gi,
  'node': /\(([\w]*)(:[\w]+)*\)/i,
  'relationship': /\[(:\w+)?(\|:\w+)*(\*\d*(\.\.)?\d*)?\]/i
  //'boolean': /\b(?:TRUE|FALSE|NULL)\b/gi,
  //'number': /\b-?(0x)?\d*\.?[\da-f]+\b/g,
  //'operator': /\b(?:ALL|AND|ANY|BETWEEN|EXISTS|IN|LIKE|NOT|OR|IS|UNIQUE|CHARACTER SET|COLLATE|DIV|OFFSET|REGEXP|RLIKE|SOUNDS LIKE|XOR)\b|[-+]{1}|!|[=<>]{1,2}|(&){1,2}|\|?\||\?|\*|\//gi,
  //'punctuation': /[;[\]()`,.]/g
};
