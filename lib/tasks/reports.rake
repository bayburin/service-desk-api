namespace :reports do
  desc 'Создать xls файл со списком всех вопросов и списком ответственных'
  task question_list: :environment do
    questions = Ticket.where(ticket_type: :question).includes(:responsible_users, :tags, :service)

    tns = []
    questions.find_each { |q| q.responsible_users.each { |u| tns << u.tn } }
    tns = tns.uniq
    data = Api::V1::Employees::Employee.new(:exact).load_users(tns: tns)
    users = data ? data['data'].map { |detail| Api::V1::UserDetails.new(detail) } : []

    CSV.open(Rails.root.join('report.csv').to_s, 'w:UTF-8', col_sep: '|') do |file|
      file << %w[Услуга Вопрос Теги]
      questions.find_each do |q|
        # Теги
        tags = q.tags.map(&:name).join(', ')
        # Услуга, вопрос, теги
        result = [q.service.name, q.name, tags]
        # Список ответственных
        user_info = users.select { |u| q.responsible_users.map(&:tn).include?(u.tn) }.map!(&:full_name)
        result += user_info

        file << result
      end
    end
  end
end
