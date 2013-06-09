#pragma D option quiet
#pragma D option switchrate=10000hz

BEGIN
{
	/* from /usr/include/sys/fcntl.h */
	fd[0] = 	"F_DUPFD";
	fd[1] = 	"F_GETFD";
	fd[2] = 	"F_SETFD";
	fd[3] = 	"F_GETFL";
	fd[4] = 	"F_SETFL";
	fd[5] = 	"F_GETOWN";
	fd[6] = 	"F_SETOWN";
      	fd[7] = 	"F_GETLK";
      	fd[8] = 	"F_SETLK";
      	fd[9] = 	"F_SETLKW";
      	fd[40] = 	"F_FLUSH_DATA";
       	fd[41] = 	"F_CHKCLEAN";
        fd[42] = 	"F_PREALLOCATE";
       	fd[43] = 	"F_SETSIZE";
       	fd[44] = 	"F_RDADVISE";
       	fd[45] = 	"F_RDAHEAD";
       	fd[46] = 	"F_READBOOTSTRAP";
       	fd[47] = 	"F_WRITEBOOTSTRAP";
       	fd[48] = 	"F_NOCACHE";
       	fd[49] = 	"F_LOG2PHYS";
       	fd[50] = 	"F_GETPATH";
       	fd[51] = 	"F_FULLFSYNC";
       	fd[52] = 	"F_PATHPKG_CHECK";
       	fd[53] = 	"F_FREEZE_FS";
       	fd[54] = 	"F_THAW_FS";
       	fd[55] =	"F_GLOBAL_NOCACHE";
	fd[59] = 	"F_ADDSIGS";
	fd[60] = 	"F_MARKDEPENDENCY";
	fd[61] = 	"F_ADDFILESIGS";
	fd[62] = 	"F_NODIRECT";
	fd[63] = 	"F_GETPROTECTIONCLASS";
	fd[64] = 	"F_SETPROTECTIONCLASS";
	fd[65] = 	"F_LOG2PHYS_EXT";
	fd[66] = 	"F_GETLKPID";
	fd[67] = 	"F_DUPFD_CLOEXEC";
	fd[70] = 	"F_SETBACKINGSTORE";
	fd[71] = 	"F_GETPATH_MTMINFO";
	fd[73] = 	"F_SETNOSIGPIPE";
	fd[74] = 	"F_GETNOSIGPIPE";
	fd[75] = 	"F_TRANSCODEKEY";
	fd[76] = 	"F_SINGLE_WRITER";
	fd[77] = 	"F_GETPROTECTIONLEVEL";
}

syscall::pread:entry,
syscall::read:entry,
syscall::readv:entry
{
	printf("read");
}

syscall::pwrite:entry,
syscall::write:entry,
syscall::writev:entry
{
	printf("write");
}

syscall::open:entry
{
	printf("open");
}

syscall::close:entry
{
	printf("close");
}

syscall::fsync:entry
{
	printf("fsync");
}

syscall::fcntl:entry
/ fd[arg1] != NULL /
{
	printf("fcntl %s", fd[arg1]);
}
