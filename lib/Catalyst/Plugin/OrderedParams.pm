package Catalyst::Plugin::OrderedParams;

use strict;
use NEXT;
use Tie::IxHash;

our $VERSION = '0.01';

=head1 NAME

Catalyst::Plugin::OrderedParams - Maintain order of submitted form parameters

=head1 SYNOPSIS

    use Catalyst 'OrderedParams';

=head1 DESCRIPTION

This plugin enables handling of GET and POST parameters in an ordered fashion.
By default in Catalyst, form parameters are stored in a simple hash, which
loses the original order in which the paramters were submitted.  This plugin
stores parameters in a Tie::IxHash which will retain the original submitted
order.

One particular application for this plugin is email handlers, where you want
the output of your email to reflect the order of form elements in the form.

Simply add this plugin to your application and the following code will be in
the proper order.

    for my $param ( $c->req->param ) {
        $email .= $param . ": " . $c->req->param( $param );
    }

=head2 METHODS

=over 4

=item prepare_request (extended)

Replace the parameters hash in Catalyst::Request with a tied hash.

=cut

sub prepare_request {
    my $c = shift;
    
    # make sure the params hash hasn't already been touched by another plugin
    if ( scalar keys %{ $c->req->parameters } ) {
        die "OrderedParams: Request parameters have already been set/modified. Please load the OrderedParams plugin before all other plugins.";
    }
    
    my $parameters = {};
    tie %$parameters, 'Tie::IxHash';
    
    $c->req->parameters( $parameters );

    return $c->NEXT::prepare_request(@_);
}

=back

=head1 SEE ALSO

L<Catalyst>

=head1 AUTHOR

Andy Grundman, C<andy@hybridized.org>

=head1 COPYRIGHT

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;
