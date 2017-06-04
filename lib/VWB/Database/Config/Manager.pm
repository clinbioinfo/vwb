package VWB::Database::Config::Manager;

use Moose;
use Data::Dumper;
use File::Path;
use FindBin;

use VWB::Database::Config::File::INI::Parser;
use VWB::Database::Config::Record;

use constant TRUE  => 1;
use constant FALSE => 0;

use constant DEFAULT_DATABASE_CONFIG_FILE => '__DEFAULT_DATABASE_CONFIG_FILE__';

has 'infile' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setInfile',
    reader   => 'getInfile',
    required => FALSE,
    default  => DEFAULT_DATABASE_CONFIG_FILE
    );

## Singleton support
my $instance;

sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::Database::Config::Manager(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::Database::Config::Manager";
        }
    }

    return $instance;
}

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);

    $self->_initParser(@_);

    $self->_buildRecordLookup(@_);

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

sub _initParser {

    my $self = shift;

    my $file = $self->getInfile();

    if (!defined($file)){
        $self->{_logger}->logconfess("file was not defined");
    }

    my $parser = VWB::Database::Config::File::INI::Parser::getInstance(infile => $file);
    if (!defined($parser)){
        $self->{_logger}->logconfess("Could not instantiate VWB::Database::Config::File::INI::Parser");
    }

    $self->{_parser} = $parser;
}


sub _buildRecordLookup {

    my $self = shift;

    my $databaseList = $self->{_parser}->getSectionList();
    if (!defined($databaseList)){
        $self->{_logger}->logconfess("databaseList was not defined");
    }

    if (scalar(@{$databaseList})  < 1){
        
        my $file = $self->{_parser}->getInfile();
        
        if (!defined($file)){
           $self->{_logger}->logconfess("file was not defined");
        }

        $self->{_logger}->logconfess("There were no databases in the list.   Please check the database configuration file '$file'");
    }

    foreach my $database (@{$databaseList}){

        my $name = $self->{_parser}->getName($database);
        if (!defined($name)){
            $self->{_logger}->logconfess("name was not defined for database '$database'");
        }

        my $etl_username = $self->{_parser}->getETLUsername($database);
        if (!defined($etl_username)){
            $self->{_logger}->logconfess("etl_username was not defined for database '$database' name '$name'");
        }

        my $etl_password = $self->{_parser}->getETLPassword($database);
        if (!defined($etl_password)){
            $self->{_logger}->logconfess("etl_password was not defined for database '$database' name '$name'");
        }

        my $bdm_proxy_account_password = $self->{_parser}->getBDMProxyAccountPassword($database);
        if (!defined($bdm_proxy_account_password)){
            $self->{_logger}->logconfess("bdm_proxy_account_password was not defined for database '$database' name '$name'");
        }

        my $server = $self->{_parser}->getServer($database);
        if (!defined($server)){
            $self->{_logger}->logconfess("server was not defined for database '$database' name '$name'");
        }

        my $scheme = $self->{_parser}->getScheme($database);
        if (!defined($scheme)){
            $self->{_logger}->logconfess("scheme was not defined for database '$database' name '$name'");
        }


        my $record = $self->_initRecord(
            $etl_username,
            $etl_password,
            $name,
            $database,
            $server,
            $scheme,
            $bdm_proxy_account_password
            );

        my $publish_username = $self->{_parser}->getPublishUsername($database);
        if (!defined($publish_username)){
            if ($scheme eq 'tng'){
                $self->{_logger}->logconfess("publish_username was not defined");
            }
            else {
                $publish_username = $etl_username;
                $self->{_logger}->warn("publish username was not defined and therefore was set to the etl username '$publish_username' since the scheme is '$scheme'");
            }
        }
         
        $record->setPublishUsername($publish_username);

        my $publish_password = $self->{_parser}->getPublishPassword($database);
        if (!defined($publish_password)){
            if ($scheme eq 'tng'){
                $self->{_logger}->logconfess("publish_password was not defined");
            }
            else {
                $publish_password = $etl_password;
                $self->{_logger}->warn("publish password was not defined and therefore was set to the etl password '$publish_password' since the scheme is '$scheme'");
            }
        }

        $record->setPublishPassword($publish_password);

        $self->{_type_to_record_lookup}->{$database} = $record;

        $self->{_name_to_record_lookup}->{$name} = $record;

        $self->{_database_name_to_record_lookup}->{$database} = $record;

        push(@{$self->{_record_list}}, $record);

        $self->{_logger}->info("Created database config record for database '$database'");
    }
}


