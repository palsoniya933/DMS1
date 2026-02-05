import { LightningElement, api,wire } from 'lwc';
import getStateOption from '@salesforce/apex/eDealerAddCompetitorController.getStateOption';
import getAffiliationOption from '@salesforce/apex/eDealerAddCompetitorController.getAffiliationOption';
import EDealer_Complete_This_Field_Error_Message from '@salesforce/label/c.EDealer_Complete_This_Field_Error_Message';
import Edealer_Competitor_Name from '@salesforce/label/c.Edealer_Competitor_Name';
import fetchLoggedInUserdetails from '@salesforce/apex/eDealerChooseCompetitorController.fetchLoggedInUserdetails';
import Edealer_Address_Lookup from '@salesforce/label/c.Edealer_Address_Lookup';
import Edealer_Affiliation from '@salesforce/label/c.Edealer_Affiliation';
import Edealer_Affiliation_Available from '@salesforce/label/c.Edealer_Affiliation_Available';
import Edealer_Affiliation_Selected from '@salesforce/label/c.Edealer_Affiliation_Selected';
import Edealer_Address_Street from '@salesforce/label/c.Edealer_Address_Street';
import EDealer_Address_City from '@salesforce/label/c.EDealer_Address_City';
import Edealer_Address_Country from '@salesforce/label/c.Edealer_Address_Country';
import Edealer_Address_State_Province from '@salesforce/label/c.Edealer_Address_State_Province';
import Edealer_Address_Zip_Postal_Code from '@salesforce/label/c.Edealer_Address_Zip_Postal_Code';
import EDealer_Cancel from '@salesforce/label/c.EDealer_Cancel';
import Edealer_SAVE_AND_SELECT_COMPETITOR from '@salesforce/label/c.Edealer_SAVE_AND_SELECT_COMPETITOR';
import getCSRHeaderTranslations from '@salesforce/apex/eDealerCreateCsrController.getCSRHeaderTranslations';


export default class EdealerAddCompetitor extends LightningElement {
    label = {
        EDealer_Complete_This_Field_Error_Message,
        Edealer_Competitor_Name,
        Edealer_Address_Lookup,
        Edealer_Affiliation,
        Edealer_Affiliation_Available,
        Edealer_Affiliation_Selected,
        Edealer_Address_Street,
        EDealer_Address_City,
        Edealer_Address_Country,
        Edealer_Address_State_Province,
        Edealer_Address_Zip_Postal_Code,
        EDealer_Cancel,
        Edealer_SAVE_AND_SELECT_COMPETITOR
    }
    
    @api addCompetitorFormData = {};
    competitorFormData = {};
    affiliationOptions = [];
    stateOptions = [];
    strCity;
    strState;
    showField = true;
     loggedInUser;
    strCountry;
    strPostalCode;
    isLoading = false;
    citycanotexceed20characters;
    postalcodecanotexceed10characters;
    stateProvincecanotexceed20characters;
    countrycanotexceed30characters;
    connectedCallback() {
        this.isLoading = true;
        this.competitorFormData = { ...this.addCompetitorFormData };
        //console.log('comsjwe--------'+JSON.stringify(this.competitorFormData));
        const promises = [];
        promises.push(
            getStateOption()
                .then((results) => {
                    this.stateOptions = results;
                })
                .catch((error) => {

                })
        );
        promises.push(
            getAffiliationOption()
                .then((results) => {
                    this.affiliationOptions = results;
                })
                .catch((error) => {

                })
        );
        Promise.all(promises)
            .then(() => {

            })
            .catch((error) => {

            })
            .finally(() => {
                this.isLoading = false;
            });
            this.getCSRTranslation();
    }

getCSRTranslation() {
   
    //getting picklist value for csr header from custom metadata(translation feature enabled)
     getCSRHeaderTranslations().then((result) => {
      console.log('result--444434---'+JSON.stringify(result));
      this.citycanotexceed20characters = result.addCompetitorAddress.Citycanotexceed20characters[0].label;
     console.log(' this.Citycanotexceed20characters---'+ this.citycanotexceed20characters);
      this.postalcodecanotexceed10characters = result.addCompetitorAddress.Postalcodecanotexceed10characters[0].label;
       this.stateProvincecanotexceed20characters = result.addCompetitorAddress.StateProvincecanotexceed20characters[0].label;
        this.countrycanotexceed30characters = result.addCompetitorAddress.Countrycanotexceed30characters[0].label;
    })
      .catch((error) => {
        console.log(JSON.stringify(error))
      });
  }
    get getAffiliationOptions() {
        return this.affiliationOptions;
    }

