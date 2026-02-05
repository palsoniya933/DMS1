import { LightningElement, api } from 'lwc';
import { tooltipTextClasses, tooltipTextStyles } from "./computeStyles";
import csr_Resources from "@salesforce/resourceUrl/csr_Resources";

export default class EDealerInfoIcon extends LightningElement {

  @api content = "";
  @api align = "top-left";
  @api iconName = "default";
  csrInfoIcon=`${csr_Resources}/Icons/csr_Info.svg`;
  
  get showDefaultIcon(){
    return this.iconName && this.iconName == 'default';
  }

  get showCSRInfoIcon(){
    return this.iconName && this.iconName == 'csr_info';
  }

  get computeTooltipTextClasses() {
    return tooltipTextClasses(this.align);
  }

  get computeTooltipTextStyles() {
    return tooltipTextStyles(this.content,this.align);
  }

  renderedCallback(){
    const tooltipContent  = this.template.querySelector('.tooltip-content');
    if(tooltipContent){
      tooltipContent.innerHTML = this.content;
    }
  }

}