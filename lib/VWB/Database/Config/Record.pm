package VWB::Database::Config::Record;

use Moose;
use Log::Log4perl;

use constant TRUE  => 1;
use constant FALSE => 0;

## Need to decide if name and section should be merged into a single value.
## I would opt to keep these separated as the type should succinctly indicate
## which version of the API should be instantiated.
has 'name' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setName',
    reader   => 'getName',
    required => FALSE
    );

has 'type' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setType',
    reader   => 'getType',
    required => FALSE
    );

has 'publish_username' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setPublishUsername',
    reader   => 'getPublishUsername',
    required => FALSE
    );

has 'publish_password' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setPublishPassword',
    reader   => 'getPublishPassword',
    required => FALSE
    );

has 'etl_username' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setETLUsername',
    reader   => 'getETLUsername',
    required => FALSE
    );

has 'etl_password' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setETLPassword',
    reader   => 'getETLPassword',
    required => FALSE
    );

has 'bdm_proxy_account_password' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setBDMProxyAccountPassword',
    reader   => 'getBDMProxyAccountPassword',
    required => FALSE
    );

has 'database' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setDatabase',
    reader   => 'getDatabase',
    required => FALSE
    );

has 'server' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setServer',
    reader   => 'getServer',
    required => FALSE
    );

has 'scheme' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setScheme',
    reader   => 'getScheme',
    required => FALSE
    );

has 'bdms_repository' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setBDMSRepository',
    reader   => 'setBDMSRepository',
    required => FALSE
    );

has 'map_import_staging' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setMapImportStaging',
    reader   => 'getMapImportStaging',
    required => FALSE
    );

has 'plan_import_staging' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setPlanImportStaging',
    reader   => 'setPlanImportStaging',
    required => FALSE
    );

sub BUILD {

    my $self = shift;


    $self->_initLogger(@_);

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


no Moose;
__PACKAGE__->meta->make_immutable;

__END__


=head1 NAME

 VWB::Database::Config::Record

 A module for encapsulating the database configuration record found in the database master configuration file

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::Database::Config::Record;
 my $record = new VWB::Database::Config::Record();


=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut