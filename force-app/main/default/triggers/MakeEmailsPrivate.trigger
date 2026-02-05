/**
 * @author gary.halstead@paccar.com
 * @created date 2020-08-05
 * @last modified 2020-08-13
 * @version 1.0
 * @description EmailMessage trigger
 */
trigger MakeEmailsPrivate on EmailMessage (after insert) {

	MessageNotExternallyAvailable.onAfterInsert(Trigger.new);

}