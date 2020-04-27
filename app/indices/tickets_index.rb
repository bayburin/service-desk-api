ThinkingSphinx::Index.define :ticket, with: :active_record, delta: true do
  indexes name, sortable: true
  indexes tags.name, as: :tag_name

  has popularity, type: :integer
  # has ticket_type, type: :integer

  where 'ticket_type != 3'
end
