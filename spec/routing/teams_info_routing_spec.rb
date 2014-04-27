require 'spec_helper'

describe TeamsInfoController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/teams/info')).to route_to('teams_info#index')
    end
  end
end
