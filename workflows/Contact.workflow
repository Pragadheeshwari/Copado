<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Email_Duplicate_Check</fullName>
        <field>Email__c</field>
        <formula>Email</formula>
        <name>Email Duplicate Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phone_Duplicate_update</fullName>
        <field>Phone__c</field>
        <formula>Phone</formula>
        <name>Phone Duplicate update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Phone Email Dup Check</fullName>
        <actions>
            <name>Email_Duplicate_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Phone_Duplicate_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISNEW(), ISCHANGED( Phone ), ISCHANGED( Email))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
