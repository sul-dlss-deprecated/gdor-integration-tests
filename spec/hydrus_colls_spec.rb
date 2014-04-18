require 'spec_helper'

describe "Hydrus collections" do
    
  shared_examples_for 'hydrus collection object' do | solr_doc_id |
    it "should have display_type of hydrus_collection" do
      resp = solr_response({'qt'=>'document', 'id'=>solr_doc_id, 'fl'=>'id,display_type', 'facet'=>false})
      resp.should include('display_type' => 'hydrus_collection')
    end
  end
  shared_examples_for 'hydrus item object' do | solr_doc_id |
    it "should have display_type of hydrus_object" do
      resp = solr_response({'qt'=>'document', 'id'=>solr_doc_id, 'fl'=>'id,display_type', 'facet'=>false})
      resp.should include('display_type' => 'hydrus_object')
    end
  end
  
  # tests for hydrus collections
  # coll_druid: the druid of the collection object
  # num_items: the number of items in this collection
  # item_query_str:  the query string to retrieve items from this collection in a SW 'everything' search
  # item_druid:  the druid of an item expected to be retrieved with the query
  # num_results:  the item druid will be found within the first (n) of the search results
  shared_examples_for 'hydrus coll' do | coll_druid, num_items, item_query_str, item_druid, num_results |
    it_behaves_like "all items in collection", coll_druid, num_items
    it_behaves_like "DOR collection object", coll_druid, coll_druid
    it_behaves_like "hydrus collection object", coll_druid
    it_behaves_like "DOR item objects", item_query_str, [item_druid], num_results, coll_druid
    it_behaves_like "hydrus item object", item_druid
    facet_query = "collection:#{coll_druid}"
    it_behaves_like "date fields present", facet_query
#    it_behaves_like "author fields present", facet_query
    # as of 2014-03, there is no way to input language into Hydrus metadata, 
    # so language can't be required until that is fixed.
#    it_behaves_like "language", facet_query
  end

  context "Big Ideas" do
    it_behaves_like 'hydrus coll', 'xf112dv1419', 74, "alix personal", 'mq607rm1165', 3
  end
  context "Folding@home" do
    it_behaves_like 'hydrus coll', 'cj269gn0736', 4, "hp35 trajectory data", 'bd829sf1034', 3
  end
  context "engineering physics undergrad theses" do
    it_behaves_like 'hydrus coll', 'xv924ks7647', 3, "deduceit", 'bg823wn2892', 3
  end
  context "engineering undergrad theses" do
    it_behaves_like 'hydrus coll', 'jg722zc0626', 30, "uclinux", 'ng517gq2855', 3
  end
  context "Forum on Future of Scientific Publishing" do
    it_behaves_like 'hydrus coll', 'ck552zg2217', 14, "open access to manuscripts", 'fx147cs4847', 10
  end
  context "Hopkins Marine Station collection" do
    it_behaves_like 'hydrus coll', 'pn808wc6253', 7, "sea anemone distribution", 'fp045wx3019', 10
  end
  context "John A. Blume Earthquake Engineering Center Technical Report Series" do
    it_behaves_like 'hydrus coll', 'mz198fp9366', 162, "damage diagnosis algorithms", 'wg007jn8560', 5
  end
  context "ME310 2013" do
    it_behaves_like 'hydrus coll', 'kq629sd5182', 8, "audievolve", 'qt429km6702', 3
  end
  context "Physics Undergrad Theses" do
    it_behaves_like 'hydrus coll', 'ds247vz0452', 17, "scanning squid", 'gh325bb5942', 3
  end
  context "Preserving Virtual Worlds" do
    it_behaves_like 'hydrus coll', 'sn446tz2204', 8, "star raiders", 'pp060nc9006', 3
  end
  context "Research Datasets for Image, Video, and Multimedia Systems Group @ Stanford" do
    it_behaves_like 'hydrus coll', 'cm018rf5314', 7, "Stanford Streaming Mobile Augmented Reality Dataset", 'ph459zk5920', 5
  end
  context "Stanford Research Data" do
    it_behaves_like 'hydrus coll', 'md919gh6774', 6, "high angular resolution", 'yx282xq2090', 3
  end
  context "SUL staff publications" do
    it_behaves_like 'hydrus coll', 'hn730ks3626', 4, "academy unbound", 'bd701dh8028', 3
  end
  context "Undergraduate Honors Theses, Graduate School of Education" do
    it_behaves_like 'hydrus coll', 'qs035dj7859', 4, "Civic Engagement in Anakbayan", 'jw598xm2819', 3
  end
  context "Vista Lab" do
    it_behaves_like 'hydrus coll', 'qd500xn1572', 4, "Asynchronous broadband signals", 'hj582pj3902', 3
  end
  context "Yotsuba Society Archives - 4Chan Imageboard Files" do
    it_behaves_like 'hydrus coll', 'rw352rk5082', 1, "4chan archive", 'tf565pz4260', 10
  end
  
  # University Archives Hydrus Collections
  
  context "David Starr Jordan Papers" do
    it_behaves_like 'hydrus coll', 'jy460rb9016', 2, "david starr jordan business correspondence", 'sw878zc4588', 10
  end
  context "H. Bruce Franklin Collection" do
    it_behaves_like 'hydrus coll', 'pn278bq2224', 11, "Advisory Board decision in the matter of professor H. Bruce Franklin", 'cm175mf2096', 5
  end
  context "Jane Lathrop Stanford Papers" do
    it_behaves_like 'hydrus coll', 'hs468px3695', 3, "death and estate papers", 'fk544dk9538', 10
  end
  context "Leland Stanford Papers" do
    it_behaves_like 'hydrus coll', 'zx692xz8270', 4, "leland stanford legal papers", 'kh510mt0132', 10
  end
  context "Martin Luther King at Stanford" do
    it_behaves_like 'hydrus coll', 'yt337pb3236', 3, "martin luther king at stanford", 'dn923nh8281', 10
  end
  context "Stanford Artificial Intelligence Laboratory Records" do
    it_behaves_like 'hydrus coll', 'jb056mm1304', 3, "35th reunion 2009", 'pb496bf3201', 5
  end
  context "The Stanford Flipside" do
    it_behaves_like 'hydrus coll', 'dq441rn2614', 3, "stanford flipside 2008", 'bv723rv4628', 10
  end
  context "Stanford Student Letters and Memoirs" do
    it_behaves_like 'hydrus coll', 'mt423yd8582', 1, "letters and memoirs", 'jv222bg0652', 10
  end
  context "Stanford University Commencement Collection" do
    it_behaves_like 'hydrus coll', 'nz928tt4938', 3, "commencement addresses", 'mp840zw9344', 10
  end
  context "Stanford University Film Collection" do
    it_behaves_like 'hydrus coll', 'tm335zd3912', 1, "stanford university film collection films 1937", 'zv044zr8616', 10
  end
  context "Stanford University Video Collection" do
    it_behaves_like 'hydrus coll', 'gn946cw3927', 1, "stanford university videos 1939", 'ts408hz9199', 20
  end
  
  # Archive of Recorded Sound Hydrus Collections
  
  context "Rigler-Deutsch Computer Tapes" do
    it_behaves_like 'hydrus coll', 'jd276dz9994', 5, "Rigler & Deutsch Record Index", 'cr661vw3932', 10
  end
  
end