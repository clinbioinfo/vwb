package VWB::BusinessRules::DBUtil::Factory;

use Moose;

use VWB::BusinessRules::MongoDB::DBUtil;

extends 'VWB:DBUtil::Factory';

use constant TRUE  => 1;
use constant FALSE => 0;


## Singleton support
my $instance;

sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::BusinessRules::DBUtil::Factory(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::BusinessRules::DBUtil::Factory";
        }
    }

    return $instance;
}

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);

    $self->{_logger}->info("Instantiated " . __PACKAGE__);
}

sub create {

    my $self = shift;
    

    my $type = $self->getType();
    if (!defined($type)){
        $self->{_logger}->logconfess("type was not defined");
    }

    if (lc($type) eq 'mongodb'){

        my $dbutil = VWB::BusinessRules::MongoDB::DBUtil::getInstance(@_);
        if (!defined($dbutil)){
            $self->{_logger}->logconfess("Could not instantiate VWB::BusinessRules::MongoDB::DBUtil");
        }
    }
    else {
        $self->{_logger}->logconfess("Unsupported database type '$type'");
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;


__END__


=head1 NAME

 VWB::BusinessRules::DBUtil::Factory

 A module factory for creating DBUtil instances.

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::BusinessRules::DBUtil::Factory;
 my $factory = VWB::BusinessRules::DBUtil::Factory::getIntance();
 my $dbutil = $factory->create('mongodb');

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut



no Moose;
__PACKAGE__->meta->make_immutable;
