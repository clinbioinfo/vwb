package VWB::VersionControl::BusinessRules::Manager;

use Moose;

use VWB::Logger;
use VWB::Config::Manager;
use VWB::VersionControl::Helper::Factory;

use constant TRUE  => 1;
use constant FALSE => 0;

extends 'VWB::BusinessRules::Manager';

## Singleton support
my $instance;


has 'config_file' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setConfigfile',
    reader   => 'getConfigfile',
    required => FALSE,
    );

sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::VersionControl::BusinessRules::Manager(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::VersionControl::BusinessRules::Manager";
        }
    }
    return $instance;
}

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);

    $self->_initConfigManager(@_);

    $self->_initVersionControlHelperFactory(@_);

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

sub _initConfigManager {

    my $self = shift;

    my $manager = VWB::Config::Manager::getInstance(@_);
    if (!defined($manager)){
        $self->{_logger}->logconfess("Could not instantiate VWB::Config::Manager");
    }

    $self->{_config_manager} = $manager;
}

sub _initVersionControlHelperFactory {

    my $self = shift;

    my $factory = VWB::VersionControl::Helper::Factory::getInstance(@_);
    if (!defined($factory)){
        $self->{_logger}->logconfess("Could not instantiate VWB::VersionControl::Helper::Factory");
    }

    $self->{_helper_factory} = $factory;
}


no Moose;
__PACKAGE__->meta->make_immutable;

__END__


=head1 NAME

 VWB::VersionControl::BusinessRules::Manager
 

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::VersionControl::BusinessRules::Manager;
 my $manager = VWB::VersionControl::BusinessRules::Manager::getInstance();
 $manager->run();

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut