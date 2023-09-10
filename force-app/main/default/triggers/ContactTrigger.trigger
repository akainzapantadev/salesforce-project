/************************************************************************************************************
* @description : ContactTrigger:beforeInsert
* @author      : Bootcamp A.E.Z
* @date        : 2023-08-07
* **********************************************************************************************************/
trigger ContactTrigger on Contact (before insert) {
  if(trigger.isBefore){
    if(trigger.isInsert){
      ContactTriggerHandler.onBeforeInsert(trigger.new);
    }
  }
}