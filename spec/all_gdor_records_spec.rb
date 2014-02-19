require 'spec_helper'

describe "All GDOR records" do

  it "every non-collection object should have a collection" do
    resp = solr_resp_doc_ids_only({'fq'=> ["-collection:*", "-display_type:*collection"]})
    resp.should_not have_documents
  end
  it "should have access_facet = Online for each collection object" do
    resp = solr_resp_doc_ids_only({'fq'=>["display_type:*collection", "-access_facet:Online"]})
    resp.should_not have_documents
  end
  it "should have a display_type" do
    resp = solr_resp_doc_ids_only({'fq'=> ["-collection:sirsi", "-display_type:*"]})
    resp.should_not have_documents
  end
  it "should have a druid" do
    resp = solr_resp_doc_ids_only({'fq'=> ["-collection:sirsi", "-druid:*"]})
    resp.should_not have_documents
  end
  it "should have a format" do
    resp = solr_resp_doc_ids_only({'fq'=> ["-collection:sirsi", "-format:*"]})
    resp.should_not have_documents
  end
  it "should have a sortable title" do
    resp = solr_resp_doc_ids_only({'fq'=> ["-collection:sirsi", "-title_sort:*"]})
    resp.should_not have_documents
  end
  it "should have a searchabe short title" do
    resp = solr_resp_doc_ids_only({'fq'=> ["-collection:sirsi", "-title_245a_search:*"]})
    resp.should_not have_documents
  end
  it "should have a searchable full title" do
    resp = solr_resp_doc_ids_only({'fq'=> ["-collection:sirsi", "-title_245_search:*"]})
    resp.should_not have_documents
  end
    
end