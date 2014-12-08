Things to note:

You can use the following credentials to log into the the app
1. Username: smk || Password: smk 
2. Username: anna || Password: 1234
3. Username: yuri || Password: 1234

****************************************************************************************

If the build fails please delete the references to the following dependencies (in Xcode) and re-add them one by one from the project folder. This should solve the dependencies issues:
#Dependencies to be included:
1. FBAudienceNetwork.framework
2. Firebase.framework
3. FacebookSDK.framework
4. Parse.framework
5. ParseUI.framework
6. ParseFacebookUtils.framework.

DO NOT INCLUDE THE “Bolts.framework” as this may cause issues.


******************************************************************************************

Known Issues:

1. The Location service is buggy. If you do not see your co-ordinates in the terminal, you’ll end up getting a null pointer exception.

2. Occasionally, Parse takes infinitely long amount of time to get the data from the User Class. 	When this happens, you’ll see a message saying “Warning: A long-running operation is being executed on the main thread. Break on warnBlockingOperationOnMainThread() to debug.”. This is however solved by restarting XCode and the simulator.