sub _initRecord {

    my $self = shift;
    my ($etl_username, $etl_password, $name, $database, $server, $scheme, $bdm_proxy_account_password) = @_;

    my $record = new VWB::Database::Config::Record(
        etl_username        => $etl_username,
        etl_password        => $etl_password,
        name                => $name,
        database            => $database,
        server              => $server,
        scheme              => $scheme,
        bdm_proxy_account_password => $bdm_proxy_account_password
        );

    if (!defined($record)){
        $self->{_logger}->logconfess("Could not instantiate VWB::Database::Config::Record");
    }

    return $record;
}

sub getRecordByType {

    my $self = shift;
    my ($type) = @_;

    if (!defined($type)){
        $self->{_logger}->logconfess("type was not defined");
    }

    if ((exists $self->{_type_to_record_lookup}->{$type}) && (defined $self->{_type_to_record_lookup}->{$type})){
        return $self->{_type_to_record_lookup}->{$type};
    }
    else {
        $self->{_logger}->logconfess("type '$type' does not exist in the record lookup");
    }
}

sub getRecordByName {

    my $self = shift;
    my ($name) = @_;

    if (!defined($name)){
        $self->{_logger}->logconfess("name was not defined");
    }

    if ((exists $self->{_name_to_record_lookup}->{$name}) && (defined $self->{_name_to_record_lookup}->{$name})){
        return $self->{_name_to_record_lookup}->{$name};
    }
    else {
        $self->{_logger}->logconfess("name '$name' does not exist in the record lookup");
    }
}

sub isNameQualified {

    my $self = shift;
    my ($name) = @_;
    if (!defined($name)){
        $self->{_logger}->logconfess("name was not defined");
    }

    if ((exists $self->{_name_to_record_lookup}->{$name}) &&
        (defined $self->{_name_to_record_lookup}->{$name})){

        return TRUE;
    }
    else {
        return FALSE;
    }
}

sub isDatabaseNameQualified {

    my $self = shift;
    my ($databaseName) = @_;
    if (!defined($databaseName)){
        $self->{_logger}->logconfess("databaseName was not defined");
    }

    if ((exists $self->{_database_name_to_record_lookup}->{$databaseName}) &&
        (defined $self->{_database_name_to_record_lookup}->{$databaseName})){

        return TRUE;
    }
    else {
        return FALSE;
    }
}

sub getRecordList {

    my $self = shift;

    return $self->{_record_list};
}

sub getETLUsername {

    my $self = shift;
    my ($database) = @_;

    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    if (! ((exists $self->{_database_name_to_record_lookup}->{$database}) && (defined $self->{_database_name_to_record_lookup}->{$database}))){
        $self->{_logger}->logconfess("database '$database' does not exist in the database name to record lookup");
    }
    else {

        my $record = $self->{_database_name_to_record_lookup}->{$database};

        my $username = $record->getETLUsername();
        if (!defined($username)){
            $self->{_logger}->logconfess("username was not defined for database '$database'");
        }

        return $username;
    }
}

sub getETLPassword {

    my $self = shift;
    my ($database) = @_;

    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    if (! ((exists $self->{_database_name_to_record_lookup}->{$database}) && (defined $self->{_database_name_to_record_lookup}->{$database}))){
        $self->{_logger}->logconfess("database '$database' does not exist in the database name to record lookup");
    }
    else {

        my $record = $self->{_database_name_to_record_lookup}->{$database};

        my $password = $record->getETLPassword();
        if (!defined($password)){
            $self->{_logger}->logconfess("password was not defined for database '$database'");
        }

        return $password;
    }
}

sub getPublishUsername {

    my $self = shift;
    my ($database) = @_;

    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    if (! ((exists $self->{_database_name_to_record_lookup}->{$database}) && (defined $self->{_database_name_to_record_lookup}->{$database}))){
        $self->{_logger}->logconfess("database '$database' does not exist in the database name to record lookup");
    }
    else {

        my $record = $self->{_database_name_to_record_lookup}->{$database};

        my $username = $record->getPublishUsername();
        if (!defined($username)){
            $self->{_logger}->logconfess("username was not defined for database '$database'");
        }

        return $username;
    }
}

sub getPublishPassword {

    my $self = shift;
    my ($database) = @_;

    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    if (! ((exists $self->{_database_name_to_record_lookup}->{$database}) && (defined $self->{_database_name_to_record_lookup}->{$database}))){
        $self->{_logger}->logconfess("database '$database' does not exist in the database name to record lookup");
    }
    else {

        my $record = $self->{_database_name_to_record_lookup}->{$database};

        my $password = $record->getPublishPassword();
        if (!defined($password)){
            $self->{_logger}->logconfess("password was not defined for database '$database'");
        }

        return $password;
    }
}

sub getBDMProxyAccountPassword {

    my $self = shift;
    my ($database) = @_;

    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    if (! ((exists $self->{_database_name_to_record_lookup}->{$database}) && (defined $self->{_database_name_to_record_lookup}->{$database}))){
        $self->{_logger}->logconfess("database '$database' does not exist in the database name to record lookup");
    }
    else {

        my $record = $self->{_database_name_to_record_lookup}->{$database};

        my $password = $record->getBDMProxyAccountPassword();
        if (!defined($password)){
            $self->{_logger}->logconfess("BDM_PROXY account password was not defined for database '$database' record: ". Dumper $record);
        }

        return $password;
    }
}

sub getServer {

    my $self = shift;
    my ($database) = @_;

    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    if (! ((exists $self->{_database_name_to_record_lookup}->{$database}) && (defined $self->{_database_name_to_record_lookup}->{$database}))){
        $self->{_logger}->logconfess("database '$database' does not exist in the database name to record lookup");
    }
    else {

        my $record = $self->{_database_name_to_record_lookup}->{$database};

        my $server = $record->getServer();
        if (!defined($server)){
            $self->{_logger}->logconfess("server was not defined for database '$database'");
        }

        return $server;
    }
}

sub getScheme {

    my $self = shift;
    my ($database) = @_;

    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    if (! ((exists $self->{_database_name_to_record_lookup}->{$database}) && (defined $self->{_database_name_to_record_lookup}->{$database}))){
        $self->{_logger}->logconfess("database '$database' does not exist in the database name to record lookup");
    }
    else {

        my $record = $self->{_database_name_to_record_lookup}->{$database};

        my $scheme = $record->getScheme();
        if (!defined($scheme)){
            $self->{_logger}->logconfess("scheme was not defined for database '$database'");
        }

        return $scheme;
    }
}

sub getDatabaseList {

    my $self = shift;

    my $databaseList = $self->{_parser}->getSectionList();
    if (!defined($databaseList)){
        $self->{_logger}->logconfess("databaseList was not defined");
    }
    

    return $databaseList;
}


no Moose;
__PACKAGE__->meta->make_immutable;


__END__


=head1 NAME

 VWB::Database::Config::Manager
 Module for managing the database configuration settings.

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::Database::Config::Manager;
 my $manager = VWB::Database::Config::Manager::getInstance();
 my $recordList = $manager->getRecordList();

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut