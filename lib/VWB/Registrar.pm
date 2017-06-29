package VWB::Registrar;

use Moose;
use Cwd;
use Data::Dumper;
use File::Path;
use FindBin;
use File::Slurp;
use Term::ANSIColor;
use JSON::Parse 'json_file_to_perl';

use VWB::Logger;
use VWB::Config::Manager;
use VWB::DBUtil::Factory;


use constant TRUE  => 1;
use constant FALSE => 0;

use constant DEFAULT_TEST_MODE => TRUE;

use constant DEFAULT_USERNAME =>  getlogin || getpwuid($<) || $ENV{USER} || "sundaramj";

use constant DEFAULT_OUTDIR => '/tmp/' . DEFAULT_USERNAME . '/' . File::Basename::basename($0) . '/' . time();

use constant DEFAULT_INDIR => File::Spec->rel2abs(cwd());

## Singleton support
my $instance;

has 'test_mode' => (
    is       => 'rw',
    isa      => 'Bool',
    writer   => 'setTestMode',
    reader   => 'getTestMode',
    required => FALSE,
    default  => DEFAULT_TEST_MODE
    );

has 'config_file' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setConfigfile',
    reader   => 'getConfigfile',
    required => FALSE,
    );

has 'outdir' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setOutdir',
    reader   => 'getOutdir',
    required => FALSE,
    default  => DEFAULT_OUTDIR
    );

has 'indir' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setIndir',
    reader   => 'getIndir',
    required => FALSE,
    default  => DEFAULT_INDIR
    );

has 'report_file' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setReportFile',
    reader   => 'getReportFile',
    required => FALSE
    );

sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::Registrar(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::Registrar";
        }
    }
    return $instance;
}

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);

    $self->_initConfigManager(@_);

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

    my $manager = VWB::Config::Manager::getInstance(@_);
    if (!defined($manager)){
        $self->{_logger}->logconfess("Could not instantiate VWB::Config::Manager");
    }

    $self->{_config_manager} = $manager;
}

sub _initDBUtilFactory {

    my $self = shift;

    my $factory = VWB::DBUtil::Factory::getInstance(@_);
    if (!defined($factory)){
        $self->{_logger}->logconfess("Could not instantiate VWB::DBUtil::Factory");
    }

    $self->{_dbutil_factory} = $factory;
}

sub _initDBUtil {

    my $self = shift;

    my $dbutil = $self->{_dbutil_factory}->create();
    if (!defined($dbutil)){
        $self->{_logger}->logconfess("Could not instantiate VWB::DBUtil");
    }

    $self->{_dbutil} = $dbutil;
}

sub _execute_cmd {

    my $self = shift;
    my ($cmd) = @_;
    
    my @results;
 
    $self->{_logger}->info("About to execute '$cmd'");
    
    eval {
    	@results = qx($cmd);
    };

    if ($?){
    	$self->{_logger}->logconfess("Encountered some error while attempting to execute '$cmd' : $! $@");
    }


    chomp @results;

    return \@results;
}

sub printBoldRed {

    my ($msg) = @_;
    print color 'bold red';
    print $msg . "\n";
    print color 'reset';
}

sub printYellow {

    my ($msg) = @_;
    print color 'yellow';
    print $msg . "\n";
    print color 'reset';
}

sub printGreen {

    my ($msg) = @_;
    print color 'green';
    print $msg . "\n";
    print color 'reset';
}

sub registerEvent {

    my $self = shift;

    $self->{_dbutil}->registerEvent(@_);
}

sub registerByJSONFile {

    my $self = shift;
    my ($json_file) = @_;

    if (!defined($json_file)){
        $self->{_logger}->logconfess("json_file was not defined");
    }

    printYellow("NOT YET IMPLEMENTED");
}

sub registerByJSONString {

    my $self = shift;
    my ($json_string) = @_;

    if (!defined($json_string)){
        $self->{_logger}->logconfess("json_string was not defined");
    }

    printYellow("NOT YET IMPLEMENTED");
}




no Moose;
__PACKAGE__->meta->make_immutable;

__END__


=head1 NAME

 VWB::Registrar
 

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::Registrar;
 my $manager = VWB::Registrar::getInstance();
 $manager->run();

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut