trigger ContentDocumentFileVisbilty on ContentDocumentLink (before insert) {
    if(Trigger.isinsert && Trigger.isbefore){
        DtmContentDocFileVisiblityHelper.sharingVisiblityToPortalUser(Trigger.new);
    }
}