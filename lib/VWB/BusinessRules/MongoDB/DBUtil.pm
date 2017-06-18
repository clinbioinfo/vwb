package VWB::BusinessRules::MongoDB::DBUtil;

use Moose;

use VWB::BusinessRules::Config::Manager;

extends 'VWB::BusinessRules::DBUtil';
extends 'VWB::MongoDB::DBUtil';

use constant TRUE  => 1;
use constant FALSE => 0;

use constant DEFAULT_HOST_URI => 'mongodb://localhost';

use constant DEFAULT_TEST_MODE => TRUE;

use constant DEFAULT_ACTOR => 'N/A';

use constant DEFAULT_DATABASE_NAME => 'business_rules';

use constant DEFAULT_COLLECTION_NAME => 'business_rules';

## Singleton support
my $instance;


sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::BusinessRules::MongoDB::DBUtil(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::BusinessRules::MongoDB::DBUtil";
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


sub addBusinessRules {

    my $self = shift;
    my ($business_rules) = @_;

    if (!defined($business_rules)){
        $self->{_logger}->logconfess("business_rules was not defined");
    }


    foreach my $business_rule (@{$business_rules}){

        $self->addBusinessRule($business_rule);
    }
}


sub addBusinessRule {

    my $self = shift;
    my ($business_rule) = @_;

    if (!defined($business_rule)){
        $self->{_logger}->logconfess("business_rule was not defined");
    }

    my $lookup = $self->_convert_business_rule_to_hash($business_rule);

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

 VWB::BusinessRules::MongoDB::DBUtil
 A module for interacting with a MongoDB database.

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::BusinessRules::MongoDB::DBUtil;
 my $dbutil = VWB::BusinessRules::MongoDB::DBUtil::getInstance();
 $dbutil->insertRecord($record);

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

 Distributed under GNU General Public License

=head1 METHODS

=over 4

=cut