#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;

###### Settings ######
my $game = "css";
my $path_servers = "/srv/gs/$game/active";
my $start_file = "run.sh";
my @servers = glob "$path_servers/*";


sub start
{
    print "Make initial tmux session for servers\n";
    system("tmux new-session -s $game -d");
    sleep(2);

    foreach my $server (@servers) {
        my $name = basename($server);
        print "Starting $name\n";
        system("tmux new-window -a -n $name -t $game -P \"cd $server; ./$start_file\"");
    }
    print "All servers are started\n";
}


sub stop
{
    print "Killing all servers!";
    system("tmux kill-session -t $game");
}


sub restart
{
    print "Restarting all servers!";
    &stop();
    &start();
}


sub status
{
    #implement smart cool shit
}


sub usage
{
    #implement smart cool shit
}
