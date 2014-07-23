require 'spec_helper'

describe "All GDOR records" do

  it "should have the correct number of digital collections" do
    resp = solr_resp_doc_ids_only({'fq'=> "collection_type:\"Digital Collection\""})
    resp.should have_exactly(49).documents
  end

  it "every non-collection object should have a collection" do
    resp = solr_resp_doc_ids_only({'fq'=> ["-collection:*", "-collection_type:\"Digital Collection\""]})
    resp.should_not include("id" => /.+/)  # get ids of errant records
  end

  it "should have access_facet = Online for each collection object" do
    resp = solr_resp_doc_ids_only({'fq'=>["collection_type:\"Digital Collection\"", "-access_facet:Online"]})
    resp.should_not include("id" => /.+/)  # get ids of errant records
  end
  
  context "" do
    facet_query = "-collection:sirsi"
    it_behaves_like "core fields present", facet_query
#    it_behaves_like "date fields present", facet_query
#    it_behaves_like "author fieldspresent", facet_query
#    it_behaves_like "language", facet_query
  end
    
end