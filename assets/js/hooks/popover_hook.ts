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

class ContentByClickVisibility {
  popover: HTMLElement;
  content: HTMLElement;
  events: HTMLElement;

  constructor(popover: HTMLElement, content: HTMLElement, events: HTMLElement) {
    this.popover = popover;
    this.content = content;
    this.events = events;
  }

  mounted() {
    this.observer = Utils.addVisibilityObserver(
      this.content,
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
    liveSocket.execJS(this.events, this.popover.dataset.onShow);
  }

  onInvisible() {
    liveSocket.execJS(this.events, this.popover.dataset.onHide);
  }
}

class ContentByHoverVisibility {
  popover: HTMLElement;
  events: HTMLElement;
  targets: HTMLElement[];

  constructor(
    popover: HTMLElement,
    events: HTMLElement,
    targets: HTMLElement[],
  ) {
    this.popover = popover;
    this.events = events;
    this.targets = targets;
  }

  mounted() {
    this.isVisible = false;

    this.timer = null;
    this.visibleDelay = 0;
    this.invisibleDelay = 200;

    this.onVisible = () => {
      clearTimeout(this.timer);

      this.timer = setTimeout(() => {
        if (!this.isVisible) {
          this.isVisible = true;

          liveSocket.execJS(this.events, this.popover.dataset.onShow);
        }
      }, this.visibleDelay);
    };
    this.onInvisible = () => {
      clearTimeout(this.timer);

      this.timer = setTimeout(() => {
        if (this.isVisible) {
          this.isVisible = false;

          liveSocket.execJS(this.events, this.popover.dataset.onHide);
        }
      }, this.invisibleDelay);
    };

    this.targets.forEach((element) => this.addEvents(element));
  }

  beforeUpdate() {}
  updated() {}

  destroyed() {
    this.targets.forEach((element) => this.removeEvents(element));
  }

  disconnected() {}
  reconnected() {}

  addEvents(element: HTMLElement) {
    element.addEventListener("mouseenter", this.onVisible);
    element.addEventListener("focus", this.onVisible);
    element.addEventListener("mouseleave", this.onInvisible);
    element.addEventListener("blur", this.onInvisible);
  }

  removeEvents(element: HTMLElement) {
    element.removeEventListener("mouseenter", this.onVisible);
    element.removeEventListener("focus", this.onVisible);
    element.removeEventListener("mouseleave", this.onInvisible);
    element.removeEventListener("blur", this.onInvisible);
  }
}

class ComputePosition {
  popover: HTMLElement;
  content: HTMLElement;
  target: HTMLElement;
  arrow: HTMLElement;

  constructor(
    popover: HTMLElement,
    content: HTMLElement,
    target: HTMLElement,
    arrow: HTMLElement,
  ) {
    this.popover = popover;
    this.content = content;
    this.target = target;
    this.arrow = arrow;
  }

  mounted() {
    this.skidding = parseInt(this.popover.dataset.skidding, 10);
    this.distance = parseInt(this.popover.dataset.distance, 10);

    this.placement = this.popover.dataset.placement.replace("_", "-");

    this.cleanup = autoUpdate(this.target, this.content, () => {
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
    computePosition(this.target, this.content, {
      placement: this.placement,
      middleware: [
        offset({ mainAxis: this.distance, crossAxis: this.skidding }),
        flip(),
        shift(),
        ...(this.arrow != null ? [arrow({ element: this.arrow })] : []),
      ],
    }).then(({ x, y, middlewareData, placement }) => {
      Object.assign(this.content.style, {
        left: `${x}px`,
        top: `${y}px`,
      });

      if (this.arrow != null) {
        const side = placement.split("-")[0];

        const staticSide = {
          top: "bottom",
          right: "left",
          bottom: "top",
          left: "right",
        }[side];

        const staticTransform = {
          top: "45",
          right: "135",
          bottom: "-135",
          left: "-45",
        }[side];

        if (middlewareData.arrow) {
          const { x, y } = middlewareData.arrow;

          Object.assign(this.arrow.style, {
            left: x != null ? `${x}px` : "",
            top: y != null ? `${y}px` : "",
            [staticSide]: `${-this.arrow.offsetWidth / 2 - 1}px`,
            transform: `rotate(${staticTransform}deg)`,
          });
        }
      }
    });
  }
}

class PopoverHook extends Hook {
  mounted() {
    const popover = this.el;
    const content = popover.querySelector("& > div[ui-popover-content]");
    const arrow = content.querySelector("& > div[ui-popover-arrow]");
    const target = popover.querySelector("& > div[ui-popover-target]");
    const events = popover.querySelector("& > span[ui-push-events]");

    switch (popover.dataset.type) {
      case "hover": {
        const targets = [...target.querySelectorAll("*")];

        console.assert(targets.length > 0);

        // Add the popover content to targets so we don't close it when the mouse
        // is hovering the popover content.
        targets.push(content);

        this.hooks = [
          new ContentByHoverVisibility(popover, events, targets),
          new ComputePosition(popover, content, target, arrow),
        ];

        break;
      }

      case "click": {
        this.hooks = [
          new ContentByClickVisibility(popover, content, events),
          new ComputePosition(popover, content, target, arrow),
        ];

        break;
      }
    }

    this.hooks.forEach((hook) => hook.mounted());
  }

  updated() {
    this.hooks.forEach((hook) => hook.updated());
  }

  destroyed() {
    this.hooks.forEach((hook) => hook.destroyed());
  }
}

export default makeHook(PopoverHook);
