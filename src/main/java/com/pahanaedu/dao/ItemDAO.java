package com.pahanaedu.dao;

import com.pahanaedu.config.DatabaseConfig;
import com.pahanaedu.model.Author;
import com.pahanaedu.model.Item;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {

    /** Fetch all active items (with their category, publisher and authors). */
    public List<Item> findAll() {
        List<Item> items = new ArrayList<>();
        String sql =
            "SELECT i.*, c.name AS category_name, p.name AS publisher_name " +
            "  FROM items i " +
            "  LEFT JOIN categories c ON i.category_id = c.id " +
            "  LEFT JOIN publishers p ON i.publisher_id = p.id " +
            " WHERE i.status = 'active' " +
            " ORDER BY i.created_at DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                Item item = mapResultSetToItem(rs);
                item.setAuthors(getItemAuthors(conn, item.getId()));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    /** Find one active item by its numeric ID. */
    public Item findById(int id) {
        String sql =
            "SELECT i.*, c.name AS category_name, p.name AS publisher_name " +
            "  FROM items i " +
            "  LEFT JOIN categories c ON i.category_id = c.id " +
            "  LEFT JOIN publishers p ON i.publisher_id = p.id " +
            " WHERE i.id = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Item item = mapResultSetToItem(rs);
                    item.setAuthors(getItemAuthors(conn, item.getId()));
                    return item;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Only returns an item if its code exactly matches (trimmed)
     * and its status is still 'active'.
     */
    public Item findByItemCode(String rawCode) {
        if (rawCode == null) return null;
        String code = rawCode.trim();

        String sql =
            "SELECT i.*, c.name AS category_name, p.name AS publisher_name " +
            "  FROM items i " +
            "  LEFT JOIN categories c ON i.category_id = c.id " +
            "  LEFT JOIN publishers p ON i.publisher_id = p.id " +
            " WHERE i.item_code = ? AND i.status = 'active'";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Item item = mapResultSetToItem(rs);
                    item.setAuthors(getItemAuthors(conn, item.getId()));
                    return item;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Inserts a brand-new item. Trims the code, checks for active duplicates,
     * and only then does the INSERT.
     */
    public boolean save(Item item) {
        // Normalize
        if (item.getItemCode() != null) {
            item.setItemCode(item.getItemCode().trim());
        }

        // Prevent duplicate among active items
        if (findByItemCode(item.getItemCode()) != null) {
            return false;
        }

        String sql =
            "INSERT INTO items (" +
            "  item_code, title, subtitle, isbn, category_id," +
            "  publisher_id, publication_date, edition, pages," +
            "  language, description, price, cost_price," +
            "  stock_quantity, min_stock_level, max_stock_level," +
            "  status, created_by" +
            ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1,  item.getItemCode());
            ps.setString(2,  item.getTitle());
            ps.setString(3,  item.getSubtitle());
            ps.setString(4,  item.getIsbn());
            ps.setObject(5,  item.getCategoryId() > 0 ? item.getCategoryId() : null);
            ps.setObject(6,  item.getPublisherId() > 0 ? item.getPublisherId() : null);
            ps.setDate(7,    item.getPublicationDate());
            ps.setString(8,  item.getEdition());
            ps.setInt(9,     item.getPages());
            ps.setString(10, item.getLanguage());
            ps.setString(11, item.getDescription());
            ps.setBigDecimal(12, item.getPrice());
            ps.setBigDecimal(13, item.getCostPrice());
            ps.setInt(14,    item.getStockQuantity());
            ps.setInt(15,    item.getMinStockLevel());
            ps.setInt(16,    item.getMaxStockLevel());
            ps.setString(17, item.getStatus());
            ps.setInt(18,   item.getCreatedBy());

            int rows = ps.executeUpdate();
            if (rows == 0) return false;

            try (ResultSet gk = ps.getGeneratedKeys()) {
                if (gk.next()) {
                    item.setId(gk.getInt(1));
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Update all modifiable fields by PK. */
    public boolean update(Item item) {
        String sql =
            "UPDATE items SET " +
            "  title = ?, subtitle = ?, isbn = ?, category_id = ?, publisher_id = ?," +
            "  publication_date = ?, edition = ?, pages = ?, language = ?, description = ?," +
            "  price = ?, cost_price = ?, stock_quantity = ?, min_stock_level = ?, " +
            "  max_stock_level = ?, status = ? " +
            "WHERE id = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1,  item.getTitle());
            ps.setString(2,  item.getSubtitle());
            ps.setString(3,  item.getIsbn());
            ps.setObject(4,  item.getCategoryId() > 0 ? item.getCategoryId() : null);
            ps.setObject(5,  item.getPublisherId() > 0 ? item.getPublisherId() : null);
            ps.setDate(6,    item.getPublicationDate());
            ps.setString(7,  item.getEdition());
            ps.setInt(8,     item.getPages());
            ps.setString(9,  item.getLanguage());
            ps.setString(10, item.getDescription());
            ps.setBigDecimal(11, item.getPrice());
            ps.setBigDecimal(12, item.getCostPrice());
            ps.setInt(13,    item.getStockQuantity());
            ps.setInt(14,    item.getMinStockLevel());
            ps.setInt(15,    item.getMaxStockLevel());
            ps.setString(16, item.getStatus());
            ps.setInt(17,   item.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Soft-delete by marking inactive. */
    public boolean delete(int id) {
        String sql = "UPDATE items SET status = 'inactive' WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** List everything under or at min-stock. */
    public List<Item> findLowStockItems() {
        List<Item> items = new ArrayList<>();
        String sql =
            "SELECT i.*, c.name AS category_name, p.name AS publisher_name " +
            "  FROM items i " +
            "  LEFT JOIN categories c ON i.category_id = c.id " +
            "  LEFT JOIN publishers p ON i.publisher_id = p.id " +
            " WHERE i.status = 'active' " +
            "   AND i.stock_quantity <= i.min_stock_level " +
            " ORDER BY i.stock_quantity ASC";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Item item = mapResultSetToItem(rs);
                item.setAuthors(getItemAuthors(conn, item.getId()));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    // ---------------------------------------------------------
    // -- Helpers: load authors and map a single row to Item --
    // ---------------------------------------------------------

    private List<Author> getItemAuthors(Connection conn, int itemId) throws SQLException {
        List<Author> authors = new ArrayList<>();
        String sql =
          "SELECT a.* FROM authors a " +
          " JOIN item_authors ia ON a.id = ia.author_id " +
          " WHERE ia.item_id = ? " +
          " ORDER BY ia.role";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Author a = new Author();
                    a.setId( rs.getInt("id") );
                    a.setFirstName( rs.getString("first_name") );
                    a.setLastName( rs.getString("last_name") );
                    a.setBiography( rs.getString("biography") );
                    a.setBirthDate( rs.getDate("birth_date") );
                    a.setNationality( rs.getString("nationality") );
                    a.setStatus( rs.getString("status") );
                    a.setCreatedAt( rs.getTimestamp("created_at") );
                    authors.add(a);
                }
            }
        }
        return authors;
    }

    private Item mapResultSetToItem(ResultSet rs) throws SQLException {
        Item item = new Item();
        item.setId( rs.getInt("id") );
        item.setItemCode( rs.getString("item_code") );
        item.setTitle( rs.getString("title") );
        item.setSubtitle( rs.getString("subtitle") );
        item.setIsbn( rs.getString("isbn") );
        item.setCategoryId( rs.getInt("category_id") );
        item.setCategoryName( rs.getString("category_name") );
        item.setPublisherId( rs.getInt("publisher_id") );
        item.setPublisherName( rs.getString("publisher_name") );
        item.setPublicationDate( rs.getDate("publication_date") );
        item.setEdition( rs.getString("edition") );
        item.setPages( rs.getInt("pages") );
        item.setLanguage( rs.getString("language") );
        item.setDescription( rs.getString("description") );
        item.setPrice( rs.getBigDecimal("price") );
        item.setCostPrice( rs.getBigDecimal("cost_price") );
        item.setStockQuantity( rs.getInt("stock_quantity") );
        item.setMinStockLevel( rs.getInt("min_stock_level") );
        item.setMaxStockLevel( rs.getInt("max_stock_level") );
        item.setStatus( rs.getString("status") );
        item.setCreatedAt( rs.getTimestamp("created_at") );
        item.setUpdatedAt( rs.getTimestamp("updated_at") );
        item.setCreatedBy( rs.getInt("created_by") );
        return item;
    }
}
