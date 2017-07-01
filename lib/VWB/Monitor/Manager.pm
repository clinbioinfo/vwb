package VWB::Monitor::Manager;

use Moose;
use Cwd;
use Data::Dumper;
use File::Path;
use FindBin;
use File::Slurp;
use Term::ANSIColor;
use JSON::Parse 'json_file_to_perl';
use Linux::Inotify2;

use VWB::Logger;
use VWB::Config::Manager;
use VWB::Registrar;

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

has 'report_file' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setReportFile',
    reader   => 'getReportFile',
    required => FALSE
    );

has 'file_list_file' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setFileListFile',
    reader   => 'getFileListFile',
    required => FALSE
    );

has 'file' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setFile',
    reader   => 'getFile',
    required => FALSE
    );

has 'dir_list_file' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setDirListFile',
    reader   => 'getDirListFile',
    required => FALSE
    );

has 'dir' => (
    is       => 'rw',
    isa      => 'Str',
    writer   => 'setDir',
    reader   => 'getDir',
    required => FALSE
    );

sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::Monitor::Manager(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::Monitor::Manager";
        }
    }
    return $instance;
}

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);

    $self->_initConfigManager(@_);

    $self->_initRegistrar(@_);

    $self->_initInotify(@_);

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

sub _initRegistrar {

    my $self = shift;

    my $registrar = VWB::Registrar::getInstance(@_);
    if (!defined($registrar)){
        $self->{_logger}->logconfess("Could not instantiate VWB::Registrar");
    }

    $self->{_registrar} = $registrar;
}

sub _initInotify {

    my $self = shift;

    my $inotify = new Linux::Inotify2();
    if (!defined($inotify)){
        $self->{_logger}->logconfess("Could not instantiate Linux::Inotify2 : $!");
    }

    $self->{_inotify} = $inotify;
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

sub run {

    my $self = shift;
    
    $self->_deploy_watchers(@_);
}

sub monitor {

    my $self = shift;
    
    $self->_deploy_watchers(@_);
}

sub _deploy_watchers {

    my $self = shift;
    
    my $found_some_asset = FALSE;

    my $file_list_file = $self->getFileListFile();

    if (defined($file_list_file)){

        $self->_process_file_list_file($file_list_file);

        $found_some_asset = TRUE;
    }

    my $dir_list_file = $self->getDirListFile();

    if (defined($dir_list_file)){

        $self->_process_dir_list_file($dir_list_file);

        $found_some_asset = TRUE;
    }


    my $file = $self->getFile();

    if (defined($file)){

        if (!-e $file){
            $self->{_logger}->logconfess("file '$file' does not exist");
        }

        $self->_watch_file($file);

        $found_some_asset = TRUE;
    }


    my $dir = $self->getDir();

    if (defined($dir)){

        if (!-e $dir){
            $self->{_logger}->logconfess("directory '$dir' does not exist");
        }
        
        $self->_watch_directory($dir);

        $found_some_asset = TRUE;
    }


    if ($found_some_asset){

        $self->{_logger}->info("Alright.   Now going to start watching/polling the assets.");

        printBrightBlue("Now going to start watching/polling the assets.");

        while (TRUE){

            $self->{_inotify}->poll();
        }
    }
    else {

        $self->{_logger}->fatal("There are no assets to monitor");

        printBoldRed("There are no assets to monitor.");

        exit(1);
    }
}

sub _process_file_list_file {

    my $self = shift;
    my ($file_list_file) = @_;

    $self->{_logger}->info("Going to process file_list_file '$file_list_file'");

    $self->{_file_error_ctr} = 0;
    
    $self->{_file_error_list} = [];

    my @lines = read_file($file_list_file);
       
    foreach my $line (@lines){
    
        chomp $line;
    
        if ($line =~ m|^\s*$|){
            next;
        }

        if ($line =~ m|^\#|){
            next;
        }

        if (!-e $line){
    
            $self->{_logger}->error("file '$line' does not exist");
    
            $self->{_file_error_ctr}++;
    
            push(@{$self->{_file_error_list}}, $line);
        }
        else {
            $self->_watch_file($line);        
        }
    }


    if ($self->{_file_error_ctr} > 0){

        printBoldRed("The following '$self->{_file_error_ctr}' files that do not exist:");

        printBoldRed(join("\n", @{$self->{_file_error_list}}));
    }

    if ($self->{_watch_file_ctr} > 0){
        
        printBrightBlue("The following '$self->{_watch_file_ctr}' files are being watched");

        print join("\n", @{$self->{_watch_file_list}}) . "\n";
    }
    else {
        printBoldRed("Not watching any files");
    }
}


sub _process_dir_list_file {

    my $self = shift;
    my ($dir_list_file) = @_;

    $self->{_logger}->info("Going to process dir_list_file '$dir_list_file'");

    $self->{_dir_error_ctr} = 0;
    
    $self->{_dir_error_list} = [];


    my @lines = read_file($dir_list_file);
       
    foreach my $line (@lines){
    
        chomp $line;
    
        if ($line =~ m|^\s*$|){
            next;
        }

        if ($line =~ m|^\#|){
            next;
        }

        if (!-e $line){
    
            $self->{_logger}->error("directory '$line' does not exist");
    
            $self->{_dir_error_ctr}++;
    
            push(@{$self->{_dir_error_list}}, $line);
        }
        else {
            $self->_watch_directory($line);        
        }
    }


    if ($self->{_dir_error_ctr} > 0){

        printBoldRed("The following '$self->{_dir_error_ctr}' directories that do not exist:");

        printBoldRed(join("\n", @{$self->{_dir_error_list}}));
    }

    if ($self->{_watch_dir_ctr} > 0){
        
        printBrightBlue("The following '$self->{_watch_dir_ctr}' directories are being watched");

        print join("\n", @{$self->{_watch_dir_list}}) . "\n";
    }
    else {
        printBoldRed("Not watching any directories");
    }
}


sub _watch_file {

    my $self = shift;
    my ($file) = @_;

    $self->{_logger}->info("Going to watch file '$file'");

    $self->{_inotify}->watch($file, IN_ACCESS|IN_MODIFY|IN_ATTRIB|IN_CLOSE_WRITE|IN_CLOSE_NOWRITE|IN_OPEN|IN_MOVED_FROM|IN_MOVED_TO|IN_CREATE|IN_DELETE|IN_DELETE_SELF|IN_MOVE_SELF|IN_ALL_EVENTS|IN_ONESHOT|IN_ONLYDIR|IN_DONT_FOLLOW|IN_MASK_ADD, sub {
        
        my $e = shift;
        
        my $name = $e->fullname;
        if (!defined($name)){
            $self->{_logger}->logconfess("name was not defined for event : " . Dumper $e);
        }
        
        my $mask = $e->mask;
        if (!defined($mask)){
            $self->{_logger}->logconfess("mask was not defined for event : " . Dumper $e);
        }

        $self->{_logger}->info("Encountered '$mask' event for '$name'");

        print "Encountered '$mask' event for '$name\n";
    });

    $self->{_watch_file_ctr}++;

    push(@{$self->{_watch_file_list}}, $file);
}

sub _watch_directory {

    my $self = shift;
    my ($dir) = @_;

    $self->{_logger}->info("Going to watch directory '$dir'");

    $self->{_inotify}->watch($dir, IN_ACCESS|IN_MODIFY|IN_ATTRIB|IN_CLOSE_WRITE|IN_CLOSE_NOWRITE|IN_OPEN|IN_MOVED_FROM|IN_MOVED_TO|IN_CREATE|IN_DELETE|IN_DELETE_SELF|IN_MOVE_SELF|IN_ALL_EVENTS|IN_ONESHOT|IN_ONLYDIR|IN_DONT_FOLLOW|IN_MASK_ADD, sub {
        
        my $e = shift;
        
        my $name = $e->fullname;
        if (!defined($name)){
            $self->{_logger}->logconfess("name was not defined for event : " . Dumper $e);
        }
        
        my $mask = $e->mask;
        if (!defined($mask)){
            $self->{_logger}->logconfess("mask was not defined for event : " . Dumper $e);
        }

        $self->{_logger}->info("Encountered '$mask' event for '$name'");
    });

    $self->{_watch_dir_ctr}++;

    push(@{$self->{_watch_dir_list}}, $dir);

}

sub printBrightBlue {

    my ($msg) = @_;
    print color 'bright_blue';
    print $msg . "\n";
    print color 'reset';
}

sub registerEvent {

    my $self = shift;

    $self->{_registrar}->registerEvent(@_);
}

sub registerByJSONFile {

    my $self = shift;
    my ($json_file) = @_;

    if (!defined($json_file)){
        $self->{_logger}->logconfess("json_file was not defined");
    }

    $self->{_registrar}->registerByJSONFile($json_file);
}

sub registerByJSONString {

    my $self = shift;
    my ($json_string) = @_;

    if (!defined($json_string)){
        $self->{_logger}->logconfess("json_string was not defined");
    }

    $self->{_registrar}->registerByJSONString($json_string);
}


no Moose;
__PACKAGE__->meta->make_immutable;

__END__


=head1 NAME

 VWB::Monitor::Manager
 

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::Monitor::Manager;
 my $manager = VWB::Monitor::Manager::getInstance();
 $manager->run();

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut