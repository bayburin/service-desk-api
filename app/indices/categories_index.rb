ThinkingSphinx::Index.define :category, with: :active_record, delta: true do
  indexes name, sortable: true
  indexes short_description

  has popularity, type: :integer
end
