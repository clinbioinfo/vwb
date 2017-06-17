package VWB::Sensor::MonitoredAssets::Manager;

use Moose;
use Data::Dumper;
use File::Path;
use FindBin;

use VWB::Sensor::Logger;
use VWB::Sensor::Config::Manager;
use VWB::Sensor::MonitoredAssets::Registrar;
use VWB::Sensor::UUID::Manager;

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

        $instance = new VWB::Sensor::MonitoredAssets::Manager(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::Sensor::MonitoredAssets::Manager";
        }
    }

    return $instance;
}

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);

    $self->_initConfigManager(@_);

    $self->_initUUIDManager(@_);

    $self->_initRegistrar(@_);

    $self->{_has_monitored_assets} = FALSE;

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

sub _initUUIDManager {

    my $self = shift;

    my $manager = VWB::Sensor::UUID::Manager::getInstance();
    if (!defined($manager)){
        $self->{_logger}->logconfess("Could not instantiate VWB::Sensor::UUID::Manager");
    }

    $self->{_uid_manager} = $manager;
}

sub _initRegistrar {

    my $self = shift;

    my $registrar = VWB::Sensor::MonitoredAssets::Registrar::getInstance();
    if (!defined($registrar)){
        $self->{_logger}->logconfess("Could not instantiate VWB::Sensor::MonitoredAssets::Registrar");
    }

    $self->{_registrar} = $registrar;
}


sub registerDirectory {


    my $self = shift;
    my ($dir) = @_;

    if (!defined($dir)){
        $self->{_logger}->logconfess("dir was not defined");
    }


    my $date = localtime();

    my $id = $self->{_uid_manager}->getId();

    my $record = new VWB::MonitoredAsset::Record(
        id          => $id,
        is_file     => FALSE,
        path        => $dir,
        start_date  => $date
        );

    if (!defined($record)){
        $self->{_logger}->logconfess("Could not instantiate VWB::MonitoredAsset::Record");
    }

    $self->{_has_monitored_assets} = TRUE;

    push(@{$self->{_monitored_assets_record_list}}, $record);

    $self->{_registrar}->registerDirectory($record);
}


sub registerFile {

    my $self = shift;
    my ($file) = @_;

    if (!defined($file)){
        $self->{_logger}->logconfess("file was not defined");
    }

    my $date = localtime();

    my $id = $self->{_uid_manager}->getId();

    my $record = new VWB::MonitoredAsset::Record(
        id          => $id,
        is_file     => TRUE,
        path        => $file,
        start_date  => $date
        );

    if (!defined($record)){
        $self->{_logger}->logconfess("Could not instantiate VWB::MonitoredAsset::Record");
    }

    $self->{_has_monitored_assets} = TRUE;

    push(@{$self->{_monitored_assets_record_list}}, $record);

    $self->{_registrar}->registerFile($record);
}

sub hasMonitoredAssets {

    my $self = shift;

    return $self->{_has_monitored_assets};
}

sub getMonitorAssetsRecordList {

    my $self = shift;

    return $self->{_monitored_assets_record_list};
}


no Moose;
__PACKAGE__->meta->make_immutable;


__END__


=head1 NAME

 VWB::Sensor::MonitoredAssets::Manager
 Module for managing the list of monitored assets (files and directories)

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::Sensor::MonitoredAssets::Manager;
 my $manager = VWB::Sensor::MonitoredAssets::Manager::getInstance();
 $manager->registerFile($file);

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut
