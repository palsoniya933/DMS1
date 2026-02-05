export function tooltipTextClasses(align = "top-right") {
  const BASE_CLASSES = ["tooltip", "slds-popover", "slds-popover_tooltip"];

  switch (align) {
    case "top-right":
      BASE_CLASSES.push("slds-nubbin_bottom-right", "tooltip-align-right");
      break;
    case "top-left":
      BASE_CLASSES.push("slds-nubbin_bottom-left", "tooltip-align-left");
      break;
    case "bottom-right":
      BASE_CLASSES.push("slds-nubbin_bottom-right", "tooltip-align-bottom-right");
      break;
    default:
      break;
  }

  return BASE_CLASSES.join(" ");
}

export function tooltipTextStyles(content, align = 'default') {
  if (typeof content === "string" && content?.length < 60) {
    return `min-width: max-content;`
  }
  else if (align === "bottom-right" && content?.length > 60) {

    return `white-space: break-spaces;padding-left: 15px`;
  }

  return `width: 60ch`;
}