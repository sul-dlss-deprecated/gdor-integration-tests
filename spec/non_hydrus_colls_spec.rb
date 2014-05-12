require 'spec_helper'

describe "DOR Digital Collections" do

  # tests for non-hydrus collections
  # coll_id: the ckey of the collection object, if there is a marc record;  druid if not
  # coll_druid: the druid of the collection object (may be the same as the coll_id)
  # num_items: the number of items in this collection
  # item_query_str:  the query string to retrieve items from this collection in a SW 'everything' search
  # item_druids:  an array of the druid(s) of item(s) expected to be retrieved with the query
  # num_results:  the item druid will be found within the first (n) of the search results
  shared_examples_for 'gdor coll' do | coll_id, coll_druid, num_items, item_query_str, item_druids, num_results |
    it_behaves_like "all items in collection", coll_id, num_items
    it_behaves_like "DOR collection object", coll_id, coll_druid
    it_behaves_like "DOR item objects", item_query_str, item_druids, num_results, coll_id
  end

  context "merged coll records" do
    # id of collection record is ckey from Sirsi, not druid from DOR
    
    context "Francis E. Stafford photographs" do
      ckey = '9615156'
      it_behaves_like 'gdor coll', ckey, 'yg867hg1375', 5, "seventh day adventist church missionaries", ['nz353cp1092'], 10
      facet_query = "collection:#{ckey}"
      it_behaves_like "date fields present", facet_query
#      it_behaves_like "author fields present", facet_query
#      it_behaves_like "language", facet_query
    end
    context "Kolb" do
      ckey = '4084372'
      it_behaves_like 'gdor coll', ckey, 'bs646cd8717', 1402, "Addison Joseph", ['vb267mw8946'], 10
#      facet_query = "collection:#{ckey}"
      # lack of pub dates grandfathered in -- old Image Gallery collection
#      it_behaves_like "date fields present", facet_query
#      it_behaves_like "author fields present", facet_query
#      it_behaves_like "language", facet_query
    end
    context "Reid Dennis" do
      ckey = '6780453'
      it_behaves_like 'gdor coll', ckey, 'sg213ph2100', 48, "bird's eye view san francisco", ['pz572zt9333', 'nz525ps5073', 'bw260mc4853', 'mz639xs9677'], 15
#      facet_query = "collection:#{ckey}"
      # lack of pub dates grandfathered in -- old Image Gallery collection
#      it_behaves_like "date fields present", facet_query
#      it_behaves_like "author fields present", facet_query
#      it_behaves_like "language", facet_query
    end
  end # merged coll records
  
  context "merged item records" do
    context "Caroline Batchelor maps collection" do
      ckey = '10357851'
      it_behaves_like 'gdor coll', ckey, 'ct961sj2730', 184, "new one-sheet map of Africa", ['8924690'], 15
      facet_query = "collection:#{ckey}"
      it_behaves_like "All DOR item objects merged", facet_query, 180
      it_behaves_like "date fields present", facet_query  # currently ct011mf9794/8836601 is without a date - should be fixed when it merges properly
#      it_behaves_like "language", facet_query 
#      it_behaves_like "author fields present", facet_query
    end
  end
  
  context "no marc coll record" do
    # id of collection record in Solr is druid from DOR
  
    context "Bob Fitch photography archive - Cesar Chavez" do
      coll_id = 'zp940yp4275'
      it_behaves_like 'gdor coll', coll_id, coll_id, 90, "dorothy day united farmworkers union", ['bv989yj8759'], 10
      facet_query = "collection:#{coll_id}"
      it_behaves_like "date fields present", facet_query
#      it_behaves_like "author fields present", facet_query
#      it_behaves_like "language", facet_query
    end
    context "Bob Fitch photography archive - Martin Luther King" do
      coll_id = 'zz473kt2569'
      it_behaves_like 'gdor coll', coll_id, coll_id, 75, "mississippi meredith march", ['cv188wn4659'], 10
      facet_query = "collection:#{coll_id}"
      it_behaves_like "date fields present", facet_query
#      it_behaves_like "author fields present", facet_query
#      it_behaves_like "language", facet_query
    end

    context "Classics Papyri" do
      coll_id = 'jr022nf7673'
      it_behaves_like 'gdor coll', coll_id, coll_id, 44, "fragment documentary text", ['jx555jt0710'], 10
      facet_query = "collection:#{coll_id}"
      it_behaves_like "sortable pub date", facet_query
      # date slider can't do BC dates
#      it_behaves_like "date slider dates", facet_query
#      it_behaves_like "author fields present", facet_query
      it_behaves_like "language", facet_query
    end
    context "Glen McLaughlin Maps" do
      coll_id = 'zb871zd0767'
      it_behaves_like 'gdor coll', coll_id, coll_id, 731, "AMERIQUE", ['jk190bb4635'], 20
      facet_query = "collection:#{coll_id}"
      it_behaves_like "date fields present", facet_query
#      it_behaves_like "author fields present", facet_query
#      it_behaves_like "language", facet_query
    end
    context "Glen McLaughlin Maps Collection -- Maps of Malta" do
      coll_id = 'yb129fc1507'
      it_behaves_like 'gdor coll', coll_id, coll_id, 13, "melita", ['zz360bw3691'], 10
      facet_query = "collection:#{coll_id}"
      it_behaves_like "date fields present", facet_query
#      it_behaves_like "author fields present", facet_query
#      it_behaves_like "language", facet_query
    end
    context "Walters Manuscripts" do
      coll_id = 'ww121ss5000'
      it_behaves_like 'gdor coll', coll_id, coll_id, 298, "walters brasses", ['cn006dx2288'], 3
      facet_query = "collection:#{coll_id}"
      it_behaves_like "date fields present", facet_query
#      it_behaves_like "author fields present", facet_query
#      it_behaves_like "language", facet_query
    end
  end # no marc coll record
  
end