require 'spec_helper'

describe "Hydrus collections" do
    
  shared_examples_for 'hydrus collection object' do | solr_doc_id |
    it "should have display_type of file" do
      resp = solr_response({'qt'=>'document', 'id'=>solr_doc_id, 'fl'=>'id,display_type', 'facet'=>false})
      resp.should include('display_type' => 'file')
    end
  end
  shared_examples_for 'hydrus item object' do | solr_doc_id |
    it "should have display_type of file" do
      resp = solr_response({'qt'=>'document', 'id'=>solr_doc_id, 'fl'=>'id,display_type', 'facet'=>false})
      resp.should include('display_type' => 'file')
    end
  end
  
  # tests for hydrus collections
  # coll_druid: the druid of the collection object
  # num_items: the number of items in this collection
  # display_types:  the expected value(s) of SW display_type field.  Can be String or Array of Strings
  # formats:  the expected value(s) of SW format field.  Can be String or Array of Strings
  # author_missing_ids: the ids of records missing searchable author.  nil, String, or Array of Strings
  # item_query_str:  the query string to retrieve items from this collection in a SW 'everything' search
  # item_druid:  the druid of an item expected to be retrieved with the query
  # num_results:  the item druid will be found within the first (n) of the search results
  # dark_object_ids = Array of Solr ids for objects that won't have file_id
  shared_examples_for 'hydrus coll' do | coll_druid, num_items, display_types, format_main_ssim, author_missing_ids, item_query_str, item_druid, num_results, dark_object_ids |
    it_behaves_like "all items in collection", coll_druid, num_items
    it_behaves_like "DOR collection object", coll_druid, coll_druid
    it_behaves_like "hydrus collection object", coll_druid
    it_behaves_like "DOR item objects", item_query_str, [item_druid], num_results, coll_druid, dark_object_ids
    it_behaves_like "hydrus item object", item_druid
    facet_query = "collection:#{coll_druid}"
    it_behaves_like 'expected display_type values', facet_query, display_types
    it_behaves_like 'expected format_main_ssim values', facet_query, format_main_ssim
    it_behaves_like "date fields present", facet_query
    if author_missing_ids && author_missing_ids.size > 0
      it_behaves_like "author field present except", facet_query, author_missing_ids
    else
      it_behaves_like "author field present", facet_query
    end
    # as of 2014-03, there is no way to input language into Hydrus metadata, 
    # so language can't be required until that is fixed.
