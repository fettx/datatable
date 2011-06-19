require 'spec_helper'

describe "headings" do

  describe "arel" do
    before do
      Object.send(:remove_const, :OrderTable) rescue nil
      class OrderTable < DataTable::Base
        set_model Order
        column :order_number
        column :memo
      end
      assign(:data_table, OrderTable)
    end

    it "should have tests"

  end

  describe "raw sql" do

    before do
      Object.send(:remove_const, :OrderTable) rescue nil
      class OrderTable < DataTable::Base

        #set_model Order

        sql <<-SQL
      SELECT orders.id, 
        orders.order_number,
        customers.first_name,
        customers.last_name,
        orders.memo
      FROM orders
      JOIN customers ON(customers.id = orders.customer_id)
        SQL


        #
        # replace this with a hash
        #

        columns({
          'orders.id' => {:type => :integer},
          'orders.order_number' => {:type => :string},
          'customers.first_name' => {:type => :string},
          'customers.last_name' => {:type => :string},
          'orders.memo' => {:type => :string},
        })

      end
      assign(:data_table, OrderTable)
    end

    it 'should humanize headings by default'  do
      ["Order Id", "Order Order Number", "Customer First Name", "Customer Last Name", "Order Memo"].each do |heading|
        helper.data_table_html.should contain(heading)
      end
    end

    # TODO
    it 'should use pretty headings when they are available' do
      fail 'TODO'
      OrderTable.columns(
        [
          ["orders.id", :integer, "Another heading that we specify manually"],
          ["orders.order_number", :integer, "Yet another"],
          ["customers.first_name", :string],
          ["customers.last_name", :string],
          ["orders.memo", :string, "And another"] 
      ])

      ["Another heading that we specify manually","Yet another" , "And another"].each do |heading|
        helper.data_table_html.should contain(heading)
      end
    end

  end

end
