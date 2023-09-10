/************************************************************************************************************
* @description : AccountTrigger:beforeUpdate
* @author      : Bootcamp A.E.Z
* @date        : 2023-08-07
* **********************************************************************************************************/
trigger AccountTrigger on Account (before update) {
  if(trigger.isBefore){
    if(trigger.isUpdate){
      AccountTriggerHandler.onBeforeUpdate(trigger.new,trigger.oldMap);
    }
  }
}