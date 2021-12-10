class Controller
  def initialize
    @parents = []
  end

  def seed
    @parents << Parent.new
  end

  def start
    loop do
      puts "Введите команду:\n
  1. Создать Paren\n
  2. Добавить ребенка"
      command = gets.to_i
      case command
      when 1
        create_parent
      when 2
        add_child
      when 0
        exit!
      end
    end
  end

  private

  def create_parent
    @parents << Parent.new
  end

  def add_child
    @parents.each.with_index(1) do |i, parent|
      puts "#{i}: #{parent.name}"
    end

    puts 'Выберите родителя'
  end
end

ctrl = Controller.new
ctrl.start