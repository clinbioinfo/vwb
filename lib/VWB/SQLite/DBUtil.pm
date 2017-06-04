package VWB::SQLite::DBUtil;

use Moose;
use VWB::Logger;
use VWB::SQLite::Config::Manager;

extends 'VWB::DBUtil';

use DBD::Oracle qw(:ora_types);

use constant TRUE  => 1;
use constant FALSE => 0;

use constant DEFAULT_DATABASE_FILE_PATH => '';

## Singleton support
my $instance;

has 'database_file_path' => (
    is        => 'rw',
    isa       => 'Str',
    writer    => 'setDatabaseFilePath',
    reader    => 'getDatabaseFilePath',
    required  => FALSE,
    default   => DEFAULT_DATABASE_FILE_PATH
    );

sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::SQLite::DBUtil(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::SQLite::DBUtil";
        }
    }
    return $instance;
}

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);

    $self->_initConfigManager(@_);

    $self->_initDBI(@_);

    $self->{_logger}->info("Instantiated " . __PACKAGE__);
}

sub _initConfigManager {

    my $self = shift;

    my $manager = VWB::Config::Manager::getInstance(@_);

    if (!defined($manager)){
        $self->{_logger}->logconfess("Could not instantiate VWB::Config::Manager");
    }

    $self->{_config_manager} = $manager;
}

sub insertRecord {

    my $self = shift;
    my ($record) = @_;

    if (!defined($record)){
        $self->{_logger}->logconfess("record was not defined");
    }

 
    $self->{_logger}->logconfess("NOT YET IMPLEMENTED");
}


sub getRecords {

    my $self = shift;

    $self->{_logger}->logconfess("NOT YET IMPLEMENTED");
}

no Moose;
__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

 VWB::SQLite::DBUtil
 A module for interacting with a SQLite database.

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::SQLite::DBUtil;
 my $dbutil = VWB::SQLite::DBUtil(database_file_path => $database_file_path);
 $dbutil->insertRecord($record);

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

 Distributed under GNU General Public License

=head1 METHODS

=over 4

=cut