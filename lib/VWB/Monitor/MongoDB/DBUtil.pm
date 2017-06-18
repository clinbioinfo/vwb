package VWB::Monitor::MongoDB::DBUtil;

use Moose;

use VWB::Config::Manager;

extends 'VWB::DBUtil';
extends 'VWB::MongoDB::DBUtil';

use constant TRUE  => 1;
use constant FALSE => 0;

use constant DEFAULT_HOST_URI => 'mongodb://localhost';

use constant DEFAULT_TEST_MODE => TRUE;

use constant DEFAULT_ACTOR => 'N/A';


## Singleton support
my $instance;


sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::Monitor::MongoDB::DBUtil(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::Monitor::MongoDB::DBUtil";
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


sub registerEvent {

    my $self = shift;
    my ($event) = @_;

    if (!defined($event)){
        $self->{_logger}->logconfess("event was not defined");
    }

    my $file_path = $event->getFilePath();
    if (!defined($file_path)){
        $self->{_logger}->logconfess("file_path was not defined");
    }

    my $checksum = $event->getChecksum();
    if (!defined($checksum)){
        $self->{_logger}->logconfess("checksum was not defined");
    }

    my $file_size = $event->getFileSize();
    if (!defined($file_size)){
        $self->{_logger}->logconfess("file_size was not defined");
    }

    my $event_type = $event->getType(); 
    if (!defined($event_type)){
        $self->{_logger}->logconfess("event_type was not defined");
    }

    my $owner = $event->getFileOwner();
    if (!defined($owner)){
        $self->{_logger}->logconfess("owner was not defined");
    }

    my $group = $event->getFileGroup();
    if (!defined($group)){
        $self->{_logger}->logconfess("group was not defined");
    }

    my $date = $event->getDate();
    if (!defined($date)){
        $date = localtime();
        $self->{_logger}->warn("date was not defined and therefore was set to '$date'");
    }

    my $actor = $event->getActor();
    if (!defined($actor)){
        $actor = DEFAULT_ACTOR;
        $self->{_logger}->warn("actor was not defined and therefore was set to default '$actor'");
    }


    my $lookup = {
        file_size  => $file_size,
        file_path  => $file_path,
        owner      => $owner,
        group      => $group,
        checksum   => $checksum,
        actor      => $actor,
        date       => $date,
        event_type => $event_type
    };


    my $extra = $self->getExtra();
    if (defined($extra)){
        $lookup->{extra} = $extra;
    }

    # my $collection = $client->ns('foo.bar'); # database foo, collection bar
    # my $result     = $collection->insert_one({ some => 'data' });
    # my $data       = $collection->find_one({ _id => $result->inserted


    my $result = $self->{_collection}->insert_one($lookup);
    if (!defined($result)){
        $self->{_logger}->logconfess("result was not defined");
    }

    return $result->inserted_id;
}


no Moose;
__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

 VWB::Monitor::MongoDB::DBUtil
 A module for interacting with a MongoDB database.

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::Monitor::MongoDB::DBUtil;
 my $dbutil = VWB::Monitor::MongoDB::DBUtil::getInstance();
 $dbutil->registerEvent($event);

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

 Distributed under GNU General Public License

=head1 METHODS

=over 4

=cut