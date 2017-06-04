package VWB::Database::Config::File::INI::Parser;

use Moose;
use Data::Dumper;
use Carp;
use Config::IniFiles;
use Log::Log4perl;

use constant TRUE => 1;
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

sub BUILD {

    my $self = shift;

    $self->{_is_parsed} = FALSE;

    $self->_initLogger(@_);
}


sub _initLogger {

    my $self = shift;

    my $logger = Log::Log4perl->get_logger(__PACKAGE__);
    if (!defined($logger)){
        confess "logger was not defined";
    }

    $self->{_logger} = $logger;
}

sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::Database::Config::File::INI::Parser(@_);

        if (!defined($instance)){
            confess "Could not instantiate VWB::Database::Config::File::INI::Parser";
        }
    }

    return $instance;
}

sub _isParsed {

    my $self = shift;

    return $self->{_is_parsed};
}

sub getName {

    my $self = shift;
    my ($database) = @_;
    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    return $self->_getValue($database, 'name');
}

sub getETLUsername {

    my $self = shift;
    my ($database) = @_;

    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    return $self->_getValue($database, 'etl_username');
}

sub getETLPassword {

    my $self = shift;
    my ($database) = @_;

    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    return $self->_getValue($database, 'etl_password');
}

sub getBDMProxyAccountPassword {

    my $self = shift;
    my ($database) = @_;

    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    return $self->_getValue($database, 'proxy_password');
}

sub getPublishUsername {

    my $self = shift;
    my ($database) = @_;

    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    return $self->_getValue($database, 'publish_username');
}

sub getPublishPassword {

    my $self = shift;
    my ($database) = @_;

    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    return $self->_getValue($database, 'publish_password');
}

sub getServer {

    my $self = shift;
    my ($database) = @_;
    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    return $self->_getValue($database, 'server');
}


sub getScheme {

    my $self = shift;
    my ($database) = @_;
    if (!defined($database)){
        $self->{_logger}->logconfess("database was not defined");
    }

    return $self->_getValue($database, 'scheme');
}

sub _getValue {

    my $self = shift;
    my ($section, $parameter) = @_;

    if (! $self->_isParsed(@_)){

        $self->_parseFile(@_);
    }

    if (!$self->{_cfg}->SectionExists($section)){
        $self->{_logger}->logconfess("section '$section' does not exist");
    }

    my $value = $self->{_cfg}->val($section, $parameter);

    if ((defined($value)) && ($value ne '')){
        return $value;
    }
    else {
        return undef;
    }
}

sub _parseFile {

    my $self = shift;
    my $file = $self->getInfile();
    
    my $cfg = new Config::IniFiles(-file => $file);
    if (!defined($cfg)){
        confess "Could not instantiate Config::IniFiles";
    }

    $self->{_cfg} = $cfg;

    $self->{_is_parsed} = TRUE;
}

sub getSectionList {

    my $self = shift;

    if (! ((exists $self->{_section_list}) && ( defined $self->{_section_list}))){

        if (! $self->_isParsed(@_)){
            $self->_parseFile(@_);
        }
        
        my @sectionList = $self->{_cfg}->Sections();

        $self->{_section_list} = \@sectionList;
    }

    return $self->{_section_list};
}

no Moose;
__PACKAGE__->meta->make_immutable;


1==1; ## End of module

__END__

=head1 NAME

 VWB::Database::Config::INIFile::Parser

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::Database::Config::INIFile::Parser;
 my $parser = VWB::Database::Config::INIFile::Parser(infile => $file);
 my $etl_username = $parser->getETLUsername($database);

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

 new
 _init
 DESTROY


=over 4

=cut