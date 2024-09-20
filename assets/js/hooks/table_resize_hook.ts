import { Hook, makeHook } from "phoenix_typed_hook";

import ColumnResizer from "column-resizer";

class TableResizeHook extends Hook {
  mounted() {
    console.log("blibs");
    this.resizer = new ColumnResizer(this.el, {
      liveDrag: false,
      serialize: false,
      dragginClass: "dragging",
      gripInnerHtml: '<div class="grip"></div>',
      resizeMode: "overflow",
      minWidth: 8,
    });

    console.log(this.resizer);
  }

  beforeUpdate() {}

  updated() {}

  destroyed() {}
}

export default makeHook(TableResizeHook);
