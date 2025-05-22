import Control from 'ol/control/Control';
import Component from '@glimmer/component';
import '@glint/environment-ember-loose';
import EmberMapModifier from 'ember-map/modifiers/ember-map';
import Map from 'ol/Map';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import Draw, { DrawEvent } from 'ol/interaction/Draw.js';
import { type Type } from 'ol/geom/Geometry';
import VectorSource from 'ol/source/Vector';
import Feature from 'ol/Feature';
import Style from 'ol/style/Style';
import Fill from 'ol/style/Fill';
import Stroke from 'ol/style/Stroke';
import CircleStyle from 'ol/style/Circle';
import { shiftKeyOnly } from 'ol/events/condition';
import Icon from 'ol/style/Icon';
import Geometry from 'ol/geom/Geometry';
import PhPencil from 'ember-phosphor-icons/components/ph-pencil';
import PhSearch from 'ember-phosphor-icons/components/ph-magnifying-glass';
import PhPolygon from 'ember-phosphor-icons/components/ph-polygon';
import PhMapPin from 'ember-phosphor-icons/components/ph-map-pin';
import PhScribble from 'ember-phosphor-icons/components/ph-scribble';
import { fn } from '@ember/helper';

import { tracked } from '@glimmer/tracking';

interface DrawShapeControlSignature {
  Args: {
    map?: Map;
    source?: VectorSource;
    features?: Feature[];
  };
}

export default class SearchControl extends Component<DrawShapeControlSignature> {
  @tracked showFeatureSearch = false;

  @action
  toggleFeatureSearch() {
    this.showFeatureSearch = !this.showFeatureSearch;
  }

  @action
  zoomToFeature(feature: Feature) {
    const extent = feature.getGeometry()!.getExtent();
    this.args.map
      ?.getView()
      .fit(extent, { padding: [50, 50, 50, 50], maxZoom: 16 });

    this.showFeatureSearch = false;
  }

  <template>
    <div
      id="search-control"
      class="ol-control top-[10px] right-[34px] ol-unselectable ol-control bg-transparent"
    >
      <div class="flex flex-row">
        {{#if this.showFeatureSearch}}
          <select class="select h-[24px] w-[275px]">
            {{#if @features.length}}
              <option disabled selected>Select a feature to zoom</option>
            {{else}}
              <option disabled selected>There are no features on the map</option>
            {{/if}}

            {{#each @features as |feature index|}}
              <option {{on "click" (fn this.zoomToFeature feature)}}>Feature
                {{index}}</option>
            {{/each}}
          </select>
        {{/if}}

        <button
          class="btn btn-square btn-soft"
          {{on "click" this.toggleFeatureSearch}}
        >
          <PhSearch />
        </button>
      </div>
    </div>
  </template>
}
