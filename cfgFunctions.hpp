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
        class allowWriting {};
        class generateName {};
        class getModuleRoot {};
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
