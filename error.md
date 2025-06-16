
The default interactive shell is now zsh.
To update your account to use zsh, please run `chsh -s /bin/zsh`.
For more details, please visit https://support.apple.com/kb/HT208050.
(base) Saads-MacBook-Air11:AugmentApp saadmomin$ log stream --predicate 'process == "Augment"' --level debug --style compact
Filtering the log data using "process == "Augment""
Timestamp               Ty Process[PID:TID]
2025-06-15 21:10:01.215 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSPersistentUIShowQuietSafeQuitStatus in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:01.216 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) supportsAutomaticTermination=0 isAutoQuittable=0 isActive=1 shouldRelaunchStopped=0
2025-06-15 21:10:01.217 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) shouldRelaunchStopped=0 relaunchShouldBeDisabled=0
2025-06-15 21:10:04.165 Db Augment[4909:8d9a] [com.apple.launchservices:cas] Calling block with kLSNotifyLostFrontmost { "ApplicationType"="Foreground", , "CFBundleIdentifier"="com.todesktop.230313mzl4w4u92", , "LSASN"=ASN:0x0-0x5d05d:, , "LSFrontApplicationSeed"=137, , "LSMenuBarOwnerASN"=ASN:0x0-0x5d05d:, , "LSMenuBarOwnerApplicationSeed"=131, , "LSOtherASN"=ASN:0x0-0x69069: } notificationID=100018 id=0x121a29a10
2025-06-15 21:10:04.178 I  Augment[4909:88ac] [com.apple.AppKit:Intelligence] stopping collection observation
2025-06-15 21:10:04.179 Db Augment[4909:88ac] [com.apple.launchservices:cas] CopyFrontApplication() = <private>
2025-06-15 21:10:04.179 Db Augment[4909:88ac] [com.apple.hiservices:processmgr] GetFrontProcess(), psn=0x0,0x5d05d result=0
2025-06-15 21:10:04.180 Df Augment[4909:8e18] [com.apple.xpc:connection] [0x10c599e50] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
2025-06-15 21:10:04.180 Df Augment[4909:8e18] [com.apple.xpc:session] [0x10c6b2640] Session canceled.
2025-06-15 21:10:04.182 Db Augment[4909:8d9a] [com.apple.runningboard:message] PERF: [app<application.com.augment.Augment.104572428.104589542(501)>:4909] Received message from runningboardd: async_didChangeInheritances:completion:
2025-06-15 21:10:04.183 A  Augment[4909:8d9a] (RunningBoardServices) didChangeInheritances
2025-06-15 21:10:04.186 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key AppleReduceDesktopTinting in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:04.186 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key DictationIMUseOnlyOfflineDictation in CFPrefsSearchListSource<0x121b34950> (Domain: com.apple.speech.recognition.AppleSpeechRecognition.prefs, Container: (null))
2025-06-15 21:10:04.185 Db Augment[4909:8d9a] [com.apple.runningboard:connection] didChangeInheritances: <RBSInheritanceChangeSet| gained:{(
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1575 0>
)} lost:(null)>
2025-06-15 21:10:04.185 Df Augment[4909:8e19] [com.apple.UIIntelligenceSupport:xpc] agent connection cancelled (details: Session manually canceled)
2025-06-15 21:10:04.189 Df Augment[4909:8e19] [com.apple.xpc:session] [0x10c6b2640] Disposing of session
2025-06-15 21:10:04.203 Db Augment[4909:8d9a] [com.apple.runningboard:message] PERF: [app<application.com.augment.Augment.104572428.104589542(501)>:4909] Received message from runningboardd: async_didChangeInheritances:completion:
2025-06-15 21:10:04.203 A  Augment[4909:8d9a] (RunningBoardServices) didChangeInheritances
2025-06-15 21:10:04.203 Db Augment[4909:8d9a] [com.apple.runningboard:connection] didChangeInheritances: <RBSInheritanceChangeSet| gained:{(
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1584 0>
)} lost:(null)>
2025-06-15 21:10:04.211 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) supportsAutomaticTermination=0 isAutoQuittable=0 isActive=0 shouldRelaunchStopped=0
2025-06-15 21:10:04.211 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) shouldRelaunchStopped=0 relaunchShouldBeDisabled=0
2025-06-15 21:10:04.267 Db Augment[4909:903d] [com.apple.runningboard:message] PERF: [app<application.com.augment.Augment.104572428.104589542(501)>:4909] Received message from runningboardd: async_didChangeInheritances:completion:
2025-06-15 21:10:04.267 A  Augment[4909:903d] (RunningBoardServices) didChangeInheritances
2025-06-15 21:10:04.268 Db Augment[4909:903d] [com.apple.runningboard:connection] didChangeInheritances: <RBSInheritanceChangeSet| gained:(null) lost:{(
    <RBSInheritance| environment:(none) name:com.apple.launchservices.userfacing origID:401-368-1553 0>,
    <RBSInheritance| environment:(none) name:com.apple.launchservices.userfacing origID:401-368-1553 0>,
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1554 0>,
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1575 0>,
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1541 0>
)}>
2025-06-15 21:10:04.290 Df Augment[4909:88ac] [com.apple.AppKit:StateRestoration] -[NSPersistentUIManager flushAllChanges]
2025-06-15 21:10:04.290 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSPersistentUIShowQuietSafeQuitStatus in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:04.290 Df Augment[4909:88ac] [com.apple.AppKit:StateRestoration] -[NSPersistentUIManager flushAllChanges] finishing enqueued operations
2025-06-15 21:10:04.290 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) supportsAutomaticTermination=0 isAutoQuittable=0 isActive=0 shouldRelaunchStopped=0
2025-06-15 21:10:04.290 Df Augment[4909:903d] [com.apple.AppKit:StateRestoration] -[NSPersistentUIManager flushAllChanges]_block_invoke asyncing to main queue
2025-06-15 21:10:04.290 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) shouldRelaunchStopped=0 relaunchShouldBeDisabled=0
2025-06-15 21:10:04.290 Df Augment[4909:903d] [com.apple.AppKit:StateRestoration] -[NSPersistentUIManager flushAllChanges]_block_invoke writing records
2025-06-15 21:10:09.265 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSPersistentUIShowQuietSafeQuitStatus in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:09.266 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) supportsAutomaticTermination=0 isAutoQuittable=0 isActive=0 shouldRelaunchStopped=0
2025-06-15 21:10:09.266 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) shouldRelaunchStopped=0 relaunchShouldBeDisabled=0
2025-06-15 21:10:09.987 Db Augment[4909:8e19] [com.apple.launchservices:cas] Calling block with kLSNotifyBecameFrontmost { "ApplicationType"="Foreground", , "CFBundleIdentifier"="com.augment.Augment", , "LSASN"=ASN:0x0-0x69069:, , "LSFrontApplicationSeed"=138, , "LSMenuBarOwnerASN"=ASN:0x0-0x69069:, , "LSMenuBarOwnerApplicationSeed"=132, , "LSOtherASN"=ASN:0x0-0x5d05d: } notificationID=100018 id=0x121a29a10
2025-06-15 21:10:09.990 I  Augment[4909:88ac] [com.apple.AppKit:Intelligence] starting collection observation
2025-06-15 21:10:09.990 Db Augment[4909:88ac] [com.apple.launchservices:cas] CopyFrontApplication() = <private>
2025-06-15 21:10:09.992 Df Augment[4909:90c0] [com.apple.UIIntelligenceSupport:xpc] establishing connection to agent
2025-06-15 21:10:09.992 Df Augment[4909:90c0] [com.apple.xpc:session] [0x121bec810] Session created.
2025-06-15 21:10:09.992 Df Augment[4909:90c0] [com.apple.xpc:session] [0x121bec810] Session created from connection [0x10ef4b500]
2025-06-15 21:10:09.992 Db Augment[4909:8e19] [com.apple.runningboard:message] PERF: [app<application.com.augment.Augment.104572428.104589542(501)>:4909] Received message from runningboardd: async_didChangeInheritances:completion:
2025-06-15 21:10:09.992 Df Augment[4909:90c0] [com.apple.xpc:connection] [0x10ef4b500] activating connection: mach=true listener=false peer=false name=com.apple.uiintelligencesupport.agent
2025-06-15 21:10:09.992 A  Augment[4909:8e19] (RunningBoardServices) didChangeInheritances
2025-06-15 21:10:09.993 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key AppleSavedCurrentInputSource in CFPrefsPlistSource<0x121d80800> (Domain: com.apple.HIToolbox, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No)
2025-06-15 21:10:09.992 Df Augment[4909:90c0] [com.apple.xpc:session] [0x121bec810] Session activated
2025-06-15 21:10:09.999 Db Augment[4909:88ac] [com.apple.hiservices:processmgr] GetFrontProcess(), psn=0x0,0x69069 result=0
2025-06-15 21:10:10.001 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:10.002 Df Augment[4909:88ac] [com.apple.AppKit:Window] order window front conditionally: 151 related: 0
2025-06-15 21:10:09.992 Db Augment[4909:8e19] [com.apple.runningboard:connection] didChangeInheritances: <RBSInheritanceChangeSet| gained:{(
    <RBSInheritance| environment:(none) name:com.apple.launchservices.userfacing origID:401-368-1595 0>,
    <RBSInheritance| environment:(none) name:com.apple.launchservices.userfacing origID:401-368-1595 0>
)} lost:(null)>
2025-06-15 21:10:10.004 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key NSWindow Frame SwiftUI.ModifiedContent<Augment.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1 in CFPrefsPlistSource<0x121a0a3c0> (Domain: com.augment.Augment, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:10.004 Db Augment[4909:8e19] [com.apple.runningboard:message] PERF: [app<application.com.augment.Augment.104572428.104589542(501)>:4909] Received message from runningboardd: async_didChangeInheritances:completion:
2025-06-15 21:10:10.004 A  Augment[4909:8e19] (RunningBoardServices) didChangeInheritances
2025-06-15 21:10:10.004 Db Augment[4909:8e19] [com.apple.runningboard:connection] didChangeInheritances: <RBSInheritanceChangeSet| gained:{(
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1596 0>
)} lost:(null)>
2025-06-15 21:10:10.009 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:10.011 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key AppleReduceDesktopTinting in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:10.011 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key DictationIMUseOnlyOfflineDictation in CFPrefsSearchListSource<0x121b34950> (Domain: com.apple.speech.recognition.AppleSpeechRecognition.prefs, Container: (null))
2025-06-15 21:10:10.662 Db Augment[4909:88ac] [com.apple.AppKit:Menu_Tracking] Menubar mouse down for session 0x121d37690, rootImpl 0x121d34e80.
2025-06-15 21:10:10.664 A  Augment[4909:88ac] (AppKit) trackMouse send control actions
2025-06-15 21:10:10.666 Db Augment[4909:88ac] [com.apple.CarbonCore:checkfix] _CSCheckFix(10507300,com.augment.Augment/1)=NOT-APPLIED
2025-06-15 21:10:10.812 A  Augment[4909:88ac] (AppKit) trackMouse send action on mouseUp
2025-06-15 21:10:10.813 A  Augment[4909:88ac] (AppKit) sendActionFrom:
2025-06-15 21:10:10.813 A  Augment[4909:88ac] (AppKit) trackMouse send control actions
2025-06-15 21:10:10.813 A  Augment[4909:88ac] (AppKit) sendAction:
2025-06-15 21:10:10.829 Db Augment[4909:88ac] [com.apple.CarbonCore:checkfix] _CSCheckFix(40356500,com.augment.Augment/1)=NOT-APPLIED
2025-06-15 21:10:10.833 Db Augment[4909:88ac] [com.apple.AppKit:Window] Window _TtC7SwiftUIP33_7B5508BFB2B0CAF1E28E206F2014E66B23SheetPresentationWindow 0x10edebbf0 context 0 -> c55b79a9
2025-06-15 21:10:10.833 I  Augment[4909:88ac] [com.apple.AppKit:Window] context (0 -> c55b79a9) for window 1cb
2025-06-15 21:10:10.834 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSAutomaticWindowAnimationsEnabled in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:10.840 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: Button, value: , table: Common, localizationNames: (null), result: Button
2025-06-15 21:10:10.843 Df Augment[4909:88ac] (Foundation) 🎨 VersionBrowser.body: **RENDERING** versions.count = 0
2025-06-15 21:10:10.844 Df Augment[4909:88ac] (Foundation) 🎨 VersionBrowser.body: versions.isEmpty = true
2025-06-15 21:10:10.844 Df Augment[4909:88ac] (Foundation) 🔍 VersionBrowser.UI: Displaying EMPTY state - versions.count = 0
2025-06-15 21:10:10.845 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: Button, value: , table: Common, localizationNames: (null), result: Button
2025-06-15 21:10:10.847 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: Button, value: , table: Common, localizationNames: (null), result: Button
2025-06-15 21:10:10.868 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key NSSplitView Subview Frames SwiftUI.ModifiedContent<Augment.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1, SidebarNavigationView, SidebarNavigationView in CFPrefsPlistSource<0x121a0a3c0> (Domain: com.augment.Augment, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:10.876 Df Augment[4909:88ac] (Foundation) 🎬 VersionBrowser.onAppear: **VIEW APPEARING** for file app_test_1.txt
2025-06-15 21:10:10.876 Df Augment[4909:88ac] (Foundation) 🎬 VersionBrowser.onAppear: File path: /Users/saadmomin/Desktop/auto3/app_test_1.txt
2025-06-15 21:10:10.876 Df Augment[4909:88ac] (Foundation) 🎬 VersionBrowser.onAppear: Current versions.count: 0
2025-06-15 21:10:10.876 Df Augment[4909:88ac] (Foundation) 🎬 VersionBrowser.onAppear: About to call loadVersions()...
2025-06-15 21:10:10.876 Df Augment[4909:88ac] (Foundation) 🚀 VersionBrowser.loadVersions: STARTING for /Users/saadmomin/Desktop/auto3/app_test_1.txt
2025-06-15 21:10:10.876 Df Augment[4909:88ac] (Foundation) 🔧 VersionBrowser.loadVersions: **SIMPLIFIED MODE - Real data only**
2025-06-15 21:10:10.879 Df Augment[4909:88ac] (Foundation) 🎬 VersionBrowser.onAppear: loadVersions() completed, versions.count: 0
2025-06-15 21:10:10.889 I  Augment[4909:88ac] [com.apple.AppKit:Controls] NSButtonVisualProvider found bezel configuration changes during display or layout
2025-06-15 21:10:10.914 I  Augment[4909:88ac] [com.apple.AppKit:Window] window 151 begin sheet 1cb
2025-06-15 21:10:10.914 Db Augment[4909:88ac] [com.apple.hiservices:processmgr] GetFrontProcess(), psn=0x0,0x69069 result=0
2025-06-15 21:10:10.914 Db Augment[4909:88ac] [com.apple.AppKit:Popover] 0x1240b4e00 _NSPopoverCloseAllPopoversRootedAtWindow, checkDefer=0, onlyTransient=1, includeSemiTransient=0
2025-06-15 21:10:10.914 Db Augment[4909:88ac] [com.apple.AppKit:Popover] 0x121bb0f80 _NSPopoverCloseAllPopoversRootedAtWindow, checkDefer=0, onlyTransient=1, includeSemiTransient=0
2025-06-15 21:10:10.914 Db Augment[4909:88ac] [com.apple.AppKit:Popover] 0x10edebbf0 _NSPopoverCloseAllPopoversRootedAtWindow, checkDefer=0, onlyTransient=1, includeSemiTransient=0
2025-06-15 21:10:10.915 I  Augment[4909:88ac] [com.apple.AppKit:Window] window 151 show sheet 1cb
2025-06-15 21:10:10.915 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSAutomaticWindowAnimationsEnabled in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:10.915 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key ApplePersistenceIgnoreState in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:10.915 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key ApplePersistenceIgnoreStateQuietly in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:10.930 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key increaseContrast in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:10.930 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key increaseContrast in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:10.930 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSAutomaticWindowAnimationsEnabled in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:10.931 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key ApplePersistenceIgnoreState in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:10.931 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key ApplePersistenceIgnoreStateQuietly in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:10.931 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key increaseContrast in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:10.931 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key increaseContrast in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:10.931 Df Augment[4909:88ac] [com.apple.AppKit:Window] order window front conditionally: 151 related: 0
2025-06-15 21:10:10.931 Df Augment[4909:88ac] [com.apple.AppKit:Window] parent <SwiftUI.AppKitWindow: 0x1240b4e00> windowNumber=151 remove <_TtC7SwiftUIP33_7B5508BFB2B0CAF1E28E206F2014E66B23SheetPresentationWindow: 0x10edebbf0> windowNumber=1cb from group
2025-06-15 21:10:10.931 Df Augment[4909:88ac] [com.apple.AppKit:Window] parent <SwiftUI.AppKitWindow: 0x1240b4e00> windowNumber=151 add <_TtC7SwiftUIP33_7B5508BFB2B0CAF1E28E206F2014E66B23SheetPresentationWindow: 0x10edebbf0> windowNumber=1cb to group
2025-06-15 21:10:10.931 Db Augment[4909:88ac] [com.apple.launchservices:cas]  key="UIPresentationMode" result="Normal" valid=YES
2025-06-15 21:10:10.931 Db Augment[4909:88ac] [com.apple.launchservices:cas]  key="UIPresentationMode" result="Normal" valid=YES
2025-06-15 21:10:10.932 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:10.933 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSAutomaticWindowAnimationsEnabled in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:10.933 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key ApplePersistenceIgnoreState in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:10.933 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key ApplePersistenceIgnoreStateQuietly in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:10.933 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key increaseContrast in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:10.933 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key increaseContrast in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:10.933 Df Augment[4909:88ac] [com.apple.AppKit:Window] order window: 1cb op: 1 relative: 151 related: 0
2025-06-15 21:10:10.945 Db Augment[4909:88ac] [com.apple.libspindump:logging] Expected HID response delay for the next 0.26s (25035357432)
2025-06-15 21:10:10.989 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:11.213 Df Augment[4909:88ac] [com.apple.AppKit:Window] parent <SwiftUI.AppKitWindow: 0x1240b4e00> windowNumber=151 remove <_TtC7SwiftUIP33_7B5508BFB2B0CAF1E28E206F2014E66B23SheetPresentationWindow: 0x10edebbf0> windowNumber=1cb from group
2025-06-15 21:10:11.213 Df Augment[4909:88ac] [com.apple.AppKit:Window] parent <SwiftUI.AppKitWindow: 0x1240b4e00> windowNumber=151 add <_TtC7SwiftUIP33_7B5508BFB2B0CAF1E28E206F2014E66B23SheetPresentationWindow: 0x10edebbf0> windowNumber=1cb to group
2025-06-15 21:10:11.213 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSAutomaticWindowAnimationsEnabled in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:11.213 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key ApplePersistenceIgnoreState in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:11.213 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key ApplePersistenceIgnoreStateQuietly in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:11.213 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key increaseContrast in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:11.213 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key increaseContrast in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:11.213 Df Augment[4909:88ac] [com.apple.AppKit:Window] order window: 1cb op: 1 relative: 151 related: 0
2025-06-15 21:10:11.214 Df Augment[4909:88ac] (Foundation) 🔄 VersionBrowser.loadVersions: **UPDATING UI STATE** on main thread
2025-06-15 21:10:11.214 Df Augment[4909:88ac] (Foundation) 🔄 VersionBrowser.loadVersions: Processing 1 loaded versions
2025-06-15 21:10:11.214 Df Augment[4909:88ac] (Foundation) 🔄 VersionBrowser.loadVersions: **SORTED VERSIONS** finalVersions.count = 1
2025-06-15 21:10:11.214 Df Augment[4909:88ac] (Foundation) 🔄 VersionBrowser.loadVersions: **FINAL STATE UPDATE** from 0 to 1
2025-06-15 21:10:11.214 Df Augment[4909:88ac] (Foundation) 🔄 VersionBrowser.loadVersions: **STATE UPDATED** versions.count = 1
2025-06-15 21:10:11.214 Df Augment[4909:88ac] (Foundation) 🏁 VersionBrowser.loadVersions: **COMPLETED** final versions.count = 1
2025-06-15 21:10:11.216 Df Augment[4909:88ac] (Foundation) 🎨 VersionBrowser.body: **RENDERING** versions.count = 1
2025-06-15 21:10:11.216 Df Augment[4909:88ac] (Foundation) 🎨 VersionBrowser.body: versions.isEmpty = false
2025-06-15 21:10:11.216 Df Augment[4909:88ac] (Foundation) 🎉 VersionBrowser.UI: Displaying VERSIONS - versions.count = 1
2025-06-15 21:10:11.216 Df Augment[4909:88ac] (Foundation) 📋 VersionBrowser.UI: Version IDs: ["B0D53F63"]
2025-06-15 21:10:11.216 Df Augment[4909:88ac] (Foundation) 🎨 VersionBrowser.VStack: **RENDERING VSTACK** with 1 versions
2025-06-15 21:10:11.216 Df Augment[4909:88ac] (Foundation) 🎨 VersionBrowser.LazyVStack: **RENDERING LAZYVSTACK** with 1 items
2025-06-15 21:10:11.217 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: Button, value: , table: Common, localizationNames: (null), result: Button
2025-06-15 21:10:11.221 Df Augment[4909:88ac] (Foundation) 🎨 VersionBrowser.ForEach: **CREATING ROW** for version B0D53F63
2025-06-15 21:10:11.221 Df Augment[4909:88ac] (Foundation) 🎨 VersionBrowser.SimpleRow: **RENDERING SIMPLE ROW** for B0D53F63
2025-06-15 21:10:11.221 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: KB, value: , table: FileSizeFormatting, localizationNames: (null), result: KB
2025-06-15 21:10:11.221 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: %@ %@, value: , table: FileSizeFormatting, localizationNames: (null), result: %1$@ %2$@
2025-06-15 21:10:11.222 Df Augment[4909:88ac] (Foundation) 🎨 VersionBrowser.ForEach: **CREATING ROW** for version B0D53F63
2025-06-15 21:10:11.222 Df Augment[4909:88ac] (Foundation) 🎨 VersionBrowser.SimpleRow: **RENDERING SIMPLE ROW** for B0D53F63
2025-06-15 21:10:11.222 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: KB, value: , table: FileSizeFormatting, localizationNames: (null), result: KB
2025-06-15 21:10:11.222 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: %@ %@, value: , table: FileSizeFormatting, localizationNames: (null), result: %1$@ %2$@
2025-06-15 21:10:11.266 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:11.272 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key NSSplitView Subview Frames SwiftUI.ModifiedContent<Augment.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1, SidebarNavigationView, SidebarNavigationView in CFPrefsPlistSource<0x121a0a3c0> (Domain: com.augment.Augment, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:11.274 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:12.413 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:13.000 Db Augment[4909:90c0] [com.apple.launchservices:cas] Calling block with kLSNotifyLostFrontmost { "ApplicationType"="Foreground", , "CFBundleIdentifier"="com.todesktop.230313mzl4w4u92", , "LSASN"=ASN:0x0-0x5d05d:, , "LSFrontApplicationSeed"=139, , "LSMenuBarOwnerASN"=ASN:0x0-0x5d05d:, , "LSMenuBarOwnerApplicationSeed"=133, , "LSOtherASN"=ASN:0x0-0x69069: } notificationID=100018 id=0x121a29a10
2025-06-15 21:10:13.005 I  Augment[4909:88ac] [com.apple.AppKit:Intelligence] stopping collection observation
2025-06-15 21:10:13.005 Db Augment[4909:88ac] [com.apple.launchservices:cas] CopyFrontApplication() = <private>
2025-06-15 21:10:13.005 Db Augment[4909:88ac] [com.apple.hiservices:processmgr] GetFrontProcess(), psn=0x0,0x5d05d result=0
2025-06-15 21:10:13.005 Df Augment[4909:90c0] [com.apple.xpc:connection] [0x10ef4b500] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
2025-06-15 21:10:13.005 Df Augment[4909:90c0] [com.apple.xpc:session] [0x121bec810] Session canceled.
2025-06-15 21:10:13.005 Df Augment[4909:90e4] [com.apple.UIIntelligenceSupport:xpc] agent connection cancelled (details: Session manually canceled)
2025-06-15 21:10:13.005 Df Augment[4909:90e4] [com.apple.xpc:session] [0x121bec810] Disposing of session
2025-06-15 21:10:13.006 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key AppleReduceDesktopTinting in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:13.006 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key DictationIMUseOnlyOfflineDictation in CFPrefsSearchListSource<0x121b34950> (Domain: com.apple.speech.recognition.AppleSpeechRecognition.prefs, Container: (null))
2025-06-15 21:10:13.006 Db Augment[4909:90c0] [com.apple.runningboard:message] PERF: [app<application.com.augment.Augment.104572428.104589542(501)>:4909] Received message from runningboardd: async_didChangeInheritances:completion:
2025-06-15 21:10:13.006 A  Augment[4909:90c0] (RunningBoardServices) didChangeInheritances
2025-06-15 21:10:13.006 Db Augment[4909:90c0] [com.apple.runningboard:connection] didChangeInheritances: <RBSInheritanceChangeSet| gained:{(
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1619 0>
)} lost:(null)>
2025-06-15 21:10:13.036 Db Augment[4909:90e4] [com.apple.runningboard:message] PERF: [app<application.com.augment.Augment.104572428.104589542(501)>:4909] Received message from runningboardd: async_didChangeInheritances:completion:
2025-06-15 21:10:13.036 A  Augment[4909:90e4] (RunningBoardServices) didChangeInheritances
2025-06-15 21:10:13.036 Db Augment[4909:90e4] [com.apple.runningboard:connection] didChangeInheritances: <RBSInheritanceChangeSet| gained:{(
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1627 0>
)} lost:(null)>
2025-06-15 21:10:13.070 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) supportsAutomaticTermination=0 isAutoQuittable=0 isActive=0 shouldRelaunchStopped=0
2025-06-15 21:10:13.070 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) shouldRelaunchStopped=0 relaunchShouldBeDisabled=0
2025-06-15 21:10:13.108 Df Augment[4909:88ac] [com.apple.AppKit:StateRestoration] -[NSPersistentUIManager flushAllChanges]
2025-06-15 21:10:13.108 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSPersistentUIShowQuietSafeQuitStatus in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:13.108 Db Augment[4909:88ac] [com.apple.launchservices:cas] Setting process information for [ kLSCurrentApp ASN, 0x0,0x2] .
2025-06-15 21:10:13.111 Df Augment[4909:88ac] [com.apple.AppKit:StateRestoration] -[NSPersistentUIManager flushAllChanges] finishing enqueued operations
2025-06-15 21:10:13.111 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) supportsAutomaticTermination=0 isAutoQuittable=0 isActive=0 shouldRelaunchStopped=0
2025-06-15 21:10:13.111 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) shouldRelaunchStopped=0 relaunchShouldBeDisabled=0
2025-06-15 21:10:13.111 Df Augment[4909:90e5] [com.apple.AppKit:StateRestoration] -[NSPersistentUIManager flushAllChanges]_block_invoke asyncing to main queue
2025-06-15 21:10:13.114 Df Augment[4909:90e3] [com.apple.AppKit:StateRestoration] -[NSPersistentUIManager flushAllChanges]_block_invoke writing records
2025-06-15 21:10:13.120 Db Augment[4909:90e3] [com.apple.runningboard:message] PERF: [app<application.com.augment.Augment.104572428.104589542(501)>:4909] Received message from runningboardd: async_didChangeInheritances:completion:
2025-06-15 21:10:13.120 A  Augment[4909:90e3] (RunningBoardServices) didChangeInheritances
2025-06-15 21:10:13.120 Db Augment[4909:90e3] [com.apple.runningboard:connection] didChangeInheritances: <RBSInheritanceChangeSet| gained:(null) lost:{(
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1619 0>,
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1584 0>,
    <RBSInheritance| environment:(none) name:com.apple.launchservices.userfacing origID:401-368-1595 0>,
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1596 0>,
    <RBSInheritance| environment:(none) name:com.apple.launchservices.userfacing origID:401-368-1595 0>
)}>
2025-06-15 21:10:15.086 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSPersistentUIShowQuietSafeQuitStatus in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:15.086 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) supportsAutomaticTermination=0 isAutoQuittable=0 isActive=0 shouldRelaunchStopped=0
2025-06-15 21:10:15.086 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) shouldRelaunchStopped=0 relaunchShouldBeDisabled=0
2025-06-15 21:10:15.538 Db Augment[4909:90e3] [com.apple.launchservices:cas] Calling block with kLSNotifyBecameFrontmost { "ApplicationType"="Foreground", , "CFBundleIdentifier"="com.augment.Augment", , "LSASN"=ASN:0x0-0x69069:, , "LSFrontApplicationSeed"=140, , "LSMenuBarOwnerASN"=ASN:0x0-0x69069:, , "LSMenuBarOwnerApplicationSeed"=134, , "LSOtherASN"=ASN:0x0-0x5d05d: } notificationID=100018 id=0x121a29a10
2025-06-15 21:10:15.539 Db Augment[4909:90e3] [com.apple.runningboard:message] PERF: [app<application.com.augment.Augment.104572428.104589542(501)>:4909] Received message from runningboardd: async_didChangeInheritances:completion:
2025-06-15 21:10:15.539 A  Augment[4909:90e3] (RunningBoardServices) didChangeInheritances
2025-06-15 21:10:15.540 Db Augment[4909:90e3] [com.apple.runningboard:connection] didChangeInheritances: <RBSInheritanceChangeSet| gained:{(
    <RBSInheritance| environment:(none) name:com.apple.launchservices.userfacing origID:401-368-1638 0>,
    <RBSInheritance| environment:(none) name:com.apple.launchservices.userfacing origID:401-368-1638 0>
)} lost:(null)>
2025-06-15 21:10:15.542 I  Augment[4909:88ac] [com.apple.AppKit:Intelligence] starting collection observation
2025-06-15 21:10:15.542 Db Augment[4909:88ac] [com.apple.launchservices:cas] CopyFrontApplication() = <private>
2025-06-15 21:10:15.544 Df Augment[4909:90e4] [com.apple.UIIntelligenceSupport:xpc] establishing connection to agent
2025-06-15 21:10:15.544 Df Augment[4909:90e4] [com.apple.xpc:session] [0x10ed36430] Session created.
2025-06-15 21:10:15.544 Df Augment[4909:90e4] [com.apple.xpc:session] [0x10ed36430] Session created from connection [0x10ed53da0]
2025-06-15 21:10:15.544 Df Augment[4909:90e4] [com.apple.xpc:connection] [0x10ed53da0] activating connection: mach=true listener=false peer=false name=com.apple.uiintelligencesupport.agent
2025-06-15 21:10:15.545 Df Augment[4909:90e4] [com.apple.xpc:session] [0x10ed36430] Session activated
2025-06-15 21:10:15.545 Db Augment[4909:90e3] [com.apple.runningboard:message] PERF: [app<application.com.augment.Augment.104572428.104589542(501)>:4909] Received message from runningboardd: async_didChangeInheritances:completion:
2025-06-15 21:10:15.545 A  Augment[4909:90e3] (RunningBoardServices) didChangeInheritances
2025-06-15 21:10:15.545 Db Augment[4909:90e3] [com.apple.runningboard:connection] didChangeInheritances: <RBSInheritanceChangeSet| gained:{(
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1639 0>
)} lost:(null)>
2025-06-15 21:10:15.548 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key AppleSavedCurrentInputSource in CFPrefsPlistSource<0x121d80800> (Domain: com.apple.HIToolbox, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No)
2025-06-15 21:10:15.551 Db Augment[4909:88ac] [com.apple.hiservices:processmgr] GetFrontProcess(), psn=0x0,0x69069 result=0
2025-06-15 21:10:15.551 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:15.551 Df Augment[4909:88ac] [com.apple.AppKit:Window] order window front conditionally: 1cb related: 0
2025-06-15 21:10:15.552 Df Augment[4909:88ac] [com.apple.AppKit:Window] order window: 151 op: -1 relative: 1cb related: 0
2025-06-15 21:10:15.553 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:15.558 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key AppleReduceDesktopTinting in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:15.558 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key DictationIMUseOnlyOfflineDictation in CFPrefsSearchListSource<0x121b34950> (Domain: com.apple.speech.recognition.AppleSpeechRecognition.prefs, Container: (null))
2025-06-15 21:10:15.660 Db Augment[4909:88ac] [com.apple.AppKit:Menu_Tracking] Menubar mouse down for session 0x121d37690, rootImpl 0x121d34e80.
2025-06-15 21:10:15.763 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSWindowTitlebarDoubleClickSwapsAppearance in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:15.763 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSWindowShouldSnapSizeOnDoubleClick in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:16.273 Df Augment[4909:88ac] [com.apple.iohid:oversized] Released connection: 3A584801-707F-4531-8357-05B334F3504F
{
    UUID = "3A584801-707F-4531-8357-05B334F3504F";
    caller = "HIToolbox: _TISCopyAttachedKeyboardLanguages + 112";
    dispatchQueue = 0;
    eventCount = 0;
    eventMask = 0;
    port = 90391;
    resetCount = 0;
    runloop = 0;
    services =     (
        4294969583
    );
    virtualServices =     (
    );
}
2025-06-15 21:10:16.273 I  Augment[4909:88ac] [com.apple.CoreAnalytics:client] Dropping "com.apple.internationalization.keyboard.doublekeypress" as it isn't used in any transform (not in the config or budgeted?)
2025-06-15 21:10:16.274 I  Augment[4909:88ac] [com.apple.AppKit:Window] window 151 end modal sheet 1cb
2025-06-15 21:10:16.275 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSAutomaticWindowAnimationsEnabled in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:16.275 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key ApplePersistenceIgnoreState in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:16.275 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key ApplePersistenceIgnoreStateQuietly in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:16.276 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key NSWindow Frame SwiftUI.ModifiedContent<Augment.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1 in CFPrefsPlistSource<0x121a0a3c0> (Domain: com.augment.Augment, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:16.281 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:16.282 Df Augment[4909:88ac] [com.apple.AppKit:Window] order window front conditionally: 151 related: 0
2025-06-15 21:10:16.282 Db Augment[4909:88ac] [com.apple.libspindump:logging] Expected HID response delay for the next 0.26s (25163469178)
2025-06-15 21:10:16.332 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:16.546 Df Augment[4909:88ac] [com.apple.AppKit:Window] parent <SwiftUI.AppKitWindow: 0x1240b4e00> windowNumber=151 remove <_TtC7SwiftUIP33_7B5508BFB2B0CAF1E28E206F2014E66B23SheetPresentationWindow: 0x10edebbf0> windowNumber=1cb from group
2025-06-15 21:10:16.546 Db Augment[4909:88ac] [com.apple.launchservices:cas]  key="UIPresentationMode" result="Normal" valid=YES
2025-06-15 21:10:16.546 Db Augment[4909:88ac] [com.apple.launchservices:cas]  key="UIPresentationMode" result="Normal" valid=YES
2025-06-15 21:10:16.548 Df Augment[4909:88ac] [com.apple.AppKit:Window] order window: 1cb op: 0 relative: 0 related: 0
2025-06-15 21:10:16.550 I  Augment[4909:88ac] [com.apple.AppKit:Window] context (c55b79a9 -> 0) for window 1cb
2025-06-15 21:10:16.572 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:16.728 Db Augment[4909:88ac] [com.apple.AppKit:Menu_Tracking] Menubar mouse down for session 0x121d37690, rootImpl 0x121d34e80.
2025-06-15 21:10:16.848 A  Augment[4909:88ac] (AppKit) sendAction:
2025-06-15 21:10:16.853 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: Button, value: , table: Common, localizationNames: (null), result: Button
2025-06-15 21:10:16.854 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: Button, value: , table: Common, localizationNames: (null), result: Button
2025-06-15 21:10:16.867 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: Button, value: , table: Common, localizationNames: (null), result: Button
2025-06-15 21:10:16.895 I  Augment[4909:88ac] [com.apple.AppKit:Controls] NSButtonVisualProvider found bezel configuration changes during display or layout
2025-06-15 21:10:16.909 I  Augment[4909:88ac] [com.apple.AppKit:Controls] NSButtonVisualProvider found bezel configuration changes during display or layout
2025-06-15 21:10:16.911 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:16.922 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: bytes, value: , table: FileSizeFormatting, localizationNames: (null), result: bytes
2025-06-15 21:10:16.922 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: %@ %@, value: , table: FileSizeFormatting, localizationNames: (null), result: %1$@ %2$@
2025-06-15 21:10:16.922 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: bytes, value: , table: FileSizeFormatting, localizationNames: (null), result: bytes
2025-06-15 21:10:16.922 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: %@ %@, value: , table: FileSizeFormatting, localizationNames: (null), result: %1$@ %2$@
2025-06-15 21:10:16.931 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: <private>, value: (null), table: Localizable, localizationNames: (null), result: <same as key>
2025-06-15 21:10:16.936 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:17.088 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:17.098 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:18.247 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSPersistentUIShowQuietSafeQuitStatus in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:18.248 Db Augment[4909:88ac] [com.apple.launchservices:cas] Setting process information for [ kLSCurrentApp ASN, 0x0,0x2] .
2025-06-15 21:10:18.248 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) supportsAutomaticTermination=0 isAutoQuittable=0 isActive=1 shouldRelaunchStopped=0
2025-06-15 21:10:18.248 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) shouldRelaunchStopped=0 relaunchShouldBeDisabled=0
2025-06-15 21:10:18.330 Db Augment[4909:88ac] [com.apple.AppKit:Menu_Tracking] Menubar mouse down for session 0x121d37690, rootImpl 0x121d34e80.
2025-06-15 21:10:18.487 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:18.493 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: <private>, value: (null), table: Localizable, localizationNames: (null), result: <same as key>
2025-06-15 21:10:18.493 Db Augment[4909:88ac] [com.apple.CFBundle:strings] Bundle: <private>, key: <private>, value: (null), table: Localizable, localizationNames: (null), result: <same as key>
2025-06-15 21:10:18.512 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:19.454 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] looked up value <private> for key cursorIsCustomized in CFPrefsPlistSource<0x121d0fc60> (Domain: com.apple.universalaccess, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: No) via CFPrefsSearchListSource<0x121d0f1a0> (Domain: com.apple.universalaccess, Container: (null))
2025-06-15 21:10:20.034 Db Augment[4909:8e19] [com.apple.launchservices:cas] Calling block with kLSNotifyLostFrontmost { "ApplicationType"="Foreground", , "CFBundleIdentifier"="com.todesktop.230313mzl4w4u92", , "LSASN"=ASN:0x0-0x5d05d:, , "LSFrontApplicationSeed"=141, , "LSMenuBarOwnerASN"=ASN:0x0-0x5d05d:, , "LSMenuBarOwnerApplicationSeed"=135, , "LSOtherASN"=ASN:0x0-0x69069: } notificationID=100018 id=0x121a29a10
2025-06-15 21:10:20.040 Db Augment[4909:8e19] [com.apple.runningboard:message] PERF: [app<application.com.augment.Augment.104572428.104589542(501)>:4909] Received message from runningboardd: async_didChangeInheritances:completion:
2025-06-15 21:10:20.040 A  Augment[4909:8e19] (RunningBoardServices) didChangeInheritances
2025-06-15 21:10:20.040 Db Augment[4909:8e19] [com.apple.runningboard:connection] didChangeInheritances: <RBSInheritanceChangeSet| gained:{(
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1658 0>
)} lost:(null)>
2025-06-15 21:10:20.043 I  Augment[4909:88ac] [com.apple.AppKit:Intelligence] stopping collection observation
2025-06-15 21:10:20.043 Db Augment[4909:88ac] [com.apple.launchservices:cas] CopyFrontApplication() = <private>
2025-06-15 21:10:20.043 Db Augment[4909:88ac] [com.apple.hiservices:processmgr] GetFrontProcess(), psn=0x0,0x5d05d result=0
2025-06-15 21:10:20.046 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key AppleReduceDesktopTinting in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:20.046 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key DictationIMUseOnlyOfflineDictation in CFPrefsSearchListSource<0x121b34950> (Domain: com.apple.speech.recognition.AppleSpeechRecognition.prefs, Container: (null))
2025-06-15 21:10:20.049 Df Augment[4909:8e19] [com.apple.xpc:connection] [0x10ed53da0] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
2025-06-15 21:10:20.049 Df Augment[4909:8e19] [com.apple.xpc:session] [0x10ed36430] Session canceled.
2025-06-15 21:10:20.050 Df Augment[4909:8e19] [com.apple.UIIntelligenceSupport:xpc] agent connection cancelled (details: Session manually canceled)
2025-06-15 21:10:20.050 Df Augment[4909:8e19] [com.apple.xpc:session] [0x10ed36430] Disposing of session
2025-06-15 21:10:20.068 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) supportsAutomaticTermination=0 isAutoQuittable=0 isActive=0 shouldRelaunchStopped=0
2025-06-15 21:10:20.068 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) shouldRelaunchStopped=0 relaunchShouldBeDisabled=0
2025-06-15 21:10:20.069 Db Augment[4909:90e4] [com.apple.runningboard:message] PERF: [app<application.com.augment.Augment.104572428.104589542(501)>:4909] Received message from runningboardd: async_didChangeInheritances:completion:
2025-06-15 21:10:20.070 A  Augment[4909:90e4] (RunningBoardServices) didChangeInheritances
2025-06-15 21:10:20.070 Db Augment[4909:90e4] [com.apple.runningboard:connection] didChangeInheritances: <RBSInheritanceChangeSet| gained:{(
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1666 0>
)} lost:(null)>
2025-06-15 21:10:20.134 Db Augment[4909:8e19] [com.apple.runningboard:message] PERF: [app<application.com.augment.Augment.104572428.104589542(501)>:4909] Received message from runningboardd: async_didChangeInheritances:completion:
2025-06-15 21:10:20.134 A  Augment[4909:8e19] (RunningBoardServices) didChangeInheritances
2025-06-15 21:10:20.134 Db Augment[4909:8e19] [com.apple.runningboard:connection] didChangeInheritances: <RBSInheritanceChangeSet| gained:(null) lost:{(
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1658 0>,
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1627 0>,
    <RBSInheritance| environment:(none) name:com.apple.launchservices.userfacing origID:401-368-1638 0>,
    <RBSInheritance| environment:(none) name:com.apple.launchservices.userfacing origID:401-368-1638 0>,
    <RBSInheritance| environment:(none) name:com.apple.frontboard.visibility origID:401-397-1639 0>
)}>
2025-06-15 21:10:20.149 Df Augment[4909:88ac] [com.apple.AppKit:StateRestoration] -[NSPersistentUIManager flushAllChanges]
2025-06-15 21:10:20.149 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSPersistentUIShowQuietSafeQuitStatus in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:20.154 Df Augment[4909:88ac] [com.apple.AppKit:StateRestoration] -[NSPersistentUIManager flushAllChanges] finishing enqueued operations
2025-06-15 21:10:20.154 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) supportsAutomaticTermination=0 isAutoQuittable=0 isActive=0 shouldRelaunchStopped=0
2025-06-15 21:10:20.154 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) shouldRelaunchStopped=0 relaunchShouldBeDisabled=0
2025-06-15 21:10:20.154 Df Augment[4909:90e4] [com.apple.AppKit:StateRestoration] -[NSPersistentUIManager flushAllChanges]_block_invoke asyncing to main queue
2025-06-15 21:10:20.155 Df Augment[4909:9190] [com.apple.AppKit:StateRestoration] -[NSPersistentUIManager flushAllChanges]_block_invoke writing records
2025-06-15 21:10:20.636 Db Augment[4909:88ac] [com.apple.defaults:User Defaults] found no value for key NSPersistentUIShowQuietSafeQuitStatus in CFPrefsSearchListSource<0x10ed26b40> (Domain: com.augment.Augment, Container: (null))
2025-06-15 21:10:20.636 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) supportsAutomaticTermination=0 isAutoQuittable=0 isActive=0 shouldRelaunchStopped=0
2025-06-15 21:10:20.636 Db Augment[4909:88ac] [com.apple.AppKit:AutomaticTermination] void _updateToReflectAutomaticTerminationState(void) shouldRelaunchStopped=0 relaunchShouldBeDisabled=0
2025-06-15 21:10:21.141 Db Augment[4909:8e19] [com.apple.libspindump:logging] HID statistics actions:3 responseBuckets:9(0.149s),0(0.000s),0(0.000s),0(0.000s),0(0.000s),0(0.000s),0(0.000s),0(0.000s),0(0.000s), legacy 148ms to handle 9 events (16ms/event)
2025-06-15 21:10:21.142 I  Augment[4909:8e19] [com.apple.CoreAnalytics:client] Dropping "com.apple.libspindump.hid_response_statistics" as it isn't used in any transform (not in the config or budgeted?)
