/*
Created for accenture Interview
Purpose: To create resume object record with a attachment
Extension for CreateResume VF page 

*/
public with sharing class AttachmentUploadController 
{
    public Id recordId;
    public REsume__c fileupload;
    

    public AttachmentUploadController() 
    {
        
    }


    public AttachmentUploadController(ApexPages.StandardController controller) 
    {
        
        fileupload =(Resume__C)controller.getRecord();
    }


    public Attachment attachment 
    {
        get 
        {
            if (attachment == null)
            attachment = new Attachment();
            return attachment;
        }
        set;
    }

public REsume__c getfileupload(){

    if(fileupload == null)
    fileupload = new Resume__c();
    return fileupload;
    }
    
    

    public PageReference upload() 
    {
    
        system.debug(fileupload+'@@@@@@'+attachment);
        
        
        try 
        {
            if(fileupload.id == null)
            insert fileupload;
            
            attachment.OwnerId = UserInfo.getUserId();
            attachment.ParentId = fileupload.id; 
            insert attachment;
            fileupload.attachid__c= attachment.id;
            update fileupload;
        } 
        catch (DMLException e) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            return null;
        } 
        finally 
        {
            attachment = new Attachment(); 
        }
        
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        PageReference pageRef = new PageReference(retURL);  
        pageRef.setRedirect(true);               
        return pageRef ;
    }
    
}