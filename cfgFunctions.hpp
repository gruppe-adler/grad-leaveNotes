#ifndef MODULES_DIRECTORY
    #define MODULES_DIRECTORY modules
#endif

class GRAD_leaveNotes {
    class common {
        file = MODULES_DIRECTORY\grad-leaveNotes\functions;

        class addSelfinteraction {};
        class delayedCall {};
        class destroyNote {};
        class dropNote {};
        class enterHint {};
        class allowWriting {};
        class generateName {};
        class getModuleRoot {};
        class giveNote {};
        class initModule {postInit = 1;};
        class initNote {};
        class loadUI {};
        class readNote {};
        class setAmount {};
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
