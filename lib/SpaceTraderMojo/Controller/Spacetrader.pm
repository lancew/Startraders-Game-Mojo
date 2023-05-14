package SpaceTraderMojo::Controller::Spacetrader;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use WebService::Spacetraders;

# This action will render a template
sub myagent ($self) {
    my $api   = WebService::Spacetraders->new;

    $self->stash( agent => $api->get_my_agent );
    $self->stash( ships => $api->get_my_ships );
    $self->stash( contracts => $api->get_contract(" "));

    $self->render;
}

sub ship ($self) {
    my $api   = WebService::Spacetraders->new;

    $self->stash( ship => $api->get_my_ships($self->param('ship_name')));

    $self->render;
}

sub contract ($self) {
    my $api   = WebService::Spacetraders->new;

    $self->stash( contract => $api->get_contract($self->param('contract_id')));

    $self->render;
}

sub contract_accept ($self) {
    my $api   = WebService::Spacetraders->new;

    my $res = $api->accept_contract($self->param('contract_id'));
    $self->redirect_to('/my/contracts/'. $self->(param('contract_id')));
}

sub waypoint ($self) {
    my $api   = WebService::Spacetraders->new;

    $self->stash( waypoint => $api->get_waypoint($self->param('waypoint_id')));

    $self->render;
}

sub system ($self) {
    my $api   = WebService::Spacetraders->new;

    $self->stash( system => $api->get_waypoints($self->param('system_id')));

    $self->render;
}
1;