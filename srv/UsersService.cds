using db from '../db/data-model';

service APIService @(path : '/graph-api') {
    @readonly
    entity Group  as projection on db.Groups;

    @readonly
    entity Member as projection on db.Members;
}
