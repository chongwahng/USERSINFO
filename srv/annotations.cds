using {db} from './UsersService';

annotate db.Groups with {
    id          @UI.Hidden
                @Common.Text            : displayName
                @Common.TextArrangement : #TextOnly;
    displayName @title                  : 'Group Name';
};

annotate db.Groups with @(
    UI.HeaderInfo : {
        TypeName       : 'Group',
        TypeNamePlural : 'Groups'
    },
    UI.LineItem   : [{
        $Type : 'UI.DataField',
        Value : displayName
    }]
);

annotate db.Members with {
    id           @UI.Hidden;
    groupId      @title                  : 'Group'
                 @Common.Text            : groupId.displayName
                 @Common.TextArrangement : #TextOnly;
    displayName  @title                  : 'Member Name'
                 @UI.HiddenFilter;
    groupName    @title                  : 'Group Name'
                 @UI.HiddenFilter;
    mailNickname @title                  : 'User-ID'
                 @UI.HiddenFilter;

};

annotate db.Members with @(
    UI.HeaderInfo      : {
        TypeName       : 'Member',
        TypeNamePlural : 'Members',

    },
    UI.LineItem        : [
        {
            $Type : 'UI.DataField',
            Value : groupName
        },
        {
            $Type : 'UI.DataField',
            Value : displayName
        },
        {
            $Type : 'UI.DataField',
            Value : mailNickname
        }
    ],
    UI.SelectionFields : [groupId_id]
);

annotate db.Members {
    groupId @Common.ValueList : {
        CollectionPath : 'Group',
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : groupId_id,
                ValueListProperty : 'id'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'displayName'
            }
        ]
    }
}
