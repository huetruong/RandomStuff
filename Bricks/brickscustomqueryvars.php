<?php
add_filter(
    "bricks/posts/query_vars",
    function ($query_vars, $settings, $element_id) {
        // List all the elements' IDs here
        $elements = ["26fd1c"];

        // Check if the element_id is inside the array
        if (!in_array($element_id, $elements)) {
            return $query_vars;
        }

        // Get the current user's group membership
        $user = wp_get_current_user();
        $group_membership = "public"; // Default to public

        // Check if the user is logged in and has the "private" group membership
        if ($user->ID && in_array("private", $user->roles)) {
            $group_membership = ["public", "private"];
        }

        // Apply the custom query vars using taxonomies
        $query_vars["tax_query"] = [
            "relation" => "AND",
            [
                "taxonomy" => "category",
                "field" => "name",
                "terms" => $group_membership,
            ],
        ];
        $query_vars["orderby"] = "date";
        $query_vars["order"] = "DESC";

        // Return the modified query vars
        return $query_vars;
    },
    10,
    3
);