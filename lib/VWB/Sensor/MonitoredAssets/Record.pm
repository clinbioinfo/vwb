package VWB::Sensor::MonitoredAssets::Record;

use Moose;

use VWB::Sensor::Logger;


use constant TRUE  => 1;
use constant FALSE => 0;


has 'id' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setId',
    reader   => 'getId',
    required => FALSE
    );

has 'is_file' => (
    is       => 'rw',
    isa      => 'Bool',
    writer   => 'setIsFile',
    reader   => 'getIsFile',
    required => FALSE
    );

has 'path' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setPath',
    reader   => 'getPath',
    required => FALSE
    );

has 'start_date' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setStartDate',
    reader   => 'getStartDate',
    required => FALSE
    );

has 'owner' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setOwner',
    reader   => 'getOwner',
    required => FALSE
    );

has 'checksum' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setChecksum',
    reader   => 'getChecksum',
    required => FALSE
    );

has 'method' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setMethod',
    reader   => 'getMethod',
    required => FALSE
    );

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);

    $self->{_logger}->info("Instantiated ". __PACKAGE__);
}

sub _initLogger {

    my $self = shift;

    my $logger = Log::Log4perl->get_logger(__PACKAGE__);
    if (!defined($logger)){
        confess "logger was not defined";
    }

    $self->{_logger} = $logger;
}



no Moose;
__PACKAGE__->meta->make_immutable;


__END__


=head1 NAME

 VWB::Sensor::Record
 Module for encapsulating a monitored asset (file or directory) record.

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::Sensor::Record;
 my $record = new VWB::Sensor::Record(
     path => $file, 
     is_file => TRUE, 
     start_date => $date);
 

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut
