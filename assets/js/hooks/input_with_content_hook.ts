import Utils from "./utils";

import { Hook, makeHook } from "phoenix_typed_hook";

class InputWithContentHook extends Hook {
  mounted() {
    const input = this.el.querySelector("& > input");

    console.assert(input != null);

    this.el.addEventListener("handle_click", (event) => {
      console.log(event);
      // { explicitOriginalTarget }
      //   console.log(explicitOriginalTarget)
      // if (explicitOriginalTarget.id == this.el.id) {
      input.focus();
      // }
    });
  }
}

export default makeHook(InputWithContentHook);
