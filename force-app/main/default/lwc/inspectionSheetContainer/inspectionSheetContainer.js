import { LightningElement, wire, api, track } from 'lwc';
import { executeQuery, getDataset } from 'lightning/analyticsWaveApi';
import fetchInspectionSheetList from '@salesforce/apex/ServiceInspectionSheetController.fetchInspectionSheetList';
import getCurrentLoggedInUserDetails from '@salesforce/apex/ServiceInspectionSheetController.getCurrentLoggedInUserDetails';
import isLoyaltyInspectionSheetAdmin from '@salesforce/apex/ServiceInspectionSheetController.isLoyaltyInspectionSheetAdmin';
import deleteFileFromS3Bucket from '@salesforce/apex/ServiceInspectionSheetController.deleteFileFromS3Bucket';

const DIVISION_KEY_BY_DIVISION_NAME = {
  kenworth: 'K',
  peterbilt: 'P',
};
const DATESET_DEALERCODEAPI = 'Dealer_code_Api';
const DATESET_FRCADEALERS = 'fr_CA_Dealers';
const QUERY_DEALERCODEAPI =
  "\";q = foreach q generate q.'DEALERGROUPNUMBER' as 'dealerGroupCode', q.'DEALERCODE' as 'dealerCode', q.'LOYALTY_REGION' as 'loyaltyRegion', q.'DIVISION' as 'division';q = limit q 2000;";
const QUERY_FRCADEALERS =
  "\";q = foreach q generate q.'CSTNO' as 'dealerCode';q = limit q 2000;";
const SPANISH_REGIONS = ['mexico', 'latin america'];
const FRENCH_REGIONS = ['canada'];

export default class InspectionSheetContainer extends LightningElement {
  @api dealerCode;
  datasetName = DATESET_DEALERCODEAPI;
  datasetId;
  datasetVersionId;
  query;
  dealerInfos = [];
  @track inspectionSheets = [];
  frCaDealers = [];
  loggedInUserInfo = {};
  isModalVisible = false;
  isAdminUser = false;
  showSpinner = true;
  existingFileIds = [];
  divisionKeys = [];

  get computedQuery() {
    if (this.datasetId && this.datasetVersionId) {
      this.query = this.buildQuery();
    }
    if (!this.query) {
      return undefined;
    }
    return {
      query: this.query,
    };
  }

  @wire(getDataset, {
    datasetIdOrApiName: '$datasetName',
  })
  onGetDataset({ data, error }) {
    if (error) {
      console.log('ERROR:', error);
      this.showSpinner = false;
    } else if (data) {
      this.datasetId = data.id;
      this.datasetVersionId = data.currentVersionId;
    }
  }

  // Please do not change the single quotes of computed query below. $computedQuery must be enclosed betweel single quotes
  @wire(executeQuery, {
    query: '$computedQuery',
  })
  onExecuteQuery({ data, error }) {
    if (error) {
      this.showSpinner = false;
    } else if (data) {
      if (this.datasetName == DATESET_DEALERCODEAPI) {
        this.dealerInfos = data.results.records;
        this.datasetName = DATESET_FRCADEALERS;
      } else {
        data?.results?.records?.forEach((record) => {
          this.frCaDealers.push(record.dealerCode);
        });
      }
      if (this.isDataReady()) {
        this.fetchCurrentLoggedInUserDetails();
      }
    }
  }

  connectedCallback() {
    this.checkUserIsInspectionSheetAdmin();
  }

  checkUserIsInspectionSheetAdmin(){
    isLoyaltyInspectionSheetAdmin()
      .then((result) => {
        this.isAdminUser = result;
      })
      .catch((error) => {
        this.showSpinner = false;
        console.log(error.message);
      });
  }

  buildQuery() {
    let query = '';
    query += 'q = load "';
    query += this.datasetId;
    query += '/';
    query += this.datasetVersionId;
    if (this.datasetName == DATESET_DEALERCODEAPI) {
      query += QUERY_DEALERCODEAPI;
    } else {
      query += QUERY_FRCADEALERS;
    }
    return query;
  }

