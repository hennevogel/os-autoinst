#!/usr/bin/perl -w

###########################################################
# Test Case:	1248950
# Case Summary: Firefox: Test firefox tabbed brower windows
# Written by:	wnereiz@github
###########################################################

# Needle Tags:
# test-firefox-1
# firefox_pre-general
# test-firefox_tab-1, test-firefox_tab-2, test-firefox_tab-3
# test-firefox_tab-4, test-firefox_tab-5

# NOTE: Some actions in this case can not be implemented.
# For example, click and drag. So they are not included.

use strict;
use base "basetest";
use bmwqemu;

sub run()
{
    my $self=shift;
    mouse_hide();

    # Launch firefox
    x11_start_program("firefox");
    waitforneedle("test-firefox-1",5);
    if($ENV{UPGRADE}) { sendkey("alt-d");waitidle; } # Don't check for updated plugins
    if($ENV{DESKTOP}=~/xfce|lxde/i) {
        sendkey "ret"; # Confirm default browser setting popup
        waitidle;
    }

    # Opening a new Tabbed Browser.
    sendkey "alt-f"; sendkey "ret"; # Open a new tab by menu
    sendkey "ctrl-t"; # Open a new tab by hotkey
    sleep 2;
    checkneedle("test-firefox_tab-1",5); sleep 2;
    sendkey "ctrl-w"; sendkey "ctrl-w"; # Restore to one tab (Home Page)

    # Confirm that the various menu items pertaining to the Tabbed Browser exist
    # Confirm the page title and url.
    sendkey "apostrophe"; sleep 1;
    sendautotype "news"; sendkey "esc"; sleep 1; # Find News link
    sendkey "menu"; sleep 1; # Use keyboard to simulate right click the link
    sendkey "down"; sendkey "ret"; # "Open link in the New Tab"
    sleep 10;
    sendkey "alt-2"; # Switch to the new opened tab
    checkneedle("test-firefox_tab-2",5);
    sendkey "ctrl-w"; # Restore to one tab (Home Page)

    # Test secure sites
    sendkey "ctrl-t"; sleep 1;
    sendkey "alt-d"; sleep 1;
    sendautotype "http://mozilla.org/\n"; sleep 10; # A non-secure site (http) 
    checkneedle("test-firefox_tab-3",5);

    sendkey "ctrl-t"; sleep 1;
    sendkey "alt-d"; sleep 1;
    sendautotype "https://digitalid.verisign.com/\n"; sleep 10; # A secure site (https) 
    checkneedle("test-firefox_tab-4",5);

    sendkey "ctrl-w"; sendkey "ctrl-w"; # Restore to one tab (Home Page)

    # Confirm default settings
    sendkey "alt-e";
    sendkey "n"; # Open Preferences
	checkneedle("firefox_pre-general",5);
    sleep 5;
    sendkey "right"; sleep 2; # Switch to the "Tabs" tab
    checkneedle("test-firefox_tab-5",5); sleep 2;

    sendkey "left";
    sendkey "esc"; # Restore

    # Restore and close firefox
    sendkey "ctrl-w";
	sendkey "ret"; # confirm "save&quit"
    sleep 2; 
     
}   

1;
