#ifndef MODULES_DIRECTORY
    #define MODULES_DIRECTORY node_modules
#endif

class GRAD_leaveNotes {
    class common {
        file = MODULES_DIRECTORY\grad-leaveNotes\functions;

        class addSelfinteraction {};
        class allowInspection {};
        class allowWriting {};
        class delayedCall {};
        class destroyNote {};
        class dropNote {};
        class enterHint {};
        class generateName {};
        class getModuleRoot {};
        class giveNote {};
        class initModule {postInit = 1;};
        class initNote {};
        class inspectNote {};
        class loadUI {};
        class playGiveAnimation {};
        class readNote {};
        class receiveNote {};
        class setAmount {};
        class setHandwriting {};
        class spawnNote {};
        class takeNote {};
        class uiDrop {};
        class uiSave {};
        class uiTakeDrop {};
        class updateMyNotes {};
        class writeNote {};
    };
};

class FAKEACE_interact_menu {
    class ace_removeActionFromClass_Workaround {
        file = MODULES_DIRECTORY\grad-leaveNotes\functions\ace_removeActionFromClass_workaround;
        class findActionName {};
        class getAllClasses {};
        class removeActionFromClass {};
    };
};
