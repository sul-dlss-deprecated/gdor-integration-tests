# tests for presence of searchable field in every record implicated by facet query
shared_examples_for 'sortable pub date' do | facet_query |
  it "" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-pub_date_sort:*"]})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
end
shared_examples_for 'date slider dates' do | facet_query |
  it "" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-pub_year_tisim:*"]})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
end
shared_examples_for 'language' do | facet_query |
  it "" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-language:*"]})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
end
shared_examples_for 'searchable author' do | facet_query |
  it "" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-author_1xx_search:*"]})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
end
shared_examples_for 'sortable author' do | facet_query |
  it "" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-author_sort:*"]})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
end

# tests for searchable date fields given a facet query
shared_examples_for 'date fields present' do | facet_query |
  it_behaves_like "sortable pub date", facet_query
  it_behaves_like "date slider dates", facet_query
end

# tests for searchable author fields given a facet query
shared_examples_for 'author fields present' do | facet_query |
  it_behaves_like "sortable author", facet_query
  it_behaves_like "searchable author", facet_query
end

# tests for presence of searchable field in every record implicated by facet query, EXCEPT for the ids indicated
# field = the SW Solr field name
# facet_query = the argument for fq for a group of records (e.g. "collection:666")
# exp_ids = ids that are the exception - we do NOT expect these docs to have this field.  Either a string "666" or an Array ["111", "222", "333"]
shared_examples_for 'SW field present except' do | field, facet_query, exp_ids |
  it "" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-#{field}:*"]})
    regex = ""
    if exp_ids.kind_of? String
      regex = exp_ids
    elsif exp_ids.kind_of? Array
      exp_ids.each { |id| 
        if regex.size == 0
          regex << id
        else
          regex << "|#{id}"
        end 
      }
    end
    if regex.empty?
      regex = ".+"
    else
      regex = "^((?!(#{regex})).)*$"
    end
    resp.should_not include("id" => Regexp.new(regex))
    resp.should include(exp_ids)
    resp.should have_at_most(exp_ids.size).documents
  end
end

# tests for presence of searchable field in every record implicated by facet query, EXCEPT for the ids indicated
shared_examples_for 'author fields present except' do | facet_query, ids|
  it_behaves_like "SW field present except", 'author_1xx_search', facet_query, ids
  it_behaves_like "SW field present except", 'author_sort', facet_query, ids
end
shared_examples_for 'date fields present except' do | facet_query, ids|
  it_behaves_like "SW field present except", 'pub_date_sort', facet_query, ids
  it_behaves_like "SW field present except", 'pub_year_tisim', facet_query, ids
end
shared_examples_for 'language field present except' do | facet_query, ids|
  it_behaves_like 'SW field present except', 'language', facet_query, ids
end

# tests for no records with a different facet value than what is specified
shared_examples_for "expected facet values" do | facet_query, field, values |
  it "" do
    fq_arr = [facet_query]
    if values.kind_of? String
      fq_arr << "-#{field}:\"#{values}\""
    elsif values.kind_of? Array
      values.each { |val|  
        fq_arr << "-#{field}:\"#{val}\""
      }
    end
    resp = solr_resp_doc_ids_only({'fq'=> fq_arr})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
end

# tests for no records with a different format value than what is specified
shared_examples_for "expected format values" do | facet_query, values |
  it_behaves_like "expected facet values", facet_query, "format", values  
end
# tests for no records with a different display_type value than what is specified
shared_examples_for "expected display_type values" do | facet_query, values |
  it_behaves_like "expected facet values", facet_query, "display_type", values  
end


