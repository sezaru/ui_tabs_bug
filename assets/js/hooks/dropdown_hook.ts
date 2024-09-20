import Utils from "./utils";

import { Hook, makeHook } from "phoenix_typed_hook";

import {
  computePosition,
  autoUpdate,
  flip,
  shift,
  offset,
  arrow,
} from "@floating-ui/dom";

class MenuVisibility {
  dropdown: HTMLElement;
  events: HTMLElement;

  constructor(dropdown: HTMLElement, events: HTMLElement) {
    this.dropdown = dropdown;
    this.events = events;
  }

  mounted() {
    this.observer = Utils.addVisibilityObserver(
      this.dropdown,
      () => this.onVisible(),
      () => this.onInvisible(),
    );
  }

  beforeUpdate() {}
  updated() {}

  destroyed() {
    Utils.removeVisibleObserver(this.observer);
  }

  disconnected() {}
  reconnected() {}

  onVisible() {
    liveSocket.execJS(this.events, this.dropdown.dataset.onShow);
  }

  onInvisible() {
    liveSocket.execJS(this.events, this.dropdown.dataset.onHide);
  }
}

class ComputePosition {
  dropdown: HTMLElement;
  button: HTMLElement;

  constructor(dropdown: HTMLElement, button: HTMLElement) {
    this.dropdown = dropdown;
    this.button = button;
  }

  mounted() {
    this.skidding = parseInt(this.dropdown.dataset.skidding, 10);
    this.distance = parseInt(this.dropdown.dataset.distance, 10);

    this.placement = this.dropdown.dataset.placement.replace("_", "-");

    this.cleanup = autoUpdate(this.button, this.dropdown, () => {
      this.doComputePosition();
    });
  }

  beforeUpdate() {}

  updated() {
    this.doComputePosition();
  }

  destroyed() {
    this.cleanup();
  }

  disconnected() {}
  reconnected() {}

  doComputePosition() {
    computePosition(this.button, this.dropdown, {
      placement: this.placement,
      middleware: [
        offset({ mainAxis: this.distance, crossAxis: this.skidding }),
        flip(),
        shift(),
      ],
    }).then(({ x, y }) => {
      console.log(y);
      Object.assign(this.dropdown.style, {
        left: `${x}px`,
        top: `${y}px`,
      });
    });
  }
}

class CheckUpdated {
  dropdown: HTMLElement;
  button: HTMLElement;
  buttonContent?: HTMLElement;

  constructor(
    dropdown: HTMLElement,
    button: HTMLElement,
    buttonContent?: HTMLElement,
  ) {
    this.dropdown = dropdown;
    this.button = button;
    this.buttonContent = buttonContent;
  }

  mounted() {
    if (this.buttonContent != null) {
      this.button.addEventListener("check_updated", () =>
        this.onCheckUpdated(),
      );

      this.onCheckUpdated();
    }
  }

  beforeUpdate() {}

  updated() {
    this.onCheckUpdated();
  }

  destroyed() {}

  disconnected() {}
  reconnected() {}

  onCheckUpdated() {
    const content = this.dropdown.querySelectorAll(
      'input[ui-menu-item][type="radio"]:checked + div[ui-button-content] > *',
    );

    const newContent = Array.from(content, (element) => {
      const newElement = element.cloneNode(true);

      // NOTE: Sometimes the button content was being duplicated for some reason
      // removing the `data-phx-id` attribute seems to fix it, but I can't reproduce
      // this anymore, so for now it is commented.
      // delete newElement.dataset.phxId

      return newElement;
    });

    if (newContent.length > 0) {
      this.buttonContent.replaceChildren(...newContent);
    }
  }
}

class DropdownHook extends Hook {
  mounted() {
    const dropdown = this.el;
    const events = dropdown.querySelector("& > span[ui-push-events]");
    const button = document.querySelector(`#${this.el.dataset.buttonId}`);
    const buttonContent = button.querySelector(`#${button.id}_content`);

    console.log(dropdown);
    console.log(button);
    console.log(buttonContent);

    console.assert(button != null);

    this.hooks = [
      new MenuVisibility(dropdown, events),
      new ComputePosition(dropdown, button),
      new CheckUpdated(dropdown, button, buttonContent),
    ];

    this.hooks.forEach((hook) => hook.mounted());
  }

  updated() {
    this.hooks.forEach((hook) => hook.updated());
  }

  destroyed() {
    this.hooks.forEach((hook) => hook.destroyed());
  }
}

export default makeHook(DropdownHook);
