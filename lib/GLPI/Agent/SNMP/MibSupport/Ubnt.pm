package GLPI::Agent::SNMP::MibSupport::Ubnt;

use strict;
use warnings;

use parent 'GLPI::Agent::SNMP::MibSupportTemplate';

use GLPI::Agent::Tools;
use GLPI::Agent::Tools::SNMP;

# See UBNT-MIB

use constant ubnt              => '.1.3.6.1.4.1.41112';
use constant ubntWlStatApMac   => ubnt . '.1.4.5.1.4.1';

# See UBNT-UniFi-MIB

use constant unifiApSystemVersion => ubnt . '.1.6.3.6.0';
use constant unifiApSystemModel	  => ubnt . '.1.6.3.3.0';

our $mibSupport = [
    {
        name    => "ubnt",
        sysobjectid => getRegexpOidMatch(ubnt)
    }
];

sub getFirmware {
    my ($self) = @_;

    return getCanonicalString($self->get(unifiApSystemVersion));
}

sub getModel {
    my ($self) = @_;

    return getCanonicalString($self->get(unifiApSystemModel));
}

sub getSerial {
    my ($self) = @_;

    my $serial = $self->getMacAddress;
    $serial =~ s/://g;

    return $serial;
}

sub getMacAddress {
    my ($self) = @_;
	
	my $device = $self->device
        or return;
	
	my $serial = getCanonicalMacAddress($self->get(ubntWlStatApMac));
	$serial = $device->{MAC}
				if not defined ($serial);

    return $serial;
}

1;

__END__

=head1 NAME

GLPI::Agent::SNMP::MibSupport::Ubnt - Inventory module for Ubnt

=head1 DESCRIPTION

This module enhances Ubnt devices support.