    get getStateOptions() {
        return this.stateOptions;
    }

     @wire(fetchLoggedInUserdetails)
    wiredUser({ error, data }) {
        if (data) {
            this.loggedInUser = data;
            console.log('this.loggedInUser.IsPortalEnabled---'+this.loggedInUser.IsPortalEnabled);
            this.handleFieldVisibility();
        } else if (error) {
            // Handle error
        }
    }

     handleFieldVisibility() {
        // Check if the user is enabled for the portal
        if (this.loggedInUser.IsPortalEnabled==true) {
            this.showField = false;
        }
    }

    handleInputChange(event) {
        let name = event.target.name;
        let value = event.detail.value;
        this.competitorFormData[name] = value;
    }
    // used to close modal.
    handleCloseCompetitorModal(evt) {
        this.dispatchEvent(new CustomEvent('cancelmodal', {
            detail: {
                openCompetitorModal: false
            }
        }));
    }

    handleValidation() {
        let isValid = true;
        let inputFields = this.template.querySelectorAll(".validate");
        inputFields.forEach(inputField => {
            if (!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
        });
         if (isValid) {
            isValid = this.validateAddress('.compAddressField');
        }else{
            this.validateAddress('.compAddressField')
        }
        return isValid;
    }

    //Use to handle event for adding new competitor from add competitor form to part list.
    handleAddCompetitor(event) {
        const address = this.template.querySelector('lightning-input-address');
        var country = address.country;
        var province = address.province;
        var city = address.city;
        var postalCode = address.postalCode;
        if (!country) {
            address.setCustomValidityForField('Field is Required', 'country');
        }
        else{
            address.setCustomValidityForField('', 'country');
        }
        if (!province) {
            address.setCustomValidityForField('Field is Required', 'province');
        }
        else{
            address.setCustomValidityForField('', 'province');
        }
        if (!postalCode) {
            address.setCustomValidityForField('Field is Required', 'postalCode');
        }
        else{
            address.setCustomValidityForField('', 'postalCode');
        }
        if (!city) {
            address.setCustomValidityForField('Field is Required', 'city');
        }
        else{
            address.setCustomValidityForField('', 'city');
        }
        const isValid = address.checkValidity();
        let isInputValidated = this.handleValidation();
        if (isValid && isInputValidated) {
            this.competitorFormData.tab = "addCompetitor";
            console.log('DAta', JSON.stringify(this.competitorFormData));
            this.dispatchEvent(new CustomEvent('addcompetitor', {
                detail: {
                    selectedCompetitorData: this.competitorFormData
                }
            }));
            this.handleCloseCompetitorModal(event);
        }
    }
    

    addressInputChange(event) {
        this.competitorFormData['CompCity'] = event.target.city;
        this.competitorFormData['CompState'] = event.target.province;
        this.competitorFormData['CompCountry'] = event.target.country;
        this.competitorFormData['CompPostal'] = event.target.postalCode;
    }
        validateAddress(addressClassField) {
    let isAddressValidated = true;

    this.template.querySelectorAll(addressClassField).forEach(field => {
        const street = field.street;
        const city = field.city;
        const state = field.province;
        const country = field.country;
        const postalCode = field.postalCode;

        if (!city) {
            field.setCustomValidityForField(" ", "city");
            isAddressValidated = false;
        } else if (city.length > 20) {
            field.setCustomValidityForField(this.citycanotexceed20characters, "city");
            isAddressValidated = false;
        } else {
            field.setCustomValidityForField("", "city");
        }

        if (!state) {
            field.setCustomValidityForField(" ", "province");
            isAddressValidated = false;
        } else if (state.length > 20) {
            field.setCustomValidityForField(this.stateProvincecanotexceed20characters, "province");
            isAddressValidated = false;
        } else {
            field.setCustomValidityForField("", "province");
        }

        if (!country) {
            field.setCustomValidityForField(" ", "country");
            isAddressValidated = false;
        } else if (country.length > 30) {
            field.setCustomValidityForField(this.countrycanotexceed30characters, "country");
            isAddressValidated = false;
        } else {
            field.setCustomValidityForField("", "country");
        }

        if (!postalCode) {
            field.setCustomValidityForField(" ", "postalCode");
            isAddressValidated = false;
        } else if (postalCode.length > 10) {
            field.setCustomValidityForField(this.postalcodecanotexceed10characters, "postalCode");
            isAddressValidated = false;
        } else {
            field.setCustomValidityForField("", "postalCode");
        }

        field.reportValidity();
    });

    return isAddressValidated;
}
}