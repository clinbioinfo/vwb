package VWB::Sensor::MonitoredAssets::MongoDB::DBUtil;

use Moose;
use MongoDB;  ## Reference: http://search.cpan.org/~mongodb/MongoDB-v1.8.0/lib/MongoDB.pm

use VWB::Sensor::Logger;
use VWB::Sensor::Config::Manager;

extends 'VWB::MongoDB::DBUtil';

use constant TRUE  => 1;
use constant FALSE => 0;

## Singleton support
my $instance;


sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::Sensor::MonitoredAssets::MongoDB::DBUtil(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::Sensor::MonitoredAssets::MongoDB::DBUtil";
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

 VWB::Sensor::MonitoredAssets::MongoDB::DBUtil
 A module for interacting with a MongoDB database.

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::Sensor::MonitoredAssets::MongoDB::DBUtil;
 my $dbutil = VWB::Sensor::MonitoredAssets::MongoDB::DBUtil::getInstance();
 $dbutil->insertRecord($record);

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

 Distributed under GNU General Public License

=head1 METHODS

=over 4

=cut
