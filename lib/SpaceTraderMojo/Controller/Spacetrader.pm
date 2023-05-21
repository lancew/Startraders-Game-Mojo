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

    my $ship = $api->get_my_ships($self->param('ship_name'));
    $self->stash( ship => $ship );

    my ($waypoint,$market);
    if ($ship->{nav}{status} eq 'IN_ORBIT') {
      $waypoint = $api->get_waypoint($ship->{nav}{waypointSymbol});
    }
    if ($ship->{nav}{status} eq 'DOCKED') {
      $market = $api->get_market($ship->{nav}{waypointSymbol});
    }
    $self->stash( waypoint => $waypoint );
    $self->stash( market   => $market );

    $self->render;
}

sub ship_dock ($self) {
    my $api   = WebService::Spacetraders->new;

    my $res = $api->dock($self->param('ship_name'));

    $self->redirect_to('/my/ships/'. $self->param('ship_name'));
}

sub ship_refuel ($self) {
    my $api   = WebService::Spacetraders->new;

    my $res = $api->refuel($self->param('ship_name'));

    $self->redirect_to('/my/ships/'. $self->param('ship_name'));
}

sub ship_orbit ($self) {
    my $api   = WebService::Spacetraders->new;

    my $res = $api->orbit($self->param('ship_name'));

    $self->redirect_to('/my/ships/'. $self->param('ship_name'));
}

sub ship_extract ($self) {
    my $api   = WebService::Spacetraders->new;

    my $res = $api->extract($self->param('ship_name'));

    $self->flash(result => $res);

    $self->redirect_to('/my/ships/'. $self->param('ship_name'));
}

sub ship_extract_to_full ($self) {
    my $api   = WebService::Spacetraders->new;
    
    $self->minion->enqueue(extract => [$self->param('ship_name')]);

    $self->redirect_to('/my/ships/'. $self->param('ship_name'));
}

sub ship_sell ($self) {
    my $api   = WebService::Spacetraders->new;

    my $res = $api->sell(
      ship => $self->param('ship_name'),
      symbol => $self->param('symbol'),
      units => $self->param('units'),
    );

    $self->flash(result => $res);

    $self->redirect_to('/my/ships/'. $self->param('ship_name'));
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

sub navigate ($self) {
    my $api   = WebService::Spacetraders->new;

    $self->stash( waypoint => $api->get_waypoint($self->param('waypoint_id')));
    $self->stash( ships    => $api->get_my_ships );

    $self->render;
}

sub navigate_ship ($self) {
    my $api   = WebService::Spacetraders->new;
    $api->navigate(
      $self->param('ship_id'),
      $self->param('waypoint_id'),
    );

    $self->redirect_to('/my/ships/' . $self->param('ship_id'));
}

sub shipyard ($self) {
    my $api   = WebService::Spacetraders->new;

    $self->stash( yard => $api->get_shipyard( $self->param('waypoint_id') ) );

    $self->render;
}

1;