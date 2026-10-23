package com.mangaz.dao;

import com.mangaz.model.Tag;
import com.mangaz.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;

public class TagDAO {

    public Map<Integer, List<Tag>> getTagsByListingIds(
            List<Integer> listingIds) throws SQLException {

        Map<Integer, List<Tag>> tagsByListing = new HashMap<>();

        if (listingIds == null || listingIds.isEmpty()) {
            return tagsByListing;
        }

        StringJoiner placeholders = new StringJoiner(", ");

        for (int i = 0; i < listingIds.size(); i++) {
            placeholders.add("?");
        }

        String sql =
                "SELECT lt.ListingId, t.TagId, t.TagName, t.Slug, t.TagType " +
                        "FROM dbo.ListingTags lt " +
                        "INNER JOIN dbo.Tags t ON lt.TagId = t.TagId " +
                        "WHERE lt.ListingId IN (" + placeholders + ") " +
                        "ORDER BY lt.ListingId, t.TagName";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < listingIds.size(); i++) {
                ps.setInt(i + 1, listingIds.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int listingId = rs.getInt("ListingId");

                    Tag tag = new Tag();
                    tag.setTagId(rs.getInt("TagId"));
                    tag.setTagName(rs.getString("TagName"));
                    tag.setSlug(rs.getString("Slug"));
                    tag.setTagType(rs.getString("TagType"));

                    tagsByListing
                            .computeIfAbsent(listingId, k -> new ArrayList<>())
                            .add(tag);
                }
            }
        }

        return tagsByListing;
    }
}