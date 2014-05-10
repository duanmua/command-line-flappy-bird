#COMMAND LINE FLAPPY BIRD
require 'curses'
require 'io/wait'

REFRESH_RATE = 0.1
COLUMNS = 60
ROWS = 20
SPACE = 3
SPACE_BETWEEN_PIPES = 15
BIRD_POSITION = 20
GRAVITY = 0.5
FLAP = -1.3

class Pipe
  def initialize
    bottom = 1 + rand(ROWS-4)
    @positions = []
    for i in 0..ROWS-1
      @positions << i if i < bottom || i > bottom + SPACE
    end
  end

  def positions
    return @positions
  end
end

class Bird
  def initialize
    @height = (ROWS/2).to_f
    @velocity = 0.to_f
    @gravity = GRAVITY
  end

  def update
    @velocity += @gravity/2
    @height += @velocity
    @velocity += @gravity/2
    if @height < 0.0
      @height = 0.0
      @velocity = 0.0
    elsif @height > ROWS - 1
      @height = (ROWS - 1).to_f
      @velocity = @gravity/2
    end
  end
  
  def flap
    @velocity = FLAP
  end

  def position
    return @height.round
  end
end

class Map
  def initialize(bird)
    @bird = bird
    @iteration = 0
    @pipes = []
  end
 
  def update
    @pipes[0] = nil
    for i in 1..COLUMNS-1
      if @pipes[i]
        @pipes[i-1] = @pipes[i]
        @pipes[i] = nil
      end
    end
    if @iteration % SPACE_BETWEEN_PIPES == 0
      @pipes[COLUMNS-1] = Pipe.new
      @iteration = 0
    end
    @iteration += 1
    @bird.update
    return @pipes[BIRD_POSITION] && @pipes[BIRD_POSITION].positions.include?(@bird.position)
  end

  def draw
    for row in 0..ROWS-1
      for column in 0..COLUMNS-1
        Curses.setpos(row, column)
        if @pipes[column] && @pipes[column].positions.include?(row)
          Curses.addch('|') 
        else
          Curses.addch(' ')
        end
        if column == BIRD_POSITION
          Curses.setpos(@bird.position, column)
          Curses.addch('@')
        end
      end
    end
    Curses.refresh
  end
end

class Game
  def initialize
    STDOUT.sync = true
    Curses::timeout = 25
    Curses.noecho
    Curses.init_screen
    @bird = Bird.new
    @map = Map.new(@bird)
  end

  def end_game
    Curses.setpos(@bird.position, BIRD_POSITION)
    Curses.addch('*')
    Curses.refresh
    sleep 1000
  end

  def run
    while true
      c = Curses.getch
      @bird.flap if c
      collision = @map.update
      @map.draw
      end_game if collision
      sleep REFRESH_RATE
    end
  end
end

Game.new.run
