namespace db;

@cds.persistence.skip
entity Groups {
    key id          : UUID;
        displayName : String;
}

@cds.persistence.skip
entity Members {
    key id           : UUID;
        groupId      : Association to Groups;
        groupName    : String;
        mailNickname : String;
        displayName  : String;
}