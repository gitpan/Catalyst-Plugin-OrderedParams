package Catalyst::Plugin::OrderedParams;

use strict;
use NEXT;
use Tie::IxHash;

our $VERSION = '0.03';

sub prepare_request {
    my $c = shift;
    
    # make sure the params hash hasn't already been touched by another plugin
    if ( scalar keys %{ $c->req->parameters } ) {
        $c->log->error( "OrderedParams: Request parameters have already been "
            . "set/modified.  Please load the OrderedParams plugin "
            . "before all other plugins." );
    }
    else {
        my $params = {};
        tie %{$params}, 'Tie::IxHash';
        
        $c->req->parameters( $params );
    }

    return $c->NEXT::prepare_request(@_);
}

1;
__END__

=head1 NAME

Catalyst::Plugin::OrderedParams - Maintain order of submitted form parameters

=head1 SYNOPSIS

    use Catalyst;
    MyApp->setup( qw/OrderedParams/ );

=head1 DESCRIPTION

This plugin enables handling of GET and POST parameters in an ordered fashion.
By default in Catalyst, form parameters are stored in a simple hash, which
loses the original order in which the parameters were submitted.  This plugin
stores parameters in a Tie::IxHash which will retain the original submitted
order.

One particular application for this plugin is email handlers, where you want
the output of your email to reflect the order of form elements in the form.

Simply add this plugin to your application and the following code will be in
the proper order.

    for my $param ( $c->req->param ) {
        $email .= $param . ": " . $c->req->param( $param );
    }

=head1 CAVEATS

Note that technically according to RFC2388, the ordering of fields submitted
by a form does not have to follow the order of the form elements displayed
on the page.  However, I believe most, if not all, common browsers do follow
this convention.  This plugin has been tested with both IE6 and Firefox 1.0.6.

=head1 SEE ALSO

L<Catalyst>

=head1 AUTHOR

Andy Grundman, <andy@hybridized.org>

=head1 THANKS

Tom Shinnick, C<shenme@perlmonks.org>, for pointing out RFC2388.

=head1 COPYRIGHT

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
