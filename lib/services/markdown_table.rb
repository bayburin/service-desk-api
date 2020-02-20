class MarkdownTable
  attr_reader :header, :break_line, :table, :rows_count, :columns_count

  def initialize(rows_count, columns_count)
    @rows_count = rows_count
    @columns_count = columns_count
    @header = columns_count.times.map { |i| "Заголовок #{i + 1}" }
    @break_line = columns_count.times.map { ' --- ' }
    @table = rows_count.times.map { row }
  end

  def add_row
    table << row
  end

  def add_rows(count)
    count.times { add_row }
  end

  def add_column
    new_count = @header.length + 1
    header << "Заголовок #{new_count}"
    break_line << ' --- '
    table.each { |row| row << column(new_count) }
  end

  def add_columns(count)
    count.times { add_column }
  end

  def write_to_header(cell, value)
    raise 'Столбец с таким индексом не существует' if cell >= header.length

    header[cell] = value
  end

  def write_to_headers(*values)
    raise 'Не совпадает число записываемых значений с числом столбцов' if header.length != values.length

    header.map!.with_index { |_cell, i| values[i] }
  end

  def write_to_cell(row, cell, value)
    raise 'Строка с таким индексом не существует' if row >= table.length
    raise 'Столбец с таким индексом не существует' if cell >= table[row].length

    table[row][cell] = value
  end

  def write_to_row(row, *values)
    raise 'Строка с таким индексом не существует' if row >= table.length
    raise 'Не совпадает число записываемых значений с числом столбцов' if table[row].length != values.length

    table[row].map!.with_index { |_cell, i| values[i] }
  end

  def to_s
    rows = table.map { |columns| columns.join(' | ') }
    header.join(' | ') + "\n" + break_line.join(' | ') + "\n" + rows.join("\n")
  end

  private

  def row
    columns_count.times.map { |j| column(j + 1) }
  end

  def column(index)
    "Столбец #{index}"
  end
end
