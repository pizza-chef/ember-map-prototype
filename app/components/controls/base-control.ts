import Control from 'ol/control/Control';

export default class BaseControl extends Control {
  constructor(id: string) {
    const element =
      document.getElementById(id) ?? document.createElement('div');

    super({ element: element });
  }
}
