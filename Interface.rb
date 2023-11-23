require "curses"
require_relative "Parser.rb"
require_relative "Lexer.rb"
require_relative "Token.rb"
require_relative "Model.rb"
include Curses
include ParserModule
include Lexer
include Tokens
include Model

# init 3 screens and constants
begin
    init_screen
    noecho
    crmode

    # constants
    EDITOR_LINES = 3                                    # height of the editor_window
    GRID_LINES = (lines - EDITOR_LINES) / 3 * 3 + 2     # height of the grid_window
    CELL_NUM_COLS = ((cols - 1)/10)                     # number of cells in a row; used for rendering calculations
    CELL_HEIGHT = 3                                     # number of lines per cell; used for rendering calculations
    CELL_WIDTH = 10                                     # number of cols  per cell; used for rendering calculations
    CONTENTS_MAX_LEN = 6                # max normally displayed chars in a cell; used for rendering cell contents variably
    CELL_MAX_LEN = 9                    # max total displayed chars in a cell;    used for rendering cell contents variably
    MIN_LINE = 5            # minimum cell y value in the window; used for out-of-bounds checks when navigating the grid
    MIN_COL = 1             # minumum cell x value in the window; used for out-of-bounds checks when navigating the grid

    # variables
    cur_line = 5        # starting line of the [0,0] cell
    cur_col = 1         # starting col of the [0,0] cell
    cur_char = -1       # invalid cur_char placeholder
    cur_address = [0,0] # x, y coords; inverted from how curses deals with it
    cur_contents = ""   # contents of [0,0] is empty at init
    grid = Grid.new     # grid + enviornment declaration
    env = Environment.new(grid)

    # Make grid parent window & the editor subwindow
    GRID_WINDOW = Window.new(lines, cols, 0, 0);
    EDITOR_WINDOW = GRID_WINDOW.subwin(EDITOR_LINES, cols, 0, 0)
    
    # Input Key Constants; fuck curses' constants
    BACKSPACE = 8
    ENTER = 10
    ESCAPE = 27
end

