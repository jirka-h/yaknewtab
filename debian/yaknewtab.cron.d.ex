#
# Regular cron jobs for the yaknewtab package
#
0 4	* * *	root	[ -x /usr/bin/yaknewtab_maintenance ] && /usr/bin/yaknewtab_maintenance
