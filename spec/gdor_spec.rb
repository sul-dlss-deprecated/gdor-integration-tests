require 'spec_helper'

describe "Index Contents" do

  shared_examples_for 'collection has all its items' do | coll_val, min_num_exp |
    it "collection filter query should return enough results" do
      resp = solr_resp_doc_ids_only({'fq'=>"collection:#{coll_val}", 'rows'=>'0'})
      resp.should have_at_least(min_num_exp).documents
    end
  end
  
  # exp_ids = expected druids for objects within a collection
  # max_res_num = items should appear within this number of results
  # coll_id = catkey or druid for the collection
  shared_examples_for 'DOR item objects' do | query_str, exp_ids, max_res_num, coll_id |
    before(:all) do
      @resp = solr_response({'q'=>query_str, 'fl'=>'id,url_fulltext,collection', 'facet'=>false})
    end
    it "item objects should be discoverable via everything search" do
      resp = solr_resp_ids_from_query query_str
      @resp.should include(exp_ids).in_first(max_res_num)
    end
    it "item objects should have gdor fields" do
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
  
  shared_examples_for 'DOR collection object' do | solr_doc_id, druid |
    before(:all) do
      @resp = solr_response({'qt'=>'document', 'id'=>solr_doc_id, 'fl'=>'id,url_fulltext,collection_type,modsxml,format,druid', 'facet'=>false})
    end
    it "collection object should have purl url in url_fulltext" do
      @resp.should include("url_fulltext" => "http://purl.stanford.edu/#{druid}")
    end
    it "collection object should have collection_type field" do
      @resp.should include("collection_type" => 'Digital Collection')
    end
    it "collection object should have modsxml field if no sirsi record" do
      @resp.should include("modsxml" => /http:\/\/www\.loc\.gov\/mods\/v3/ ) if solr_doc_id == druid
    end
    it "collection object should have a format field" do
      @resp.should include("format" => /.+/)
    end
    it "collection object should have a druid field if no sirsi record" do
      @resp.should include("druid" => druid ) if solr_doc_id == druid
    end
  end


  context "DOR Digital Collections" do
    
    context "Kolb" do
      it_behaves_like "collection has all its items", '4084372', 1150
      it_behaves_like "DOR collection object", '4084372', 'bs646cd8717'
      it_behaves_like "DOR item objects", "Addison Joseph", ['vb267mw8946'], 10, '4084372'
    end

    context "Reid Dennis" do
      it_behaves_like "collection has all its items", '6780453', 46
      it_behaves_like "DOR collection object", '6780453', 'sg213ph2100'
      it_behaves_like "DOR item objects", "bird's eye view san francisco", ['pz572zt9333', 'nz525ps5073', 'bw260mc4853', 'mz639xs9677'], 15, '6780453'
    end

    context "Walters Manuscripts" do
      it_behaves_like "collection has all its items", 'ww121ss5000', 265
      it_behaves_like "DOR collection object", 'ww121ss5000', 'ww121ss5000'
      it_behaves_like "DOR item objects", "walters brasses", ['cn006dx2288'], 3, 'ww121ss5000'
    end
    
    context "Glen McLaughlin Maps" do
        it_behaves_like "collection has all its items", 'zb871zd0767', 731
        it_behaves_like "DOR collection object", 'zb871zd0767', 'zb871zd0767'
        it_behaves_like "DOR item objects", "AMERIQUE", ['jk190bb4635'], 114, 'zb871zd0767'
      
    end
    context "Classics Papyri" do
      it_behaves_like "collection has all its items", 'jr022nf7673', 44
      it_behaves_like "DOR collection object", 'jr022nf7673', 'jr022nf7673'
      it_behaves_like "DOR item objects", "fragment documentary text", ['jx555jt0710'], 10, 'jr022nf7673'
    end
    context "Glen McLaughlin Maps Collection -- Maps of Malta" do
      it_behaves_like "collection has all its items", 'yb129fc1507', 13
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
        it_behaves_like "collection has all its items", 'cj269gn0736', 3
        it_behaves_like "DOR collection object", 'cj269gn0736', 'cj269gn0736'
        it_behaves_like "hydrus collection object", 'cj269gn0736'
        it_behaves_like "DOR item objects", "hp35 trajectory data", ['bd829sf1034'], 3, 'cj269gn0736'
        it_behaves_like "hydrus item object", 'bd829sf1034'
      end
      context "Preserving Virtual Worlds" do
        it_behaves_like "collection has all its items", 'sn446tz2204', 8
        it_behaves_like "DOR collection object", 'sn446tz2204', 'sn446tz2204'
        it_behaves_like "hydrus collection object", 'sn446tz2204'
        it_behaves_like "DOR item objects", "star raiders", ['pp060nc9006'], 3, 'sn446tz2204'
        it_behaves_like "hydrus item object", 'pp060nc9006'
      end
      context "Stanford Research Data" do
        it_behaves_like "collection has all its items", 'md919gh6774', 6
        it_behaves_like "DOR collection object", 'md919gh6774', 'md919gh6774'
        it_behaves_like "hydrus collection object", 'md919gh6774'
        it_behaves_like "DOR item objects", "high angular resolution", ['yx282xq2090'], 3, 'md919gh6774'
        it_behaves_like "hydrus item object", 'yx282xq2090'
      end
      context "SUL staff publications" do
        it_behaves_like "collection has all its items", 'hn730ks3626', 2
        it_behaves_like "DOR collection object", 'hn730ks3626', 'hn730ks3626'
        it_behaves_like "hydrus collection object", 'hn730ks3626'
        it_behaves_like "DOR item objects", "academy unbound", ['bd701dh8028'], 3, 'hn730ks3626'
        it_behaves_like "hydrus item object", 'bd701dh8028'
      end
      context "Physic Undergrad Theses" do
        it_behaves_like "collection has all its items", 'ds247vz0452', 17
        it_behaves_like "DOR collection object", 'ds247vz0452', 'ds247vz0452'
        it_behaves_like "hydrus collection object", 'ds247vz0452'
        it_behaves_like "DOR item objects", "scanning squid", ['gh325bb5942'], 3, 'ds247vz0452'
        it_behaves_like "hydrus item object", 'gh325bb5942'
      end
      
      context "Big Ideas" do
        it_behaves_like "collection has all its items", 'xf112dv1419', 74
        it_behaves_like "DOR collection object", 'xf112dv1419', 'xf112dv1419'
        it_behaves_like "hydrus collection object", 'xf112dv1419'
        it_behaves_like "DOR item objects", "alix personal", ['mq607rm1165'], 3, 'xf112dv1419'
        it_behaves_like "hydrus item object", 'mq607rm1165'
      end
      
      context "ME310 2013" do
        it_behaves_like "collection has all its items", 'kq629sd5182', 8
        it_behaves_like "DOR collection object", 'kq629sd5182', 'kq629sd5182'
        it_behaves_like "hydrus collection object", 'kq629sd5182'
        it_behaves_like "DOR item objects", "audievolve", ['qt429km6702'], 3, 'kq629sd5182'
        it_behaves_like "hydrus item object", 'qt429km6702'
      end
      context "engineering physics undergrad theses" do
        it_behaves_like "collection has all its items", 'xv924ks7647', 3
        it_behaves_like "DOR collection object", 'xv924ks7647', 'xv924ks7647'
        it_behaves_like "hydrus collection object", 'xv924ks7647'
        it_behaves_like "DOR item objects", "deduceit", ['bg823wn2892'], 3, 'xv924ks7647'
        it_behaves_like "hydrus item object", 'bg823wn2892'
      end
      context "engineering undergrad theses" do
        it_behaves_like "collection has all its items", 'jg722zc0626', 28
        it_behaves_like "DOR collection object", 'jg722zc0626', 'jg722zc0626'
        it_behaves_like "hydrus collection object", 'jg722zc0626'
        it_behaves_like "DOR item objects", "uclinux", ['ng517gq2855'], 3, 'jg722zc0626'
        it_behaves_like "hydrus item object", 'ng517gq2855'
      end
      context "Undergraduate Honors Theses, Graduate School of Education" do
        it_behaves_like "collection has all its items", 'qs035dj7859', 4
        it_behaves_like "DOR collection object", 'qs035dj7859', 'qs035dj7859'
        it_behaves_like "hydrus collection object", 'qs035dj7859'
        it_behaves_like "DOR item objects", "Civic Engagement in Anakbayan", ['jw598xm2819'], 3, 'qs035dj7859'
        it_behaves_like "hydrus item object", 'jw598xm2819'
      end
      context "Vista Lab" do
        it_behaves_like "collection has all its items", 'qd500xn1572', 3
        it_behaves_like "DOR collection object", 'qd500xn1572', 'qd500xn1572'
        it_behaves_like "hydrus collection object", 'qd500xn1572'
        it_behaves_like "DOR item objects", "Asynchronous broadband signals", ['hj582pj3902'], 3, 'qd500xn1572'
        it_behaves_like "hydrus item object", 'hj582pj3902'
      end
      
      context "Stanford Artificial Intelligence Laboratory Records" do
        it_behaves_like "collection has all its items", 'jb056mm1304', 3
        it_behaves_like "DOR collection object", 'jb056mm1304', 'jb056mm1304'
        it_behaves_like "hydrus collection object", 'jb056mm1304'
        it_behaves_like "DOR item objects", "35th reunion 2009", ['pb496bf3201'], 5, 'jb056mm1304'
        it_behaves_like "hydrus item object", 'pb496bf3201'
      end
      
      context "Research Datasets for Image, Video, and Multimedia Systems Group @ Stanford" do
        it_behaves_like "collection has all its items", 'cm018rf5314', 6
        it_behaves_like "DOR collection object", 'cm018rf5314', 'cm018rf5314'
        it_behaves_like "hydrus collection object", 'cm018rf5314'
        it_behaves_like "DOR item objects", "Stanford Streaming Mobile Augmented Reality Dataset", ['ph459zk5920'], 5, 'cm018rf5314'
        it_behaves_like "hydrus item object", 'ph459zk5920'
      end
      
      context "Stanford University Film Collection" do
        it_behaves_like "collection has all its items", 'tm335zd3912', 1
        it_behaves_like "DOR collection object", 'tm335zd3912', 'tm335zd3912'
        it_behaves_like "hydrus collection object", 'tm335zd3912'
        it_behaves_like "DOR item objects", "Films: 1937-1975", ['zv044zr8616'], 5, 'tm335zd3912'
        it_behaves_like "hydrus item object", 'zv044zr8616'
      end
      
      context "H. Bruce Franklin Collection" do
        it_behaves_like "collection has all its items", 'pn278bq2224', 11
        it_behaves_like "DOR collection object", 'pn278bq2224', 'pn278bq2224'
        it_behaves_like "hydrus collection object", 'pn278bq2224'
        it_behaves_like "DOR item objects", "Advisory Board decision in the matter of professor H. Bruce Franklin", ['cm175mf2096'], 5, 'pn278bq2224'
        it_behaves_like "hydrus item object", 'cm175mf2096'
      end
      
      context "Rigler-Deutsch Computer Tapes" do
        it_behaves_like "collection has all its items", 'jd276dz9994', 3
        it_behaves_like "DOR collection object", 'jd276dz9994', 'jd276dz9994'
        it_behaves_like "hydrus collection object", 'jd276dz9994'
        it_behaves_like "DOR item objects", "Rigler & Deutsch Record Index", ['cr661vw3932'], 10, 'jd276dz9994'
        it_behaves_like "hydrus item object", 'cr661vw3932'
      end
      
      context "Jane Lathrop Stanford Papers" do
        it_behaves_like "collection has all its items", 'hs468px3695', 3
        it_behaves_like "DOR collection object", 'hs468px3695', 'hs468px3695'
        it_behaves_like "hydrus collection object", 'hs468px3695'
        it_behaves_like "DOR item objects", "death and estate papers", ['fk544dk9538'], 10, 'hs468px3695'
        it_behaves_like "hydrus item object", 'fk544dk9538'
      end
      
      context "Stanford University Video Collection" do
        it_behaves_like "collection has all its items", 'gn946cw3927', 1
        it_behaves_like "DOR collection object", 'gn946cw3927', 'gn946cw3927'
        it_behaves_like "hydrus collection object", 'gn946cw3927'
        it_behaves_like "DOR item objects", "stanford university video collection 2013", ['ts408hz9199'], 10, 'gn946cw3927'
        it_behaves_like "hydrus item object", 'ts408hz9199'
      end
      
      context "Stanford Student Letters and Memoirs" do
        it_behaves_like "collection has all its items", 'mt423yd8582', 1
        it_behaves_like "DOR collection object", 'mt423yd8582', 'mt423yd8582'
        it_behaves_like "hydrus collection object", 'mt423yd8582'
        it_behaves_like "DOR item objects", "letters and memoirs", ['jv222bg0652'], 10, 'mt423yd8582'
        it_behaves_like "hydrus item object", 'ts408hz9199'
      end
      
      context "David Starr Jordan Papers" do
        it_behaves_like "collection has all its items", 'jy460rb9016', 2
        it_behaves_like "DOR collection object", 'jy460rb9016', 'jy460rb9016'
        it_behaves_like "hydrus collection object", 'jy460rb9016'
        it_behaves_like "DOR item objects", "david starr jordan business correspondence", ['sw878zc4588'], 10, 'jy460rb9016'
        it_behaves_like "hydrus item object", 'sw878zc4588'
      end
      
      context "The Stanford Flipside" do
        it_behaves_like "collection has all its items", 'dq441rn2614', 3
        it_behaves_like "DOR collection object", 'dq441rn2614', 'dq441rn2614'
        it_behaves_like "hydrus collection object", 'dq441rn2614'
        it_behaves_like "DOR item objects", "stanford flipside 2008", ['bv723rv4628'], 10, 'dq441rn2614'
        it_behaves_like "hydrus item object", 'bv723rv4628'
      end
      

      
    end # Hydrus collections
    
    
    context "Inspector General Semiannual Reports" do
     context "Department of Defense" do
       it_behaves_like "collection has all its items", '2933010', 4
       it_behaves_like "DOR collection object", '2933010', 'ng056wy3948'
       it_behaves_like "DOR item objects", "semiannual report to congress defense", ['xh307bp5065'], 10, '2933010'

     end
     context "Department of Justice" do
       it_behaves_like "collection has all its items", '8422414', 6
       it_behaves_like "DOR collection object", '8422414', 'yf340nx0094'
       it_behaves_like "DOR item objects", "semiannual report to congress justice", ['cx148rm2108'], 150, '8422414'
     end
     
     context "Department of energy" do
       it_behaves_like "collection has all its items", '5459243', 16
       it_behaves_like "DOR collection object", '5459243', 'bx237rw7019'
       it_behaves_like "DOR item objects", "semiannual report to congress energy", ['bn558th7305'], 50, '5459243'
     end
     
     context "Department of Treasury" do
       it_behaves_like "collection has all its items", '3026762', 14
       it_behaves_like "DOR collection object", '3026762', 'wf189dk1775'
       it_behaves_like "DOR item objects", "inspector general treasury", ['mr633wy5808'], 50, '3026762'
     end

     context "Department of State" do
       it_behaves_like "collection has all its items", '4823691', 14
       it_behaves_like "DOR collection object", '4823691', 'xn240hy3817'
       it_behaves_like "DOR item objects", "\"semiannual report to congress united states department of state\"", ['cp867xh7666'], 14, '4823691'
     end
     
    end
    
  end # DOR Digital Collections
  
end