require 'spec_helper'

describe "DOR Digital Collections" do

  context "merged coll records" do
    # id of collection record is ckey from Sirsi, not druid from DOR
    
    context "Francis E. Stafford photographs" do
      ckey = '9615156'
      it_behaves_like "all items in collection", ckey, 5
      it_behaves_like "DOR collection object", ckey, 'yg867hg1375'
      it_behaves_like "DOR item objects", "seventh day adventist church missionaries", ['nz353cp1092'], 10, ckey
      facet_query = "collection:#{ckey}"
      it_behaves_like "date fields present", facet_query
#      it_behaves_like "author fields present", facet_query
#      it_behaves_like "language", facet_query
    end
    context "Kolb" do
      ckey = '4084372'
      it_behaves_like "all items in collection", ckey, 1402
      it_behaves_like "DOR collection object", ckey, 'bs646cd8717'
      it_behaves_like "DOR item objects", "Addison Joseph", ['vb267mw8946'], 10, ckey
#      facet_query = "collection:#{ckey}"
      # lack of pub dates grandfathered in -- old Image Gallery collection
#      it_behaves_like "date fields present", facet_query
#      it_behaves_like "author fields present", facet_query
#      it_behaves_like "language", facet_query
    end
    context "Reid Dennis" do
      ckey = '6780453'
      it_behaves_like "all items in collection", ckey, 48
      it_behaves_like "DOR collection object", ckey, 'sg213ph2100'
      it_behaves_like "DOR item objects", "bird's eye view san francisco", ['pz572zt9333', 'nz525ps5073', 'bw260mc4853', 'mz639xs9677'], 15, ckey
#      facet_query = "collection:#{ckey}"
      # lack of pub dates grandfathered in -- old Image Gallery collection
#      it_behaves_like "date fields present", facet_query
#      it_behaves_like "author fields present", facet_query
#      it_behaves_like "language", facet_query
    end
  end # merged coll records
  
  
  context "no marc coll record" do
    # id of collection record in Solr is druid from DOR
  
    context "Classics Papyri" do
      coll_id = 'jr022nf7673'
      it_behaves_like "all items in collection", coll_id, 44
      it_behaves_like "DOR collection object", coll_id, coll_id
      it_behaves_like "DOR item objects", "fragment documentary text", ['jx555jt0710'], 10, coll_id
      facet_query = "collection:#{coll_id}"
      it_behaves_like "sortable pub date", facet_query
      # date slider can't do BC dates
#      it_behaves_like "date slider dates", facet_query
#      it_behaves_like "author fields present", facet_query
      it_behaves_like "language", facet_query
    end
    context "Glen McLaughlin Maps" do
      coll_id = 'zb871zd0767'
      it_behaves_like "all items in collection", coll_id, 731
      it_behaves_like "DOR collection object", coll_id, coll_id
      it_behaves_like "DOR item objects", "AMERIQUE", ['jk190bb4635'], 20, coll_id   
      facet_query = "collection:#{coll_id}"
      it_behaves_like "date fields present", facet_query
#      it_behaves_like "author fields present", facet_query
#      it_behaves_like "language", facet_query
    end
    context "Glen McLaughlin Maps Collection -- Maps of Malta" do
      coll_id = 'yb129fc1507'
      it_behaves_like "all items in collection", coll_id, 13
      it_behaves_like "DOR collection object", coll_id, coll_id
      it_behaves_like "DOR item objects", "melita", ['zz360bw3691'], 10, coll_id
      facet_query = "collection:#{coll_id}"
      it_behaves_like "date fields present", facet_query
#      it_behaves_like "author fields present", facet_query
#      it_behaves_like "language", facet_query
    end
    context "Walters Manuscripts" do
      coll_id = 'ww121ss5000'
      it_behaves_like "all items in collection", coll_id, 298
      it_behaves_like "DOR collection object", coll_id, coll_id
      it_behaves_like "DOR item objects", "walters brasses", ['cn006dx2288'], 3, coll_id
      facet_query = "collection:#{coll_id}"
      it_behaves_like "date fields present", facet_query
#      it_behaves_like "author fields present", facet_query
#      it_behaves_like "language", facet_query
    end
  end # no marc coll record
  
end