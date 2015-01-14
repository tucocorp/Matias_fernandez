class CreateConstraintsIssuesTable < ActiveRecord::Migration
  def change
    create_table :constraints_issues, id: false do |t|
      t.integer :constraint_id
      t.integer :issue_id
    end
  end
end
