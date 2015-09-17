convertResult = (data) ->
  result = 
    columns: []
    data: []
  columns = data.columns
  count = columns.length
  rows = data.json.length

  for column, idx in columns
    result.columns[idx] =
      sTitle: column
      sWidth: column.length * CHAR_WIDTH

  for row, row_idx in data.json
    new_row = for column, idx in columns
      value = convertCell(row[column])
      result.columns[idx].sWidth = Math.max(value.length * CHAR_WIDTH, result.columns[idx].sWidth)
      value

    result.data[row_idx] = new_row

  width = 0
  for column, idx in columns
    width += result.columns[idx].sWidth

  for column, idx in columns
    result.columns[idx].sWidth = '' + Math.round(100 * result.columns[idx].sWidth / width) + '%'

  result

convertCell = (cell) ->
  return '<null>' if cell == null

  if cell instanceof Array
    result = []

    for c in cell
      result.push convertCell(c)

    return "[#{result.join(', ')}]"

  if cell instanceof Object
    if cell['_type']
      return "(#{cell['_start']})-[#{cell['_id']}:#{cell['_type'] + props(cell)}]->(#{cell['_end']})"
    else if cell['_id']
      labels = ''

      if cell['_labels']
        labels = ':' + cell['_labels'].join(':')

      return '(' + cell['_id'] + labels + props(cell) + ')'
    return props(cell)

  cell

props = (cell) ->
  props = []
  for key of cell
    if cell.hasOwnProperty(key) and key[0] != '_'
      props.push [ key ] + ':' + JSON.stringify(cell[key])

  if props.length then " {#{props.join(', ')}}" else ''

window.renderTable = (element, data) ->
  return false if !data or !'stats' of data or !'rows' of data.stats

  result = convertResult(data)
  table = $TABLE.clone().appendTo($(element))
  large = result.data.length > 10

  dataTable = table.dataTable
    aoColumns: result.columns
    bFilter: large
    bInfo: large
    bLengthChange: large
    bPaginate: large
    aaData: result.data
    aLengthMenu: [
      [10, 25, 50, -1 ]
      [10, 25, 50, 'All']
    ]
    aaSorting: []
    bSortable: true
    oLanguage:
      oPaginate:
        sNext: ' >> '
        sPrevious: ' << '

  true

CHAR_WIDTH = 8
$TABLE = $('<table class="ui table" cellpadding="0" cellspacing="0" border="0"></table>')
