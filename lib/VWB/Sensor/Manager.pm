package VWB::Sensor::Manager;

use Moose;
use Data::Dumper;
use File::Path;
use FindBin;

use VWB::Sensor::Logger;
use VWB::Sensor::Config::Manager;
use VWB::Sensor::MonitoredAssets::Manager;


use constant TRUE  => 1;
use constant FALSE => 0;

use constant DEFAULT_CONFIG_FILE => '';

has 'config_file' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setConfigFile',
    reader   => 'getConfigFile',
    required => FALSE,
    default  => DEFAULT_CONFIG_FILE
    );

## Singleton support
my $instance;

sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::Sensor::Manager(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::Sensor::Manager";
        }
    }

    return $instance;
}

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);

    $self->_initConfigManager(@_);

    $self->_initMonitoredAssetsManager(@_);

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

sub _initMonitoredAssetsManager {

    my $self = shift;

    my $manager = VWB::Sensor::MonitoredAssets::Manager::getInstance();
    if (!defined($manager)){
        $self->{_logger}->logconfess("Could not instantiate VWB::Sensor::MonitoredAssets::Manager");
    }

    $self->{_assets_manager} = $manager;
}

sub monitorDirectory {


    my $self = shift;
    my ($dir) = @_;

    if (!defined($dir)){
        $self->{_logger}->logconfess("dir was not defined");
    }

    if (!-e $dir){
        $self->{_logger}->logconfess("directory '$dir' does not exist");
    }

    if (!-d $dir){
        $self->{_logger}->logconfess("'$dir' is not a regular directory");
    }

    $self->_monitor_directory($dir);
}

sub _monitor_directory {

    my $self = shift;
    my ($dir) = @_;

    if (!defined($dir)){
        $self->{_logger}->logconfess("dir was not defined");
    }


    $self->{_assets_manager}->registerDirectory($dir);

}

sub monitorFile {

    my $self = shift;
    my ($file) = @_;

    if (!defined($file)){
        $self->{_logger}->logconfess("file was not defined");
    }

    if (!-e $file){
        $self->{_logger}->logconfess("file '$file' does not exist");
    }

    if (!-f $file){
        $self->{_logger}->logconfess("'$file' is not a regular file");
    }

    $self->_monitor_file($file);
}

sub _monitor_file {

    my $self = shift;
    my ($file) = @_;

    if (!defined($file)){
        $self->{_logger}->logconfess("file was not defined");
    }


    $self->{_assets_manager}->registerFile($file);
}

sub hasMonitoredAssets {

    my $self = shift;

    return $self->{_assets_manager}->hasMonitoredAssets();
}

sub getMonitorAssetsRecordList {

    my $self = shift;

    return $self->{_assets_manager}->getMonitorAssetsRecordList();
}


no Moose;
__PACKAGE__->meta->make_immutable;


__END__


=head1 NAME

 VWB::Sensor::Manager
 Module for managing the database configuration settings.

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::Sensor::Manager;
 my $manager = VWB::Sensor::Manager::getInstance();
 my $recordList = $manager->getRecordList();

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut
