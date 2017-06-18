package VWB::BusinessRules::Manager;

use Moose;
use Cwd;
use Data::Dumper;
use File::Path;
use FindBin;
use Term::ANSIColor;

use VWB::BusinessRules::Config::Manager;
use VWB::BusinessRules::DBUtil::Factory;

use constant TRUE  => 1;
use constant FALSE => 0;

use constant DEFAULT_TEST_MODE => TRUE;

use constant DEFAULT_USERNAME =>  getpwuid($<) || $ENV{USER} || "sundaramj";

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


sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::BusinessRules::Manager(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::BusinessRules::Manager";
        }
    }
    return $instance;
}

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);

    $self->_initConfigManager(@_);

    $self->_initDBUtilFactory(@_);

    $self->_initDBUtil(@_);

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

    my $manager = VWB::BusinessRules::Config::Manager::getInstance(@_);
    if (!defined($manager)){
        $self->{_logger}->logconfess("Could not instantiate VWB::BusinessRules::Config::Manager");
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

sub addBusinessRules {

    my $self = shift;
    my ($business_rules_list) = @_;

    if (!defined($business_rules_list)){
        $self->{_logger}->logconfess("business_rules_list was not defined");
    }

    my $ctr = 0;

    foreach my $business_rule (@{$business_rules_list}){
        $self->{_dbutil}->addBusinessRule($business_rule);
        $ctr++;
    }

    $self->{_logger}->info("Added '$ctr' business rules");
}

sub getBusinessRules {

    my $self = shift;
    
    my $business_rules = $self->{_dbutil}->getBusinessRules(@_);
    if (!defined($business_rules)){
        $self->{_logger}->logconfess("business_rules was not defined");
    }

    my $business_rules_list = [];

    my $ctr = 0;

    foreach my $rule (@{$business_rules}){

        $ctr++;

        push(@{$business_rules_list}, $rule);

    }

    $self->{_logger}->info("Retrieved '$ctr' business rules");


    return $business_rules_list;

}

sub getBusinessRulesByUser {

    my $self = shift;
    my ($user) = @_;

    if (!defined($user)){
        $self->{_logger}->logconfess("user was not defined");
    }


    my $business_rules = $self->{_dbutil}->getBusinessRulesByUser(@_);
    if (!defined($business_rules)){
        $self->{_logger}->logconfess("business_rules was not defined for user '$user->getUsername()'");
    }

    my $business_rules_list = [];

    my $ctr = 0;

    foreach my $rule (@{$business_rules}){

        $ctr++;

        push(@{$business_rules_list}, $rule);

    }

    $self->{_logger}->info("Retrieved '$ctr' business rules");


    return $business_rules_list;

}



sub addBusinessRule {

    my $self = shift;
    my ($rule) = @_:

    if (!defined($rule)){
        $self->{_logger}->logconfess("rule was not defined");
    }

    $self->{_dbutil}->addBusinessRule($rule);
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


no Moose;
__PACKAGE__->meta->make_immutable;

__END__


=head1 NAME

 VWB::BusinessRules::Manager
 

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::BusinessRules::Manager;
 my $manager = VWB::BusinessRules::Manager::getInstance();
 $manager->run();

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

=head1 METHODS

=over 4

=cut