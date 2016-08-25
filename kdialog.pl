use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '0.1.2';
%IRSSI = (
        authors     => 'Ondrej Skopek',
        contact     => 'skopekondrej@gmail.com',
        name        => 'kdialog',
        description => 'A KDialog PassivePopup show\'s who is talking to you, on what IRC channel.',
        url         => 'https://gist.github.com/oskopek/9566780',
        license     => 'BSD',
        changed     => '$Date: 2014-03-15 13:55:00 +0100 (Sat, 15 Mar 2014) $'
);

#--------------------------------------------------------------------
# Based on osd.pl 0.3.3 by Jeroen Coekaerts, Koenraad Heijlen
# http://www.irssi.org/scripts/scripts/osd.pl
#--------------------------------------------------------------------
# Based on knotify.pl 0.1.1 by Hugo Haas
# http://larve.net/people/hugo/2003/scratchpad/IrssiKnotify.html
#--------------------------------------------------------------------

#--------------------------------------------------------------------
# Printing private messages
#--------------------------------------------------------------------

sub priv_msg {
    my ($server, $msg, $nick, $address) = @_;

    kde_print("Private Message", "$nick: $msg")
}

#--------------------------------------------------------------------
# Printing hilight's
#--------------------------------------------------------------------

sub hilight {
    my ($dest, $text, $stripped) = @_;

    if ($dest->{level} & MSGLEVEL_HILIGHT) {
        kde_print($dest->{target}, $stripped);
    }
}

#--------------------------------------------------------------------
# The actual printing
#--------------------------------------------------------------------

sub kde_print {
    my ($title, $text, $output) = @_;

    $title =~ s/\\/\\\\/g;
    $text =~ s/\\/\\\\/g;
    $output = `kdialog --title "Irssi: $title" --passivepopup "$text"`;

    return;
}

#--------------------------------------------------------------------
# Irssi::signal_add_last
#--------------------------------------------------------------------

Irssi::signal_add_last("message private", "priv_msg");
Irssi::signal_add_last("print text", "hilight");

#- end
