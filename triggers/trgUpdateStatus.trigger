/* Purpose: update resume status to maintain one active at a time per candidate and updating application once active resume was changed */
trigger trgUpdateStatus on Resume__c (after insert, after update) 
{
    Map<id,Resume__c> mapAll = new Map<id, Resume__c>();
    set<id> contactId = new Set<id> ();
    set<id> resumeid = new Set<id> ();
    if(trigger.Isupdate)
    {
        for (Integer i = 0; i < Trigger.new.size(); i++) 
        {
            resumeid.add(trigger.new[i].id);
            if(trigger.old[i].Status__c != Trigger.new[i].Status__c && Trigger.new[i].Status__c == 'Active' )
            {
                    contactId.add(trigger.new[i].candidate__c);
                    mapAll.put(trigger.new[i].candidate__c, trigger.new[i]);
            }
        }
    }
    else
    {
        for (Integer i = 0; i < Trigger.new.size(); i++) 
        {
            resumeid.add(trigger.new[i].id);
            if(Trigger.new[i].Status__c == 'Active' )
            {
                    contactId.add(trigger.new[i].candidate__c);
                    mapAll.put(trigger.new[i].candidate__c, trigger.new[i]);
            }
        }
    }
    
    Resume__c[] updResume = [select id,status__c,candidate__c from resume__c where candidate__c in: contactid and status__c = 'Active' and id not in: resumeid];
    if(updResume.size() > 0)
    {
        for(resume__c updStatus : updResume)
        {
            updStatus.Status__c = 'InActive';
            
        }
        update updResume;
    }
    
    Application__c[] updApplication = [Select id,Resume__c,candidate__c from Application__c where candidate__c in: contactid];
    if(updApplication.size() > 0)
    {
        for(Application__c updApp : updApplication)
        {
            if(mapAll.get(updApp.Candidate__c).Status__c == 'Active')
            updApp.Resume__c= mapAll.get(updApp.Candidate__c).id;
            
        }
        update updApplication;
    }

}