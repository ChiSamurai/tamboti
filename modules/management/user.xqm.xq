xquery version "3.1";

module namespace user = "http://hra.uni-heidelberg.de/ns/tamboti/modules/management/user";

import module namespace dbutil="http://exist-db.org/xquery/dbutil";
import module namespace security = "http://exist-db.org/mods/security" at "/db/apps/tamboti/modules/search/security.xqm";
import module namespace functx="http://www.functx.com";

declare %private function user:_metadata-createCollectionPermission($user as xs:string, $collection as xs:anyURI) {
    if ($collection != "" and not(functx:substring-after-last($collection, "/") = "VRA_images") ) then
        let $usermode := security:get-user-permissions($user, $collection)
        return
            if (not($usermode = "---")) then
                <collection uri="{$collection}" mode="{$usermode}" />
            else
                ()
    else
        ()
};

declare function user:matadata-createSharedCollectionsList($root-collection as xs:anyURI, $user as xs:string) {
    <sharedCollections user="{$user}">
        {
            dbutil:scan-collections($root-collection, function($collection){
                user:_metadata-createCollectionPermission($user, $collection)
            })
        }
    </sharedCollections>
};
