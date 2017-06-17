package VWB::Sensor::MonitoredAssets::SQLite::DBUtil;

use Moose;


use VWB::Sensor::Logger;
use VWB::Sensor::Config::Manager;

extends 'VWB::SQLite::DBUtil';

use constant TRUE  => 1;
use constant FALSE => 0;

## Singleton support
my $instance;


sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::Sensor::MonitoredAssets::SQLite::DBUtil(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::Sensor::MonitoredAssets::SQLite::DBUtil";
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


sub _initConnection {

    my $self = shift;
}


no Moose;
__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

 VWB::Sensor::MonitoredAssets::SQLite::DBUtil
 A module for interacting with a SQLite database.

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::Sensor::MonitoredAssets::SQLite::DBUtil;
 my $dbutil = VWB::Sensor::MonitoredAssets::SQLite::DBUtil::getInstance();
 $dbutil->insertRecord($record);

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

 Distributed under GNU General Public License

=head1 METHODS

=over 4

=cut
