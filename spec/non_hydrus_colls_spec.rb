require 'spec_helper'

describe "DOR Digital Collections" do

  # tests for non-hydrus collections
  # coll_id: the ckey of the collection object, if there is a marc record;  druid if not
  # coll_druid: the druid of the collection object (may be the same as the coll_id)
  # num_items: the number of items in this collection
  # display_types:  the expected value(s) of SW display_type field.  Can be String or Array of Strings
  # formats:  the expected value(s) of SW format field.  Can be String or Array of Strings
  # item_query_str:  the query string to retrieve items from this collection in a SW 'everything' search
  # item_druids:  an array of the druid(s) of item(s) expected to be retrieved with the query
  # num_results:  the item druid will be found within the first (n) of the search results
  shared_examples_for 'gdor coll' do | coll_id, coll_druid, num_items, display_types, formats, item_query_str, item_druids, num_results |
    it_behaves_like "all items in collection", coll_id, num_items
    it_behaves_like "DOR collection object", coll_id, coll_druid
    it_behaves_like "DOR item objects", item_query_str, item_druids, num_results, coll_id
    facet_query = "collection:#{coll_druid}"
    it_behaves_like 'expected display_type values', facet_query, display_types
    it_behaves_like 'expected format values', facet_query, formats
  end

  context "merged coll records" do
    # id of collection record is ckey from Sirsi, not druid from DOR
    
    context "Francis E. Stafford photographs" do
      ckey = '9615156'
      it_behaves_like 'gdor coll', ckey, 'yg867hg1375', 5, 'image', "Image", "seventh day adventist church missionaries", ['nz353cp1092'], 10
      facet_query = "collection:#{ckey}"
      it_behaves_like "date fields present", facet_query
      # DATA FIXME:  the same 5 records missing searchable author and language???
      it_behaves_like 'author field present except', facet_query, ["nz353cp1092", "jf275fd6276", "ww689vs6534", "th998nk0722", "tc552kq0798"]
      it_behaves_like 'language field present except', facet_query, ['nz353cp1092', 'jf275fd6276', 'ww689vs6534', 'th998nk0722', 'tc552kq0798']
    end
    context "Kolb" do
      ckey = '4084372'
      it_behaves_like 'gdor coll', ckey, 'bs646cd8717', 1402, 'image', "Image", "Addison Joseph", ['vb267mw8946'], 10
      #facet_query = "collection:#{ckey}"
      # lack of pub dates grandfathered in -- old Image Gallery collection
      #  as of 2014-05-23, none of the records have any of these fields
      #it_behaves_like "date fields present", facet_query
      #it_behaves_like "author field present", facet_query
      #it_behaves_like "language", facet_query
    end
    context "Reid Dennis" do
      ckey = '6780453'
      it_behaves_like 'gdor coll', ckey, 'sg213ph2100', 48, 'image', "Image", "bird's eye view san francisco", ['pz572zt9333', 'nz525ps5073', 'bw260mc4853', 'mz639xs9677'], 15
      facet_query = "collection:#{ckey}"
      # lack of pub dates grandfathered in -- old Image Gallery collection
      it_behaves_like "date fields present except", facet_query, ["bt970vy9251", "kg568mq8595", "qw685fw6269", "xn563rv5499", "bf098tm0241"]
      #it_behaves_like "author field present except", facet_query  # 21 records missing author as of 2014-05-23
      #it_behaves_like "language field present except", facet_query # all records missing language as of 2014-05-23
    end
  end # merged coll records
  
  context "merged item records" do
    context "Caroline Batchelor maps" do
      ckey = '10357851'
      coll_size = 181 # 187 DOR objects, but 181 Solr docs -- 12 DOR objects go to 6 ckeys?
      it_behaves_like 'gdor coll', ckey, 'ct961sj2730', coll_size, 'image', "Map/Globe", "new one-sheet map of Africa", ['8924690'], 15
      facet_query = "collection:#{ckey}"
      it_behaves_like "expected merged items", facet_query, coll_size, coll_size
      # 8836601 has 17uu which gives sortable date, but nothing for date slider
      it_behaves_like "sortable pub date", facet_query
      it_behaves_like "SW field present except", 'pub_year_tisim', facet_query, '8836601'
      it_behaves_like "language field present except", facet_query, 
        ["8832188",
         "8837479",
         "8837481",
         "8837485",
         "8837494",
         "8881594",
         "8884264",
         "8924678",
         "8924695",
         "8925401",
         "8935525",
         "8940656",
         "8940672",
         "9052083",
         "9067460",
         "9081170",
         "9082129",
         "9082623",
         "9082975"]
      #it_behaves_like "author field present except", facet_query # 69 recs missing author as of 2014-05-23
    end
    context "Glen McLaughlin Maps" do
      coll_id = 'zb871zd0767'
      coll_size = 733
      it_behaves_like 'gdor coll', coll_id, coll_id, coll_size, 'image', "Map/Globe", "AMERIQUE", ['jk190bb4635'], 20
      facet_query = "collection:#{coll_id}"
      it_behaves_like "expected merged items", facet_query, 5, coll_size
      it_behaves_like "date fields present", facet_query
      #it_behaves_like "author field present", facet_query # 544 recs missing author as of 2014-05-23
      #it_behaves_like "language", facet_query # 581 recs missing language as of 2014-05-23
    end

    context "Memorial Library of Music" do
      ckey = '9645653'
      coll_size = 15
      it_behaves_like 'gdor coll', ckey, 'ft241sj7871', coll_size, 'image', ['Music - Score', 'Manuscript/Archive'], "comus masque", ['3901792'], 10
      facet_query = "collection:#{ckey}"
      it_behaves_like "expected merged items", facet_query, coll_size, coll_size
      it_behaves_like "date fields present except", facet_query, '9686884'
      it_behaves_like "language", facet_query 
      it_behaves_like "author field present except", facet_query, ["3320159", "3901701"]
    end
  end # merged items
  
  context "no marc coll record" do
    # id of collection record in Solr is druid from DOR
  
    context "Bob Fitch photography archive - Cesar Chavez" do
      coll_id = 'zp940yp4275'
      it_behaves_like 'gdor coll', coll_id, coll_id, 90, 'image', "Image", "dorothy day united farmworkers union", ['bv989yj8759'], 10
      facet_query = "collection:#{coll_id}"
      it_behaves_like "date fields present", facet_query
      # it_behaves_like "author field present", facet_query # 90 recs missing author as of 2014-05-23
      # it_behaves_like "language", facet_query # 90 recs missing language as of 2014-05-23
    end
    context "Bob Fitch photography archive - Martin Luther King" do
      coll_id = 'zz473kt2569'
      it_behaves_like 'gdor coll', coll_id, coll_id, 75, 'image', "Image", "mississippi meredith march", ['cv188wn4659'], 10
      facet_query = "collection:#{coll_id}"
      it_behaves_like "date fields present", facet_query
      #it_behaves_like "author field present", facet_query # 75 recs missing author as of 2014-05-23
      #it_behaves_like "language", facet_query # 75 recs missing language as of 2014-05-23
    end

    context "Classics Papyri" do
      coll_id = 'jr022nf7673'
      it_behaves_like 'gdor coll', coll_id, coll_id, 44, "image", "Manuscript/Archive", "fragment documentary text", ['jx555jt0710'], 10
      facet_query = "collection:#{coll_id}"
      it_behaves_like "sortable pub date", facet_query
      # date slider can't do BC dates
      #it_behaves_like "date slider dates", facet_query # 44 recs missing pub_year_tisim as of 2014-05-23
      #it_behaves_like "author field present", facet_query # 44 recs missing author as of 2014-05-23
      it_behaves_like "language", facet_query
    end

    context "Glen McLaughlin Maps Collection -- Maps of Malta" do
      coll_id = 'yb129fc1507'
      it_behaves_like 'gdor coll', coll_id, coll_id, 13, "image", "Map/Globe", "melita", ['zz360bw3691'], 10
      facet_query = "collection:#{coll_id}"
      it_behaves_like "date fields present", facet_query
      #it_behaves_like "author field present", facet_query # 13 recs missing author as of 2014-05-23
      #it_behaves_like "language", facet_query # 13 recs missing language as of 2014-05-23
    end
    
    context "Walters Manuscripts" do
      coll_id = 'ww121ss5000'
      it_behaves_like 'gdor coll', coll_id, coll_id, 298, 'image', "Manuscript/Archive", "walters brasses", ['cn006dx2288'], 3
      facet_query = "collection:#{coll_id}"
      it_behaves_like "date fields present", facet_query
      #it_behaves_like "author field present", facet_query # 298 recs missing author as of 2014-05-23
      #it_behaves_like "language field present except", facet_query # 24 recs missing language as of 2014-05-23
    end
  end # no marc coll record
  
end