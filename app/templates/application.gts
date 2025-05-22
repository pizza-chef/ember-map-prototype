import Component from '@glimmer/component';
import RouteTemplate from 'ember-route-template';
import '@glint/environment-ember-loose';
import EmberMap from 'ember-map/components/ember-map';

class Application extends Component {
  get titleWithDefault() {
    return 'HI!';
  }

  <template><EmberMap /></template>
}

export default RouteTemplate(Application);
