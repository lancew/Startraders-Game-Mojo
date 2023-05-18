package SpaceTraderMojo;
use Mojo::Base 'Mojolicious', -signatures;


# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/' => sub ($c) {
    $c->redirect_to('/my/agent');
  });

  $r->get('/my/agent')->to('Spacetrader#myagent');
  $r->get('/my/ships/:ship_name')->to('Spacetrader#ship');
  $r->get('/my/ships/:ship_name/dock')->to('Spacetrader#ship_dock');
  $r->get('/my/ships/:ship_name/refuel')->to('Spacetrader#ship_refuel');
  $r->get('/my/ships/:ship_name/orbit')->to('Spacetrader#ship_orbit');
  $r->get('/my/ships/:ship_name/extract')->to('Spacetrader#ship_extract');

  $r->get('/my/contracts/:contract_id')->to('Spacetrader#contract');
  $r->post('/my/contracts/:contract_id')->to('Spacetrader#contract_accept');

  $r->get('/waypoints/:waypoint_id')->to('Spacetrader#waypoint');
  $r->get('/system/:system_id')->to('Spacetrader#system');

  $r->get('/navigate/:waypoint_id')->to('Spacetrader#navigate');
  $r->get('/navigate_to/:waypoint_id/:ship_id')->to('Spacetrader#navigate_ship');

  $r->get('/shipyard/:waypoint_id')->to('Spacetrader#shipyard');

}

1;
