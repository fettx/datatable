require 'spec_helper'

describe "headings" do

  describe "arel" do
    before do
      Object.send(:remove_const, :T) rescue nil
      class T < Datatable::Base
        set_model Order
        column :order_number
        column :memo
      end
      assign(:datatable, T)
    end

    it "should have tests"

  end

  describe "raw sql" do

    before do
      Object.send(:remove_const, :T) rescue nil
      class T < Datatable::Base
        sql <<-SQL
          SELECT
            orders.id,
            orders.order_number,
            customers.first_name,
            customers.last_name,
            orders.memo
          FROM
            orders
          JOIN
            customers
          ON
            customers.id = orders.customer_id
        SQL
        columns(
          {'orders.id' => {:type => :integer}},
          {'orders.order_number' => {:type => :string}},
          {'customers.first_name' => {:type => :string}},
          {'customers.last_name' => {:type => :string}},
          {'orders.memo' => {:type => :string}}
        )
      end
      assign(:datatable, T)
    end

    it 'should humanize headings by default'  do
      ["Order Id", "Order Order Number", "Customer First Name", "Customer Last Name", "Order Memo"].each do |heading|
        helper.datatable_html.should contain(heading)
      end
    end

    it 'should use pretty headings when they are available' do
      T.columns(
        {'orders.id' => {:type => :integer, :heading => "Another heading that we specify manually"}},
        {'orders.order_number' => {:type => :string, :heading => 'Yet another' }},
        {'customers.first_name' => {:type => :string}},
        {'customers.last_name' => {:type => :string}},
        {'orders.memo' => {:type => :string, :heading => 'And another'}}
      )
      ["Another heading that we specify manually","Yet another" , "And another"].each do |heading|
        helper.datatable_html.should contain(heading)
      end
    end

  end

end
