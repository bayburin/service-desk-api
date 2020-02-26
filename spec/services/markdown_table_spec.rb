require 'rails_helper'

RSpec.describe MarkdownTable do
  let(:rows_count) { 3 }
  let(:columns_count) { 2 }
  subject { MarkdownTable.new(rows_count, columns_count) }

  it 'creates table with specified number of rows' do
    expect(subject.table.length).to eq rows_count
  end

  it 'creates table with specified number of columns' do
    expect(subject.table[0].length).to eq columns_count
  end

  describe '#add_row' do
    before { subject.add_row }

    it 'adds row to table' do
      expect(subject.table.length).to eq rows_count + 1
    end

    it 'adds columns to created row' do
      expect(subject.table[rows_count].length).to eq columns_count
    end
  end

  describe '#add_rows' do
    let(:new_rows_count) { 5 }

    it 'adds specified number of rows' do
      expect(subject).to receive(:add_row).exactly(new_rows_count).times

      subject.add_rows(new_rows_count)
    end
  end

  describe '#add_column' do
    before { subject.add_column }

    it 'adds column to header' do
      expect(subject.header.length).to eq columns_count + 1
    end

    it 'adds column to line breaks' do
      expect(subject.break_line.length).to eq columns_count + 1
    end

    it 'adds column to main table' do
      subject.table.each do |row|
        expect(row.length).to eq columns_count + 1
      end
    end
  end

  describe '#add_columns' do
    let(:new_columns_count) { 5 }

    it 'adds specified number of columns' do
      expect(subject).to receive(:add_column).exactly(new_columns_count).times

      subject.add_columns(new_columns_count)
    end
  end

  describe '#write_to_header' do
    let(:index) { 1 }
    let(:value) { 'new value' }

    it 'change value of specified header' do
      subject.write_to_header(index, value)

      expect(subject.header[index]).to eq value
    end

    context 'when column of out range' do
      let(:index) { 2 }

      it 'raise error' do
        expect { subject.write_to_header(index, value) }.to raise_error(RuntimeError, 'Столбец с таким индексом не существует')
      end
    end
  end

  describe '#write_to_headers' do
    let(:value) { 'new value' }

    it 'write values to each header cell' do
      subject.write_to_headers("#{value} 1", "#{value} 2")

      subject.header.each_with_index do |header, index|
        expect(header).to eq "#{value} #{index + 1}"
      end
    end

    context 'when count of values is not equal to count of cells' do
      it 'raise error' do
        expect { subject.write_to_headers('new value') }.to raise_error(RuntimeError, 'Не совпадает число записываемых значений с числом столбцов')
      end
    end
  end

  describe 'write_to_cell' do
    let(:row_index) { 2 }
    let(:column_index) { 1 }
    let(:value) { 'new_value' }

    it 'write value to specified cell' do
      subject.write_to_cell(row_index, column_index, value)

      expect(subject.table[row_index][column_index]).to eq value
    end

    context 'when row of out range' do
      it 'raise error' do
        expect { subject.write_to_cell(3, 2, value) }.to raise_error(RuntimeError, 'Строка с таким индексом не существует')
      end
    end

    context 'when column out of range' do
      it 'raise error' do
        expect { subject.write_to_cell(2, 3, value) }.to raise_error(RuntimeError, 'Столбец с таким индексом не существует')
      end
    end
  end

  describe '#write_to_row' do
    let(:row_index) { 1 }
    let(:value) { 'new value' }

    it 'write value to each cell in specified row' do
      subject.write_to_row(row_index, "#{value} 1", "#{value} 2")

      subject.table[row_index].each_with_index do |cell, index|
        expect(cell).to eq "#{value} #{index + 1}"
      end
    end

    context 'when count of values is not equal to count of cells' do
      it 'raise error' do
        expect { subject.write_to_row(3, "#{value} 1", "#{value} 2") }.to raise_error(RuntimeError, 'Строка с таким индексом не существует')
      end
    end

    context 'when count of values is not equal to count of cells' do
      it 'raise error' do
        expect { subject.write_to_row(row_index, "#{value} 1") }.to raise_error(RuntimeError, 'Не совпадает число записываемых значений с числом столбцов')
      end
    end
  end

  describe '#to_s' do
    let(:result) do
      rows = subject.table.map { |columns| columns.join(' | ') }
      subject.header.join(' | ') + "\n" + subject.break_line.join(' | ') + "\n" + rows.join("\n")
    end

    it 'returns string with markdowned table' do
      expect(subject.to_s).to eq result
    end
  end
end
