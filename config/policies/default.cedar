// Allow all users to request access to all resources
permit (
    principal,
    action == Access::Action::"Request",
    resource
);

// Allow manually approved Grants to be activated
permit (
    principal,
    action == Access::Action::"Activate",
    resource
)
when { resource.approved };

// Allow the Control Plane service to close any request in the request cleanup process
permit (
    principal == CF::Service::"ControlPlane",
    action == Access::Action::"Close",
    resource
);

// Allow users to close their own requests
@advice("Closing your own request is permitted")
permit (
    principal,
    action == Access::Action::"Close",
    resource
)
when { principal == resource.principal };

// Allow the security team to close anyone's requests
@advice("You can close any request because you are on the security team")
permit (
    principal in Entra::Group::"ID_OF_SECURITY_GROUP",
    action == Access::Action::"Close",
    resource
);

// Forbid users from approving their own access request
@advice("You cannot approve your own access request")
forbid (
    principal,
    action == Access::Action::"Approve",
    resource
)
when { principal == resource.principal };