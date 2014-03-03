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
    facet_query = "-collection:sirsi"
    it_behaves_like "core fields present", facet_query
#    it_behaves_like "date fields present", facet_query
#    it_behaves_like "author fields present", facet_query
#    it_behaves_like "language", facet_query
  end
    
end