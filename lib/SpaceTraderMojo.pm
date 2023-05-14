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

  $r->get('/my/contracts/:contract_id')->to('Spacetrader#contract');
  $r->post('/my/contracts/:contract_id')->to('Spacetrader#contract_accept');

  $r->get('/waypoints/:waypoint_id')->to('Spacetrader#waypoint');
  $r->get('/system/:system_id')->to('Spacetrader#system');
}

1;
