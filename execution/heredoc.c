/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   heredoc.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ymouchta <ymouchta@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/05/13 22:22:28 by ymouchta          #+#    #+#             */
/*   Updated: 2025/05/28 21:16:08 by ymouchta         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../minishell.h"

bool    herdoc_read(t_cmd *tmp, char *dlm)
{
    // int fd;
    char *line;

    // fd = open(HEREDOC_FILE , O_CREAT | O_TRUNC | O_RDWR , 0600);
    // if(fd == -1)
    //     return(perror(""), false);
    dlm = ft_strjoin(dlm , "\n");
    if(!dlm)
        return(perror(""), false);
    while(1)
    {
        ft_putstr_fd("> ", 1);
        line  = get_next_line(STDIN_FILENO);
        if(!line)
            return(perror(""), false);
        if(!ft_strcmp(line , dlm))
            break;
        else
            ft_putstr_fd(line, tmp->fd_herdoc[1]);
        free(line);
    }
    free(line);
    free(dlm);
    close(tmp->fd_herdoc[0]);
    close(tmp->fd_herdoc[1]);
    // while(1);
    return(true);
}

bool    fork_heredoc(t_cmd *tmp, char *delimiter)
{
    int fork_pid;

    fork_pid = fork();
    if(fork_pid  < 0)
        return(perror(""), false);
    if(fork_pid == 0)
    {
        if(!herdoc_read(tmp, delimiter))
            exit(1);
        exit(0);
    }
    if(fork_pid > 0)
    {
        close(tmp->fd_herdoc[1]);
        waitpid(fork_pid, NULL, 0);
    }
    return(true);
}

bool   ft_herdoc(t_shell *val)
{
    t_cmd *tmp;
    t_redirec *redc;

    tmp = val->list;
    while(tmp)
    {
        redc = tmp->redirec;
        while(redc)
        {
            if(redc->type == D_HERDOC)
            {
                printf("herdoc: %s\n", redc->name);
                pipe(tmp->fd_herdoc);
                if(!fork_heredoc(tmp, redc->name))
                    return(perror(""), false);
            }
            redc = redc->next;
        }
        tmp = tmp->next;
    }
    return(true);
}