namespace :reports do
  desc 'Создать xls файл со списком всех вопросов и списком ответственных'
  task question_list: :environment do
    questions = Question.includes(:answers, ticket: [:responsible_users, :tags, :service])

    tns = []
    questions.find_each { |q| q.responsible_users.each { |u| tns << u.tn } }
    tns = tns.uniq
    data = Api::V1::Employees::Employee.new(:exact).load_users(tns: tns)
    users = data ? data['data'].map { |detail| Api::V1::UserDetails.new(detail) } : []

    CSV.open(Rails.root.join('report.csv').to_s, 'w:UTF-8', col_sep: '|') do |file|
      file << %w[Услуга Отдел Вопрос Ответы Теги]
      questions.find_each do |q|
        # Ответы
        answers = q.answers.map(&:answer)
        # Теги
        tags = q.tags.map(&:name)
        # Список ответственных
        user_info = users.select { |u| q.responsible_users.map(&:tn).include?(u.tn) }
        # Отдел
        dept = (%w[712 713 714 715 821] & tags).first || (user_info.any? ? user_info.first.dept : '')
        user_info.map!(&:full_name)
        # Услуга, вопрос, теги
        result = [q.service.name, dept.to_i, q.ticket.name, answers.join("\n\n\n"), tags.join(', ')]
        result += user_info

        file << result
      end
    end
  end
end