# tests for required searchable fields excepting dates, given a facet query
shared_examples_for 'core fields present' do | facet_query |
  it "druid" do
    resp = solr_resp_doc_ids_only({'fq'=>[facet_query, "-druid:*"]})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
  it "access_facet = Online" do
    resp = solr_resp_doc_ids_only({'fq'=>[facet_query, "-access_facet:Online"]})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
  it "format" do
    resp = solr_resp_doc_ids_only({'fq'=>[facet_query, "-format:*"]})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
  it "valid format value" do
    resp = solr_resp_doc_ids_only({'fq'=>[facet_query,
      # commented out lines are because gdor has no records in those formats
                                          '-format:Book',
                                          '-format:"Computer File"',
                                          '-format:"Conference Proceedings"',
#                                          '-format:Database',
                                          '-format:Image',
                                          '-format:"Journal/Periodical"',
                                          '-format:"Manuscript/Archive"',
                                          '-format:"Map/Globe"',
#                                          '-format:Microformat',
                                          '-format:"Music - Recording"',
                                          '-format:"Music - Score"',
#                                          '-format:Newspaper',
                                          '-format:Other',
                                          '-format:"Sound Recording"',
                                          '-format:Thesis',
                                          '-format:Video'
                                          ]})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
  it "display_type" do
    resp = solr_resp_doc_ids_only({'fq'=>[facet_query, "-display_type:*"]})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
  it "valid display_type value" do
    resp = solr_resp_doc_ids_only({'fq'=>[facet_query,
                                          '-display_type:file',
                                          '-display_type:image',
                                          ]})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
  it "sortable title" do
    resp = solr_resp_doc_ids_only({'fq'=>[facet_query, "-title_sort:*"]})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
  it "searchabe short title" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-title_245a_search:*"]})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
  it "searchable full title" do
    resp = solr_resp_doc_ids_only({'fq'=> [facet_query, "-title_245_search:*"]})
    resp.should_not include("id" => /.+/) # get ids of errant records
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
    resp = solr_response({'fq'=>"collection:#{coll_id}", 'facet.field' => 'collection_type', 'facet'=>true, 'rows'=>'0'})
    resp.should_not have_facet_field('collection_type').with_value('Digital Collection')
  end
  it "should not have a date of 499 or less" do
    resp = solr_resp_doc_ids_only({'fq'=>["collection:#{coll_id}", "pub_year_tisim:[* TO 499]"]})
    resp.should_not include("id" => /.+/) # get ids of errant records
  end
  context "" do
    it_behaves_like "core fields present", "collection:#{coll_id}"
  end
end

# tests for required stored fields for item and collection records, merged or unmerged
# solr_doc_id - the id of this item's Solr doc; could be ckey or druid 
# druid - the druid for this item
shared_examples_for 'gdor fields present' do | solr_doc_id, druid |
  before(:all) do
    @resp = solr_resp_single_doc(solr_doc_id)
    @merged = solr_doc_id != druid
  end
  # NOTE: can only check stored Solr fields this way
  it "druid" do
    @resp.should include("druid" => druid)
  end
  it "url_fulltext" do
    @resp.should include("url_fulltext" => "http://purl.stanford.edu/#{druid}")
  end
  it "display_type" do
    @resp.should include("display_type" => /file|image/) 
    @resp.should include("display_type" => 'sirsi') if @merged
  end
  it "should have modsxml field if no sirsi record" do
    @resp.should include("modsxml" => /http:\/\/www\.loc\.gov\/mods\/v3/ ) if !@merged
  end
  it "should not have a separate Solr record for druid if there is a sirsi record" do
    if @merged
      solr_resp_single_doc(druid).should_not include("id" => /.+/) # get ids of errant records
    end
  end
end

# tests for required stored fields for item record, merged or unmerged
# solr_doc_id - the id of this item's Solr doc; could be ckey or druid 
# druid - the druid for this item
# coll_solr_doc_id - the id of this item's collection obj Solr doc; could be ckey or druid
shared_examples_for 'item gdor fields present' do | solr_doc_id, druid, coll_solr_doc_id |
  before(:all) do
    @resp = solr_resp_single_doc(solr_doc_id)
    @merged = solr_doc_id != druid
  end
  it_behaves_like 'gdor fields present', solr_doc_id, druid
  # NOTE: can only check stored Solr fields this way
  it "file_id" do
    @resp.should include("file_id")
  end
  it "collection" do
    @resp.should include("collection" => coll_solr_doc_id)
  end
  it "collection_with_title" do
    @resp.should include("collection_with_title" => coll_solr_doc_id)
  end
end

# tests for a query retrieving specific item ids; we can check stored fields on these items
# query_str = an 'everything' query that will retrieve the expected item objects
# exp_ids = expected druids for objects within a collection
# max_res_num = items should appear within this number of results
# coll_id = catkey or druid for the collection
shared_examples_for 'DOR item objects' do | query_str, exp_ids, max_res_num, coll_id |
  it "should be discoverable via everything search" do
    resp = solr_response({'q'=>query_str, 'fl'=>'id', 'facet'=>false})
    resp.should include(exp_ids).in_first(max_res_num)
  end
  it "should have gdor fields" do
    # FIXME:  would like to DRY this up, but 
    # can't call 'item gdor fields present' from here for each doc due to nested examples
    exp_ids.each { |solr_doc_id|
      resp = solr_resp_single_doc(solr_doc_id)

      resp.should include("collection" => coll_id )
      resp.should include("collection_with_title" => Regexp.new("^#{coll_id}-\\|-.*"))
      resp.should include('display_type' => /file|image/)
      resp.should include("file_id" => /.+/)

      druid = resp['response']['docs'][0]['druid']
      if solr_doc_id != druid
        # DOR item is merged with MARC 
        solr_doc_id.should_not =~ /^[a-z]{2}[0-9]{3}[a-z]{2}[0-9]{4}$/
        resp.should include("druid" => druid )
        resp.should include('display_type' => 'sirsi')
        resp.should include("url_fulltext" => "http://purl.stanford.edu/#{druid}")
        resp.should_not include('modsxml')
        # there should be no record for the druid and if there is, we want the id
        solr_resp_single_doc(druid).should_not include("id" => /.+/)
      else
        solr_doc_id.should =~ /^[a-z]{2}[0-9]{3}[a-z]{2}[0-9]{4}$/
        resp.should include("druid" => solr_doc_id)
        resp.should include("url_fulltext" => "http://purl.stanford.edu/#{solr_doc_id}")
        resp.should include("modsxml" => /http:\/\/www\.loc\.gov\/mods\/v3/ )
      end  
    }
  end
