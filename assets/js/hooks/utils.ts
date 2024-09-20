class Utils {
  public static addVisibilityObserver(element, onVisible, onInvisible) {
    const observer = new IntersectionObserver((entries, observer) => {
      entries.forEach((entry) => {
        if (entry.intersectionRatio > 0) {
          onVisible(element);
        } else {
          onInvisible(element);
        }
      });
    });

    observer.observe(element);

    return observer;
  }

  public static removeVisibilityObserver(observer) {
    return observer.disconnect();
  }

  public static isVisibleInViewport(element, partiallyVisible = false) {
    const { top, left, bottom, right } = element.getBoundingClientRect();
    const { innerHeight, innerWidth } = window;

    if (partiallyVisible) {
      return (
        ((top > 0 && top < innerHeight) ||
          (bottom > 0 && bottom < innerHeight)) &&
        ((left > 0 && left < innerWidth) || (right > 0 && right < innerWidth))
      );
    } else {
      return (
        top >= 0 && left >= 0 && bottom <= innerHeight && right <= innerWidth
      );
    }
  }
}

export default Utils;
