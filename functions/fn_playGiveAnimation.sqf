if (!isNull objectParent ACE_player) exitWith {};
_animation = switch (currentWeapon ACE_player) do {
    case (""): {
        switch (stance ACE_player) do {
            case ("STAND"): {"AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"};
            case ("CROUCH"): {"AmovPknlMstpSnonWnonDnon_AinvPknlMstpSnonWnonDnon_Putdown"};
            case ("PRONE"): {"AmovPpneMstpSnonWnonDnon_AinvPpneMstpSnonWnonDnon_Putdown"};
            default {""};
        };
    };

    case (primaryWeapon ACE_player): {
        switch (stance ACE_player) do {
            case ("STAND"): {"AmovPercMstpSrasWrflDnon_AinvPercMstpSrasWrflDnon_Putdown"};
            case ("CROUCH"): {"AmovPknlMstpSrasWrflDnon_AinvPknlMstpSrasWrflDnon_Putdown"};
            case ("PRONE"): {"AmovPpneMstpSrasWrflDnon_AinvPpneMstpSrasWrflDnon_Putdown"};
            default {""};
        };
    };

    case (handgunWeapon ACE_player): {
        switch (stance ACE_player) do {
            case ("STAND"): {"AmovPercMstpSrasWpstDnon_AinvPercMstpSrasWpstDnon_Putdown"};
            case ("CROUCH"): {"AmovPknlMstpSrasWpstDnon_AinvPknlMstpSrasWpstDnon_Putdown"};
            case ("PRONE"): {"AmovPpneMstpSrasWpstDnon_AinvPpneMstpSrasWpstDnon_Putdown"};
            default {""};
        };
    };

    case (secondaryWeapon ACE_player): {
        switch (stance ACE_player) do {
            case ("STAND"): {"AmovPercMstpSrasWlnrDnon_AinvPercMstpSrasWlnrDnon_Putdown"};
            case ("CROUCH"): {"AmovPknlMstpSrasWlnrDnon_AinvPknlMstpSrasWlnrDnon_Putdown"};
            case ("PRONE"): {""};
            default {""};
        };
    };

    case (binocular ACE_player): {
        switch (stance ACE_player) do {
            case ("STAND"): {"AmovPercMstpSoptWbinDnon_AinvPercMstpSoptWbinDnon_Putdown"};
            case ("CROUCH"): {""};
            case ("PRONE"): {""};
            default {""};
        };
    };

    default {""};
};

ACE_player playMove _animation;
