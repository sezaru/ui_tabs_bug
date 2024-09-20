import { Hook, makeHook } from "phoenix_typed_hook";

import Sortable from "sortablejs";

class SortableHook extends Hook {
  mounted() {
    this.sortable = Sortable.create(this.el, {
      animation: 150,
      delay: 100,
      dragClass: "drag-item",
      ghostClass: "drag-ghost",
      forceFallback: true,
      onEnd: (event) => {
        // this.order = this.sortable.toArray()

        event.item
          .querySelector("input")
          .dispatchEvent(new Event("change", { bubbles: true }));
      },
    });

    // this.order = this.sortable.toArray()
  }

  beforeUpdate() {}

  updated() {}

  destroyed() {}
}

export default makeHook(SortableHook);
