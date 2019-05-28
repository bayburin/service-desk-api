FactoryBot.define do
  factory :answer_attachment do
    answer { create(:answer) }
    document { Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec', 'uploads', 'test_file.txt'))) }
  end
end