# Runtime loop
begin
    # ========================================================== Grid Render | Start
    for i in EDITOR_LINES + 1...GRID_LINES
        if i - 1 == EDITOR_LINES        # top row
            GRID_WINDOW.setpos(i, 0)
            GRID_WINDOW.addch('┌')
            GRID_WINDOW.setpos(i, 1)
            GRID_WINDOW.addstr('─────────┬'*CELL_NUM_COLS)
            GRID_WINDOW.setpos(i, CELL_NUM_COLS*CELL_WIDTH)
            GRID_WINDOW.addch('┐')
            
        elsif i + 1 == GRID_LINES       # bottom row
            GRID_WINDOW.setpos(i, 0)
            GRID_WINDOW.addch('└')
            GRID_WINDOW.setpos(i, 1)
            GRID_WINDOW.addstr('─────────┴'*CELL_NUM_COLS)
            GRID_WINDOW.setpos(i, CELL_NUM_COLS*CELL_WIDTH)
            GRID_WINDOW.addch('┘')
            
        elsif (i-1) % 3 == 0            # all intermediate deliniator rows
            GRID_WINDOW.setpos(i, 0)
            GRID_WINDOW.addch('├')
            GRID_WINDOW.setpos(i, 1)
            GRID_WINDOW.addstr('─────────┼'*CELL_NUM_COLS)
            GRID_WINDOW.setpos(i, CELL_NUM_COLS*CELL_WIDTH)
            GRID_WINDOW.addch('┤')

        else                            # all column-only rows
            GRID_WINDOW.setpos(i, 0)
            GRID_WINDOW.addch('│')
            GRID_WINDOW.setpos(i, 1)
            GRID_WINDOW.addstr('         │'*CELL_NUM_COLS)
        end
    end
    GRID_WINDOW.refresh
    # ========================================================== Grid Render | End

    while cur_char != ESCAPE                                # Grid Window Loop
        
        # ======================================================= Match display with Grid contents | Start

        GRID_WINDOW.setpos(cur_line, cur_col)                   # enter current cell
        GRID_WINDOW.addstr(' '*9)                               # clear cell contents before attempting to update
        GRID_WINDOW.refresh                                     # update grid window

        EDITOR_WINDOW.setpos(0, 0)                              # Enter editor window
        EDITOR_WINDOW.clear                                     # clear editor window before attempting to update
        EDITOR_WINDOW.refresh                                   # update editor window

        if grid.retrieve(cur_address) != nil                    # if there is cell contents
            EDITOR_WINDOW.addstr(grid.retrieve(cur_address))    # display cell contents in the editor window
            EDITOR_WINDOW.refresh                               # update editor window

            GRID_WINDOW.setpos(cur_line, cur_col)               # enter current cell
            for i in 0...CELL_MAX_LEN                           # up to 9 chars displayed total
                if grid.retrieve(cur_address)[i] != nil         # if there is a char to print
                    if (i < CONTENTS_MAX_LEN)                   # display first 6 chars normally
                        GRID_WINDOW.addch(grid.retrieve(cur_address)[i])
                    else                                        # mask last 3 chars as '.' to show that
                        GRID_WINDOW.addch('.')                  #   not all contents are being displayed
                    end
                end
            end
        end

        # ======================================================= Match display with Grid contents | End

        GRID_WINDOW.setpos(cur_line, cur_col)               # set cursor position
        cur_char = GRID_WINDOW.getch                        # wait for input

        # =================================================== Edit Cell Contents | Start
        
        if cur_char == ENTER
            flash                                           # flash for visual change indication
            GRID_WINDOW.setpos(cur_line + 1, cur_col + 8)   # set cursor to the bottom right of the cell
            GRID_WINDOW.addch('X')                          # put marker to indicate current cell
            GRID_WINDOW.setpos(cur_line, cur_col)           # set cursor to top left of the cell
            GRID_WINDOW.refresh
            EDITOR_WINDOW.setpos(0, 0)                      # set cursor into the editor window

            cur_char = -1                                   # set cur_char so that its able to enter the editor loop
            if grid.retrieve(cur_address) != nil            # update cur_contents to match current cell
                cur_contents = grid.retrieve(cur_address)
                EDITOR_WINDOW.addstr(grid.retrieve(cur_address))
            else
                cur_contents = ''
            end

            while cur_char != ESCAPE && cur_char != ENTER   # Editor Window Loop
                cur_char = EDITOR_WINDOW.getch
                if cur_char == BACKSPACE                    # branch for backspace
                    if (cur_contents.length != 0)           # stagger this if statement to prevent errors
                        cur_contents[-1] = ""
                        EDITOR_WINDOW.clear
                        EDITOR_WINDOW.addstr(cur_contents)
                    end

                elsif cur_char == ENTER
                    flash
                    grid.place(cur_address, cur_contents)           # update grid hashmap
                    cur_contents = ''
                    EDITOR_WINDOW.clear                             # wipe window so user doesnt get confused
                    EDITOR_WINDOW.refresh                           # update so clear is visible
                
                elsif cur_char != ESCAPE
                    cur_contents += cur_char
                    EDITOR_WINDOW.addch(cur_char)

                end
            end

            GRID_WINDOW.setpos(cur_line, cur_col)           # set cursor to top left of the cell

        # =================================================== Edit Cell Contents | End

        # =================================================== Navigate Cells (with wasd) | Start

        elsif cur_char == 'w'
            GRID_WINDOW.setpos(cur_line + 1, cur_col + 8)       # set to bottom right of the cell
            GRID_WINDOW.addch(' ')                              # clear marker to indicate current cell

            if cur_line - CELL_HEIGHT >= MIN_LINE               # if nav up is inbounds
                cur_line -= CELL_HEIGHT                         # update cur_line
                cur_address[1] -= 1                             # update cur_address y (lines) value
            end
            GRID_WINDOW.setpos(cur_line, cur_col)               # set cursor to top left of the (possibly) NEW cell

        elsif cur_char == 's'
            GRID_WINDOW.setpos(cur_line + 1, cur_col + 8)       # set to bottom right of the cell
            GRID_WINDOW.addch(' ')                              # clear marker to indicate current cell

            if cur_line + CELL_HEIGHT <= lines - CELL_HEIGHT    # if nav down is inbounds
                cur_line += CELL_HEIGHT                         # update cur_line
                cur_address[1] += 1                             # update cur_address y (lines) value
            end
            GRID_WINDOW.setpos(cur_line, cur_col)               # set cursor to top left of the (possibly) NEW cell

        elsif cur_char == 'a'
            GRID_WINDOW.setpos(cur_line + 1, cur_col + 8)       # set to bottom right of the cell
            GRID_WINDOW.addch(' ')                              # clear marker to indicate current cell

            if cur_col - CELL_WIDTH >= MIN_COL                  # if nav left is inbounds
                cur_col -= CELL_WIDTH                           # update cur_col
                cur_address[0] -= 1                             # update cur_address x (cols) value
            end
            GRID_WINDOW.setpos(cur_line, cur_col)               # set cursor to top left of the (possibly) NEW cell

        elsif cur_char == 'd'
            GRID_WINDOW.setpos(cur_line + 1, cur_col + 8)       # set to bottom right of the cell
            GRID_WINDOW.addch(' ')                              # clear marker to indicate current cell

            if cur_col + CELL_WIDTH <= cols - CELL_WIDTH        # if nav right is inbounds
                cur_col += CELL_WIDTH                           # update cur_col
                cur_address[0] += 1                             # update cur_address x (cols) value
            end
            GRID_WINDOW.setpos(cur_line, cur_col)               # set cursor to top left of the (possibly) NEW cell
            
        end
        # =================================================== Navigate Cells (with wasd) | End
    end

ensure
    close_screen
end