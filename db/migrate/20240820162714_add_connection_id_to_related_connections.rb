class AddConnectionIdToRelatedConnections < ActiveRecord::Migration[7.1]
  def change
    add_column :related_connections, :connection_id, :integer
  end
end
