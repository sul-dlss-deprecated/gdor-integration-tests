require 'spec_helper'

describe "DOR Digital Collections" do

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
  context "Francis E. Stafford photographs" do
    it_behaves_like "all items in collection", '9615156', 5
    it_behaves_like "DOR collection object", '9615156', 'yg867hg1375'
    it_behaves_like "DOR item objects", "seventh day adventist church missionaries", ['nz353cp1092'], 10, '9615156'
  end
  
end