import { registerDestructor } from '@ember/destroyable';
import ClassBasedModifier, {
  type ArgsFor,
  type NamedArgs,
  type PositionalArgs,
} from 'ember-modifier';
import Map from 'ol/Map.js';
import View from 'ol/View.js';
import TileLayer from 'ol/layer/Tile.js';
import VectorLayer from 'ol/layer/Vector.js';
import OSM from 'ol/source/OSM.js';
import VectorSource from 'ol/source/Vector.js';

export interface EmberMapModifierSignature {
  Args: {
    Named: {
      registerMap?: (map: Map, source: VectorSource) => void;
    };
  };
}

function cleanup(instance: EmberMapModifier) {
  instance.instance = null;
}

export default class EmberMapModifier extends ClassBasedModifier<EmberMapModifierSignature> {
  instance: unknown = null;

  constructor(owner: any, args: ArgsFor<EmberMapModifierSignature>) {
    super(owner, args);
    registerDestructor(this, cleanup);
  }

  modify(
    element: HTMLElement,
    []: PositionalArgs<EmberMapModifierSignature>,
    { registerMap }: NamedArgs<EmberMapModifierSignature>,
  ) {
    const raster = new TileLayer({
      source: new OSM(),
    });

    const source = new VectorSource({ wrapX: false });

    const vector = new VectorLayer({
      source: source,
    });

    const map = new Map({
      layers: [raster, vector],
      target: element,
      view: new View({
        center: [-11000000, 4600000],
        zoom: 4,
      }),
    });

    registerMap?.(map, source);
  }
}
