defmodule UiWeb.Router do
  use UiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {UiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UiWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/button", ButtonLive

    live "/button_group", ButtonGroupLive

    live "/modal", ModalLive, :index
    live "/modal/open_1", ModalLive, :modal_1
    live "/modal/open_2", ModalLive, :modal_2

    live "/drawer", DrawerLive, :index
    live "/drawer/open_1", DrawerLive, :drawer_1
    live "/drawer/open_2", DrawerLive, :drawer_2

    live "/tabs", TabsLive, :index
    live "/tabs/load_shit", TabsLive, :load_shit
    live "/tabs/with_form", TabsLive, :with_form

    live "/dynamic_tabs", DynamicTabsLive, :index
    live "/dynamic_tabs/load_shit", DynamicTabsLive, :load_shit
    live "/dynamic_tabs/with_form", DynamicTabsLive, :with_form
    live "/dynamic_tabs/:current_tab_id", DynamicTabsLive, :dynamic

    live "/combo_box", ComboBoxLive
    live "/dropdown", DropdownLive
    live "/popover", PopoverLive

    live "/table", TableLive

    live "/editor", EditorLive

    live "/form", FormLive

    live "/accordion", AccordionLive
    live "/accordion/flowbite", AccordionLive, :flowbite
    live "/accordion/gura", AccordionLive, :gura
    live "/accordion/woman", AccordionLive, :woman

    live "/carousel", CarouselLive

    live "/test", TestLive

    # TODO breadcrumb
    # TODO Chip https://surface.moon.io/components/v2/chip
    # TODO auth code https://surface.moon.io/components/v2/form/auth_code
    # TODO Make drawer horizontally
    # TODO buttom group
    # TODO Carousel
    # DONE Expand dropdown to support chat bubble example
    # TODO dropdowns examples
    # DONE form inputs
    # DONE popover
    # DONE tooltips
    # TODO speed dial
    # TODO combobox https://preline.co/plugins/html/combobox.html https://surface.moon.io/components/v2/form/combobox
    # TODO search input https://surface.moon.io/components/v2/search
    # TODO date picker https://surface.moon.io/components/date/datepicker
    # TODO menu item https://surface.moon.io/components/v2/menu_item
    # TODO Group inputs https://surface.moon.io/components/v2/form/group
    # TODO Add option to replace variant? (ex. card with tabs in flowbite)
  end
end
