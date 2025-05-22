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
import Control from 'ol/control/Control';
import Geometry from 'ol/geom/Geometry';
import PhCube from 'ember-phosphor-icons/components/ph-cube';
import DrawShapeControl from './controls/draw-control';
import BaseControl from './controls/base-control';
import SearchControl from './controls/search-control';
import { tracked } from '@glimmer/tracking';

export default class EmberMap extends Component {
  emberMapModifier = EmberMapModifier;

  map?: Map;
  source?: VectorSource;
  draw?: Draw;
  @tracked features: Feature[] = [];

  @action
  registerMap(map: Map, source: VectorSource) {
    this.map = map;
    this.source = source;
    this.map.addControl(new BaseControl('draw-control'));
    this.map.addControl(new BaseControl('search-control'));
  }

  @action
  onDrawEnd(feature: Feature) {
    this.features = [...this.features, feature];
  }

  @action
  colourChange(event: Event) {
    const target = event.target as HTMLSelectElement;
    const colour = target.value;
    const style =
      colour == 'Default'
        ? undefined
        : new Style({
            fill: new Fill({ color: colour }),
            stroke: new Stroke({ color: colour }),
          });

    const circleStyle = new Style({
      image: new CircleStyle({
        radius: 6,
        fill: new Fill({ color: colour }),
        stroke: new Stroke({ color: colour }),
      }),
    });

    this.source?.forEachFeature((feature) => {
      if (feature.getGeometry()?.getType() == 'Point' && style) {
        feature.setStyle(circleStyle);
      } else {
        feature.setStyle(style);
      }
    });
  }

  @action
  zoomToFit() {
    if (!this.map || !this.source) return;
    const extent = this.source.getExtent();
    this.map.getView().fit(extent, {
      padding: [50, 50, 50, 50], // Padding around the features
      duration: 1000, // Animation duration in ms
      maxZoom: 16, // Optional: prevent zooming in too far
    });
  }

  <template>
    <div
      class="h-[800px] w-full"
      {{this.emberMapModifier registerMap=this.registerMap}}
    >
    </div>

    <DrawShapeControl
      @map={{this.map}}
      @source={{this.source}}
      @onDrawEnd={{this.onDrawEnd}}
    />

    <SearchControl
      @map={{this.map}}
      @source={{this.source}}
      @features={{this.features}}
    />

    <div>
      <label>Colour:</label>
      <select class="select" {{on "change" this.colourChange}}>
        <option value="Default">Default</option>
        <option value="rgba(255, 0, 0, 0.5)">Red</option>
        <option value="rgba(0, 255, 0, 0.5)">Green</option>
      </select>
    </div>

    <button class="btn btn-small" {{on "click" this.zoomToFit}}>Zoom to Fit</button>
  </template>
}
