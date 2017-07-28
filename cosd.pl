use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '1.0.0';
%IRSSI = (
        authors     => 'Chris "Ceiu" Rog',
        contact     => 'ceiu@cericlabs.com',
        name        => 'c-osd',
        description => 'An OSD script for displaying popups on private messages and public mentions',
        url         => 'n/a',
        license     => 'BSD',
        changed     => '$Date: 2017-07-25 12:24:00 -0600 (Tue, 25 Jul 2017) $'
);

#---------------------------------------------------------------------------------------------------
# Based on kdialog by Ondrej Skopek (skopekondrej@gmail.com)
# https://gist.github.com/oskopek/9566780
#---------------------------------------------------------------------------------------------------

# TODO: Add some configuration bits so we can toggle whether or not we want the improved nick
# detection active (and generating more popups)


#---------------------------------------------------------------------------------------------------
# Signal handlers
#---------------------------------------------------------------------------------------------------

sub on_print_text {
    my ($dest, $message, $stripped) = @_;

    # If the message is highlighted, display a notice
    if ($dest->{level} & MSGLEVEL_HILIGHT) {
        osd_show("Mention in $dest->{target}", $stripped);
    }
    elsif ($dest->{level} & MSGLEVEL_PUBLIC) {
        # The default nick-based highlighting is somewhat unreliable. Check if our nick is actually
        # present in the message
        my $server = $dest->{server};
        my $nick = $server->{nick};

        # If we see a message we didn't send that includes our nick, generate a notification
        if ($stripped =~ /\A<\s*[~&@%+]?([a-z_\-\[\]\\^{}|`][a-z0-9_\-\[\]\\^{}|`]*)>\s(.*)\z/i) {
            my ($sender, $text) = ($1, $2);

            if ($sender ne $nick && $text =~ /(\A|\W)\Q$nick\E(\z|\W)/i) {
                osd_show("Mention in $dest->{target}", $stripped);
            }
        }
    }
}

sub on_private_message {
    my ($server, $message, $sender, $address) = @_;

    osd_show("Private Message", "$sender: $message");
}


#---------------------------------------------------------------------------------------------------
# OSD Procedure(s)
#---------------------------------------------------------------------------------------------------

sub osd_show {
    my ($title, $text) = @_;

    # Escape our title & message so we don't break kdialog
    $title =~ s/\\/\\\\/g;
    $title =~ s/&/&amp;/g;
    $title =~ s/</&lt;/g;
    $title =~ s/>/&gt;/g;

    $text =~ s/\\/\\\\/g;
    $text =~ s/&/&amp;/g;
    $text =~ s/</&lt;/g;
    $text =~ s/>/&gt;/g;

    # Pass it off to kdialog for display
    my @cmd_args = ("--title", "Irssi: $title", "--passivepopup", $text);
    system("kdialog", @cmd_args);

    return;
}


#---------------------------------------------------------------------------------------------------
# Signal Registration
#---------------------------------------------------------------------------------------------------

Irssi::signal_add_last("print text", "on_print_text");
Irssi::signal_add_last("message private", "on_private_message");

osd_show("cOSD", "cOSD loaded successfully");

#- end
