package VWB::VersionControl::UUID::Manager;

use Moose;

use VWB::Config::Manager;

extends 'VWB::UUID::Manager';

use constant TRUE  => 1;

use constant FALSE => 0;


## Singleton support
my $instance;

sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::VersionControl::UUID::Manager(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::VersionControl::UUID::Manager";
        }
    }

    return $instance;
}

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);

    $self->_initConfigManager(@_);

    $self->{_logger}->info("Instantiated ". __PACKAGE__);
}


no Moose;
__PACKAGE__->meta->make_immutable;


__END__


=head1 NAME

 VWB::VersionControl::UUID::Manager
 Module for managing the universal unique identifiers

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::VersionControl::UUID::Manager;
 my $manager = VWB::VersionControl::UUID::Manager::getInstance();
 $manager->createFileID();

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut
