#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;

###### Settings ######
my $game = "css";
my $path_servers = "/srv/gs/$game/active";
my $start_file = "run.sh";
my @servers = glob "$path_servers/*";
my @servers_names = map(basename($_), @servers);
my @allowed_options = ("start", "stop", "restart", "status");

sub main
{
    if ($#ARGV != 1 or !(grep $_ eq $ARGV[0], @allowed_options)) {
        &usage();
    } else {
        if ($ARGV[0] eq "start") {
            if ($ARGV[1] eq "all") {
                &start($ARGV[1]);
            #I have read that this is highly bad practice.
            } elsif (grep $_ eq $ARGV[1], @servers_names) {
                &start($ARGV[1]);
            } else {
                print "You gave me a wrong name you dick\n";
                &usage();
            }
        }
        if ($ARGV[0] eq "stop") {
            if ($ARGV[1] eq "all") {
                &stop($ARGV[1]);
            #I have read that this is highly bad practice.
            } elsif (grep $_ eq $ARGV[1], @servers_names) {
                &stop($ARGV[1]);
            } else {
                print "You gave me a wrong name you dick\n";
                &usage();
            }
        }
        if ($ARGV[0] eq "restart") {
            if ($ARGV[1] eq "all") {
                &restart($ARGV[1]);
            #I have read that this is highly bad practice.
            } elsif (grep $_ eq $ARGV[1], @servers_names) {
                &restart($ARGV[1]);
            } else {
                print "You gave me a wrong name you dick\n";
                &usage();
            }
        }
        if ($ARGV[0] eq "status") {
            if ($ARGV[1] eq "all") {
                &status($ARGV[1]);
            #I have read that this is highly bad practice.
            } elsif (grep $_ eq $ARGV[1], @servers_names) {
                &status($ARGV[1]);
            } else {
                print "You gave me a wrong name you dick\n";
                &usage();
            }
        }
    }
}

sub start
{
    my $arg = shift;
    if ($arg eq "all") {
        print "Make initial tmux session for servers\n";
        system("tmux new-session -s $game -d");
        sleep(2);

        foreach my $server (@servers) {
            my $name = basename($server);
            print "Starting $name\n";
            system("tmux new-window -a -n $name -t $game -P \"cd $server; ./$start_file\"");
        }
        print "All servers are started\n";
    
    } else {
        print "Starting $arg\n";
        system("tmux new-window -a -n $arg -t $game -P \"cd $path_servers/$arg; ./$start_file\"");
        print "Started $arg\n";
    }
}


sub stop
{
    my $arg = shift;
    if ($arg eq "all") {
        print "Killing all servers!\n";
        system("tmux kill-session -t $game");
    } else {
        print "Stoping $arg\n";
        #TODO
        system("tmux new-window -a -n $arg -t $game -P \"cd $path_servers/$arg; ./$start_file\"");
        print "Stopped $arg\n";
    }
}


sub restart
{
    my $arg = shift;
    if ($arg eq "all") {
        print "Restarting all servers!\n";
        &stop($arg);
        &start($arg);
        print "All servers are now restarted\n";
    } else {
        print "Restarting $arg\n";
        &stop($arg);
        &start($arg);
        print "Restarted $arg\n";
    }
}


sub status
{
    #implement smart cool shit
    print "NOT YET IMPLEMENTED EXCEPTION LOL\n";
}


sub usage
{
    print "Usage: manage.pl [start | stop | restart | status] [all | servername]\n"
}

&main()
