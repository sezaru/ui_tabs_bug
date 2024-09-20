import Utils from "./utils";

import { Hook, makeHook } from "phoenix_typed_hook";

class ScrollToElementHook extends Hook {
  mounted() {
    this.handleEvent("scroll_to_element", (data) => this.onScroll(data));
  }

  onScroll({ id }) {
    if (id == this.el.id && !Utils.isVisibleInViewport(this.el)) {
      scroll(this.el, {
        behavior: "smooth",
        block: "start",
        inline: "nearest",
      });
    }
  }
}

export default makeHook(ScrollToElementHook);
