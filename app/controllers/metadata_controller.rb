class MetadataController < ApplicationController
  before_action MetadataPresenter::ValidateSchema
end
