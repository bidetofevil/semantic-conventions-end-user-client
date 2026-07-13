package after_resolution

import rego.v1

# Public attribute groups are this registry's stable export surface: consumers
# import attributes by group id, so an attribute missing from its domain's
# group is silently invisible downstream. This policy makes that an error.
# every locally-defined attribute must be referenced by at least one attribute
# group.

group_member_keys contains key if {
    some group in input.registry.attribute_groups
    some attr in group.attributes
    key := attr.key
}

deny contains finding if {
    some attr in input.registry.attributes
    object.get(attr, "provenance", null) != null
    not group_member_keys[attr.key]

    finding := {
        "id": "attribute_not_exported",
        "context": {"attribute_key": attr.key},
        "message": sprintf(
            "Attribute '%s' is not referenced by any attribute group. Add it to its domain's public group (see CONTRIBUTING.md) or consumers will not receive it.",
            [attr.key],
        ),
        "level": "violation",
    }
}
