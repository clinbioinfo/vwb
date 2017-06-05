package VWB::Sensor::MonitoredAssets::Registrar;

use Moose;
use Data::Dumper;
use File::Path;
use FindBin;

use VWB::Sensor::Logger;
use VWB::Sensor::Config::Manager;
use VWB::Sensor::MonitoredAssets::DBUtil::Factory;


use constant TRUE  => 1;
use constant FALSE => 0;


use constant DEFAULT_CONFIG_FILE => '';

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

        $instance = new VWB::Sensor::MonitoredAssets::Registrar(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::Sensor::MonitoredAssets::Registrar";
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

    my $manager = VWB::Sensor::Config::Manager::getInstance(config_File => $config_file);
    if (!defined($manager)){
        $self->{_logger}->logconfess("Could not instantiate VWB::Sensor::Config::Manager");
    }

    $self->{_config_manager} = $manager;
}


sub _initDBUtilFactory {

    my $self = shift;

    my $factory = VWB::Sensor::MonitoredAssets:::DBUtil::Factory::getInstance();
    if (!defined($factory)){
        $self->{_logger}->logconfess("Could not instantiate VWB::Sensor::MonitoredAssets::DBUtil::Factory");
    }

    $self->{_dbutil_factory} = $factory;


    my $dbutil = $self->{_dbutil_factory}->create();
    if (!defined($dbutil)){
        $self->{_logger}->logconfess("dbutil was not defined");
    }

    $self->{_dbutil} = $dbutil;
}

sub registerFile {

    my $self = shift;
    my ($fileRecord) = @_;

    if (!defined($fileRecord)){
        $self->{_logger}->logconfess("fileRecord was not defined");
    }


    $self->{_dbutil}->insertRecord($fileRecord);

    $self->{_logger}->logconfess("NOT YET IMPLEMENTED");

}

sub registerDirector {

    my $self = shift;
    my ($dirRecord) = @_;

    if (!defined($dirRecord)){
        $self->{_logger}->logconfess("dirRecord was not defined");
    }

    
    $self->{_dbutil}->insertRecord($dirRecord);

    $self->{_logger}->logconfess("NOT YET IMPLEMENTED");

}


no Moose;
__PACKAGE__->meta->make_immutable;


__END__


=head1 NAME

 VWB::Sensor::Registrar
 Module for managing the registration of monitored assets (files and directories)

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::Sensor::Registrar;
 my $registrar = VWB::Sensor::Registrar::getInstance();
 $registrar->registerFile($fileRecord);

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut
