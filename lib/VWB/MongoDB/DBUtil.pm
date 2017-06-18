package VWB::MongoDB::DBUtil;

use Moose;

use MongoDB;  ## Reference: http://search.cpan.org/~mongodb/MongoDB-v1.8.0/lib/MongoDB.pm

use VWB::Config::Manager;

extends 'VWB::DBUtil';

use constant TRUE  => 1;
use constant FALSE => 0;

use constant DEFAULT_HOST_URI => 'mongodb://localhost';

use constant DEFAULT_TEST_MODE => TRUE;

use constant DEFAULT_ACTOR => 'N/A';

has 'test_mode' => (
    is       => 'rw',
    isa      => 'Bool',
    writer   => 'setTestMode',
    reader   => 'getTestMode',
    required => FALSE,
    default  => DEFAULT_TEST_MODE
    );

has 'host_uri' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setHostURI',
    reader   => 'getHostURI',
    required => FALSE,
    default  => DEFAULT_HOST_URI
    );



## Singleton support
my $instance;


sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::MongoDB::DBUtil(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::MongoDB::DBUtil";
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

sub _initConnection {

    my $self = shift;

    my $host_uri = $self->getHostURI();
    if (!defined($host_uri)){
        $self->{_logger}->logconfess("host_uri was not defined");
    }

    my $client = MongoDB->connect($host_uri);
    if (!defined($client)){
        $self->{_logger}->logconfess("client was not defined for host URI '$host_uri'");
    }

    $self->{_client} = $client;

    my $database_name = $self->getDatabaseName();
    if (!defined($database_name)){
        $self->{_logger}->logconfess("database_name was not defined");
    }


    my $collection_name = $self->getCollectionName();
    if (!defined($collection_name)){
        $self->{_logger}->logconfess("collection_name was not defined");
    }


    my $db = $client->get_database($database_name);
    if (!defined($db)){
        $self->{_logger}->logconfess("db was not defined for database name '$database_name'");
    }

    $self->{_db} = $db;

    my $collection = $db->get_collection($collection_name);
    if (!defined($collection)){
        $self->{_logger}->logconfess("collection was not defined for collection  name '$collection_name'");
    }

    $self->{_collection} = $collection;
    

    $self->{_logger}->info("Connection established with MongoDB at host '$host_uri' for database '$database_name' collection '$collection_name'");
}


no Moose;
__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

 VWB::MongoDB::DBUtil
 A module for interacting with a MongoDB database.

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::MongoDB::DBUtil;
 my $dbutil = VWB::MongoDB::DBUtil::getInstance();
 $dbutil->insertRecord($record);

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

 Distributed under GNU General Public License

=head1 METHODS

=over 4

=cut
