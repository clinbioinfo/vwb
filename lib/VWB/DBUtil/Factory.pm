package VWB::DBUtil::Factory;

use Moose;

use VWB::Logger;

use constant TRUE  => 1;
use constant FALSE => 0;

use constant DEFAULT_TYPE => 'mongodb';

## Singleton support
my $instance;

has 'type' => (
    is         => 'rw',
    isa        => 'Str',
    writer     => 'setType',
    reader     => 'getType',
    required   => FALSE,
    default    => DEFAULT_TYPE
    );

has 'database' => (
    is         => 'rw',
    isa        => 'Str',
    writer     => 'setDatabase',
    reader     => 'getDatabase',
    required   => FALSE,
    );

sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::DBUtil::Factory(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::DBUtil::Factory";
        }
    }

    return $instance;
}

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);

    $self->{_logger}->info("Instantiated " . __PACKAGE__);
}

sub _initLogger {

    my $self = shift;

    my $logger = Log::Log4perl->get_logger(__PACKAGE__);
    if (!defined($logger)){
        confess "logger was not defined";
    }

    $self->{_logger} = $logger;
}

sub _getType {

    my $self = shift;
    my (%args) = @_;

    my $type = $self->getType();

    if (!defined($type)){

        if (( exists $args{type}) && ( defined $args{type})){
            $type = $args{type};
        }
        elsif (( exists $self->{_type}) && ( defined $self->{_type})){
            $type = $self->{_type};
        }
        else {
            $self->{_logger}->logconfess("type was not defined");
        }

        $self->setType($type);
    }

    return $type;
}

sub _getDatabase {

    my $self = shift;
    my (%args) = @_;

    my $database = $self->getDatabase();

    if (!defined($database)){

        if (( exists $args{database}) && ( defined $args{database})){
            $database = $args{database};
        }
        elsif (( exists $self->{_database}) && ( defined $self->{_database})){
            $database = $self->{_database};
        }
        else {
            $self->{_logger}->logconfess("database was not defined");
        }

        $self->setDatabase($database);
    }

    return $database;
}

no Moose;
__PACKAGE__->meta->make_immutable;


__END__


=head1 NAME

 VWB::DBUtil::Factory

 A module factory for creating DBUtil instances.

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::DBUtil::Factory;
 my $factory = VWB::DBUtil::Factory::getIntance();
 my $dbutil = $factory->create('mongodb');

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut



no Moose;
__PACKAGE__->meta->make_immutable;
