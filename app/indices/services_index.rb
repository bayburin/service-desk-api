ThinkingSphinx::Index.define :service, with: :active_record, delta: true do
  indexes name, sortable: true
  indexes short_description

  has popularity
end
