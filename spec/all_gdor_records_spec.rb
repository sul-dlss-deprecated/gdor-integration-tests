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
  
  context "" do
    it_behaves_like "have required fields:", "-collection:sirsi"
  end
    
end