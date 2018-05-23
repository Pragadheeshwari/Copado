/* Purpose: creating chatter post to the group once application is created and changing application status */

trigger trgPostFeed on Application__c (after insert, after update) 
{
        if(trigger.isafter && trigger.isinsert)
        {
            CollaborationGroup chatterGroup = [select Id, Name from CollaborationGroup where Name = :'Recruiting'];
            FeedItem post = new FeedItem();
            post.Title = trigger.new[0].Name;
            post.Body = 'New Application was received';
            post.ParentId = chatterGroup.Id;
            post.linkURL = URL.getSalesforceBaseUrl().toExternalForm()+'/'+ trigger.new[0].id; 
            insert post;
        }
        
        set<id> jobId = new Set<id> ();
        set<id> appid = new Set<id> ();
        if(trigger.Isupdate)
        {
            for (Integer i = 0; i < Trigger.new.size(); i++) 
            {
                appid .add(trigger.new[i].id);
                if(trigger.old[i].Status__c != Trigger.new[i].Status__c && Trigger.new[i].Status__c == 'Offered' )
                {
                        jobId.add(trigger.new[i].Job_Posting__c);                 
                }
            }
        }
        else
        {
            for (Integer i = 0; i < Trigger.new.size(); i++) 
            {
                appid .add(trigger.new[i].id);
                if(Trigger.new[i].Status__c == 'Offered' )
                {
                        jobId.add(trigger.new[i].Job_Posting__c );
                        
                }
            }
        }
        
        Application__c [] updApplication = [select id,status__c,candidate__c,Job_Posting__c from Application__c where Job_Posting__c in: jobId and id not in: appid ];
        if(updApplication .size() > 0)
        {
            for(Application__c updStatus : updApplication)
            {
                updStatus.Status__c = 'Declined';
                
            }
            update updApplication;
        }
        
}