#    it_behaves_like "language", facet_query
  end

  context "Big Ideas" do
    # DATA FIXME:  is format 'Other' still best fit?
    it_behaves_like 'hydrus coll', 'xf112dv1419', 74, 'file', 'Article', nil, "alix personal", 'mq607rm1165', 3
  end
  context "Digital Humanities" do
    it_behaves_like 'hydrus coll', 'np305zs0638', 2, 'file', 'Dataset', nil, "network edge and node tables", 'mn425tz9757', 10
  end
  context "Digital Humanities" do
    it_behaves_like 'hydrus coll', 'np305zs0638', 2, 'file', 'Computer File', nil, "network edge and node tables", 'mn425tz9757', 10
  end
  context "Digital Humanities" do
    it_behaves_like 'hydrus coll', 'np305zs0638', 2, 'file', 'Computer File', nil, "network edge and node tables", 'mn425tz9757', 10
  end
  context "engineering physics undergrad theses" do
    it_behaves_like 'hydrus coll', 'xv924ks7647', 3, 'file', 'Book', nil, "deduceit", 'bg823wn2892', 3
  end
  context "engineering undergrad theses" do
    it_behaves_like 'hydrus coll', 'jg722zc0626', 35, 'file', 'Book', nil, "uclinux", 'ng517gq2855', 3
  end
  context "Folding@home" do
    it_behaves_like 'hydrus coll', 'cj269gn0736', 8, 'file', ['Dataset','Software/Multimedia'], nil, "hp35 trajectory data", 'bd829sf1034', 3
  end
  context "Forum on Future of Scientific Publishing" do
    it_behaves_like 'hydrus coll', 'ck552zg2217', 14, 'file', 'Book', nil, "open access to manuscripts", 'fx147cs4847', 10
  end
  context "GSE Open Archive" do
    it_behaves_like 'hydrus coll', 'tz959sb6952', 97, 'file', ["Article", "Book", 'Archive/Manuscript'], nil, "acculturative stress and coping", 'yg867nn1610', 5
  end
  context "Hopkins Marine Station collection" do
    it_behaves_like 'hydrus coll', 'pn808wc6253', 8, 'file', ["Dataset", "Archive/Manuscript"], ["fp045wx3019", "tt999fm2734", "gk364tm7562", "yb742ts0531"], "sea anemone distribution", 'fp045wx3019', 10
    facet_query = "collection:pn808wc6253"
    it_behaves_like "language", facet_query
  end
  context "John A. Blume Earthquake Engineering Center Technical Report Series" do
    it_behaves_like 'hydrus coll', 'mz198fp9366', 162, 'file', "Book", ["dv756jr9637", "nh929nm1593"], "damage diagnosis algorithms", 'wg007jn8560', 5
    #it_behaves_like "language", facet_query # 157 recs missing language as of 2014-05-23
  end
  context "Lobell Laboratory" do
    it_behaves_like 'hydrus coll', 'rz423vt0583', 1, 'file', "Computer File", nil, "maize yield increase in the US midwest", 'tp790js7917', 5
  end
  context "ME310 2013" do
    # DATA FIXME:  is format 'Other' still best fit?
    it_behaves_like 'hydrus coll', 'kq629sd5182', 18, 'file', ['Article', 'Book', 'Other'], nil, "audievolve", 'qt429km6702', 3
  end
  context "Physics Undergrad Theses" do
    it_behaves_like 'hydrus coll', 'ds247vz0452', 20, 'file', "Book", nil, "scanning squid", 'gh325bb5942', 3
  end
  context "Donald Pippin" do
    it_behaves_like 'hydrus coll', 'xg598bt7576', 73, 'file', "Book", nil, "no love allowed", 'bw510pk6500', 3
  end
  context "Pleistocene Lake Surprise" do
    it_behaves_like 'hydrus coll', 'wm362dj5692', 6, 'file', ['Book', 'Computer File'], nil, "Pleistocene to middle Holocene", 'cb924rw5595', 10
  end
  context "Preserving Virtual Worlds" do
    it_behaves_like 'hydrus coll', 'sn446tz2204', 8, 'file', "Computer File", ['xy157wz5444', 'rd383mp8260'], "star raiders", 'pp060nc9006', 3, ['pp060nc9006']
  end
  context "Research Datasets for Image, Video, and Multimedia Systems Group @ Stanford" do
    it_behaves_like 'hydrus coll', 'cm018rf5314', 8, 'file', "Computer File", nil, "Stanford Streaming Mobile Augmented Reality Dataset", 'ph459zk5920', 5
  end
  context "Serial section electron microscopy data for Nanoscale organization of the MEC-4 DEG/ENaC sensory mechanotransduction channel in Caenorhabditis elegans touch receptor neurons" do
    it_behaves_like 'hydrus coll', 'cv355cw2458', 2, 'file', "Computer File", nil, "immuno electron microscopy", 'zb423jg0099', 10
  end
  context "Serial section electron microscopy data for Posttranslational acetylation of alpha tubulin constrains protofilament number in native microtubules" do
    it_behaves_like 'hydrus coll', 'sc642pw6867', 8, "file", "Computer File", nil, "touch receptor neurons", 'qg053ym5844', 10
  end
  context "Stanford Athletics Interviews" do
    it_behaves_like 'hydrus coll', 'zk807sw9336', 2, 'file', ['Sound Recording', 'Manuscript/Archive'], ['gz839jz3577', 'pd175rf4256'], "transcripts interviews bob murphy", 'pd175rf4256', 20
  end
  context "Stanford LGBT Alumni Oral History Interviews" do
    it_behaves_like 'hydrus coll', 'kz963xt9682', 2, 'file', ['Sound Recording', 'Manuscript/Archive'], nil, "transcripts LGBT alumni oral history", 'gk352dr4264', 20
  end
  context "Stanford Research Data" do
    it_behaves_like 'hydrus coll', 'md919gh6774', 8, 'file', ['Computer File', 'Book'], nil, "high angular resolution", 'yx282xq2090', 3
  end
  context "SUL staff publications" do
    it_behaves_like 'hydrus coll', 'hn730ks3626', 5, 'file', ['Article', 'Book'], nil, "academy unbound", 'bd701dh8028', 3
 end
  context "Undergraduate Honors Theses, Graduate School of Education" do
    it_behaves_like 'hydrus coll', 'qs035dj7859', 10, "file", "Book", nil, "Civic Engagement in Anakbayan", 'jw598xm2819', 3
  end
  context "Undergraduate Theses, Program in Feminist, Gender, and Sexuality Studies" do
    it_behaves_like 'hydrus coll', 'jr938vv9537', 4, "file", "Book", nil, "gay catholic men", 'by699sk7545', 3
  end
  context "Vista Lab" do
    it_behaves_like 'hydrus coll', 'qd500xn1572', 4, "file", "Computer File", nil, "Asynchronous broadband signals", 'hj582pj3902', 3
  end
  context "Yotsuba Society Archives - 4Chan Imageboard Files" do
    it_behaves_like 'hydrus coll', 'rw352rk5082', 1, "file", "Manuscript/Archive", 'tf565pz4260', "4chan archive", 'tf565pz4260', 10
    facet_query = "collection:rw352rk5082"
    it_behaves_like "language", facet_query
  end
  
  # University Archives Hydrus Collections
  
  context "David Starr Jordan Papers" do
    it_behaves_like 'hydrus coll', 'jy460rb9016', 2, "file", "Manuscript/Archive", nil, "david starr jordan business correspondence", 'sw878zc4588', 10
  end
  context "H. Bruce Franklin Collection" do
    it_behaves_like 'hydrus coll', 'pn278bq2224', 11, "file", "Manuscript/Archive", nil,"Advisory Board decision in the matter of professor H. Bruce Franklin", 'cm175mf2096', 5
  end
  context "Jane Lathrop Stanford Papers" do
    it_behaves_like 'hydrus coll', 'hs468px3695', 3, "file", "Manuscript/Archive", nil, "death and estate papers", 'fk544dk9538', 10
  end
  context "Leland Stanford Papers" do
    it_behaves_like 'hydrus coll', 'zx692xz8270', 4, "file", "Manuscript/Archive", nil, "leland stanford legal papers", 'kh510mt0132', 10
  end
  context "Martin Hellman" do
    it_behaves_like 'hydrus coll', 'rr229tn9249', 5, 'file', "Manuscript/Archive", nil, "cryptography history", 'wg115cn5068', 10
  end
  context "Martin Luther King at Stanford" do
    it_behaves_like 'hydrus coll', 'yt337pb3236', 3, "file", ["Image", "Video"], "dn923nh8281",  "martin luther king at stanford", 'dn923nh8281', 10
  end
  context "Paul R. Ehrlich papers" do
    it_behaves_like 'hydrus coll', 'ft617pg1817', 2, 'file', ["Video", "Sound Recording"], nil, "Additional Material (Accession 2005-170)", 'zp321tx2887', 10
  end
  context "Stanford Artificial Intelligence Laboratory Records" do
    it_behaves_like 'hydrus coll', 'jb056mm1304', 3, "file", ["Image", "Manuscript/Archive"], ["pb496bf3201", "hb976hq8639", "qz957bs6680"],  "35th reunion 2009", 'pb496bf3201', 5
  end
  context "The Stanford Flipside" do
    it_behaves_like 'hydrus coll', 'dq441rn2614', 3, "file", "Manuscript/Archive", nil, "stanford flipside 2008", 'bv723rv4628', 10
  end
  context "Stanford Student Letters and Memoirs" do
    it_behaves_like 'hydrus coll', 'mt423yd8582', 1, "file", "Manuscript/Archive", 'jv222bg0652',  "letters and memoirs", 'jv222bg0652', 10
  end
  context "Stanford University Commencement Collection" do
    it_behaves_like 'hydrus coll', 'nz928tt4938', 3, "file", ["Manuscript/Archive", "Video"], ["xq460yy5434", "sv489yy6266", "mp840zw9344"],  "commencement addresses", 'mp840zw9344', 10
  end
  context "Stanford University Film Collection" do
    it_behaves_like 'hydrus coll', 'tm335zd3912', 1, "file", "Video", 'zv044zr8616', "stanford university film collection films 1937", 'zv044zr8616', 10
  end
  context "Stanford University Video Collection" do
    it_behaves_like 'hydrus coll', 'gn946cw3927', 1, "file", "Video", 'ts408hz9199', "stanford university videos 1939", 'ts408hz9199', 20
  end
  
  # Archive of Recorded Sound Hydrus Collections
  
  context "Rigler-Deutsch Computer Tapes" do
    it_behaves_like 'hydrus coll', 'jd276dz9994', 5, "file", ["Article", "Dataset","Archive/Manuscript"], nil, "Rigler Deutsch Record Index", 'cr661vw3932', 10
  end
  
end