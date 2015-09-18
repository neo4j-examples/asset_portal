require 'spec_helper'
require './lib/graph_gist_tools'

RSpec.describe GraphGistTools do
  use_vcr_cassette 'graph_gist_tools'

  describe '.raw_url_for' do

    subject { GraphGistTools.raw_url_for(url) }
    let_context url: 'https://gist.github.com/galliva/ca811daa580aee95bd07' do
      it { should eq 'https://gist.githubusercontent.com/galliva/ca811daa580aee95bd07/raw/aa11f84ec7cd02beeefd0bf892602cbf1ed09797/NoSQLGist' }
    end
    let_context url: 'https://gist.github.com/ca811daa580aee95bd07' do
      it { should eq 'https://gist.githubusercontent.com/galliva/ca811daa580aee95bd07/raw/aa11f84ec7cd02beeefd0bf892602cbf1ed09797/NoSQLGist' }
    end
  end
end