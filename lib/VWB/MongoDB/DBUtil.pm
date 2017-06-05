package VWB::MongoDB::DBUtil;

use Moose;
use MongoDB;  ## Reference: http://search.cpan.org/~mongodb/MongoDB-v1.8.0/lib/MongoDB.pm
use VWB::Logger;
use VWB::Config::Manager;

extends 'VWB::DBUtil';

use constant TRUE  => 1;
use constant FALSE => 0;

## Singleton support
my $instance;


sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::MongoDB::DBUtil(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::MongoDB::DBUtil";
        }
    }
    return $instance;
}

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);
    $self->_initConfigManager(@_);
    $self->_initConnection(@_);

    $self->{_logger}->info("Instantiated " . __PACKAGE__);
}

sub _initConnection {

    my $self = shift;
}

sub insertRecord {

    my $self = shift;
    my ($record) = @_;

    if (!defined($record)){
        $self->{_logger}->logconfess("record was not defined");
    }

 
    $self->{_logger}->logconfess("NOT YET IMPLEMENTED");
}


sub getRecords {

    my $self = shift;

    $self->{_logger}->logconfess("NOT YET IMPLEMENTED");
}

no Moose;
__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

 VWB::MongoDB::DBUtil
 A module for interacting with a MongoDB database.

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::MongoDB::DBUtil;
 my $dbutil = VWB::MongoDB::DBUtil::getInstance();
 $dbutil->insertRecord($record);

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

 Distributed under GNU General Public License

=head1 METHODS

=over 4

=cut
