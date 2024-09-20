import { Hook, makeHook } from "phoenix_typed_hook";

class EditorButtonHook extends Hook {
  mounted() {
    this.el.addEventListener("click", () => this.updateClass());
  }

  beforeUpdate() {}

  updated() {
    console.log(">>> UPDATED");
  }

  destroyed() {}

  updateClass() {
    console.log(document.querySelector("#editor"));
  }
}

export default makeHook(EditorButtonHook);
