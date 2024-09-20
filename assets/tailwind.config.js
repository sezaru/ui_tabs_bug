// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin");
const fs = require("fs");
const path = require("path");

const matchGroup = (groupName, selector, matchVariant) => {
  matchVariant(
    groupName,
    (_value, { modifier }) => {
      if (modifier) {
        return `:merge(.group\\/${modifier})${selector} &`;
      } else {
        return `:merge(.group)${selector} &`;
      }
    },
    { values: { DEFAULT: "" } },
  );
};

const matchPeer = (peerName, selector, matchVariant) => {
  matchVariant(
    peerName,
    (_value, { modifier }) => {
      if (modifier) {
        return `:merge(.peer\\/${modifier})${selector} ~ &`;
      } else {
        return `:merge(.peer)${selector} ~ &`;
      }
    },
    { values: { DEFAULT: "" } },
  );
};

module.exports = {
  content: [
    "./js/**/*.{js,ts,tsx,jsx}",
    "./node_modules/flowbite/**/*.js",
    "../lib/ui_web.ex",
    "../lib/ui_web/**/*.*ex",
  ],
  theme: {
    extend: {
      colors: {
        brand: "#FD4F00",
      },
    },
  },
  plugins: [
    require("flowbite/plugin"),
    require("@tailwindcss/forms"),
    plugin(({ addVariant, matchVariant }) => {
      addVariant("phx-click-loading", [
        ".phx-click-loading&",
        ".phx-click-loading &",
      ]);
      matchGroup("group-phx-click-loading", ".phx-click-loading", matchVariant);
      matchPeer("peer-phx-click-loading", ".phx-click-loading", matchVariant);
    }),
    plugin(({ addVariant, matchVariant }) => {
      addVariant("phx-submit-loading", [
        ".phx-submit-loading&",
        ".phx-submit-loading &",
      ]);
      matchGroup(
        "group-phx-submit-loading",
        ".phx-submit-loading",
        matchVariant,
      );
      matchPeer("peer-phx-submit-loading", ".phx-submit-loading", matchVariant);
    }),
    plugin(({ addVariant, matchVariant }) => {
      addVariant("phx-change-loading", [
        ".phx-change-loading&",
        ".phx-change-loading &",
      ]);
      matchGroup(
        "group-phx-change-loading",
        ".phx-change-loading",
        matchVariant,
      );
      matchPeer("peer-phx-change-loading", ".phx-change-loading", matchVariant);
    }),
    plugin(({ addVariant, matchVariant }) => {
      addVariant("ui-loading", [
        ".phx-submit-loading&",
        ".phx-click-loading&",
        ".ui-loading&",
        ".phx-submit-loading &",
        ".phx-click-loading &",
        ".ui-loading &",
      ]);
      matchGroup(
        "group-ui-loading",
        ":is(.phx-click-loading, .phx-submit-loading, .ui-loading)",
        matchVariant,
      );
      matchPeer(
        "peer-ui-loading",
        ":is(.phx-click-loading, .phx-submit-loading, .ui-loading)",
        matchVariant,
      );
    }),
    plugin(({ addVariant }) => {
      addVariant("drag-item", [".drag-item&", ".drag-item &"]);
      addVariant("drag-ghost", [".drag-ghost&", ".drag-ghost &"]);
    }),
  ],
};