end # DOR item objects

# check every item doc returned to determine if it has all gdor stored fields and whether it is merged
#  facet_query = facet query for the collection    collection:coll_solr_doc_id
#  exp_num_merged = number of items in this collection expected to be merged
#  coll_size = total size of this collection
shared_examples_for 'expected merged items' do | facet_query, exp_num_merged, coll_size |
  before(:all) do
    @resp = solr_response({'fq'=>facet_query, 'rows'=>coll_size, 'fl'=>"id,druid,url_fulltext,file_id,display_type,modsxml,collection,collection_with_title", 'facet'=>false})
    @coll_solr_doc_id = facet_query.split(':').last
  end
  
  it "should have exp fields" do
    # FIXME:  would like to DRY this up, but 
    # can't call 'item gdor fields present' from here for each doc id due to nested examples
    # also doc is hash, not Rspec::Solr::SolrResponseHash
    num_merged = 0
    @resp['response']['docs'].each { |solr_doc| 
      # FIXME: it would be awesome if any failures below would indicate the solr doc id of the failed record
      solr_doc_id = solr_doc['id']
      druid = solr_doc['druid']
      druid.should =~ /^[a-z]{2}[0-9]{3}[a-z]{2}[0-9]{4}$/
      merged = solr_doc_id != druid
      num_merged += 1 if merged

      solr_doc['collection'].should include(@coll_solr_doc_id)
      solr_doc['collection_with_title'].should be_any {|s| s =~ Regexp.new("^#{@coll_solr_doc_id}-\\|-.*")}      
      display_types = solr_doc['display_type']
      display_types.should be_any {|s| s =~ /file|image/}
      solr_doc['file_id'].size.should > 0

      if merged
        solr_doc_id.should_not =~ /^[a-z]{2}[0-9]{3}[a-z]{2}[0-9]{4}$/
        display_types.should include('sirsi')
        solr_doc['url_fulltext'].should include("http://purl.stanford.edu/#{druid}")
        solr_doc['modsxml'].should be_nil
        # there should be no record for the druid and if there is, we want the id
        solr_resp_single_doc(druid).should_not include("id" => /.+/)
      else
        solr_doc_id.should =~ /^[a-z]{2}[0-9]{3}[a-z]{2}[0-9]{4}$/
        solr_doc['url_fulltext'].should include("http://purl.stanford.edu/#{solr_doc_id}")
        solr_doc['modsxml'].should =~ /http:\/\/www\.loc\.gov\/mods\/v3/
      end
    }
    num_merged.should == exp_num_merged
  end
  
  it "merged records should not be missing gdor fields" do
    resp = solr_resp_doc_ids_only('fq'=>[facet_query, "-druid:*"])
    if exp_num_merged == coll_size
      # get ckeys of any records updated in Symphony that lost their gdor-ness (their druid field)
      resp.should_not include("id" => /.+/)  # get ids of errant records
    else
      resp.should have_at_most(coll_size - exp_num_merged).documents
    end
  end
end # expected merged items

# tests for required stored fields for collection record, merged or unmerged
# solr_doc_id - the id of this item's Solr doc; could be ckey or druid 
# druid - the druid for this item
shared_examples_for 'collection gdor fields present' do | solr_doc_id, druid |
  before(:all) do
    @resp = solr_resp_single_doc(solr_doc_id)
    @merged = solr_doc_id != druid
  end
  # NOTE: can only check stored Solr fields this way
  it_behaves_like 'gdor fields present', solr_doc_id, druid
  it "collection_type" do
    @resp.should include("collection_type" => 'Digital Collection')
  end
end

# tests for collection records/objects
# solr_doc_id = the Solr field id  value for the collection record
# druid = the druid of the collection record
shared_examples_for 'DOR collection object' do | solr_doc_id, druid |
  before(:all) do
    @resp = solr_resp_single_doc(solr_doc_id)
    @merged = solr_doc_id != druid
  end
  it_behaves_like 'collection gdor fields present', solr_doc_id, druid
  it "should have a format field" do
    @resp.should include("format" => /.+/)
  end
end
