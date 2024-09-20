import { html, css, LitElement } from "lit";

import { customElement, property } from "lit/decorators.js";

@customElement("simple-greeting")
export class SimpleGreeting extends LitElement {
  static styles = css`
    p {
      color: blue;
    }
  `;

  @property()
  name = "Somebody";

  @property()
  items = [];

  //@property({type: (props: {id: Number}) => void})
  @property()
  applyCommand = (props) => {};

  render() {
    return html`
      <ul class="bg-green-100 font-bold z-10">
        ${this.items.map(
          (item, index) => html`<li class="bg-green-100">${item} ${index}</li>`,
        )}
      </ul>
    `;
  }
}
