TARGET = minishell
CC = clang
# CFLAGS =  -Wunreachable-code -I/usr/include
MINIFLAGS = -lreadline -L/usr/lib/x86_64-linux-gnu

# READLINE = $(shell brew --prefix readline)
# CFLAGS = -Wall -Wextra -Werror -I$(READLINE)/include
# MINIFLAGS =  -lreadline -L$(READLINE)/lib -g -Wl,-no_pie

SRCS=	$(TARGET).c \
	minishell_utils.c \
	./parsing/cwd.c \
	./parsing/env_init.c \
	./parsing/env_parse.c \
	./parsing/strtok.c \
	./parsing/ft_handles.c \
	./parsing/utils.c \
	./parsing/free.c \
	./parsing/tokens.c \
	./parsing/printers.c \
	./parsing/parser.c \
	./parsing/varexp.c \
	./parsing/nodes.c \
	./parsing/expanding_utils.c \
	./parsing/heredoc_exp.c \
	./parsing/redirection.c \
	./execution/execution.c \
	./execution/get_next_line.c \
	./execution/get_path.c \
	./execution/set_env.c \
	./execution/heredoc.c \
	./execution/struct_cpy.c \

RM = rm -rf
NAME = $(TARGET).a
OBJS = $(SRCS:.c=.o)
HEADER = $(TARGET).h
LIBFT = ./libft/libft.a

DEF_COLOR = \033[0;39m
GRAY = \033[0;90m
RED = \033[0;91m
GREEN = \033[1;92m
YELLOW = \033[1;93m
BLUE = \033[1;94m
MAGENTA = \033[0;95m
CYAN = \033[0;96m
WHITE = \033[0;97m

all: $(TARGET)

$(TARGET): $(NAME) $(HEADER) $(LIBFT)
	@echo "$(BLUE)Making $(TARGET) ...$(DEF_COLOR)"
	@${CC} ${CFLAGS} -o $(TARGET) $(TARGET).c $(NAME) $(LIBFT) ${MINIFLAGS}
	@echo "$(RESET)"
	@echo "$(YELLOW)  ███╗   ███╗██╗███╗   ██╗██╗███████╗██╗  ██╗███████╗██╗     ██╗"
	@echo "$(YELLOW)  ████╗ ████║██║████╗  ██║██║██╔════╝██║  ██║██╔════╝██║     ██║"
	@echo "$(YELLOW)  ██╔████╔██║██║██╔██╗ ██║██║███████╗███████║█████╗  ██║     ██║"
	@echo "$(YELLOW)  ██║╚██╔╝██║██║██║╚██╗██║██║╚════██║██╔══██║██╔══╝  ██║     ██║"
	@echo "$(YELLOW)  ██║ ╚═╝ ██║██║██║ ╚████║██║███████║██║  ██║███████╗███████╗███████╗"
	@echo "$(YELLOW)  ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝"
	@echo "$(RESET)"
	@echo "$(GREEN)\n==The Executable of [$(TARGET)] has been compiled!==\n$(DEF_COLOR)"
	@echo "$(YELLOW)\n=> Usage: ./$(TARGET)\n$(DEF_COLOR)"

$(NAME): $(OBJS)
	@echo "$(BLUE)Archiving the Library $(NAME) ...$(DEF_COLOR)"
	@ar rcs $(NAME) $^

%.o: %.c $(HEADER)
	@echo "$(GREEN)Compiling $< ...$(DEF_COLOR)"
	@${CC} ${CFLAGS} -c $< -o $@

$(LIBFT):
	@echo "$(BLUE)Compiling the Library LIBFT ...$(DEF_COLOR)"
	@make -C ./libft
	@sleep 1

clean:
	@echo "$(MAGENTA)Cleaning minishell objects ...$(DEF_COLOR)"
	@$(RM) $(OBJS)
	@make -C ./libft clean
	@echo "$(MAGENTA)Cleaning libft objects ...$(DEF_COLOR)"

fclean: clean
	@echo "$(RED)Cleaning $(LIBFT) ...$(DEF_COLOR)"
	@echo "$(RED)Cleaning $(NAME) and $(TARGET) ...$(DEF_COLOR)"
	@$(RM) $(NAME) $(TARGET)
	@make -C ./libft fclean
	@rm -rf minishell.dSYM/

re: fclean all

.PHONY: all clean fclean re
