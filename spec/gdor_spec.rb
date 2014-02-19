require 'spec_helper'

describe "Index Contents" do

  context "All GDOR content" do
    it "every non-collection object should have a collection" do
      resp = solr_resp_doc_ids_only({'fq'=> ["-collection:*", "-display_type:*collection"], 'rows'=>'0'})
      resp.should_not have_documents
    end
    it "should have access_facet = Online for each colleciton object" do
      resp = solr_resp_doc_ids_only({'fq'=>["display_type:*collection", "-access_facet:Online"], 'rows'=>'0'})
      resp.should_not have_documents
    end
  end

  context "DOR Digital Collections" do
    
    context "Kolb" do
      it_behaves_like "all items in collection", '4084372', 1402
      it_behaves_like "DOR collection object", '4084372', 'bs646cd8717'
      it_behaves_like "DOR item objects", "Addison Joseph", ['vb267mw8946'], 10, '4084372'
    end

    context "Reid Dennis" do
      it_behaves_like "all items in collection", '6780453', 48
      it_behaves_like "DOR collection object", '6780453', 'sg213ph2100'
      it_behaves_like "DOR item objects", "bird's eye view san francisco", ['pz572zt9333', 'nz525ps5073', 'bw260mc4853', 'mz639xs9677'], 15, '6780453'
    end

    context "Walters Manuscripts" do
      it_behaves_like "all items in collection", 'ww121ss5000', 298
      it_behaves_like "DOR collection object", 'ww121ss5000', 'ww121ss5000'
      it_behaves_like "DOR item objects", "walters brasses", ['cn006dx2288'], 3, 'ww121ss5000'
    end
    
    context "Glen McLaughlin Maps" do
        it_behaves_like "all items in collection", 'zb871zd0767', 731
        it_behaves_like "DOR collection object", 'zb871zd0767', 'zb871zd0767'
        it_behaves_like "DOR item objects", "AMERIQUE", ['jk190bb4635'], 114, 'zb871zd0767'   
    end
    
    context "Classics Papyri" do
      it_behaves_like "all items in collection", 'jr022nf7673', 44
      it_behaves_like "DOR collection object", 'jr022nf7673', 'jr022nf7673'
      it_behaves_like "DOR item objects", "fragment documentary text", ['jx555jt0710'], 10, 'jr022nf7673'
    end
    context "Glen McLaughlin Maps Collection -- Maps of Malta" do
      it_behaves_like "all items in collection", 'yb129fc1507', 13
      it_behaves_like "DOR collection object", 'yb129fc1507', 'yb129fc1507'
      it_behaves_like "DOR item objects", "melita", ['zz360bw3691'], 10, 'yb129fc1507'
    end
    
    context "Hydrus collections" do
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

      context "Folding@home" do
        it_behaves_like "all items in collection", 'cj269gn0736', 4
        it_behaves_like "DOR collection object", 'cj269gn0736', 'cj269gn0736'
        it_behaves_like "hydrus collection object", 'cj269gn0736'
        it_behaves_like "DOR item objects", "hp35 trajectory data", ['bd829sf1034'], 3, 'cj269gn0736'
        it_behaves_like "hydrus item object", 'bd829sf1034'
      end
      context "Preserving Virtual Worlds" do
        it_behaves_like "all items in collection", 'sn446tz2204', 8
        it_behaves_like "DOR collection object", 'sn446tz2204', 'sn446tz2204'
        it_behaves_like "hydrus collection object", 'sn446tz2204'
        it_behaves_like "DOR item objects", "star raiders", ['pp060nc9006'], 3, 'sn446tz2204'
        it_behaves_like "hydrus item object", 'pp060nc9006'
      end
      context "Stanford Research Data" do
        it_behaves_like "all items in collection", 'md919gh6774', 5
        it_behaves_like "DOR collection object", 'md919gh6774', 'md919gh6774'
        it_behaves_like "hydrus collection object", 'md919gh6774'
        it_behaves_like "DOR item objects", "high angular resolution", ['yx282xq2090'], 3, 'md919gh6774'
        it_behaves_like "hydrus item object", 'yx282xq2090'
      end
      context "SUL staff publications" do
        it_behaves_like "all items in collection", 'hn730ks3626', 4
        it_behaves_like "DOR collection object", 'hn730ks3626', 'hn730ks3626'
        it_behaves_like "hydrus collection object", 'hn730ks3626'
        it_behaves_like "DOR item objects", "academy unbound", ['bd701dh8028'], 3, 'hn730ks3626'
        it_behaves_like "hydrus item object", 'bd701dh8028'
      end
      context "Physic Undergrad Theses" do
        it_behaves_like "all items in collection", 'ds247vz0452', 17
        it_behaves_like "DOR collection object", 'ds247vz0452', 'ds247vz0452'
        it_behaves_like "hydrus collection object", 'ds247vz0452'
        it_behaves_like "DOR item objects", "scanning squid", ['gh325bb5942'], 3, 'ds247vz0452'
        it_behaves_like "hydrus item object", 'gh325bb5942'
      end
      
      context "Big Ideas" do
        it_behaves_like "all items in collection", 'xf112dv1419', 74
        it_behaves_like "DOR collection object", 'xf112dv1419', 'xf112dv1419'
        it_behaves_like "hydrus collection object", 'xf112dv1419'
        it_behaves_like "DOR item objects", "alix personal", ['mq607rm1165'], 3, 'xf112dv1419'
        it_behaves_like "hydrus item object", 'mq607rm1165'
      end
      
      context "ME310 2013" do
        it_behaves_like "all items in collection", 'kq629sd5182', 8
        it_behaves_like "DOR collection object", 'kq629sd5182', 'kq629sd5182'
        it_behaves_like "hydrus collection object", 'kq629sd5182'
        it_behaves_like "DOR item objects", "audievolve", ['qt429km6702'], 3, 'kq629sd5182'
        it_behaves_like "hydrus item object", 'qt429km6702'
      end
      context "engineering physics undergrad theses" do
        it_behaves_like "all items in collection", 'xv924ks7647', 3
        it_behaves_like "DOR collection object", 'xv924ks7647', 'xv924ks7647'
        it_behaves_like "hydrus collection object", 'xv924ks7647'
        it_behaves_like "DOR item objects", "deduceit", ['bg823wn2892'], 3, 'xv924ks7647'
        it_behaves_like "hydrus item object", 'bg823wn2892'
      end
      context "engineering undergrad theses" do
        it_behaves_like "all items in collection", 'jg722zc0626', 30
        it_behaves_like "DOR collection object", 'jg722zc0626', 'jg722zc0626'
        it_behaves_like "hydrus collection object", 'jg722zc0626'
        it_behaves_like "DOR item objects", "uclinux", ['ng517gq2855'], 3, 'jg722zc0626'
        it_behaves_like "hydrus item object", 'ng517gq2855'
      end
      context "Undergraduate Honors Theses, Graduate School of Education" do
        it_behaves_like "all items in collection", 'qs035dj7859', 4
        it_behaves_like "DOR collection object", 'qs035dj7859', 'qs035dj7859'
        it_behaves_like "hydrus collection object", 'qs035dj7859'
        it_behaves_like "DOR item objects", "Civic Engagement in Anakbayan", ['jw598xm2819'], 3, 'qs035dj7859'
        it_behaves_like "hydrus item object", 'jw598xm2819'
      end
      context "Vista Lab" do
        it_behaves_like "all items in collection", 'qd500xn1572', 4
        it_behaves_like "DOR collection object", 'qd500xn1572', 'qd500xn1572'
        it_behaves_like "hydrus collection object", 'qd500xn1572'
        it_behaves_like "DOR item objects", "Asynchronous broadband signals", ['hj582pj3902'], 3, 'qd500xn1572'
        it_behaves_like "hydrus item object", 'hj582pj3902'
      end
      
      context "Stanford Artificial Intelligence Laboratory Records" do
        it_behaves_like "all items in collection", 'jb056mm1304', 3
        it_behaves_like "DOR collection object", 'jb056mm1304', 'jb056mm1304'
        it_behaves_like "hydrus collection object", 'jb056mm1304'
        it_behaves_like "DOR item objects", "35th reunion 2009", ['pb496bf3201'], 5, 'jb056mm1304'
        it_behaves_like "hydrus item object", 'pb496bf3201'
      end
      
      context "Research Datasets for Image, Video, and Multimedia Systems Group @ Stanford" do
        it_behaves_like "all items in collection", 'cm018rf5314', 6
        it_behaves_like "DOR collection object", 'cm018rf5314', 'cm018rf5314'
        it_behaves_like "hydrus collection object", 'cm018rf5314'
        it_behaves_like "DOR item objects", "Stanford Streaming Mobile Augmented Reality Dataset", ['ph459zk5920'], 5, 'cm018rf5314'
        it_behaves_like "hydrus item object", 'ph459zk5920'
      end
      
      context "Stanford University Film Collection" do
        it_behaves_like "all items in collection", 'tm335zd3912', 1
        it_behaves_like "DOR collection object", 'tm335zd3912', 'tm335zd3912'
        it_behaves_like "hydrus collection object", 'tm335zd3912'
        it_behaves_like "DOR item objects", "stanford university film collection films 1937", ['zv044zr8616'], 10, 'tm335zd3912'
        it_behaves_like "hydrus item object", 'zv044zr8616'
      end
      
      context "H. Bruce Franklin Collection" do
        it_behaves_like "all items in collection", 'pn278bq2224', 11
        it_behaves_like "DOR collection object", 'pn278bq2224', 'pn278bq2224'
        it_behaves_like "hydrus collection object", 'pn278bq2224'
        it_behaves_like "DOR item objects", "Advisory Board decision in the matter of professor H. Bruce Franklin", ['cm175mf2096'], 5, 'pn278bq2224'
        it_behaves_like "hydrus item object", 'cm175mf2096'
      end
      
      context "Rigler-Deutsch Computer Tapes" do
        it_behaves_like "all items in collection", 'jd276dz9994', 3
        it_behaves_like "DOR collection object", 'jd276dz9994', 'jd276dz9994'
        it_behaves_like "hydrus collection object", 'jd276dz9994'
        it_behaves_like "DOR item objects", "Rigler & Deutsch Record Index", ['cr661vw3932'], 10, 'jd276dz9994'
        it_behaves_like "hydrus item object", 'cr661vw3932'
      end
      
      context "Jane Lathrop Stanford Papers" do
        it_behaves_like "all items in collection", 'hs468px3695', 3
        it_behaves_like "DOR collection object", 'hs468px3695', 'hs468px3695'
        it_behaves_like "hydrus collection object", 'hs468px3695'
        it_behaves_like "DOR item objects", "death and estate papers", ['fk544dk9538'], 10, 'hs468px3695'
        it_behaves_like "hydrus item object", 'fk544dk9538'
      end
      
      context "Stanford University Video Collection" do
        it_behaves_like "all items in collection", 'gn946cw3927', 1
        it_behaves_like "DOR collection object", 'gn946cw3927', 'gn946cw3927'
        it_behaves_like "hydrus collection object", 'gn946cw3927'
        it_behaves_like "DOR item objects", "stanford university video collections videos 1939", ['ts408hz9199'], 20, 'gn946cw3927'
        it_behaves_like "hydrus item object", 'ts408hz9199'
      end
      
      context "Stanford Student Letters and Memoirs" do
        it_behaves_like "all items in collection", 'mt423yd8582', 1
        it_behaves_like "DOR collection object", 'mt423yd8582', 'mt423yd8582'
        it_behaves_like "hydrus collection object", 'mt423yd8582'
        it_behaves_like "DOR item objects", "letters and memoirs", ['jv222bg0652'], 10, 'mt423yd8582'
        it_behaves_like "hydrus item object", 'ts408hz9199'
      end
      
      context "David Starr Jordan Papers" do
        it_behaves_like "all items in collection", 'jy460rb9016', 2
        it_behaves_like "DOR collection object", 'jy460rb9016', 'jy460rb9016'
        it_behaves_like "hydrus collection object", 'jy460rb9016'
        it_behaves_like "DOR item objects", "david starr jordan business correspondence", ['sw878zc4588'], 10, 'jy460rb9016'
        it_behaves_like "hydrus item object", 'sw878zc4588'
      end
      
      context "The Stanford Flipside" do
        it_behaves_like "all items in collection", 'dq441rn2614', 3
        it_behaves_like "DOR collection object", 'dq441rn2614', 'dq441rn2614'
        it_behaves_like "hydrus collection object", 'dq441rn2614'
        it_behaves_like "DOR item objects", "stanford flipside 2008", ['bv723rv4628'], 10, 'dq441rn2614'
        it_behaves_like "hydrus item object", 'bv723rv4628'
      end
      
      context "Leland Stanford Papers" do
        it_behaves_like "all items in collection", 'zx692xz8270', 3
        it_behaves_like "DOR collection object", 'zx692xz8270', 'zx692xz8270'
        it_behaves_like "hydrus collection object", 'zx692xz8270'
        it_behaves_like "DOR item objects", "leland stanford legal papers", ['kh510mt0132'], 10, 'zx692xz8270'
        it_behaves_like "hydrus item object", 'kh510mt0132'
      end
      
      context "Stanford University Commencement Collection" do
        it_behaves_like "all items in collection", 'nz928tt4938', 3
        it_behaves_like "DOR collection object", 'nz928tt4938', 'nz928tt4938'
        it_behaves_like "hydrus collection object", 'nz928tt4938'
        it_behaves_like "DOR item objects", "commencement addresses", ['mp840zw9344'], 10, 'nz928tt4938'
        it_behaves_like "hydrus item object", 'mp840zw9344'
      end
      
      context "Martin Luther King at Stanford" do
        it_behaves_like "all items in collection", 'yt337pb3236', 3
        it_behaves_like "DOR collection object", 'yt337pb3236', 'yt337pb3236'
        it_behaves_like "hydrus collection object", 'yt337pb3236'
        it_behaves_like "DOR item objects", "martin luther king at stanford", ['dn923nh8281'], 10, 'yt337pb3236'
        it_behaves_like "hydrus item object", 'dn923nh8281'
      end
   
    end # Hydrus collections
    
    
    context "Francis E. Stafford photographs" do
      it_behaves_like "all items in collection", '9615156', 5
      it_behaves_like "DOR collection object", '9615156', 'yg867hg1375'
      it_behaves_like "DOR item objects", "seventh day adventist church missionaries", ['nz353cp1092'], 10, '9615156'
    end
    
    
  end # DOR Digital Collections
  
end