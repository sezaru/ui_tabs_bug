import { forwardRef } from "preact/compat";
import { useImperativeHandle, useState } from "preact/hooks";

const MustacheMenu = forwardRef((props, ref) => {
  const [selectedIndex, setSelectedIndex] = useState(0);

  useImperativeHandle(ref, () => ({
    onKeyDown: ({ event }) => {
      if (event.key === "ArrowUp") {
        upHandler();
        return true;
      }

      if (event.key === "ArrowDown") {
        downHandler();
        return true;
      }

      if (event.key === "Enter") {
        enterHandler();
        return true;
      }

      return false;
    },
  }));

  const upHandler = () => {
    setSelectedIndex(
      (selectedIndex + props.items.length - 1) % props.items.length,
    );
  };

  const downHandler = () => {
    setSelectedIndex((selectedIndex + 1) % props.items.length);
  };

  const enterHandler = () => {
    selectItem(selectedIndex);
  };

  const selectItem = (index) => {
    const item = props.items[index];

    if (item) {
      props.command({ id: item.value });
    }
  };

  const Item = (props) => {
    return (
      <button
        className={
          (props.isSelected ? "bg-purple-100" : "") + " hover:bg-purple-50"
        }
        key={props.index}
        onClick={() => selectItem(props.index)}
      >
        {props.item.label}
      </button>
    );
  };

  const Items = (props) => {
    if (props.items.length == 0) {
      return <div className="bg-red-100">No result</div>;
    } else {
      return props.items.map((item, index) => (
        <Item item={item} index={index} isSelected={index == selectedIndex} />
      ));
    }
  };

  return (
    <div className="bg-green-100 p-4 flex flex-col gap-2">
      <Items items={props.items} />
    </div>
  );
});

export default MustacheMenu;
