require File.dirname(__FILE__) + '/../spec_helper'

describe ForumsController, "(remember-me functionality)" do
  define_models

  before do
    session[:forums_page] = {}
  end
end