#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>

/*
int Socket(int family, int type, int protocol);
void Bind(int sockfd, const struct sockaddr * socketaddr, socklen_t addrlen);
void Listen(int sockfd, int backlog);
int Accept(int sockfd, struct sockaddr* cliaddr, socklen_t *addrlen);
*/

int Socket(int family, int type, int protocol)
{
	int result = 0;
	result = socket(family, type, protocol);
	if (result == -1)
	{
		printf("Socket Contructing Error\n");
		exit(0);
	}
	return result;
}



void Bind(int sockfd, const struct sockaddr * socketaddr, socklen_t addrlen)
{
	int result = 0;
	result = bind(sockfd, socketaddr, addrlen);
	if (result == -1)
	{
		printf("Socket Binding Error\n");
		exit(0);
	}
	else
	{
		printf("Success Binding\n");
	}
	
}
void Listen(int sockfd, int backlog)
{
	int result = 0;
	result = listen(sockfd, backlog);
	if (result == -1)
	{
		printf("Listening Error\n");
		exit(0);
	}
	else
	{
		printf("Success Listening\n");
	}
}

int Accept(int sockfd, struct sockaddr* cliaddr, socklen_t *addrlen)
{
	int result = 0;
	result = accept(sockfd, cliaddr, addrlen); 
	if (result == -1)
	{
		printf("Accept Error\n");
		exit(0);
	}
	else
	{
		printf("Success Accept\n");
	}
	return result;
}
