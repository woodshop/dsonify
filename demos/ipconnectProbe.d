/* Adapted from soconnect.d from http://www.dtracebook.com/ */
#pragma D option quiet
#pragma D option switchrate=10000hz

inline int af_inet = 2;		/* AF_INET defined in bsd/sys/socket.h */
inline int af_inet6 = 30;	/* AF_INET6 defined in bsd/sys/socket.h */

syscall::connect*:entry
{
	/* assume this is sockaddr_in until we can examine family */
	this->s = (struct sockaddr_in *)copyin(arg1, sizeof (struct sockaddr_IN));
	this->f = this->s->sin_family;
}

syscall::connect*:entry
/this->f == af_inet/
{
	/* Convert port to host byte order without ntohs() being available. */
	self->port = (this->s->sin_port & 0xFF00) >> 8;
	self->port |= (this->s->sin_port & 0xFF) << 8;
        self->start = 1;
}

syscall::connect*:return
/self->start/
{
	printf("ipconnect %d", self->port);
	self->port = 0;
	self->start = 0;
}