  fetchInspectionSheet(language) {
    this.showSpinner = true;
    fetchInspectionSheetList({ Language: language })
      .then((results) => {
        let inspectionSheets = this.sortListByFileName(results);
        if (inspectionSheets && inspectionSheets.length > 0) {
          this.existingFileIds = inspectionSheets.map((sheet) => {
            return sheet.id;
          });
        }
        this.inspectionSheets =
          this.filterSheetsForCurrentUser(inspectionSheets);
      })
      .catch((error) => {
        console.log(error.body.message);
      })
      .finally(() => {
        this.showSpinner = false;
      });
  }

  fetchCurrentLoggedInUserDetails() {
    this.showSpinner = true;
    getCurrentLoggedInUserDetails()
      .then((result) => {
        this.loggedInUserInfo = result;
        const language = this.identifyLanguage();
        this.fetchInspectionSheet(language);
      })
      .catch((error) => {
        console.log(error.message);
      })
      .finally(() => {
        this.showSpinner = false;
      });
  }

  handleModalVisibility() {
    this.isModalVisible = !this.isModalVisible;
  }

  isDataReady() {
    return (
      this.dealerInfos &&
      this.frCaDealers &&
      this.dealerInfos.length > 0 &&
      this.frCaDealers.length > 0
    );
  }

  identifyLanguage() {
    let dealerCode = '';
    let language = 'English';
    if (this.loggedInUserInfo.isDealerUser) {
      dealerCode = this.loggedInUserInfo.dealerCode;
    } else {
      dealerCode = this.dealerCode;
    }
    if (dealerCode) {
      const currentDealer = this.dealerInfos.find(
        (dealer) => dealer.dealerCode == dealerCode
      );
      if (currentDealer) {
        this.divisionKeys = DIVISION_KEY_BY_DIVISION_NAME[
          currentDealer.division.toLowerCase()
        ]
          ? [
              DIVISION_KEY_BY_DIVISION_NAME[
                currentDealer.division.toLowerCase()
              ],
              'A',
            ]
          : ['A'];
        if (
          SPANISH_REGIONS.includes(currentDealer.loyaltyRegion.toLowerCase())
        ) {
          language = 'Spanish';
        } else if (
          FRENCH_REGIONS.includes(currentDealer.loyaltyRegion.toLowerCase())
        ) {
          const isFrenchCanadianDealer =
            this.identifyFrenchCanadianDealer(dealerCode);
          if (isFrenchCanadianDealer) {
            language = 'French';
          } else {
            language = 'English';
          }
        } else {
          language = 'English';
        }
      }
    }
    return language;
  }

  handleFileUploaded() {
    const language = this.identifyLanguage();
    this.fetchInspectionSheet(language);
    this.handleModalVisibility();
  }

  sortListByFileName(data) {
    data.sort(function (a, b) {
      var x = a.fileName;
      var y = b.fileName;
      return x < y ? -1 : x > y ? 1 : 0;
    });
    return data;
  }

  identifyFrenchCanadianDealer(dealerCode) {
    return this.frCaDealers.includes(dealerCode);
  }

  deleteDocument(event) {
    const uniqueId = event.detail.documentUniqueId;
    this.deleteDocumentFromS3Bucket(uniqueId);
  }

  deleteDocumentFromS3Bucket(uniqueId) {
    this.showSpinner = true;
    deleteFileFromS3Bucket({
      uniqueId: uniqueId,
    })
      .then((result) => {
        this.fetchInspectionSheet(this.identifyLanguage());
      })
      .catch((error) => {
        console.log(error);
      })
      .finally(() => {
        this.showSpinner = false;
      });
  }

  filterSheetsForCurrentUser(inspectionSheets) {
    if (this.isAdminUser) {
      return inspectionSheets;
    } else {
      return inspectionSheets.filter((sheet) => {
        return this.divisionKeys.some((key) =>
          sheet?.id?.toUpperCase().includes(key)
        );
      });
    }
  }
}