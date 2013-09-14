package RebootNow;

use strict;
use warnings;
use utf8;

sub plugin {
    MT->component('RebootNow');
}

sub reboot_now {
    my ($app) = @_;

    return $app->permission_denied()
        unless $app->user->is_superuser();

    $app->reboot;
    $app->redirect(
        $app->uri(
            'mode' => 'tools',
            args   => { reboot_complete => 1 }
        ),
    );
}

sub template_param_system_check {
    my ( $cb, $app, $param, $tmpl ) = @_;

    return 1
        unless $app->user->is_superuser();

    $param->{reboot_complete} = !!$app->param('reboot_complete');

    my $place_holder = $tmpl->getElementById('system_check');
    foreach my $t ( @{ plugin()->load_tmpl('system_check.tmpl')->tokens } ) {
        $tmpl->insertAfter( $t, $place_holder );
        $place_holder = $t;
    }
}

1;
