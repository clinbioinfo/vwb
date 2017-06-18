package VWB::UUID::Manager;

use Moose;

use FindBin;

use VWB::Config::Manager;

use constant TRUE  => 1;
use constant FALSE => 0;


use constant DEFAULT_CONFIG_FILE => "$FindBin::Bin/../vwb_conf.ini";

has 'config_file' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setInfile',
    reader   => 'getInfile',
    required => FALSE,
    default  => DEFAULT_CONFIG_FILE
    );

## Singleton support
my $instance;

sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::UUID::Manager(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::UUID::Manager";
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

    my $config_file = $self->getConfigFile();

    if (!defined($config_file)){
        $self->{_logger}->logconfess("config_file was not defined");
    }

    my $manager = VWB::Config::Manager::getInstance(config_File => $config_file);
    if (!defined($manager)){
        $self->{_logger}->logconfess("Could not instantiate VWB::Config::Manager");
    }

    $self->{_config_manager} = $manager;
}

sub getUUID {

    my $self = shift;

    return $self->createUUID(@_);

}
sub createUUID {

    my $self = shift;

    $self->{_logger}->logconfess("NOT YET IMPLEMENTED");
}


no Moose;
__PACKAGE__->meta->make_immutable;


__END__


=head1 NAME

 VWB::UUID::Manager
 Module for managing the universal unique identifiers

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::UUID::Manager;
 my $manager = VWB::UUID::Manager::getInstance();
 $manager->createFileID();

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut
