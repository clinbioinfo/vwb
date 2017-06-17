package VWB::VersionControl::Git::Helper;

use Moose;

use VWB::Logger;
use VWB::Config::Manager;


use constant TRUE  => 1;
use constant FALSE => 0;

use constant DEFAULT_TEST_MODE => TRUE;

has 'test_mode' => (
    is       => 'rw',
    isa      => 'Bool',
    writer   => 'setTestMode',
    reader   => 'getTestMode',
    required => FALSE,
    default  => DEFAULT_TEST_MODE
    );


## Singleton support
my $instance;


sub getInstance {

    if (!defined($instance)){

        $instance = new VWB::VersionControl::Git::Helper(@_);

        if (!defined($instance)){

            confess "Could not instantiate VWB::VersionControl::Git::Helper";
        }
    }
    return $instance;
}

sub BUILD {

    my $self = shift;

    $self->_initLogger(@_);
    $self->_initConfigManager(@_);

    $self->{_logger}->info("Instantiated " . __PACKAGE__);
}

sub addFile {

    my $self = shift;
    my ($file) = @_;

    $self->commitFile($file);
}


sub commitFile {

    my $self = shift;
    my ($file) = @_;
}


no Moose;
__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

 VWB::VersionControl::Git::Helper
 A module for interacting with a Git repository.

=head1 VERSION

 1.0

=head1 SYNOPSIS

 use VWB::VersionControl::Git::Helper;
 my $helper = VWB::VersionControl::Git::Helper::getInstance();
 $helper->commitFile($file);

=head1 AUTHOR

 Jaideep Sundaram

 Copyright Jaideep Sundaram

 Distributed under GNU General Public License

=head1 METHODS

=over 4

=cut