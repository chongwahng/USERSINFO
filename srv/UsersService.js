const cdsapi = require('@sapmentors/cds-scp-api')

module.exports = async function (srv) {
    srv.on('READ', 'Group', getUserGroups)
    srv.on('READ', 'Member', getMembers)
}

const getUserGroups = async (req) => {
    let url = `/v1.0/groups?$filter=startswith(displayName,'SAP')&$select=displayName,id&$count=true`

    const service = await cdsapi.connect.to('Microsoft_Graph_User_List_API')

    const userGroups = await service.run({
        url: url,
        method: "get",
        headers: {
            'ConsistencyLevel': 'eventual'
        }
    })

    let user_groups = userGroups.value.map(groups => {
        var user_group = {}
        user_group.id = groups.id
        user_group.displayName = groups.displayName
        return user_group
    })

    Object.assign(user_groups, { $count: userGroups['@odata.count'] })
    return user_groups
}

const getMembers = async (req) => {
    let result = []
    let odataCount = 0

    const service = await cdsapi.connect.to('Microsoft_Graph_User_List_API')
    
    if (req._.odataReq._uriInfo._queryOptions.$filter !== undefined) {
        const groupIds = await decodeGroupIds(req._queryOptions.$filter)

        for (let i of groupIds.entries()) {
            let groupName = await getGroupName(i[1], service)

            let url = `/v1.0/groups/${i[1]}/members/microsoft.graph.user?$count=true&$select=id,displayName,mailNickname`

            const members = await service.run({
                url: url,
                method: "get",
                headers: {
                    'ConsistencyLevel': 'eventual'
                }
            })

            let group_members = members.value.map(members => {
                var group_member = {}
                group_member.id = members.id
                group_member.displayName = members.displayName
                group_member.mailNickname = members.mailNickname
                group_member.groupId_id = i[1]
                group_member.groupName = groupName
                return group_member
            })

            odataCount = odataCount + parseInt(members['@odata.count'])

            result = result.concat(group_members)
        }

        Object.assign(result, { '$count': odataCount })
        return result

    } else {
        return {}
    }
}

const getGroupName = async (id, service) => {
    let url = `/v1.0/groups/${id}?$select=displayName`

    const detail = await service.run({
        url: url,
        method: "get"
    })

    return detail.displayName
}

const decodeGroupIds = async (filter) => {
    let idx
    let groupIds = []

    if (filter.includes('or')) {
        let tokens = filter.split('or')
        
        for (let i of tokens.entries()) {
            idx = i[1].indexOf('eq') + 3
            groupIds.push(i[1].substr(idx, 36))
        }
    } else {
        idx = filter.indexOf('eq') + 3
        groupIds.push(filter.substr(idx, 36))
    }

    return groupIds
}
