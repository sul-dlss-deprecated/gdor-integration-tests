# tests for all items in a collection
# coll_id = collection record id (e.g. a ckey or druid)
# num_exp = the number of items expected in the collection
shared_examples_for 'all items in collection' do | coll_id, num_exp |
  it "should be the expected number" do
    resp = solr_resp_doc_ids_only({'fq'=>"collection:#{coll_id}", 'rows'=>'0'})
    resp.should have_exactly(num_exp).documents
  end
  it "should not include any additional collection records" do
    resp = solr_response({'fq'=>"collection:#{coll_id}", 'facet.field' => 'display_type', 'facet'=>true, 'rows'=>'0'})
    resp.should_not have_facet_field('display_type').with_value('collection')
    resp.should_not have_facet_field('display_type').with_value('hydrus_collection')
  end
  it "should have access_facet = Online" do
    resp = solr_resp_doc_ids_only({'fq'=>["collection:#{coll_id}", "access_facet:Online"], 'rows'=>'0'})
    resp.should have_exactly(num_exp).documents
  end
  it "should have no items with a date of 499 or less" do
    resp = solr_resp_doc_ids_only({'fq'=>["collection:#{coll_id}", "pub_year_tisim:[* TO 499]"], 'rows'=>'0'})
    resp.should_not have_documents
  end
  it "should have a valid format for each item object" do
    resp = solr_resp_doc_ids_only({'fq'=>["collection:#{coll_id}", "-format:*"], 'rows'=>'0'})
    resp.should_not have_documents
  end
end

# tests for a query retrieving specific item ids; we can check stored fields on these items
# query_str = an 'everything' query that will retrieve the expected item objects
# exp_ids = expected druids for objects within a collection
# max_res_num = items should appear within this number of results
# coll_id = catkey or druid for the collection
shared_examples_for 'DOR item objects' do | query_str, exp_ids, max_res_num, coll_id |
  before(:all) do
    @resp = solr_response({'q'=>query_str, 'fl'=>'id,url_fulltext,collection', 'facet'=>false})
  end
  it "should be discoverable via everything search" do
    @resp.should include(exp_ids).in_first(max_res_num)
  end
  it "should have gdor fields" do
    exp_ids.each { |druid|
      resp = solr_response({'qt'=>'document', 'id'=>druid, 'fl'=>'id,collection,modsxml,url_fulltext,format,druid', 'facet'=>false})
      resp.should include("url_fulltext" => "http://purl.stanford.edu/#{druid}")
      resp.should include("modsxml" => /http:\/\/www\.loc\.gov\/mods\/v3/ )
      resp.should include("collection" => coll_id )
      resp.should include("format" => /.+/)
      resp.should include("druid" => druid )
    }
  end
end

# tests for collection records/objects
# solr_doc_id = the Solr field id  value for the collection record
# druid = the druid of the collection record
shared_examples_for 'DOR collection object' do | solr_doc_id, druid |
  before(:all) do
    @resp = solr_response({'qt'=>'document', 'id'=>solr_doc_id, 'fl'=>'id,url_fulltext,collection_type,modsxml,format,druid', 'facet'=>false})
  end
  it "should have purl url in url_fulltext" do
    @resp.should include("url_fulltext" => "http://purl.stanford.edu/#{druid}")
  end
  it "should have collection_type field" do
    @resp.should include("collection_type" => 'Digital Collection')
  end
  it "should have modsxml field if no sirsi record" do
    @resp.should include("modsxml" => /http:\/\/www\.loc\.gov\/mods\/v3/ ) if solr_doc_id == druid
  end
  it "should have a format field" do
    @resp.should include("format" => /.+/)
  end
  it "should have a druid field if no sirsi record" do
    @resp.should include("druid" => druid ) if solr_doc_id == druid
  end
  it "should not have two records (ckey and druid)" do
    if solr_doc_id != druid     
      resp = solr_response({'qt'=>'document', 'id'=>druid})
      resp.should_not include(druid)
    end
  end
end
