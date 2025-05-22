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
import PhCircle from 'ember-phosphor-icons/components/ph-circle';
import PhPolygon from 'ember-phosphor-icons/components/ph-polygon';
import PhMapPin from 'ember-phosphor-icons/components/ph-map-pin';
import PhScribble from 'ember-phosphor-icons/components/ph-scribble';
import { fn } from '@ember/helper';

import { tracked } from '@glimmer/tracking';

interface DrawShapeControlSignature {
  Args: {
    map?: Map;
    source?: VectorSource;
    onDrawEnd?: (feature: Feature) => void;
  };
}

export default class DrawShapeControl extends Component<DrawShapeControlSignature> {
  @tracked showMenu = false;
  draw?: Draw;

  // Much faster rendering whenreusing this style
  markerStyle = new Style({
    image: new Icon({
      src: 'marker.svg',
      anchor: [0.5, 1],
      scale: 1,
    }),
  });

  @action
  toggleShowMenu() {
    this.showMenu = !this.showMenu;
  }

  @action
  onDraw(shape: string) {
    this.showMenu = false;
    if (this.draw) {
      this.args.map?.removeInteraction(this.draw);
    }

    if (shape == 'None' || !this.args.map) return;

    this.draw = new Draw({
      source: this.args.source,
      type: shape as Type,
      freehandCondition: shiftKeyOnly,
    });

    this.args.map.addInteraction(this.draw);
    this.draw.on('drawend', (event: DrawEvent) => {
      if (shape == 'Point') {
        event.feature.setStyle(this.markerStyle);
      }
      this.args.onDrawEnd?.(event.feature);
      if (this.draw) {
        this.args.map?.removeInteraction(this.draw);
      }
    });
  }

  <template>
    <div
      id="draw-control"
      class="ol-control top-[10px] right-[10px] ol-unselectable ol-control bg-transparent"
    >

      <button
        class="btn btn-square btn-soft"
        {{on "click" this.toggleShowMenu}}
      >
        <PhPencil />
      </button>
      {{#if this.showMenu}}

        <button
          class="btn btn-square btn-soft w-full"
          {{on "click" (fn this.onDraw "Polygon")}}
        >
          <PhPolygon />
        </button>
        <button
          class="btn btn-square btn-soft w-full"
          {{on "click" (fn this.onDraw "Point")}}
        >
          <PhMapPin />
        </button>
        <button
          class="btn btn-square btn-soft w-full"
          {{on "click" (fn this.onDraw "Circle")}}
        >
          <PhCircle />
        </button>
        <button
          class="btn btn-square btn-soft w-full"
          {{on "click" (fn this.onDraw "LineString")}}
        >
          <PhScribble />
        </button>
      {{/if}}
    </div>
  </template>
}
