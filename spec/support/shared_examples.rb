# tests for presence of a field in every record implicated by facet query
shared_examples_for 'sortable pub date' do | facet_query |
  it "" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-pub_date_sort:*"]})
    resp.should_not have_documents
  end
end
shared_examples_for 'date slider dates' do | facet_query |
  it "" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-pub_year_tisim:*"]})
    resp.should_not have_documents
  end
end
shared_examples_for 'language' do | facet_query |
  it "" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-language:*"]})
    resp.should_not have_documents
  end
end
shared_examples_for 'searchable author' do | facet_query |
  it "" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-author_1xx_search:*"]})
    resp.should_not have_documents
  end
end
shared_examples_for 'sortable author' do | facet_query |
  it "" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-author_sort:*"]})
    resp.should_not have_documents
  end
end

# tests for required fields excepting dates, given a facet query
shared_examples_for 'core fields:' do | facet_query |
  it "druid" do
    resp = solr_resp_doc_ids_only({'fq'=>[facet_query, "-druid:*"], 'rows'=>'0'})
    resp.should_not have_documents
  end
  it "access_facet = Online" do
    resp = solr_resp_doc_ids_only({'fq'=>[facet_query, "-access_facet:Online"], 'rows'=>'0'})
    resp.should_not have_documents
  end
  it "format" do
    resp = solr_resp_doc_ids_only({'fq'=>[facet_query, "-format:*"], 'rows'=>'0'})
    resp.should_not have_documents
  end
  it "valid format value" do
    resp = solr_resp_doc_ids_only({'fq'=>[facet_query,
      # commented out lines are because gdor has no records in those formats
                                          '-format:Book',
                                          '-format:"Computer File"',
#                                          '-format:"Conference Proceedings"',
#                                          '-format:Database',
                                          '-format:Image',
                                          '-format:"Journal/Periodical"',
                                          '-format:"Manuscript/Archive"',
                                          '-format:"Map/Globe"',
#                                          '-format:Microformat',
#                                          '-format:"Music - Recording"',
#                                          '-format:"Music - Score"',
#                                          '-format:Newspaper',
                                          '-format:Other',
#                                          '-format:"Sound Recording"',
                                          '-format:Thesis',
                                          '-format:Video'
                                          ]})
    resp.should_not have_documents
  end
  it "display_type" do
    resp = solr_resp_doc_ids_only({'fq'=>[facet_query, "-display_type:*"], 'rows'=>'0'})
    resp.should_not have_documents
  end
  it "valid display_type value" do
    resp = solr_resp_doc_ids_only({'fq'=>[facet_query,
                                          '-display_type:collection',
                                          '-display_type:hydrus_collection',
                                          '-display_type:hydrus_object',
                                          '-display_type:image',
                                          '-display_type:map'
                                          ]})
    resp.should_not have_documents
  end
  it "sortable title" do
    resp = solr_resp_doc_ids_only({'fq'=>[facet_query, "-title_sort:*"], 'rows'=>'0'})
    resp.should_not have_documents
  end
  it "searchabe short title" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-title_245a_search:*"]})
    resp.should_not have_documents
  end
  it "searchable full title" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-title_245_search:*"]})
    resp.should_not have_documents
  end
end
 
# tests for required fields given a facet query
shared_examples_for 'have required fields:' do | facet_query |
  context "" do
    it_behaves_like "core fields:", facet_query
    it_behaves_like "sortable pub date", facet_query
    it_behaves_like "date slider dates", facet_query
  end
end


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
  it "should not have a date of 499 or less" do
    resp = solr_resp_doc_ids_only({'fq'=>["collection:#{coll_id}", "pub_year_tisim:[* TO 499]"], 'rows'=>'0'})
    resp.should_not have_documents
  end
  context "" do
    it_behaves_like "have required fields:", "collection:#{coll_id}"
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
    @resp = solr_response({'qt'=>'document', 'id'=>solr_doc_id, 'fl'=>'id,url_fulltext,collection_type,modsxml,format,druid,display_type', 'facet'=>false})
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
  it "should have a collection flavor display_type if no sirsi record" do
    @resp.should include("display_type" => /.*collection.*/) if solr_doc_id == druid
  end
  it "should have a druid field if no sirsi record" do
    @resp.should include("druid" => druid ) if solr_doc_id == druid
  end
  it "should not have a separate Solr record for a druid if there is a sirsi record" do
    if solr_doc_id != druid     
      resp = solr_response({'qt'=>'document', 'id'=>druid})
      resp.should_not include(druid)
    end
  end
end
