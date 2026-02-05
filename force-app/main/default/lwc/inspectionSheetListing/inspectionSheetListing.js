import { LightningElement, api } from 'lwc';

export default class InspectionSheetListing extends LightningElement {
  selectedDocuments = [];
  @api inspectionSheets = [];
  @api isAdminUser;

  get inspectionSheetsList() {
    return this.inspectionSheets;
  }

  get isDisplayOnly() {
    return true;
  }
}